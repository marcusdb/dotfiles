#!/usr/bin/env tsx

import { exec } from 'child_process';
import { promisify } from 'util';
import path from 'path';

const execAsync = promisify(exec);

interface HookInput {
  session_id: string;
  transcript_path: string;
  cwd?: string;
  hook_event_name: string;
  stop_hook_active?: boolean;
  prompt?: string;
  tool_name?: string;
  tool_input?: any;
  tool_response?: any;
  message?: string;
  trigger?: string;
  custom_instructions?: string;
  source?: string;
}

interface HookOutput {
  continue?: boolean;
  stopReason?: string;
  suppressOutput?: boolean;
  decision?: 'block' | 'approve' | 'allow' | 'deny' | 'ask';
  reason?: string;
  hookSpecificOutput?: {
    hookEventName: string;
    additionalContext?: string;
    permissionDecision?: 'allow' | 'deny' | 'ask';
    permissionDecisionReason?: string;
  };
}

class AudioNotificationHandler {
  private audioDir: string;

  constructor() {
    this.audioDir = path.join(__dirname, '..', 'audio');
  }

  private async playAudio(filename: string): Promise<void> {
    try {
      const audioPath = path.join(this.audioDir, filename);
      // macOS specific audio player
      await execAsync(`afplay "${audioPath}"`);
    } catch (error) {
      console.error(`Failed to play audio ${filename}:`, error);
    }
  }

  private async sendNotification(title: string, message: string): Promise<void> {
    try {
      await execAsync(`osascript -e 'display notification "${message}" with title "${title}"'`);
    } catch (error) {
      console.error(`Failed to send notification:`, error);
    }
  }

  private async sendPushoverNotification(title: string, message: string): Promise<void> {
    const PUSHOVER_APP_TOKEN = process.env.PUSHOVER_APP_TOKEN;
    const PUSHOVER_USER_KEY = process.env.PUSHOVER_USER_KEY;

    // Skip if credentials not configured
    if (!PUSHOVER_APP_TOKEN || !PUSHOVER_USER_KEY) {
      console.log('Pushover credentials not available - skipping notification');
      return;
    }
    
    try {
      const curlCommand = `curl -s -F "token=${PUSHOVER_APP_TOKEN}" -F "user=${PUSHOVER_USER_KEY}" -F "title=${title}" -F "message=${message}" https://api.pushover.net/1/messages.json`;
      const result = await execAsync(curlCommand);
      
      // Log result for debugging
      if (result.stdout) {
        const response = JSON.parse(result.stdout);
        if (response.status !== 1) {
          console.error('Pushover API error:', response.errors);
        }
      }
    } catch (error) {
      console.error(`Failed to send Pushover notification:`, error);
    }
  }

  async handleHook(input: HookInput): Promise<void> {
    // Log ALL events with full details
    //const debugLog = `[${new Date().toISOString()}] Event: ${input.hook_event_name} | Full Input: ${JSON.stringify(input)}\n`;
    //require('fs').appendFileSync('/tmp/claude-hooks.log', debugLog);
    
    const output: HookOutput = {
      continue: true,
      suppressOutput: false
    };

    let audioFile: string | null = null;
    let notificationTitle = 'Claude Code';
    let notificationMessage = '';

    switch (input.hook_event_name) {
      case 'Stop':
        // Main task completion
        if (!input.stop_hook_active) {
          audioFile = 'task-finished.mp3';
          notificationMessage = 'Task completed successfully';
        }
        break;

      case 'SubagentStop':
        // Sub-agent task completion
        if (!input.stop_hook_active) {
          audioFile = 'sub-agent-finished.mp3';
          notificationTitle = 'Sub-Agent';
          notificationMessage = 'Sub-agent task completed';
        }
        break;

      case 'Notification':
        // Handle different notification types
        const message = input.message || '';
        
        // Check if permission is needed based on notification message
        if (this.isPermissionNeededMessage(message)) {
          audioFile = 'permission-needed.mp3';
          notificationTitle = 'Permission Required';
          notificationMessage = message || 'Permission needed for action';
        }
        // Check if input is needed
        else if (this.isInputNeededMessage(message)) {
          audioFile = 'needs-input.mp3';
          notificationTitle = 'Input Required';
          notificationMessage = 'Claude needs your input';
        } else {
          audioFile = 'task-complete.mp3';
          notificationMessage = message || 'Notification received';
        }
        break;

      case 'PostToolUse':
        // Only play sounds for specific successful operations
        if (input.tool_response?.success) {
          const toolName = input.tool_name || '';
          
          if (toolName === 'Bash') {
            const command = input.tool_input?.command || '';
            if (command.includes('build') || command.includes('npm run build')) {
              audioFile = 'build-complete.mp3';
              notificationTitle = 'Build Complete';
              notificationMessage = 'Build process finished successfully';
            }
          }
        }
        break;

    }

    // Play audio and show notification if configured
    if (audioFile && notificationMessage) {
      await Promise.all([
        this.playAudio(audioFile),
        this.sendNotification(notificationTitle, notificationMessage),
        this.sendPushoverNotification(notificationTitle, notificationMessage)
      ]);
    }

    // Output the hook response
    console.log(JSON.stringify(output));
  }

  private isPermissionNeededMessage(message: string): boolean {
    // Keywords that indicate permission is being requested
    const permissionKeywords = [
      'permission', 'approve', 'allow', 'authorize', 'confirm',
      'may i', 'can i', 'would you like me to', 'should i',
      'do you want me to', 'shall i'
    ];
    
    const lowerMessage = message.toLowerCase();
    return permissionKeywords.some(keyword => lowerMessage.includes(keyword));
  }

  private isInputNeededMessage(message: string): boolean {
    const inputKeywords = [
      'input', 'waiting', 'provide', 'enter', 'specify',
      'need', 'require', 'missing', 'please', 'what'
    ];
    
    const lowerMessage = message.toLowerCase();
    return inputKeywords.some(keyword => lowerMessage.includes(keyword));
  }
}

async function readStdinJson(): Promise<HookInput> {
  return new Promise((resolve, reject) => {
    let data = '';
    
    process.stdin.on('data', chunk => {
      data += chunk;
    });
    
    process.stdin.on('end', () => {
      try {
        const parsed = JSON.parse(data);
        resolve(parsed);
      } catch (error) {
        reject(new Error(`Invalid JSON input: ${error}`));
      }
    });
    
    process.stdin.on('error', reject);
  });
}

async function main() {
  try {
    const input = await readStdinJson();
    const handler = new AudioNotificationHandler();
    await handler.handleHook(input);
  } catch (error) {
    console.error('Hook handler error:', error);
    // Output error response
    console.log(JSON.stringify({
      continue: true,
      suppressOutput: false
    }));
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}