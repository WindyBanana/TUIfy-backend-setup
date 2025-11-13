# Service Integration Guide

Complete guide to all services supported by TUIfy.

## Service Overview

| Service | Type | Auto-Setup | Manual Steps |
|---------|------|------------|--------------|
| **Vercel** | Deployment | ✅ Full | None |
| **Convex** | Backend/DB | ✅ Full | None (dev), Manual (prod) |
| **Clerk** | Auth | ⚠️ Partial | API keys required |
| **Axiom** | Observability | ✅ Most | Token creation |
| **Linear** | Issue Tracking + Tasks | ❌ Manual | API key + GraphQL |
| **shadcn/ui** | UI Components | ✅ Full | None |
| **AI (OpenAI/Anthropic)** | AI Integration | ✅ Full | API keys required |
| **Admin Panel** | Dashboard | ✅ Full | Optional email config |
| **GitHub** | CI/CD | ✅ Full | OAuth login |

---

## Vercel (Deployment)

**Fully Automated** - Browser OAuth + API integration

### What Gets Set Up
- ✅ CLI authentication via browser
- ✅ Project creation/linking
- ✅ `vercel.json` configuration
- ✅ **Production secrets automatically set via API**
- ✅ Environment variable configuration

### Automated Features
```bash
# Automatically sets these via Vercel REST API:
- CLERK_SECRET_KEY (production)
- NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY (production)
- CONVEX_DEPLOY_KEY (production)
- AXIOM_TOKEN (production)
- OPENAI_API_KEY / ANTHROPIC_API_KEY
```

### Environments
- **Development**: Local (`.env.local`)
- **Preview**: All non-main branches
- **Production**: Main branch only

### Manual Steps
None! Fully automated.

---

## Convex (Backend/Database)

**Fully Automated for Dev** - Browser OAuth, manual production deployment

### What Gets Set Up
- ✅ Local package installation (`convex`)
- ✅ Development deployment initialization
- ✅ Schema files (`convex/schema.ts`)
- ✅ Example queries/mutations
- ✅ Auto-populated dev URLs in `.env.local`

### Generated Files
```
convex/
├── schema.ts              # Database schema
├── example.ts             # Example queries
├── admin.ts              # Admin functions (if admin panel enabled)
└── featureToggles.ts     # Feature flags (if enabled)
```

### Commands
```bash
# Development (auto-started during setup):
npx convex dev

# Production deployment (manual):
npx convex deploy --prod
```

### Environments
- **Development**: Auto-created during setup
- **Production**: Run `npx convex deploy --prod` before deploying to Vercel

### Manual Steps
Only for production: Deploy with `npx convex deploy --prod`

---

## Clerk (Authentication)

**Partially Automated** - API keys collected upfront, webhooks automated via Svix API

### What Gets Set Up
- ✅ API keys collected during setup (dev + prod)
- ✅ Keys auto-populated in `.env.local`
- ✅ Production keys auto-set in Vercel
- ✅ Webhook configuration via Svix API
- ✅ Clerk React components configured

### Required Manual Steps (Before Setup)
1. Go to https://dashboard.clerk.com
2. Create TWO applications:
   - **Development App** (for test keys: `pk_test_*`, `sk_test_*`)
   - **Production App** (for live keys: `pk_live_*`, `sk_live_*`)
3. Have keys ready when prompted

### API Keys Needed
```bash
# Development (test environment):
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...

# Production (live environment):
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_live_...
CLERK_SECRET_KEY=sk_live_...
```

### Webhook Setup
Automated via Svix API - webhooks are configured automatically for:
- `user.created`
- `user.updated`
- `user.deleted`

---

## Axiom (Observability)

**Mostly Automated** - CLI login, dataset creation, token may need manual creation

### What Gets Set Up
- ✅ Axiom CLI installed (Linux/macOS)
- ✅ Browser-based CLI login
- ✅ Dataset creation (`your-project-dev`)
- ✅ Client library installation (`@axiomhq/js`)
- ✅ Helper utility (`lib/axiom.ts`)
- ⚠️ Token creation (may need manual step)

### Manual Steps (If Needed)
```bash
# If token creation fails during setup:
axiom auth login
axiom token create tuify-token --datasets="your-project-dev:ingest"
# Copy token to .env.local
```

### Usage
```typescript
import { axiom } from '@/lib/axiom';

axiom.ingest('your-dataset', [{ 
  event: 'user_action', 
  user_id: '123' 
}]);
```

---

## Linear (Issue Tracking & Task Management)

**Manual Setup** - API key + GraphQL configuration

**What Linear Does:**
Linear is a modern issue tracker and task management tool (think Jira, but faster and cleaner). Use it for:
- Bug tracking
- Feature request management  
- Developer task assignment
- Sprint/cycle planning
- User feedback collection (via API/webhooks)
- Product roadmaps

### What Gets Set Up
- ✅ Setup guide in `SETUP_GUIDE.md`
- ✅ API key placeholder in `.env.local`
- ✅ Example GraphQL queries in guide
- ✅ Webhook configuration guide

### Manual Steps Required
1. Go to https://linear.app/settings/api
2. Create personal API key
3. Copy key to `.env.local`:
   ```bash
   LINEAR_API_KEY=lin_api_...
   LINEAR_TEAM_ID=your-team-id
   ```

### Example Usage
```typescript
const response = await fetch('https://api.linear.app/graphql', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': process.env.LINEAR_API_KEY!,
  },
  body: JSON.stringify({
    query: `query Me { viewer { id name email } }`,
  }),
});
```

---

## shadcn/ui (UI Components)

**Fully Automated** - Component library + dark mode setup

### What Gets Set Up
- ✅ `components.json` configuration
- ✅ Pre-installed components: button, card, dialog, input, label, select, switch, textarea
- ✅ Dark mode with theme toggle
- ✅ Tailwind CSS configured
- ✅ Required dependencies installed

### Installed Packages
- `class-variance-authority`
- `clsx`
- `tailwind-merge`
- `lucide-react` (icons)
- `next-themes` (dark mode)

### Generated Files
```
components/
├── ui/                    # shadcn components
│   ├── button.tsx
│   ├── card.tsx
│   ├── dialog.tsx
│   └── ...
└── theme-toggle.tsx       # Dark mode toggle
```

### Adding More Components
```bash
npx shadcn@latest add dropdown-menu
npx shadcn@latest add toast
npx shadcn@latest add table
```

---

## AI Integration (OpenAI / Anthropic)

**Fully Automated** - API keys collected, utilities generated

### What Gets Set Up
- ✅ SDK installation (`openai` and/or `@anthropic-ai/sdk`)
- ✅ Unified helper utilities in `lib/ai/`
- ✅ Example API route
- ✅ Example React component
- ✅ Streaming support

### API Keys Required
Collected during setup:
```bash
OPENAI_API_KEY=sk-proj-...        # From: https://platform.openai.com/api-keys
ANTHROPIC_API_KEY=sk-ant-...      # From: https://console.anthropic.com/settings/keys
```

### Generated Files
```
lib/ai/
├── openai.ts              # OpenAI helpers
├── anthropic.ts           # Anthropic helpers
└── index.ts               # Unified API

app/api/ai/chat/
└── route.ts               # Example API endpoint

components/examples/
└── ai-chat-example.tsx    # Example chat component
```

### Usage
```typescript
import { generateText, streamText } from '@/lib/ai';

// Simple generation
const response = await generateText('Your prompt here', {
  systemPrompt: 'You are a helpful assistant',
  provider: 'openai', // or 'anthropic' or auto-detect
});

// Streaming
for await (const chunk of streamText('Your prompt', options)) {
  console.log(chunk);
}
```

---

## Admin Panel

**Fully Automated** - Dashboard with user management (requires Convex)

### Requirements
- ✅ Convex must be enabled
- ✅ Optional: Clerk for user management
- ✅ Optional: Axiom for logs

### What Gets Set Up
- ✅ Admin layout with sidebar navigation
- ✅ Dashboard with system statistics
- ✅ User management interface
- ✅ Database viewer (links to Convex dashboard)
- ✅ Logs viewer (links to Axiom if enabled)
- ✅ Settings page
- ✅ Dark mode support (if shadcn/ui enabled)

### Generated Files
```
app/admin/
├── layout.tsx             # Admin layout
├── page.tsx               # Dashboard
├── users/page.tsx         # User management
├── database/page.tsx      # Database viewer
├── logs/page.tsx          # Logs viewer
└── settings/page.tsx      # Settings

convex/
└── admin.ts               # Admin Convex functions
```

### Configuration
```bash
# .env.local
ENABLE_ADMIN_PANEL=true   # Set to false to disable in production
ADMIN_ALLOWED_EMAILS=you@example.com,admin@example.com
```

### Access
- Development: `http://localhost:3000/admin`
- Production: Disabled by default (set `ENABLE_ADMIN_PANEL=true` in Vercel)

### Security
- Dev-only by default
- Email-based access control
- Optional production enable with explicit configuration

---

## GitHub (CI/CD)

**Fully Automated** - Repository creation, Vercel integration

### What Gets Set Up
- ✅ GitHub CLI authentication
- ✅ Repository creation (public/private)
- ✅ Initial push of all code
- ✅ Vercel integration for auto-deployment
- ✅ GitHub Actions workflow (optional)

### Manual Steps
```bash
# If GitHub CLI isn't authenticated:
gh auth login
# Choose: Login via web browser (or paste token)

# Then resume setup:
./tuify/create-project.sh
```

### Features
- **Auto-Deployment**: Push to `main` → auto-deploy to Vercel production
- **Preview Deployments**: Any branch push → preview deployment
- **Status Checks**: Vercel deployment status in PR

---

## Environment Variables Summary

### Development (.env.local)
```bash
# Automatically populated during setup:
NEXT_PUBLIC_CONVEX_URL=https://...convex.cloud
CONVEX_DEPLOY_KEY=dev_...
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
AXIOM_DATASET=your-project-dev
AXIOM_TOKEN=xaat_...
LINEAR_API_KEY=lin_api_...
OPENAI_API_KEY=sk-proj-...
ANTHROPIC_API_KEY=sk-ant-...
```

### Production (Vercel Dashboard)
```bash
# Automatically set via Vercel API during setup:
NEXT_PUBLIC_CONVEX_URL=https://...convex.cloud
CONVEX_DEPLOY_KEY=prod_...
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_live_...
CLERK_SECRET_KEY=sk_live_...
AXIOM_TOKEN=xaat-prod-...
OPENAI_API_KEY=sk-proj-...
ANTHROPIC_API_KEY=sk-ant-...
```

---

## Need Help?

- Check generated `SETUP_GUIDE.md` in your project
- See [TROUBLESHOOTING.md](../ERROR_HANDLING_GUIDE.md) for common issues
- Official service documentation links in main README

