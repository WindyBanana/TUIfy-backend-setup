#!/bin/bash

# Install missing CLI tools

install_missing_clis() {
    local use_vercel=$1
    local use_convex=$2
    local use_axiom=$3

    local installed_any=false

    # Install Vercel CLI
    if $use_vercel; then
        if ! command -v vercel &> /dev/null; then
            echo -e "${BLUE}Installing Vercel CLI...${NC}"
            npm install -g vercel
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ Vercel CLI installed${NC}"
                installed_any=true
            else
                echo -e "${RED}✗ Failed to install Vercel CLI${NC}"
                exit 1
            fi
        fi
    fi

    # Convex is used via npx, no global install needed

    # Install Axiom CLI
    if $use_axiom; then
        if ! command -v axiom &> /dev/null; then
            echo -e "${BLUE}Installing Axiom CLI...${NC}"

            # Detect OS and install accordingly
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                # Linux installation with proper error checking
                if curl -fsSL https://github.com/axiomhq/cli/releases/latest/download/axiom_linux_amd64 -o /tmp/axiom; then
                    chmod +x /tmp/axiom
                    # Verify it's a valid binary
                    if file /tmp/axiom | grep -q "executable"; then
                        sudo mv /tmp/axiom /usr/local/bin/axiom
                        echo -e "${GREEN}✓ Axiom CLI installed${NC}"
                        installed_any=true
                    else
                        echo -e "${YELLOW}⚠️  Downloaded file is not a valid binary${NC}"
                        echo -e "${CYAN}Please install manually: https://axiom.co/docs/reference/cli#installation${NC}"
                        rm -f /tmp/axiom
                    fi
                else
                    echo -e "${YELLOW}⚠️  Failed to download Axiom CLI${NC}"
                    echo -e "${CYAN}Please install manually: https://axiom.co/docs/reference/cli#installation${NC}"
                fi
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS installation
                if brew install axiomhq/tap/axiom; then
                    echo -e "${GREEN}✓ Axiom CLI installed${NC}"
                    installed_any=true
                else
                    echo -e "${YELLOW}⚠️  Failed to install Axiom CLI via Homebrew${NC}"
                    echo -e "${CYAN}Please install manually: https://axiom.co/docs/reference/cli#installation${NC}"
                fi
            else
                echo -e "${YELLOW}⚠️  Unsupported OS for Axiom CLI auto-install${NC}"
                echo -e "${CYAN}Please install manually: https://axiom.co/docs/reference/cli#installation${NC}"
            fi
        fi
    fi

    if ! $installed_any; then
        echo -e "${GREEN}✓ All required CLIs already installed${NC}"
    fi
}
