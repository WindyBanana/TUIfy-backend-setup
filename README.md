# Launchify

**Production-ready Next.js projects in minutes, not hours**

Automated project generator with smart resume, progress tracking, and zero-config service integration. Choose your stack, enter your API keys, and get a fully configured app ready to deploy.

> **Why Launchify?** Every new project starts the same way: hours configuring Vercel, setting up Clerk webhooks, connecting Convex, managing environment variables. Launchify automates the repetitive setup so you can skip straight to building what makes your product unique.

```bash
./create-project.sh
# 5-15 minutes later: ✅ Production-ready app
```

---

## 🚀 Quick Start

```bash
# 1. Clone
git clone https://github.com/yourusername/launchify.git
cd launchify

# 2. Run (from parent directory recommended)
cd ..
./launchify/create-project.sh

# 3. Choose your stack (or pick a preset)
# 4. Done! Your app is ready.
```

**Presets Available:**
- **SaaS Starter** - Full-stack with auth + database + admin
- **Modern Frontend** - Beautiful UI with Next.js 16 + shadcn/ui + Vercel + GitHub
- **AI Application** - AI-powered app with OpenAI/Anthropic
- **Minimal** - Just Next.js + Vercel

---

## What You Get

**Automated Setup:**
- ✅ Next.js 16 + TypeScript + Tailwind CSS
- ✅ Service integration (Vercel, Convex, Clerk, Axiom)
- ✅ Environment variables configured (dev + prod)
- ✅ Git repository initialized
- ✅ GitHub repo created & linked
- ✅ CI/CD pipeline configured
- ✅ Production secrets set automatically

**Built-in Safety:**
- Checkpoint/resume from any failure point
- Progress tracking with ETA
- Full logging to `~/.launchify/logs/`
- ✅ Post-setup health checks

**Developer Experience:**
- Configuration presets for quick start
- Export/import custom configs
- Interactive TUI or CLI mode
- Generated setup guides

---

## Supported Services

| Service | What It Does | Setup | Status |
|---------|-------------|-------|--------|
| **Vercel** | Deployment + hosting | Auto | ✅ |
| **Convex** | Backend + database | Auto | ✅ |
| **Clerk** | Authentication | Keys required | ✅ |
| **Axiom** | Observability | Auto | ✅ |
| **Linear** | Issue tracking + tasks | Manual | ✅ |
| **GitHub** | CI/CD pipeline | Auto | ✅ |
| **shadcn/ui** | UI components + dark mode | Auto | ✅ |
| **OpenAI/Anthropic** | AI integration | Keys required | ✅ |

**Admin Panel** (optional) - Full dashboard with user management

[→ Detailed service documentation](docs/SERVICES.md)

---

## Requirements

**System:**
- Node.js 18+
- Git
- npm/pnpm/yarn
- Bash shell

**Platform Compatibility:**
- ✅ **Linux** - Full compatibility (Ubuntu, Debian, Fedora, Arch)
- ✅ **macOS** - Full compatibility (Intel & Apple Silicon)
- ✅ **Windows** - Via WSL 2 (Windows Subsystem for Linux)
  - WSL 2 provides the best experience
  - Native PowerShell/CMD not compatible (requires Bash shell)

[→ Platform-specific notes & WSL guide](docs/PLATFORM_NOTES.md)

---

## Documentation

**User Guides:**
- **[Services Guide](docs/SERVICES.md)** - Detailed service integration info
- **[Platform Notes](docs/PLATFORM_NOTES.md)** - Linux, macOS, WSL specifics
- **[Troubleshooting](ERROR_HANDLING_GUIDE.md)** - Common issues & recovery

**Developer:**
- **[Architecture](docs/ARCHITECTURE.md)** - Technical design & implementation
- **[Contributing](CONTRIBUTING.md)** - How to contribute

**Legal:**
- **[License](LICENSE)** - MIT License

---

## Example Workflow

```bash
$ ./create-project.sh

# Choose preset: Modern Frontend
# ✓ Next.js 16 + Tailwind + shadcn/ui
# ✓ Vercel + GitHub CI/CD

# Enter project name: my-app

# 5 minutes later...

🚀 PROJECT SETUP COMPLETE!

Project created at: ./my-app

Next steps:
  1. cd my-app
  2. npm run dev
  3. Open http://localhost:3000

# Push to GitHub → Auto-deploys to Vercel
```

---

## Common Commands

```bash
# Normal setup
./create-project.sh

# Preview without changes
./create-project.sh --dry-run

# Resume after failure
./create-project.sh
# → Automatically detects and resumes

# Check logs
ls ~/.launchify/logs/

# Start over
rm -rf .launchify-state/
```

---

## Troubleshooting

### Setup Failed?

**You can resume!** Progress is saved automatically:

```bash
./create-project.sh
# → "Resume from step X? [Y/n]:"
```

### Where Are My Logs?

```bash
ls -lt ~/.launchify/logs/
# Logs: project-name_YYYY-MM-DD_HH-MM-SS.log
```

### Common Issues

| Issue | Solution |
|-------|----------|
| Browser OAuth fails (WSL) | Use WSL 2, or pre-authenticate: `vercel login`, `gh auth login` |
| "Command not found" | Run `npm install -g vercel` or let script install it |
| Missing API keys | Check `.env.local` for TODO placeholders, fill them in |

[→ Full troubleshooting guide](ERROR_HANDLING_GUIDE.md)

---

## Configuration Presets

**1. SaaS Starter**
- Vercel + Convex + Clerk + Axiom
- shadcn/ui + Admin Panel + Feature Toggles
- **Best for:** Production SaaS applications

**2. Modern Frontend**
- Next.js 16 + Tailwind + shadcn/ui
- Vercel + GitHub CI/CD
- **Best for:** Landing pages, portfolios, marketing sites

**3. AI Application**
- Vercel + Convex + Clerk
- OpenAI & Anthropic integration
- **Best for:** AI tools, chatbots, automation

**4. Minimal**
- Next.js + Vercel only
- **Best for:** Learning, prototyping

**5. Custom**
- Choose features individually
- **Best for:** Specific requirements

---

## Features

### Checkpoint/Resume System
Never lose progress. If setup fails, just run the script again—it resumes exactly where you left off.

### Progress Tracking
Visual progress bar with real-time ETA based on actual step durations.

### Smart Error Handling
When something fails, you get 4 options:
1. **Retry** - Try again
2. **Skip** - Continue without it
3. **Manual** - Fix yourself, mark done
4. **Abort** - Resume later

### Automated Service Integration
- Vercel: Project linking + production secrets via API
- Convex: Dev deployment + schema generation
- Clerk: Webhook configuration via Svix API
- Axiom: Dataset creation + token generation
- GitHub: Repo creation + Vercel integration

### Environment Management
- Development keys in `.env.local`
- Production keys auto-set in Vercel dashboard
- Separate dev/prod for Clerk, Convex, Axiom

---

## Contributing

Contributions are welcome! Found a bug? Have an idea? Want to add a service integration?

**See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.**

Quick start:
1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

We review PRs when time permits. This is an open source project maintained alongside other work, so response times may vary—but we appreciate every contribution!

---

## License

[MIT License](LICENSE) - Use for any project, commercial or personal.

---

## Roadmap

- [ ] More frameworks (React, Vue, Svelte)
- [ ] More backends (Supabase, Firebase, PlanetScale)
- [ ] More auth providers (Auth0, NextAuth)
- [ ] Docker configuration
- [ ] Testing setup (Jest, Playwright)
- [ ] Monitoring setup (Sentry)

---

## Resources

- [Next.js](https://nextjs.org/docs)
- [Vercel](https://vercel.com/docs)
- [Convex](https://docs.convex.dev)
- [Clerk](https://clerk.com/docs)
- [Axiom](https://axiom.co/docs)
- [shadcn/ui](https://ui.shadcn.com)

---

**Questions or issues?** Open an issue on GitHub.

**Happy coding!** 🚀
