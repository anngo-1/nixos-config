set -e

# colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # no color

echo -e "${GREEN}Starting NixOS configuration deployment...${NC}"

# make sure we're in the right directory
cd "$(dirname "$0")"

# update flake inputs
echo -e "${YELLOW}Updating flake inputs...${NC}"
nix flake update

# build and switch system configuration
echo -e "${YELLOW}Building and switching system configuration...${NC}"
sudo nixos-rebuild switch --flake .#nixos

# build and switch home-manager configuration
echo -e "${YELLOW}Building and switching home-manager configuration...${NC}"
home-manager switch --flake .#an@nixos

# check if config files were installed correctly
echo -e "${BLUE}Checking configuration files...${NC}"

if [ -f "$HOME/.config/hypr/hypr.conf" ]; then
    echo -e "${GREEN}✓ Hyprland configuration installed successfully${NC}"
else
    echo -e "${RED}✗ Hyprland configuration not found${NC}"
fi

if [ -f "$HOME/.config/wofi/config" ] && [ -f "$HOME/.config/wofi/style.css" ]; then
    echo -e "${GREEN}✓ Wofi configuration installed successfully${NC}"
else
    echo -e "${RED}✗ Wofi configuration not found${NC}"
fi

if [ -f "$HOME/.config/ghostty/config" ]; then
    echo -e "${GREEN}✓ Ghostty configuration installed successfully${NC}"
else
    echo -e "${RED}✗ Ghostty configuration not found${NC}"
fi

# check if wallpaper was installed
if [ -f "$HOME/Pictures/wallpapers/wallpaper.png" ]; then
    echo -e "${GREEN}✓ Wallpaper installed successfully${NC}"
else
    echo -e "${YELLOW}⚠ Wallpaper not found (add your wallpaper to assets/wallpaper.png)${NC}"
fi

echo -e "${GREEN}Configuration deployed successfully!${NC}"
echo -e "${BLUE}To switch to Hyprland:${NC}"
echo -e "  1. Log out"
echo -e "  2. Click the gear icon in GDM"
echo -e "  3. Select 'Hyprland'"
echo -e "  4. Log back in"
