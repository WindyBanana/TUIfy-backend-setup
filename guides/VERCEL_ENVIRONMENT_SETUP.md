# Vercel Environment Variables Setup Guide

This guide explains how to properly configure environment variables across Vercel's three deployment environments.

---

## Vercel's Three Environments

Vercel has **three separate environments** for your variables:

| Environment   | Branches        | Purpose                    | Example URL                          |
|---------------|-----------------|----------------------------|--------------------------------------|
| **Production**    | `main` or `master` | Live users, production data | `https://your-app.com`              |
| **Preview**       | All other branches | PR testing, staging       | `https://your-app-git-feature.vercel.app` |
| **Development**   | Local machine   | `npm run dev` on localhost | `http://localhost:3000`             |

---

## Environment Variable Strategy

### Which Variables Go Where?

#### ✅ **All Three Environments** (Development + Preview + Production)
These are **public** or **non-sensitive** configuration:
```bash
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/dashboard
NEXT_PUBLIC_EU_REGION=true
DATA_RETENTION_DAYS=30
```

#### ⚠️ **Preview + Production Only**
Test/staging keys that work in both non-local environments:
```bash
# Usually you'll use test keys for Preview
# Set these in Vercel dashboard for Preview environment
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
```

#### 🔒 **Production Only**
Live API keys and production resources:
```bash
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_live_...
CLERK_SECRET_KEY=sk_live_...
NEXT_PUBLIC_CONVEX_URL=https://prod-deployment.convex.cloud
CONVEX_DEPLOY_KEY=prod_...
AXIOM_DATASET=your-app-prod
```

---

## 🔧 How to Set Variables in Vercel

### Step 1: Go to Vercel Dashboard
1. Open: `https://vercel.com/[your-username]/[your-project]`
2. Click **Settings** → **Environment Variables**

### Step 2: Add Each Variable

For each variable, you'll see checkboxes:
```
┌─────────────────────────────────────────┐
│ Key:   NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY│
│ Value: pk_live_xxxxx                    │
│                                          │
│ ☑ Production                             │
│ ☐ Preview                                │
│ ☐ Development                            │
└─────────────────────────────────────────┘
```

**Important:** Check the appropriate boxes based on the tables below.

---

## Complete Variable Configuration

### Clerk (Authentication)

**Development (`.env.local`):**
```bash
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
```

**Vercel Dashboard:**

| Variable | Value | Environments |
|----------|-------|--------------|
| `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY` | `pk_test_...` | ☐ Production ☑ Preview ☐ Dev |
| `CLERK_SECRET_KEY` | `sk_test_...` | ☐ Production ☑ Preview ☐ Dev |
| `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY` | `pk_live_...` | ☑ Production ☐ Preview ☐ Dev |
| `CLERK_SECRET_KEY` | `sk_live_...` | ☑ Production ☐ Preview ☐ Dev |
| `NEXT_PUBLIC_CLERK_SIGN_IN_URL` | `/sign-in` | ☑ Production ☑ Preview ☐ Dev |
| `NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL` | `/dashboard` | ☑ Production ☑ Preview ☐ Dev |

---

### Convex (Backend/Database)

**Development (`.env.local`):**
```bash
NEXT_PUBLIC_CONVEX_URL=https://dev-abc123.convex.cloud
CONVEX_DEPLOY_KEY=dev_...
CONVEX_DEPLOYMENT=dev:your-project
```

**Vercel Dashboard:**

| Variable | Value | Environments |
|----------|-------|--------------|
| `NEXT_PUBLIC_CONVEX_URL` | `https://dev-abc123.convex.cloud` | ☐ Production ☑ Preview ☐ Dev |
| `CONVEX_DEPLOY_KEY` | `dev_...` | ☐ Production ☑ Preview ☐ Dev |
| `NEXT_PUBLIC_CONVEX_URL` | `https://prod-xyz789.convex.cloud` | ☑ Production ☐ Preview ☐ Dev |
| `CONVEX_DEPLOY_KEY` | `prod_...` | ☑ Production ☐ Preview ☐ Dev |
| `CONVEX_DEPLOYMENT` | `prod:your-project` | ☑ Production ☐ Preview ☐ Dev |

**Creating Production Deployment:**
```bash
# In your project directory
npx convex deploy --prod

# This creates a new production deployment
# Copy the URL and deploy key to Vercel
```

---

### Axiom (Observability)

**Development (`.env.local`):**
```bash
AXIOM_DATASET=your-app-dev
AXIOM_TOKEN=xaat-...
AXIOM_ORG_ID=your-org-id
```

**Vercel Dashboard:**

| Variable | Value | Environments |
|----------|-------|--------------|
| `AXIOM_DATASET` | `your-app-dev` | ☐ Production ☑ Preview ☐ Dev |
| `AXIOM_DATASET` | `your-app-prod` | ☑ Production ☐ Preview ☐ Dev |
| `AXIOM_TOKEN` | `xaat-...` | ☑ Production ☑ Preview ☐ Dev |
| `AXIOM_ORG_ID` | `your-org-id` | ☑ Production ☑ Preview ☐ Dev |

**Best Practice:** Use separate datasets for dev/prod to keep logs isolated.

---

### AI APIs (OpenAI/Anthropic)

**Development (`.env.local`):**
```bash
OPENAI_API_KEY=sk-proj-...
ANTHROPIC_API_KEY=sk-ant-...
```

**Vercel Dashboard:**

| Variable | Value | Environments |
|----------|-------|--------------|
| `OPENAI_API_KEY` | `sk-proj-...` | ☑ Production ☑ Preview ☐ Dev |
| `ANTHROPIC_API_KEY` | `sk-ant-...` | ☑ Production ☑ Preview ☐ Dev |

**Note:** Usually the same API key works across all environments (usage-based billing).

---

### Linear (Project Tracking)

**Development (`.env.local`):**
```bash
LINEAR_API_KEY=lin_api_...
LINEAR_TEAM_ID=your-team-id
```

**Vercel Dashboard:**

| Variable | Value | Environments |
|----------|-------|--------------|
| `LINEAR_API_KEY` | `lin_api_...` | ☑ Production ☑ Preview ☐ Dev |
| `LINEAR_TEAM_ID` | `your-team-id` | ☑ Production ☑ Preview ☐ Dev |

---

### Application Configuration

**Development (`.env.local`):**
```bash
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_ENVIRONMENT=development
NEXT_PUBLIC_EU_REGION=true
DATA_RETENTION_DAYS=30
```

**Vercel Dashboard:**

| Variable | Value | Environments |
|----------|-------|--------------|
| `NEXT_PUBLIC_APP_URL` | `https://your-app-git-*.vercel.app` | ☐ Production ☑ Preview ☐ Dev |
| `NEXT_PUBLIC_APP_URL` | `https://your-app.com` | ☑ Production ☐ Preview ☐ Dev |
| `NEXT_PUBLIC_ENVIRONMENT` | `preview` | ☐ Production ☑ Preview ☐ Dev |
| `NEXT_PUBLIC_ENVIRONMENT` | `production` | ☑ Production ☐ Preview ☐ Dev |
| `NEXT_PUBLIC_EU_REGION` | `true` | ☑ Production ☑ Preview ☐ Dev |
| `DATA_RETENTION_DAYS` | `30` | ☑ Production ☑ Preview ☐ Dev |

---

## 🚀 Deployment Workflow

### Initial Setup (One Time)

1. **Create Production Convex Deployment:**
   ```bash
   npx convex deploy --prod
   ```

2. **Create Production Clerk Application:**
   - Go to dashboard.clerk.com
   - Create new application: `your-app-prod`
   - Get `pk_live_` and `sk_live_` keys

3. **Create Production Axiom Dataset:**
   ```bash
   axiom dataset create your-app-prod
   ```

### For Each Deployment

1. **Push to Branch:**
   ```bash
   git push origin feature-branch
   ```
   → Triggers **Preview** deployment (uses Preview env vars)

2. **Merge to Main:**
   ```bash
   git push origin main
   ```
   → Triggers **Production** deployment (uses Production env vars)

---

## ✅ Verification Checklist

Before deploying to production, verify:

- [ ] All production API keys added to Vercel (Production environment only)
- [ ] Preview keys added to Vercel (Preview environment)
- [ ] `NEXT_PUBLIC_` variables set correctly (visible in browser!)
- [ ] Convex production deployment created and URL added
- [ ] Clerk production application created with live keys
- [ ] Axiom production dataset created
- [ ] `NEXT_PUBLIC_APP_URL` points to your custom domain
- [ ] Environment indicators set (`NEXT_PUBLIC_ENVIRONMENT`)

---

## 🐛 Common Issues

### Issue: "Clerk authentication not working in Preview"
**Solution:** Make sure Preview environment has `pk_test_` keys set in Vercel dashboard.

### Issue: "Convex data not syncing in Production"
**Solution:** Verify `NEXT_PUBLIC_CONVEX_URL` points to production deployment, not dev.

### Issue: "API keys exposed in browser"
**Solution:** Non-`NEXT_PUBLIC_` variables are server-only. Never put secrets in `NEXT_PUBLIC_` vars.

### Issue: "Environment variables not updating"
**Solution:** After changing Vercel env vars, trigger a new deployment (push a commit or redeploy).

---

## Resources

- **Vercel Docs:** https://vercel.com/docs/concepts/projects/environment-variables
- **Convex Deployments:** https://docs.convex.dev/production/hosting/deploy
- **Clerk Instances:** https://clerk.com/docs/deployments/environments
- **Axiom Datasets:** https://axiom.co/docs/getting-started/datasets

---

## 🎓 Best Practices

1. **Never commit production keys** to git
2. **Use separate resources** for dev/prod (databases, auth instances, etc.)
3. **Test in Preview** before merging to main
4. **Set environment indicators** to know which environment you're in
5. **Use descriptive dataset names** with environment suffixes
6. **Regularly rotate API keys** for security
7. **Document custom variables** your team adds

---

**Generated by TUIfy** 🚀
