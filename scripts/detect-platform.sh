#!/bin/bash

# Platform detection and tool installation

detect_platform() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        PLATFORM="linux"
        PLATFORM_NAME="Linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        PLATFORM="macos"
        PLATFORM_NAME="macOS"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        PLATFORM="windows"
        PLATFORM_NAME="Windows (WSL/Cygwin)"
    else
        PLATFORM="unknown"
        PLATFORM_NAME="Unknown"
    fi

    export PLATFORM
    export PLATFORM_NAME
}

check_homebrew() {
    if [[ "$PLATFORM" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            echo -e "${YELLOW}⚠️  Homebrew not found${NC}"
            echo ""
            echo "Homebrew is recommended for installing tools on macOS."
            echo ""
            read -p "Install Homebrew now? [Y/n]: " install_brew
            install_brew=${install_brew:-Y}

            if [[ $install_brew =~ ^[Yy]$ ]]; then
                echo ""
                echo "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

                if [[ $? -eq 0 ]]; then
                    echo -e "${GREEN}✓ Homebrew installed${NC}"

                    # Add to PATH for current session
                    if [[ -f "/opt/homebrew/bin/brew" ]]; then
                        eval "$(/opt/homebrew/bin/brew shellenv)"
                    fi
                else
                    echo -e "${RED}✗ Homebrew installation failed${NC}"
                    return 1
                fi
            else
                echo -e "${YELLOW}Skipping Homebrew installation${NC}"
                echo "Some tools may not be available without Homebrew"
                return 1
            fi
        fi
    fi
    return 0
}

install_tool_cross_platform() {
    local tool_name=$1
    local brew_package=$2
    local apt_package=${3:-$2}
    local description=$4

    if command -v "$tool_name" &> /dev/null; then
        return 0
    fi

    echo -e "${YELLOW}⚠️  ${tool_name} not found${NC}"

    if [[ -n "$description" ]]; then
        echo "$description"
        echo ""
    fi

    read -p "Install ${tool_name}? [Y/n]: " install_it
    install_it=${install_it:-Y}

    if [[ ! $install_it =~ ^[Yy]$ ]]; then
        echo "Skipping ${tool_name}"
        return 1
    fi

    if [[ "$PLATFORM" == "macos" ]]; then
        if command -v brew &> /dev/null; then
            echo "Installing via Homebrew..."
            brew install "$brew_package"
        else
            echo -e "${RED}✗ Homebrew required for installation${NC}"
            return 1
        fi
    elif [[ "$PLATFORM" == "linux" ]]; then
        if command -v apt-get &> /dev/null; then
            echo "Installing via apt..."
            sudo apt-get update && sudo apt-get install -y "$apt_package"
        elif command -v yum &> /dev/null; then
            echo "Installing via yum..."
            sudo yum install -y "$apt_package"
        elif command -v pacman &> /dev/null; then
            echo "Installing via pacman..."
            sudo pacman -S --noconfirm "$apt_package"
        else
            echo -e "${RED}✗ No supported package manager found${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Unsupported platform for automatic installation${NC}"
        return 1
    fi

    if command -v "$tool_name" &> /dev/null; then
        echo -e "${GREEN}✓ ${tool_name} installed${NC}"
        return 0
    else
        echo -e "${RED}✗ Installation may have failed${NC}"
        return 1
    fi
}

setup_platform_tools() {
    detect_platform

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}Platform: ${PLATFORM_NAME}${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    if [[ "$PLATFORM" == "macos" ]]; then
        check_homebrew

        # Install whiptail for interactive UI (macOS doesn't have it by default)
        if ! command -v whiptail &> /dev/null; then
            if command -v brew &> /dev/null; then
                echo "Installing whiptail for interactive UI..."
                brew install newt 2>/dev/null || echo "whiptail installation skipped"
            fi
        fi
    fi

    if [[ "$PLATFORM" == "windows" ]]; then
        echo -e "${YELLOW}⚠️  Windows detected (WSL/Cygwin)${NC}"
        echo "Some features may require manual configuration."
        echo "For best experience, use WSL 2."
        echo ""
    fi

    if [[ "$PLATFORM" == "unknown" ]]; then
        echo -e "${RED}✗ Unsupported platform${NC}"
        echo "Launchify is designed for Linux and macOS."
        echo ""
        return 1
    fi

    return 0
}
