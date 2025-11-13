# Contributing to TUIfy

Thanks for your interest in improving TUIfy!

## Project Status

This is an **active open source project** built to solve a real problem: automating repetitive project setup. It's maintained by developers who use it for their own projects.

**What this means:**
- ✅ The project works and is tested
- ✅ Issues and PRs are welcome
- ✅ We'll review contributions when time permits
- ⚠️ Response times may vary (this isn't a full-time job for us)
- ⚠️ Breaking changes to core functionality may be carefully considered

## How to Contribute

### Reporting Issues

**Found a bug or have a suggestion?**

1. Check if it's already reported in [Issues](../../issues)
2. If not, create a new issue with:
   - Clear description of the problem
   - Steps to reproduce (for bugs)
   - Your environment (OS, Node version, etc.)
   - Error logs if available (`~/.tuify/logs/`)

### Suggesting Features

We're open to new ideas! Before creating an issue:
- Consider if it fits TUIfy's goal: **automate common setup tasks**
- Check if it could be a separate script/extension
- Explain the use case and why it would help many users

### Pull Requests

**Ready to code?**

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature`
3. **Make your changes**
4. **Test thoroughly**:
   - Test on your platform (Linux/macOS/WSL)
   - Test with different service combinations
   - Test the checkpoint/resume system
5. **Keep it clean**:
   - Follow existing code style
   - Add comments for complex logic
   - Update documentation if needed
6. **Submit PR** with:
   - Clear description of what it does
   - Why it's useful
   - Testing you've done

### What We're Looking For

**High priority contributions:**
- ✅ Bug fixes
- ✅ Documentation improvements
- ✅ Platform compatibility fixes (especially WSL)
- ✅ Error message improvements
- ✅ Test coverage

**Welcome contributions:**
- ✅ New service integrations (if widely used)
- ✅ New presets
- ✅ Performance improvements
- ✅ Better error handling

**Lower priority:**
- ⚠️ Major architectural changes (discuss first in an issue)
- ⚠️ Adding dependencies (keep it lightweight)
- ⚠️ Niche features used by very few

## Development Setup

```bash
# Fork and clone
git clone https://github.com/YOUR_USERNAME/tuify.git
cd tuify

# Make executable
chmod +x create-project.sh

# Test your changes
./create-project.sh --dry-run
./create-project.sh  # Run actual test
```

**Understanding the Codebase:**
- Read **[Architecture Guide](docs/ARCHITECTURE.md)** - Explains the gather-then-execute pattern
- Check **[Services Guide](docs/SERVICES.md)** - How each service integration works
- Review existing scripts in `scripts/` - Follow established patterns

## Code Style

- Use **bash best practices**
- Add **comments** for non-obvious logic
- Keep functions **small and focused**
- Use **descriptive variable names**
- Follow existing **formatting patterns**

### Language & Messaging

**Keep it professional and welcoming:**

✅ **Good:**
- "Platform not compatible" (then explain why + solution)
- "This step requires..." (explain what's needed)
- "Please provide..." (request politely)
- "Compatibility note: WSL 2 recommended"

❌ **Avoid:**
- "Not supported" (without explanation)
- "You must..." (sounds demanding)
- "You should have..." (sounds blaming)
- "Obviously..." or "Just..." (assumes knowledge)

**Error messages should:**
- Explain what happened
- Suggest how to fix it
- Provide alternatives when possible
- Link to docs for more help

**Example:**
```bash
# Instead of:
echo "Failed. You need to install X first."

# Use:
echo "Unable to proceed: X is required"
echo "Install with: sudo apt install X"
echo "Or see: https://docs...."
```

## Testing Your Changes

Before submitting:

```bash
# 1. Syntax check
bash -n scripts/*.sh

# 2. Test dry run
./create-project.sh --dry-run

# 3. Test actual setup with different configs
./create-project.sh  # Try minimal preset
./create-project.sh  # Try SaaS preset

# 4. Test resume/checkpoint
# - Start setup
# - Press Ctrl+C mid-way
# - Run again and confirm resume works

# 5. Check logs
cat ~/.tuify/logs/your-project-*.log
```

## Adding New Services

Want to add a new service integration?

1. **Create setup script**: `scripts/setup-yourservice.sh`
2. **Add CLI check**: Update `scripts/check-dependencies.sh`
3. **Add CLI install**: Update `scripts/install-clis.sh`
4. **Add to execution**: Update `scripts/execute-setup.sh`
5. **Add env vars**: Update `scripts/utils.sh`
6. **Add to presets**: Update relevant `.conf` files if needed
7. **Document it**: Add section to `docs/SERVICES.md`
8. **Test thoroughly**

## Questions?

- **General questions**: Open a [Discussion](../../discussions)
- **Bugs**: Open an [Issue](../../issues)
- **Security issues**: See [SECURITY.md](SECURITY.md) _(if you have one)_

## Code of Conduct

**Be respectful.** We're all here to build useful tools together.

- Be kind and constructive
- Assume good intentions
- Help others learn
- No harassment, discrimination, or spam

## License

By contributing, you agree that your contributions will be licensed under the same [MIT License](LICENSE) as the project.

---

**Thank you for helping make TUIfy better!** 🚀

Every contribution; big or small is appreciated.

