#!/bin/bash

# Interactive UI for feature selection using whiptail/dialog

show_feature_selection_ui() {
    # Check if whiptail or dialog is available
    if command -v whiptail &> /dev/null; then
        UI_TOOL="whiptail"
    elif command -v dialog &> /dev/null; then
        UI_TOOL="dialog"
    else
        echo -e "${YELLOW}⚠️  whiptail/dialog not available, using CLI mode${NC}"
        return 1
    fi

    # Create temp file for results
    local temp_file=$(mktemp)

    # Service selection
    $UI_TOOL --title "Launchify - Service Selection" \
        --checklist "Select services to integrate (Space to select, Enter to confirm):" \
        20 78 6 \
        "VERCEL" "Deployment platform with auto-linking" ON \
        "CONVEX" "Serverless backend & real-time database" ON \
        "CLERK" "Authentication (fully automated via API)" ON \
        "AXIOM" "Observability & logging" OFF \
        "LINEAR" "Issue/project tracking (GraphQL API)" OFF \
        2>"$temp_file"

    if [[ $? -ne 0 ]]; then
        rm "$temp_file"
        return 1
    fi

    # Parse results
    local selected=$(cat "$temp_file")
    rm "$temp_file"

    # Set boolean variables based on selection
    [[ "$selected" == *"VERCEL"* ]] && USE_VERCEL=true || USE_VERCEL=false
    [[ "$selected" == *"CONVEX"* ]] && USE_CONVEX=true || USE_CONVEX=false
    [[ "$selected" == *"CLERK"* ]] && USE_CLERK=true || USE_CLERK=false
    [[ "$selected" == *"AXIOM"* ]] && USE_AXIOM=true || USE_AXIOM=false
    [[ "$selected" == *"LINEAR"* ]] && USE_LINEAR=true || USE_LINEAR=false

    # UI & Features selection
    $UI_TOOL --title "Launchify - UI & Features" \
        --checklist "Select additional features (Space to select, Enter to confirm):" \
        20 78 3 \
        "SHADCN" "shadcn/ui component library + dark mode" ON \
        "AI" "AI Integration (OpenAI/Anthropic)" OFF \
        "ADMIN" "Admin Panel (requires Convex)" OFF \
        2>"$temp_file"

    if [[ $? -ne 0 ]]; then
        rm "$temp_file"
        return 1
    fi

    selected=$(cat "$temp_file")
    rm "$temp_file"

    [[ "$selected" == *"SHADCN"* ]] && USE_SHADCN=true || USE_SHADCN=false
    [[ "$selected" == *"AI"* ]] && USE_AI=true || USE_AI=false
    [[ "$selected" == *"ADMIN"* ]] && USE_ADMIN=true || USE_ADMIN=false

    # AI Provider selection if AI is enabled
    if $USE_AI; then
        $UI_TOOL --title "AI Provider" \
            --radiolist "Choose AI provider:" \
            15 78 3 \
            "OPENAI" "OpenAI (GPT-4, etc.)" ON \
            "ANTHROPIC" "Anthropic (Claude)" OFF \
            "BOTH" "Both providers" OFF \
            2>"$temp_file"

        if [[ $? -eq 0 ]]; then
            local ai_choice=$(cat "$temp_file")
            case $ai_choice in
                "OPENAI") AI_PROVIDER="openai" ;;
                "ANTHROPIC") AI_PROVIDER="anthropic" ;;
                "BOTH") AI_PROVIDER="both" ;;
                *) AI_PROVIDER="openai" ;;
            esac
        else
            AI_PROVIDER="openai"
        fi
        rm "$temp_file"
    fi

    # Admin panel production setting if enabled
    if $USE_ADMIN; then
        $UI_TOOL --title "Admin Panel" \
            --yesno "Enable admin panel in production?\n\n(Disabled by default for security)" \
            10 60

        if [[ $? -eq 0 ]]; then
            ADMIN_PROD_ENABLED=true
        else
            ADMIN_PROD_ENABLED=false
        fi
    fi

    # Show configuration summary
    show_config_summary_ui

    return 0
}

show_config_summary_ui() {
    local summary=""

    summary+="PROJECT: $PROJECT_NAME\n"
    summary+="PACKAGE MANAGER: $PACKAGE_MANAGER\n"
    summary+="FRAMEWORK: Next.js 15\n\n"

    summary+="SERVICES:\n"
    $USE_VERCEL && summary+="  ✓ Vercel\n" || summary+="  ✗ Vercel\n"
    $USE_CONVEX && summary+="  ✓ Convex\n" || summary+="  ✗ Convex\n"
    $USE_CLERK && summary+="  ✓ Clerk\n" || summary+="  ✗ Clerk\n"
    $USE_AXIOM && summary+="  ✓ Axiom\n" || summary+="  ✗ Axiom\n"
    $USE_LINEAR && summary+="  ✓ Linear\n" || summary+="  ✗ Linear\n"

    summary+="\nFEATURES:\n"
    $USE_SHADCN && summary+="  ✓ shadcn/ui\n" || summary+="  ✗ shadcn/ui\n"
    $USE_AI && summary+="  ✓ AI Integration ($AI_PROVIDER)\n" || summary+="  ✗ AI Integration\n"
    $USE_ADMIN && summary+="  ✓ Admin Panel\n" || summary+="  ✗ Admin Panel\n"

    if command -v whiptail &> /dev/null; then
        whiptail --title "Configuration Summary" \
            --yesno "$summary\n\nProceed with this configuration?" \
            22 60

        if [[ $? -ne 0 ]]; then
            echo ""
            echo "Setup cancelled."
            exit 0
        fi
    elif command -v dialog &> /dev/null; then
        dialog --title "Configuration Summary" \
            --yesno "$summary\n\nProceed with this configuration?" \
            22 60

        if [[ $? -ne 0 ]]; then
            echo ""
            echo "Setup cancelled."
            exit 0
        fi
        clear
    fi
}

show_progress_ui() {
    local title=$1
    local message=$2
    local percent=$3

    if command -v whiptail &> /dev/null; then
        echo "$percent" | whiptail --title "$title" --gauge "$message" 8 60 0
    elif command -v dialog &> /dev/null; then
        echo "$percent" | dialog --title "$title" --gauge "$message" 8 60
    fi
}

show_completion_ui() {
    local project_name=$1

    local message="✅ Project Created Successfully!\n\n"
    message+="Location: ./$project_name\n\n"
    message+="Next Steps:\n"
    message+="1. cd $project_name\n"
    message+="2. Review .env.local and add any missing values\n"
    message+="3. npm run dev\n"
    message+="4. Open http://localhost:3000\n\n"
    message+="Documentation: See README.md and SETUP_GUIDE.md"

    if command -v whiptail &> /dev/null; then
        whiptail --title "Launchify - Complete!" \
            --msgbox "$message" \
            20 70
    elif command -v dialog &> /dev/null; then
        dialog --title "Launchify - Complete!" \
            --msgbox "$message" \
            20 70
        clear
    else
        echo ""
        echo "╔════════════════════════════════════════════╗"
        echo "║   ✅ Project Created Successfully!         ║"
        echo "╚════════════════════════════════════════════╝"
        echo ""
        echo "$message" | sed 's/\\n/\n/g'
        echo ""
    fi
}

# Package manager selection UI
show_package_manager_ui() {
    local temp_file=$(mktemp)

    if command -v whiptail &> /dev/null; then
        whiptail --title "Package Manager" \
            --radiolist "Choose your package manager:" \
            15 60 3 \
            "npm" "npm (default, most compatible)" ON \
            "pnpm" "pnpm (fast, efficient)" OFF \
            "yarn" "yarn (popular alternative)" OFF \
            2>"$temp_file"

        if [[ $? -eq 0 ]]; then
            PACKAGE_MANAGER=$(cat "$temp_file")
        else
            PACKAGE_MANAGER="npm"
        fi
    elif command -v dialog &> /dev/null; then
        dialog --title "Package Manager" \
            --radiolist "Choose your package manager:" \
            15 60 3 \
            "npm" "npm (default, most compatible)" ON \
            "pnpm" "pnpm (fast, efficient)" OFF \
            "yarn" "yarn (popular alternative)" OFF \
            2>"$temp_file"

        if [[ $? -eq 0 ]]; then
            PACKAGE_MANAGER=$(cat "$temp_file")
        else
            PACKAGE_MANAGER="npm"
        fi
        clear
    else
        return 1
    fi

    rm -f "$temp_file"
    return 0
}
