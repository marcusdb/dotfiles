#!/usr/bin/env tsx

import { exec } from 'child_process';
import { promisify } from 'util';
import { readFileSync } from 'fs';
import path from 'path';

const execAsync = promisify(exec);

interface HookContext {
  event: string;
  tool?: string;
  success?: boolean;
  error?: string;
  [key: string]: any;
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

  private getEventDetails(context: HookContext): { audio: string | null; title: string; message: string } {
    const { event, tool, success, error } = context;

    switch (event) {
      case 'UserPromptSubmit':
        return {
          audio: 'awaiting-instructions.mp3',
          title: 'Claude Code',
          message: 'Processing your request...'
        };
      
      case 'Stop':
        return {
          audio: 'ready.mp3',
          title: 'Claude Code',
          message: 'Task completed - Ready for next request'
        };
      
      case 'PostToolUse':
        if (tool === 'Bash' && success) {
          if (context.command?.includes('build') || context.command?.includes('npm run build')) {
            return {
              audio: 'build-complete.mp3',
              title: 'Build Complete',
              message: 'Build process finished successfully'
            };
          }
          return {
            audio: 'task-complete.mp3',
            title: 'Command Complete',
            message: `Bash command executed successfully`
          };
        }
        if (success && (tool === 'Edit' || tool === 'MultiEdit' || tool === 'Write')) {
          return {
            audio: 'task-complete.mp3',
            title: 'File Updated',
            message: `${tool} operation completed successfully`
          };
        }
        break;
      
      case 'Notification':
        if (error) {
          return {
            audio: 'error-fixed.mp3',
            title: 'Issue Resolved',
            message: 'Error has been fixed'
          };
        }
        return {
          audio: 'task-complete.mp3',
          title: 'Notification',
          message: 'Task completed successfully'
        };
      
      default:
        return { audio: null, title: '', message: '' };
    }

    return { audio: null, title: '', message: '' };
  }

  async handleHook(context: HookContext): Promise<void> {
    const { audio, title, message } = this.getEventDetails(context);
    
    if (audio && title && message) {
      await Promise.all([
        this.playAudio(audio),
        this.sendNotification(title, message)
      ]);
    }

    // Return success JSON response
    console.log(JSON.stringify({
      continue: true,
      suppressOutput: false
    }));
  }
}

async function main() {
  try {
    const input = process.argv[2] || process.env.CLAUDE_HOOK_CONTEXT || '{}';
    const context: HookContext = JSON.parse(input);
    
    const handler = new AudioNotificationHandler();
    await handler.handleHook(context);
    
  } catch (error) {
    console.error('Hook handler error:', error);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}