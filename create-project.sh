#!/bin/bash

# Launchify - Project Template Generator
# Transform your idea into a production-ready project with automated service setup

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source helper scripts
source "$SCRIPT_DIR/scripts/check-dependencies.sh"
source "$SCRIPT_DIR/scripts/install-clis.sh"
source "$SCRIPT_DIR/scripts/setup-vercel.sh"
source "$SCRIPT_DIR/scripts/setup-convex.sh"
source "$SCRIPT_DIR/scripts/setup-axiom.sh"
source "$SCRIPT_DIR/scripts/setup-clerk.sh"
source "$SCRIPT_DIR/scripts/setup-shadcn.sh"
source "$SCRIPT_DIR/scripts/setup-ai.sh"
source "$SCRIPT_DIR/scripts/setup-admin.sh"
source "$SCRIPT_DIR/scripts/utils.sh"
source "$SCRIPT_DIR/scripts/resume-setup.sh"
source "$SCRIPT_DIR/scripts/setup-vercel-env.sh"
source "$SCRIPT_DIR/scripts/detect-platform.sh"
source "$SCRIPT_DIR/scripts/interactive-ui.sh"

# Banner
echo -e "${PURPLE}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║                                                       ║"
echo "║                    LAUNCHIFY                          ║"
echo "║        Transform ideas into production apps           ║"
echo "║                                                       ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

# Disclaimer
echo -e "${YELLOW}DISCLAIMER:${NC}"
echo "This software is provided AS IS without warranty of any kind."
echo "You are responsible for reviewing generated code, API costs,"
echo "security, and compliance. See LICENSE for full terms."
echo ""
read -p "Do you accept these terms? [Y/n]: " ACCEPT_TERMS
ACCEPT_TERMS=${ACCEPT_TERMS:-Y}

if [[ ! $ACCEPT_TERMS =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi
echo ""

# Safety Check: Prevent running inside launchify directory
if [ -f "$SCRIPT_DIR/create-project.sh" ] && [ -d "$SCRIPT_DIR/scripts" ] && [ -d "$SCRIPT_DIR/templates" ]; then
    CURRENT_DIR=$(basename "$PWD")
    if [ "$PWD" = "$SCRIPT_DIR" ]; then
        echo -e "${RED}╔════════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║  ⚠️  SAFETY WARNING: Wrong Directory!              ║${NC}"
        echo -e "${RED}╚════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${YELLOW}You are running the generator inside the launchify directory itself!${NC}"
        echo -e "${YELLOW}This will create your project as a subdirectory of the generator.${NC}"
        echo ""
        echo -e "${CYAN}Recommended:${NC}"
        echo -e "  1. ${CYAN}cd ..${NC} (go up one directory)"
        echo -e "  2. ${CYAN}./launchify/create-project.sh${NC} (run from parent directory)"
        echo ""
        echo -e "${YELLOW}This way your project will be created alongside launchify, not inside it.${NC}"
        echo ""
        read -p "Continue anyway? [y/N]: " CONTINUE_ANYWAY
        CONTINUE_ANYWAY=${CONTINUE_ANYWAY:-N}

        if [[ ! $CONTINUE_ANYWAY =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}Good choice! Run from the parent directory instead.${NC}"
            exit 0
        fi

        echo -e "${YELLOW}⚠️  Proceeding anyway (not recommended)${NC}\n"
    fi
fi

# Security Notice
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         SECURITY & PRIVACY NOTICE                          ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✅ Safe Practices This Script Uses:${NC}"
echo ""
echo -e "  ${BLUE}What Gets Committed to Git:${NC}"
echo -e "    • Project code and configuration files"
echo -e "    • Templates and .gitignore"
echo -e "    • Setup guides and documentation"
echo ""
echo -e "  ${GREEN}What NEVER Gets Committed:${NC}"
echo -e "    • ${RED}.env.local${NC} - Your development secrets (in .gitignore)"
echo -e "    • ${RED}.env.production${NC} - Production secrets (in .gitignore)"
echo -e "    • ${RED}API keys and tokens${NC} - Never stored in Git"
echo ""
echo -e "  ${BLUE}How Environment Variables Are Set:${NC}"
echo -e "    • ${CYAN}Manual Entry:${NC} You type them when prompted (Clerk, Linear, AI)"
echo -e "    • ${CYAN}Vercel API:${NC} Sent directly to Vercel cloud (encrypted)"
echo -e "    • ${CYAN}Convex CLI:${NC} Managed by Convex deployment"
echo -e "    • ${CYAN}Axiom CLI:${NC} Managed by Axiom cloud"
echo ""
echo -e "  ${YELLOW}⚠️  Important:${NC}"
echo -e "    • Secrets stored ${GREEN}locally in .env.local${NC} (on your machine only)"
echo -e "    • Production secrets set ${GREEN}in Vercel dashboard${NC} (encrypted)"
echo -e "    • ${RED}Never commit .env files to Git${NC} (already in .gitignore)"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Platform Detection
setup_platform_tools
echo ""

# Step 1: Project Name and Location
echo -e "${CYAN}Step 1: Project Configuration${NC}"
read -p "Enter project name (lowercase, hyphens only): " PROJECT_NAME

# Validate project name
if [[ ! $PROJECT_NAME =~ ^[a-z0-9-]+$ ]]; then
    echo -e "${RED}❌ Invalid project name. Use lowercase letters, numbers, and hyphens only.${NC}"
    exit 1
fi

# Determine project creation directory
PARENT_DIR="$(cd .. && pwd)"
CURRENT_DIR="$(pwd)"
LAUNCHIFY_DIR_NAME="$(basename "$CURRENT_DIR")"

echo ""
echo -e "${YELLOW}📁 Project Location:${NC}"
echo -e "   By default, your project will be created in the parent directory:"
echo -e "   ${CYAN}$PARENT_DIR/$PROJECT_NAME${NC}"
echo ""
echo -e "   This keeps it separate from the Launchify template folder."
echo ""
read -p "Create project in parent directory? [Y/n]: " USE_PARENT
USE_PARENT=${USE_PARENT:-Y}

if [[ $USE_PARENT =~ ^[Yy]$ ]]; then
    PROJECT_DIR="$PARENT_DIR/$PROJECT_NAME"
    cd "$PARENT_DIR" || exit 1
    echo -e "${GREEN}✓ Project will be created at: $PROJECT_DIR${NC}"
else
    PROJECT_DIR="$CURRENT_DIR/$PROJECT_NAME"
    echo -e "${GREEN}✓ Project will be created at: $PROJECT_DIR${NC}"
    echo -e "${YELLOW}⚠️  Note: Project will be created inside the Launchify directory${NC}"
fi
echo ""

# Check if directory already exists
RESUMING=false
if [ -d "$PROJECT_NAME" ]; then
    # Project exists - detect what's configured
    detect_configured_services "$PROJECT_NAME"

    # Ask user what to do
    if ask_resume_action; then
        # User chose to resume
        RESUMING=true
        cd "$PROJECT_NAME" || exit 1
        echo -e "${GREEN}✓ Resuming setup for '$PROJECT_NAME'${NC}\n"
    else
        # User chose to start fresh - project was deleted
        RESUMING=false
    fi
else
    # Initialize detection flags for new project
    HAS_VERCEL=false
    HAS_CONVEX=false
    HAS_CLERK=false
    HAS_AXIOM=false
    HAS_SHADCN=false
    HAS_AI=false
    HAS_ADMIN=false
    HAS_ENV=false
    HAS_GUIDE=false
fi

echo -e "${GREEN}✓ Project name: $PROJECT_NAME${NC}\n"

# Step 2: Package Manager Selection
echo -e "${CYAN}Step 2: Package Manager${NC}"

# Try interactive UI first, fall back to CLI
if ! show_package_manager_ui; then
    echo "Select your package manager:"
    echo "  1) npm (default)"
    echo "  2) pnpm"
    echo "  3) yarn"
    read -p "Choice [1-3] (default: 1): " PKG_MANAGER_CHOICE

    case $PKG_MANAGER_CHOICE in
        2) PACKAGE_MANAGER="pnpm" ;;
        3) PACKAGE_MANAGER="yarn" ;;
        *) PACKAGE_MANAGER="npm" ;;
    esac
fi

echo -e "${GREEN}✓ Package manager: $PACKAGE_MANAGER${NC}\n"

# Step 3: Framework Selection
echo -e "${CYAN}Step 3: Framework${NC}"
echo "Select your framework:"
echo "  1) Next.js 15 + TypeScript + Tailwind (recommended)"
echo "  2) Plain React + TypeScript (coming soon)"
echo "  3) Node.js Express API (coming soon)"
read -p "Choice [1-3] (default: 1): " FRAMEWORK_CHOICE

case $FRAMEWORK_CHOICE in
    1) FRAMEWORK="nextjs" ;;
    2)
        echo -e "${YELLOW}⚠️  Plain React template coming soon. Using Next.js for now.${NC}"
        FRAMEWORK="nextjs"
        ;;
    3)
        echo -e "${YELLOW}⚠️  Express template coming soon. Using Next.js for now.${NC}"
        FRAMEWORK="nextjs"
        ;;
    *) FRAMEWORK="nextjs" ;;
esac

echo -e "${GREEN}✓ Framework: $FRAMEWORK${NC}\n"

# Step 4 & 5: Feature Selection (Interactive UI with CLI fallback)
echo -e "${CYAN}Step 4: Feature Selection${NC}"

# Try interactive UI first, fall back to CLI
if ! show_feature_selection_ui; then
    echo -e "${YELLOW}Using CLI mode...${NC}"
    echo ""

    # Service Selection
    echo "Select services to integrate (y/n):"

    read -p "  Vercel (Deployment) [Y/n]: " USE_VERCEL
    USE_VERCEL=${USE_VERCEL:-Y}

    read -p "  Convex (Backend/Database) [Y/n]: " USE_CONVEX
    USE_CONVEX=${USE_CONVEX:-Y}

    read -p "  Clerk (Authentication) [Y/n]: " USE_CLERK
    USE_CLERK=${USE_CLERK:-Y}

    read -p "  Axiom (Observability) [y/N]: " USE_AXIOM
    USE_AXIOM=${USE_AXIOM:-N}

    read -p "  Linear (Issue/Project Tracking) [y/N]: " USE_LINEAR
    USE_LINEAR=${USE_LINEAR:-N}

    echo ""

    # Convert to boolean flags
    [[ $USE_VERCEL =~ ^[Yy]$ ]] && USE_VERCEL=true || USE_VERCEL=false
    [[ $USE_CONVEX =~ ^[Yy]$ ]] && USE_CONVEX=true || USE_CONVEX=false
    [[ $USE_CLERK =~ ^[Yy]$ ]] && USE_CLERK=true || USE_CLERK=false
    [[ $USE_AXIOM =~ ^[Yy]$ ]] && USE_AXIOM=true || USE_AXIOM=false
    [[ $USE_LINEAR =~ ^[Yy]$ ]] && USE_LINEAR=true || USE_LINEAR=false

    # UI & Features
    echo "Select additional features (y/n):"

    read -p "  shadcn/ui + Dark Mode [Y/n]: " USE_SHADCN
    USE_SHADCN=${USE_SHADCN:-Y}
    [[ $USE_SHADCN =~ ^[Yy]$ ]] && USE_SHADCN=true || USE_SHADCN=false

    read -p "  AI Integration [y/N]: " USE_AI
    USE_AI=${USE_AI:-N}
    [[ $USE_AI =~ ^[Yy]$ ]] && USE_AI=true || USE_AI=false

    # AI Provider selection
    AI_PROVIDER="none"
    if $USE_AI; then
        echo "  Which AI provider?"
        echo "    1) OpenAI (GPT-4, etc.)"
        echo "    2) Anthropic (Claude)"
        echo "    3) Both"
        read -p "  Choice [1-3]: " AI_CHOICE
        case $AI_CHOICE in
            1) AI_PROVIDER="openai" ;;
            2) AI_PROVIDER="anthropic" ;;
            3) AI_PROVIDER="both" ;;
            *) AI_PROVIDER="openai" ;;
        esac
    fi

    read -p "  Admin Panel (requires Convex) [y/N]: " USE_ADMIN
    USE_ADMIN=${USE_ADMIN:-N}
    [[ $USE_ADMIN =~ ^[Yy]$ ]] && USE_ADMIN=true || USE_ADMIN=false
fi

# Check if admin panel requires Convex
if $USE_ADMIN && ! $USE_CONVEX; then
    echo -e "\n${YELLOW}⚠️  Admin Panel requires Convex backend.${NC}"
    read -p "Enable Convex? [Y/n]: " ENABLE_CONVEX_FOR_ADMIN
    ENABLE_CONVEX_FOR_ADMIN=${ENABLE_CONVEX_FOR_ADMIN:-Y}
    if [[ $ENABLE_CONVEX_FOR_ADMIN =~ ^[Yy]$ ]]; then
        USE_CONVEX=true
        echo -e "${GREEN}✓ Convex enabled${NC}"
    else
        USE_ADMIN=false
        echo -e "${YELLOW}⚠️  Admin Panel disabled (requires Convex)${NC}"
    fi
fi

# Admin panel production setting
ADMIN_PROD_ENABLED=false
if $USE_ADMIN; then
    read -p "  Enable admin panel in production? [y/N]: " ADMIN_PROD
    ADMIN_PROD=${ADMIN_PROD:-N}
    [[ $ADMIN_PROD =~ ^[Yy]$ ]] && ADMIN_PROD_ENABLED=true || ADMIN_PROD_ENABLED=false
fi

echo ""

# Summary
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}Configuration Summary:${NC}"
echo -e "  Project: ${GREEN}$PROJECT_NAME${NC}"
echo -e "  Package Manager: ${GREEN}$PACKAGE_MANAGER${NC}"
echo -e "  Framework: ${GREEN}$FRAMEWORK${NC}"
echo -e "  Services:"
$USE_VERCEL && echo -e "    ${GREEN}✓${NC} Vercel" || echo -e "    ${RED}✗${NC} Vercel"
$USE_CONVEX && echo -e "    ${GREEN}✓${NC} Convex" || echo -e "    ${RED}✗${NC} Convex"
$USE_CLERK && echo -e "    ${GREEN}✓${NC} Clerk" || echo -e "    ${RED}✗${NC} Clerk"
$USE_AXIOM && echo -e "    ${GREEN}✓${NC} Axiom" || echo -e "    ${RED}✗${NC} Axiom"
$USE_LINEAR && echo -e "    ${GREEN}✓${NC} Linear" || echo -e "    ${RED}✗${NC} Linear"
echo -e "  Features:"
$USE_SHADCN && echo -e "    ${GREEN}✓${NC} shadcn/ui + Dark Mode" || echo -e "    ${RED}✗${NC} shadcn/ui"
if $USE_AI; then
    echo -e "    ${GREEN}✓${NC} AI Integration ($AI_PROVIDER)"
else
    echo -e "    ${RED}✗${NC} AI Integration"
fi
$USE_ADMIN && echo -e "    ${GREEN}✓${NC} Admin Panel" || echo -e "    ${RED}✗${NC} Admin Panel"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

read -p "Proceed with setup? [Y/n]: " CONFIRM
CONFIRM=${CONFIRM:-Y}

if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Setup cancelled.${NC}"
    exit 0
fi

echo ""

# Step 5: Check Dependencies
echo -e "${CYAN}Step 5: Checking Dependencies${NC}"
check_dependencies "$USE_VERCEL" "$USE_CONVEX" "$USE_AXIOM" "$PACKAGE_MANAGER"
echo ""

# Step 6: Install Missing CLIs
echo -e "${CYAN}Step 6: Installing Missing CLIs${NC}"
install_missing_clis "$USE_VERCEL" "$USE_CONVEX" "$USE_AXIOM"
echo ""

# Step 7: Create Project
if ! $RESUMING; then
    echo -e "${CYAN}🚀 Step 7: Creating Project${NC}"
    create_project "$PROJECT_NAME" "$FRAMEWORK" "$PACKAGE_MANAGER"
    echo ""
    cd "$PROJECT_NAME"
else
    echo -e "${CYAN}Step 7: Project Creation${NC}"
    echo -e "${BLUE}⏭️  Skipping - project already exists${NC}"
    echo ""
fi

# Step 8: Setup Services

if should_setup_service "Vercel" "$USE_VERCEL" "$HAS_VERCEL"; then
    echo -e "${CYAN}Setting up Vercel...${NC}"
    setup_vercel "$PROJECT_NAME"
    echo ""
fi

if should_setup_service "Convex" "$USE_CONVEX" "$HAS_CONVEX"; then
    echo -e "${CYAN}Setting up Convex...${NC}"
    setup_convex "$PROJECT_NAME" "$PACKAGE_MANAGER"
    echo ""
fi

if should_setup_service "Axiom" "$USE_AXIOM" "$HAS_AXIOM"; then
    echo -e "${CYAN}Setting up Axiom Observability...${NC}"
    echo -e "${BLUE}After setup, you'll need to run: ${GREEN}axiom auth login${NC}"
    echo -e "${BLUE}and create an API token${NC}"
    echo ""
    if setup_axiom "$PROJECT_NAME"; then
        echo -e "${GREEN}✓ Axiom setup completed${NC}"
    else
        echo -e "${YELLOW}⚠️  Axiom setup incomplete - manual configuration needed${NC}"
        echo -e "${CYAN}See SETUP_GUIDE.md for manual setup instructions${NC}"
    fi
    echo ""
fi

if should_setup_service "Clerk" "$USE_CLERK" "$HAS_CLERK"; then
    echo -e "${CYAN}Setting up Clerk Authentication...${NC}"
    echo -e "${BLUE}This will set up webhooks and configure Clerk automatically${NC}"
    echo -e "${BLUE}You'll need your Clerk API keys from: ${CYAN}https://dashboard.clerk.com${NC}"
    echo ""

    if setup_clerk "$USE_CONVEX" "$USE_VERCEL" "$PROJECT_NAME"; then
        CLERK_AUTOMATED=true
        echo -e "${GREEN}✓ Clerk automated setup completed${NC}"
    else
        CLERK_AUTOMATED=false
        echo -e "${YELLOW}⚠️  Clerk needs manual configuration${NC}"
        echo -e "${BLUE}See the manual setup summary at the end${NC}"
    fi
    echo ""
fi

# Step 9: Setup UI & Features
if should_setup_service "shadcn/ui" "$USE_SHADCN" "$HAS_SHADCN"; then
    echo -e "${CYAN}Setting up shadcn/ui...${NC}"
    setup_shadcn "$PACKAGE_MANAGER"
    echo ""
fi

if should_setup_service "AI Integration" "$USE_AI" "$HAS_AI"; then
    echo -e "${CYAN}Setting up AI Integration...${NC}"
    if [ "$AI_PROVIDER" = "openai" ]; then
        echo -e "${BLUE}Get your API key from: ${CYAN}https://platform.openai.com/api-keys${NC}"
    elif [ "$AI_PROVIDER" = "anthropic" ]; then
        echo -e "${BLUE}Get your API key from: ${CYAN}https://console.anthropic.com/settings/keys${NC}"
    elif [ "$AI_PROVIDER" = "both" ]; then
        echo -e "${BLUE}You'll need API keys from both:${NC}"
        echo -e "${BLUE}OpenAI: ${CYAN}https://platform.openai.com/api-keys${NC}"
        echo -e "${BLUE}Anthropic: ${CYAN}https://console.anthropic.com/settings/keys${NC}"
    fi
    echo ""
    setup_ai "$PACKAGE_MANAGER" "$AI_PROVIDER"
    echo ""
fi

if should_setup_service "Admin Panel" "$USE_ADMIN" "$HAS_ADMIN"; then
    echo -e "${CYAN}Setting up Admin Panel...${NC}"
    setup_admin_panel "$USE_CLERK" "$USE_AXIOM" "$USE_LINEAR" "$ADMIN_PROD_ENABLED"
    echo ""
fi

# Step 10: Generate Environment Files
if ! $HAS_ENV || $RESUMING; then
    echo -e "${CYAN}Step 10: Generating Environment Files${NC}"
    echo -e "${YELLOW}Security Reminder:${NC}"
    echo -e "   • .env.local contains your secrets - ${GREEN}stored locally only${NC}"
    echo -e "   • ${RED}Never commit .env files to Git${NC}"
    echo -e "   • Production secrets set separately in Vercel dashboard"
    echo ""
    generate_env_files "$USE_VERCEL" "$USE_CONVEX" "$USE_CLERK" "$USE_AXIOM" "$USE_LINEAR" "$USE_AI" "$AI_PROVIDER"
    echo ""
    echo -e "${GREEN}✓ Environment files created${NC}"
    echo -e "${BLUE}.env.local is already in .gitignore - safe from Git${NC}"
    echo ""
else
    echo -e "${CYAN}Step 10: Environment Files${NC}"
    echo -e "${BLUE}⏭️  .env.local already exists${NC}"
    echo ""
fi

# Step 11: Create Setup Guides
if ! $HAS_GUIDE || $RESUMING; then
    echo -e "${CYAN}Step 11: Creating Setup Guides${NC}"

    # Always copy Vercel environment setup guide
    cp "$SCRIPT_DIR/guides/VERCEL_ENVIRONMENT_SETUP.md" .
    echo -e "${GREEN}✓ VERCEL_ENVIRONMENT_SETUP.md created${NC}"

    # Create service-specific guides if needed
    if $USE_CLERK || $USE_LINEAR; then
        create_setup_guides "$USE_CLERK" "$USE_LINEAR"
    fi

    echo ""
else
    echo -e "${CYAN}Step 11: Setup Guides${NC}"
    echo -e "${BLUE}⏭️  Setup guides already exist${NC}"
    echo ""
fi

# Step 12: Validate Build
echo -e "${CYAN}Step 12: Validating Project Build${NC}"
echo -e "${BLUE}Running type check...${NC}"
if [ "$PACKAGE_MANAGER" = "pnpm" ]; then
    pnpm tsc --noEmit
elif [ "$PACKAGE_MANAGER" = "yarn" ]; then
    yarn tsc --noEmit
else
    npm run tsc --noEmit 2>/dev/null || npx tsc --noEmit
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Type check passed${NC}"
else
    echo -e "${YELLOW}⚠️  Type check had warnings (non-critical)${NC}"
fi

echo -e "${BLUE}Running lint...${NC}"
if [ "$PACKAGE_MANAGER" = "pnpm" ]; then
    pnpm lint
elif [ "$PACKAGE_MANAGER" = "yarn" ]; then
    yarn lint
else
    npm run lint
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Lint passed${NC}"
else
    echo -e "${YELLOW}⚠️  Lint had warnings${NC}"
fi

echo -e "${BLUE}Running production build...${NC}"
if [ "$PACKAGE_MANAGER" = "pnpm" ]; then
    pnpm build
elif [ "$PACKAGE_MANAGER" = "yarn" ]; then
    yarn build
else
    npm run build
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Production build successful${NC}"
    echo -e "${GREEN}✓ Project is ready for Vercel deployment${NC}\n"
else
    echo -e "${RED}✗ Build failed${NC}"
    echo -e "${YELLOW}⚠️  Please fix build errors before deploying${NC}\n"
fi

# Step 13: Initialize Git
echo -e "${CYAN}Step 13: Initializing Git Repository${NC}"
git init
git add .
git commit -m "Initial commit: $PROJECT_NAME - Launchify template with automated setup"
echo -e "${GREEN}✓ Git repository initialized${NC}\n"

# Step 14: Optional GitHub Setup
echo -e "${CYAN}Step 14: GitHub Repository Setup${NC}"
echo -e "Do you want to push this project to GitHub now?"
read -p "Add GitHub remote and push? [y/N]: " SETUP_GITHUB
SETUP_GITHUB=${SETUP_GITHUB:-N}

if [[ $SETUP_GITHUB =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${BLUE}GitHub Repository Setup${NC}"
    echo -e "${YELLOW}Please create a repository on GitHub first if you haven't already:${NC}"
    echo -e "  ${CYAN}https://github.com/new${NC}"
    echo ""

    read -p "Enter your GitHub repository URL (e.g., https://github.com/username/repo.git): " REPO_URL

    if [ -n "$REPO_URL" ]; then
        echo -e "${BLUE}Adding remote...${NC}"
        git remote add origin "$REPO_URL"

        echo -e "${BLUE}Renaming branch to main...${NC}"
        git branch -M main

        echo -e "${BLUE}Pushing to GitHub...${NC}"
        if git push -u origin main; then
            echo -e "${GREEN}✓ Successfully pushed to GitHub!${NC}"
            echo -e "${GREEN}✓ Repository: $REPO_URL${NC}\n"
        else
            echo -e "${YELLOW}⚠️  Push failed. You may need to authenticate or check your repository URL.${NC}"
            echo -e "${CYAN}You can push manually later with:${NC}"
            echo -e "  ${CYAN}git push -u origin main${NC}\n"
        fi
    else
        echo -e "${YELLOW}⚠️  No repository URL provided. Skipping push.${NC}\n"
    fi
else
    echo -e "${BLUE}Skipping GitHub setup. You can push later with:${NC}"
    echo -e "  ${CYAN}git remote add origin <your-repo-url>${NC}"
    echo -e "  ${CYAN}git branch -M main${NC}"
    echo -e "  ${CYAN}git push -u origin main${NC}\n"
fi

# Final Summary
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                       ║${NC}"
echo -e "${GREEN}║          🚀 PROJECT SETUP COMPLETE! 🚀               ║${NC}"
echo -e "${GREEN}║                                                       ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}\n"

echo -e "${CYAN}Project created at: ${GREEN}$PROJECT_DIR${NC}\n"

# Show detailed manual setup summary
CLERK_AUTOMATED=${CLERK_AUTOMATED:-false}
show_manual_setup_summary "$USE_CLERK" "$USE_AXIOM" "$USE_LINEAR" "$USE_AI" "$AI_PROVIDER" "$CLERK_AUTOMATED"

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}GETTING STARTED - RUNNING YOUR PROJECT${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${CYAN}1. Navigate to your project:${NC}"
echo -e "   ${GREEN}cd $PROJECT_DIR${NC}\n"

echo -e "${CYAN}2. Review and update environment variables:${NC}"
echo -e "   ${GREEN}# Edit .env.local and add your API keys${NC}"
echo -e "   ${GREEN}# See the manual setup instructions above for details${NC}\n"

if $USE_CONVEX; then
    echo -e "${CYAN}3. Start your development servers:${NC}"
    echo -e "   ${GREEN}# Terminal 1 - Start Convex${NC}"
    echo -e "   ${GREEN}npx convex dev${NC}\n"
    echo -e "   ${GREEN}# Terminal 2 - Start Next.js${NC}"
    echo -e "   ${GREEN}$PACKAGE_MANAGER run dev${NC}\n"
    echo -e "   ${BLUE}Your app will be running at: ${CYAN}http://localhost:3000${NC}\n"
else
    echo -e "${CYAN}3. Start your development server:${NC}"
    echo -e "   ${GREEN}$PACKAGE_MANAGER run dev${NC}\n"
    echo -e "   ${BLUE}Your app will be running at: ${CYAN}http://localhost:3000${NC}\n"
fi

if $USE_ADMIN; then
    echo -e "${CYAN}4. Access the admin panel:${NC}"
    echo -e "   ${GREEN}http://localhost:3000/admin${NC}\n"
fi

# Only show git push instructions if user didn't already push
if [[ ! $SETUP_GITHUB =~ ^[Yy]$ ]]; then
    echo -e "${CYAN}5. Push to GitHub (when ready):${NC}"
    echo -e "   ${GREEN}git remote add origin <your-repo-url>${NC}"
    echo -e "   ${GREEN}git push -u origin main${NC}\n"
fi

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
echo -e "${GREEN}✨ Happy coding!${NC}\n"
