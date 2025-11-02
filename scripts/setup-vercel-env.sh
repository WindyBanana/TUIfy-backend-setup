#!/bin/bash

# Set environment variables in Vercel via API

set_vercel_env_var() {
    local project_id=$1
    local key=$2
    local value=$3
    local target=$4  # "production", "preview", "development", or "production,preview"
    local type=${5:-"encrypted"}  # "plain", "encrypted", or "sensitive"

    if [[ -z "$VERCEL_TOKEN" ]]; then
        echo -e "${RED}✗ VERCEL_TOKEN not found${NC}"
        return 1
    fi

    # Convert target to array format
    local target_array
    if [[ "$target" == *","* ]]; then
        # Multiple targets
        IFS=',' read -ra TARGETS <<< "$target"
        target_array=$(printf ',"%s"' "${TARGETS[@]}")
        target_array="[${target_array:1}]"
    else
        target_array="[\"$target\"]"
    fi

    # Create JSON payload
    local payload=$(cat <<EOF
[
  {
    "key": "${key}",
    "value": "${value}",
    "target": ${target_array},
    "type": "${type}"
  }
]
EOF
)

    # Make API request with upsert
    local response=$(curl -s -X POST \
        "https://api.vercel.com/v10/projects/${project_id}/env?upsert=true" \
        -H "Authorization: Bearer ${VERCEL_TOKEN}" \
        -H "Content-Type: application/json" \
        -d "$payload")

    # Check for errors
    if echo "$response" | grep -q '"error"'; then
        local error_msg=$(echo "$response" | grep -o '"message":"[^"]*"' | sed 's/"message":"//' | sed 's/"$//')
        echo -e "${RED}✗ Failed to set ${key}${NC}"
        echo "Error: $error_msg"
        return 1
    fi

    echo -e "${GREEN}✓${NC} Set ${key} for ${target}"
    return 0
}

setup_vercel_env_vars() {
    local project_name=$1
    shift
    local env_vars=("$@")  # Array of "KEY=VALUE=TARGET=TYPE"

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}Setting Vercel Environment Variables${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # Check if we have a Vercel token
    if [[ -z "$VERCEL_TOKEN" ]]; then
        echo -e "${YELLOW}⚠️  Vercel token not found${NC}"
        echo ""
        echo "To automatically set production environment variables,"
        echo "you need to provide a Vercel API token."
        echo ""
        echo "Get your token from: ${CYAN}https://vercel.com/account/tokens${NC}"
        echo ""
        read -p "Do you have a Vercel token? [y/N]: " has_token

        if [[ $has_token =~ ^[Yy]$ ]]; then
            read -sp "Enter your Vercel token: " VERCEL_TOKEN
            echo ""
            export VERCEL_TOKEN
        else
            echo ""
            echo -e "${YELLOW}Skipping automatic environment variable setup${NC}"
            echo ""
            echo "You'll need to manually add these to Vercel:"
            for env_var in "${env_vars[@]}"; do
                IFS='=' read -r key value target type <<< "$env_var"
                echo "  - ${CYAN}${key}${NC} (${target})"
            done
            echo ""
            echo "Instructions provided at end of setup."
            return 0
        fi
    fi

    # Get project ID from Vercel
    echo "Fetching Vercel project details..."
    local project_response=$(curl -s \
        "https://api.vercel.com/v9/projects/${project_name}" \
        -H "Authorization: Bearer ${VERCEL_TOKEN}")

    local project_id=$(echo "$project_response" | grep -o '"id":"[^"]*"' | head -1 | sed 's/"id":"//' | sed 's/"$//')

    if [[ -z "$project_id" ]]; then
        echo -e "${RED}✗ Could not find Vercel project: ${project_name}${NC}"
        echo ""
        echo "Make sure:"
        echo "  1. The project is linked to Vercel (run 'vercel link' first)"
        echo "  2. Your token has access to this project"
        echo ""
        return 1
    fi

    echo -e "${GREEN}✓${NC} Found project: ${project_name} (${project_id})"
    echo ""

    # Set each environment variable
    local success_count=0
    local fail_count=0

    for env_var in "${env_vars[@]}"; do
        IFS='=' read -r key value target type <<< "$env_var"

        if set_vercel_env_var "$project_id" "$key" "$value" "$target" "$type"; then
            ((success_count++))
        else
            ((fail_count++))
        fi
    done

    echo ""
    echo -e "${GREEN}✓ Set ${success_count} environment variables${NC}"

    if [[ $fail_count -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  ${fail_count} variables failed to set${NC}"
        echo "You may need to set these manually in Vercel dashboard"
    fi

    echo ""
}
