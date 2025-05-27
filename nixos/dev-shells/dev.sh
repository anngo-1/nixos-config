#!/usr/bin/env bash
# Save this as ~/Documents/nix-config/dev-shells/dev.sh
# Make it executable with: chmod +x ~/Documents/nix-config/dev-shells/dev.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

DEV_SHELLS_DIR="$(dirname "$0")"

show_help() {
    echo -e "${CYAN}Development Environment Manager${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo "  ./dev.sh [environment]"
    echo ""
    echo -e "${YELLOW}Available environments:${NC}"
    echo -e "  ${GREEN}python${NC}     - Python development with common packages"
    echo -e "  ${GREEN}node${NC}       - Node.js with npm, yarn, typescript"
    echo -e "  ${GREEN}fullstack${NC}  - Python + Node.js + databases"
    echo -e "  ${GREEN}cpp${NC}        - C++ with gcc, cmake, debugging tools"
    echo -e "  ${GREEN}rust${NC}       - Rust with cargo and tools"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  ./dev.sh python"
    echo "  ./dev.sh fullstack"
    echo ""
    echo -e "${YELLOW}Project-specific shell:${NC}"
    echo "  Create a shell.nix in your project directory"
    echo "  Then run: nix-shell"
}

if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

ENVIRONMENT="$1"
SHELL_FILE="$DEV_SHELLS_DIR/$ENVIRONMENT.nix"

if [ ! -f "$SHELL_FILE" ]; then
    echo -e "${RED}Error: Environment '$ENVIRONMENT' not found${NC}"
    echo -e "${YELLOW}Available environments:${NC} python, node, fullstack, cpp, rust"
    exit 1
fi

echo -e "${BLUE}Entering $ENVIRONMENT development environment...${NC}"
nix-shell "$SHELL_FILE"
