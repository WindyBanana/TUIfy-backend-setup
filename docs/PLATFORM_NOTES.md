# Platform-Specific Notes

## Linux (Fully Supported) ✅

**Works perfectly on:**
- Ubuntu/Debian (tested)
- Fedora/RHEL (yum/dnf)
- Arch Linux (pacman)

**Features:**
- Auto-detects package manager
- TUI dashboard with whiptail/dialog
- All browser OAuth flows work
- No special configuration needed

## macOS (Fully Supported) ✅

**Features:**
- Auto-installs Homebrew if needed
- TUI dashboard with dialog
- All browser OAuth flows work
- Native terminal experience

## WSL (Windows Subsystem for Linux) ⚠️

**Compatibility Status:** Mostly works, with minor caveats

### WSL 2 (Recommended) - Excellent Experience ✅

**What Works:**
- ✅ All script execution
- ✅ TUI dashboard
- ✅ Project generation
- ✅ File operations (fast in Linux filesystem)
- ✅ Browser OAuth flows **usually work automatically**
- ✅ CLI tools installation

**WSL 2 automatically opens Windows browsers for OAuth:**
- `vercel login` → Opens Edge/Chrome
- `gh auth login` → Opens Edge/Chrome
- `axiom auth login` → Opens Edge/Chrome
- `npx convex dev` → Opens Edge/Chrome

### WSL 1 (Workable) ⚠️

**What May Need Manual Steps:**
- ⚠️ Browser OAuth may fail to open automatically
- ⚠️ You'll need to manually copy/paste URLs

**When browser doesn't open:**
```bash
# The CLI will show a URL like:
# Visit: https://vercel.com/auth?code=abc123

# Copy and paste into your Windows browser
# Then return to terminal to continue
```

### Recommendations for WSL Users

#### 1. Use WSL 2 (Strongly Recommended)

Check your version:
```bash
wsl --list --verbose
```

Upgrade to WSL 2 if needed:
```bash
wsl --set-version Ubuntu 2
```

#### 2. Use Linux Filesystem (Important!)

Keep your project in the Linux filesystem, NOT Windows:

✅ **Good (Fast):**
```bash
cd ~/projects
./launchify/create-project.sh
```

❌ **Bad (Slow):**
```bash
cd /mnt/c/Users/YourName/projects  # Windows filesystem
./launchify/create-project.sh      # Will be slow!
```

#### 3. Pre-Authenticate CLIs (Optional - Makes Setup Smoother)

If you want to avoid any browser issues during setup:

```bash
# Authenticate before running the script:
vercel login
gh auth login
axiom auth login

# Then run Launchify:
./launchify/create-project.sh
# All logins will be detected - no browser needed!
```

#### 4. Token-Based Authentication (Alternative)

If browser OAuth completely fails, use tokens:

**For GitHub:**
```bash
# Create token at: https://github.com/settings/tokens
# Select scopes: repo, workflow

gh auth login --with-token < your-token.txt
# Or paste when prompted
```

**For Vercel:**
```bash
# Get token from: https://vercel.com/account/tokens
vercel login --token YOUR_TOKEN
```

### What Works Well in WSL

**No Issues:**
- ✅ API key collection (Clerk, OpenAI, Anthropic, Linear)
- ✅ Project generation
- ✅ Git operations
- ✅ npm/pnpm/yarn operations
- ✅ File generation
- ✅ TypeScript/ESLint
- ✅ Checkpoint/resume system

**May Need Manual Copy/Paste (WSL 1 only):**
- ⚠️ Vercel login
- ⚠️ GitHub CLI login
- ⚠️ Axiom login
- ⚠️ Convex initialization

### Troubleshooting WSL Issues

#### Browser Doesn't Open for OAuth

**Solution 1:** Copy/paste the URL manually
```bash
# CLI shows:
# Visit: https://vercel.com/auth?code=abc123

# Copy URL, paste in Windows browser, complete auth
```

**Solution 2:** Use token-based authentication (see above)

**Solution 3:** Pre-authenticate before running script

#### Setup Fails at OAuth Step

The checkpoint system has you covered:

```bash
# Setup paused at step X

# 1. Complete OAuth manually:
vercel login
# or
gh auth login

# 2. Resume setup:
./launchify/create-project.sh
# Automatically resumes from where you left off!
```

#### Slow File Operations

Move your project to Linux filesystem:
```bash
# Instead of: /mnt/c/Users/...
# Use: ~/projects/
```

WSL 2 is 5-10x faster when working in Linux filesystem.

### Summary: Should You Use WSL?

| WSL Version | Experience | What to Expect |
|-------------|------------|----------------|
| **WSL 2** | ✅ Excellent | 95% automated - browser OAuth usually works |
| **WSL 1** | ⚠️ Good | Works well - some OAuth steps may need manual URL copy/paste |
| **Native Windows** | ⚠️ Limited | Not compatible - please use WSL (see below) |

**Recommendation:** WSL 2 provides the best developer experience with Launchify. The checkpoint/resume system ensures you can complete setup successfully, even if OAuth flows need manual intervention.

## Windows Users: Using WSL

**For Windows users,** Launchify works great through **Windows Subsystem for Linux (WSL)**. This provides a native Linux environment within Windows.

### Why WSL?

Launchify is built as a Bash script and uses Unix-standard tools. While native Windows (PowerShell/CMD) uses different tools and package managers, WSL provides a Linux environment that's:
- ✅ Free and built into Windows 10/11
- ✅ Fast and lightweight
- ✅ Fully compatible with Linux developer tools
- ✅ Integrated with your Windows filesystem

### Quick Setup (5 minutes)

**Install WSL 2:**
```powershell
# Open PowerShell as Administrator and run:
wsl --install
wsl --set-default-version 2

# Restart your computer
# Launch "Ubuntu" from Start menu
```

**Then run Launchify:**
```bash
# Inside Ubuntu/WSL terminal:
cd ~
git clone https://github.com/yourusername/launchify.git
cd launchify
./create-project.sh
```

**Resources:**
- [Microsoft's WSL Installation Guide](https://docs.microsoft.com/en-us/windows/wsl/install)
- [WSL 2 Features](https://docs.microsoft.com/en-us/windows/wsl/compare-versions)

