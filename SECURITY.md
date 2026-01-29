# Security Policy

## Overview

This is a **personal macOS dotfiles repository** shared for reference and educational purposes. While no secrets are committed, users should be aware of security considerations before using or deploying these configurations.

## Security Best Practices for Users

### Before Running Installation Scripts

1. **Review scripts before execution** - Don't blindly run `install.sh` or `brew.sh`
   - These scripts modify system configuration and install software
   - Review the specific packages/configurations you need

2. **Installation security concerns**:
   - The `install.sh` script pipes remote shell scripts directly from GitHub
   - While GitHub is trusted, consider downloading and reviewing scripts first:
   ```bash
   # Instead of piping directly:
   # sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

   # Download, review, then run:
   curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /tmp/install-ohmyzsh.sh
   cat /tmp/install-ohmyzsh.sh  # Review the script
   bash /tmp/install-ohmyzsh.sh
   ```

3. **Use stow carefully** - Stow creates symlinks to system directories
   - Back up existing configurations first
   - Test in non-critical environments first
   - Only stow packages you actually need

### After Installation

1. **Verify sensitive file permissions**:
   ```bash
   # SSH keys should be 600 (read/write for owner only)
   ls -la ~/.ssh/id_ed25519  # Should show: -rw-------

   # Password store should be 700
   ls -ld ~/.password-store   # Should show: drwx------
   ```

2. **Secure your credentials**:
   - Keep `PUSHOVER_APP_TOKEN` and `PUSHOVER_USER_KEY` in your environment, never committed
   - Use Doppler CLI properly: `doppler login` and configure projects
   - Keep GitHub CLI credentials fresh: `gh auth login`

3. **Monitor system services**:
   ```bash
   # Check auto-started services
   brew services list

   # Stop unnecessary services
   brew services stop languagetool  # if not needed
   brew services stop autokbisw     # if not needed
   ```

## Known Security Considerations

### Command Injection Vulnerabilities

⚠️ **This repository contains TypeScript code with potential command injection vulnerabilities in `claude/.claude/hooks/audio-handler.ts`:**

- **Lines 75, 58**: User-controlled input passed to shell commands without proper escaping
- **Impact**: If notification messages contain shell metacharacters, arbitrary code could execute
- **Status**: This is personal code not intended for production use

**Affected code**:
```typescript
// Vulnerable to injection - message/title not escaped
await execAsync(`osascript -e 'display notification "${message}" with title "${title}"'`);
const curlCommand = `curl -s -F "token=${TOKEN}" ... -F "message=${message}"`;
```

**Recommendation**: If using this code, replace with safe alternatives:
```typescript
// Use execFile instead of shell execution
import { execFile } from 'child_process';
await execFile('curl', ['--form', `message=${message}`, ...], {shell: false});
```

### Environment Variable Exposure

- **Pushover credentials** may be visible in process listings if passed as command arguments
- **Doppler configuration** details are visible in settings.json
- **Mitigation**: These tokens are not committed; keep them only in your environment

## Installed Software Security

### Recommended Updates

Keep installed software updated:
```bash
# Update Homebrew packages
brew update
brew upgrade

# Update global npm packages
npm update -g

# Update neovim plugins
# (run :PlugUpdate in neovim)

# Update Kubernetes tools
kind version
tilt version
```

### Potentially High-Risk Software

These tools are powerful and should be kept up-to-date:
- **Docker**: Requires proper daemon configuration
- **Kubernetes (kind)**: Cluster data could expose secrets
- **Terraform**: Can provision live cloud resources - use with caution
- **GPG Suite**: Keep updated for cryptographic security

### Recommended Lockdown

For maximum security, consider:
- Disabling unnecessary services: `brew services stop <service>`
- Removing unused applications from the `brew.sh` install list
- Enabling macOS FileVault encryption
- Using separate GPG keys for different purposes

## Secrets Management

### What's NOT in this Repository ✅

- SSH private keys
- GitHub authentication tokens
- GPG private keys
- API tokens or credentials
- `.env` files
- `.password-store` directory

### How Secrets Should Be Managed

1. **Pushover API tokens**: Use environment variables only
   ```bash
   export PUSHOVER_APP_TOKEN=your_token
   export PUSHOVER_USER_KEY=your_key
   ```

2. **Doppler integration**: Use Doppler CLI for centralized secrets
   ```bash
   doppler login
   doppler setup  # Configure your project
   ```

3. **GitHub credentials**: Use GitHub CLI
   ```bash
   gh auth login
   ```

4. **SSH keys**: Stored in `~/.ssh` with 600 permissions (not in this repo)

5. **Password store**: Use `pass` command, stored in `~/.password-store`

## Reporting Security Issues

If you discover a security vulnerability in this repository:

1. **Do NOT open a public issue** - This could expose the vulnerability
2. **Contact the maintainer privately** via email or GitHub security advisory
3. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if available)

## Deployment Recommendations

### For Your Own Use Only

This is **NOT recommended for**:
- Production servers
- Shared/multi-user systems
- Untrusted networks

This **IS appropriate for**:
- Personal development machines
- Reference/learning purposes
- Base configuration for customization

### Safe Deployment Strategy

1. **Clone the repository**
   ```bash
   git clone git@github.com:marcusdb/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Review each stow package**
   ```bash
   # Check what will be symlinked
   stow --verbose --dry-run zsh -t ~/
   ```

3. **Deploy selectively**
   ```bash
   # Only deploy packages you need
   stow zsh -t ~/
   stow tmux -t ~/
   # Skip packages you don't need (e.g., don't stow everything)
   ```

4. **Test before full deployment**
   - Test in a fresh macOS instance if possible
   - Verify each configuration works as expected
   - Keep backups of original configs

5. **Update and maintain**
   ```bash
   # Keep your dotfiles updated
   cd ~/dotfiles
   git pull

   # Update installed packages
   brew update && brew upgrade
   ```

## Audit Log

### Last Security Review
- Date: January 29, 2026
- Scope: Full repository security analysis
- Issues Found: 11 (1 critical, 2 high, 2 medium, 6 low)

### Known Issues Summary

| Severity | Issue | Status |
|----------|-------|--------|
| Critical | Command injection in audio-handler.ts | Unfixed (personal code) |
| High | Unsafe remote script installation | Documented |
| High | Credentials in process args | Documented |
| Medium | Doppler config visibility | Documented |
| Medium | GPG Suite without version pinning | Documented |

## Security Contact

For security issues: **Use GitHub's private security advisory feature**

- Go to: `https://github.com/marcusdb/dotfiles/security/advisories`
- Report vulnerabilities privately

---

**Last Updated**: January 29, 2026
**Repository Status**: Personal reference dotfiles - not for production use
**Recommendation**: Review security considerations before using in any environment beyond personal development
