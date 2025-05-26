set -e

# colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # no color

echo -e "${GREEN}starting nixos configuration deployment...${NC}"

# make sure we're in the right directory
cd "$(dirname "$0")"

# update flake inputs
echo -e "${YELLOW}updating flake inputs...${NC}"
nix flake update

# build and switch system configuration
echo -e "${YELLOW}building and switching system configuration...${NC}"
sudo nixos-rebuild switch --flake .#nixos

# build and switch home-manager configuration
echo -e "${YELLOW}building and switching home-manager configuration...${NC}"
home-manager switch --flake .#an@nixos

# check if config files were installed correctly
echo -e "${BLUE}checking configuration files...${NC}"

if [ -f "$HOME/.config/hypr/hypr.conf" ]; then
    echo -e "${GREEN}✓ hyprland configuration installed successfully${NC}"
else
    echo -e "${RED}✗ hyprland configuration not found${NC}"
fi

if [ -f "$HOME/.config/wofi/config" ] && [ -f "$HOME/.config/wofi/style.css" ]; then
    echo -e "${GREEN}✓ wofi configuration installed successfully${NC}"
else
    echo -e "${RED}✗ wofi configuration not found${NC}"
fi

if [ -f "$HOME/.config/ghostty/config" ]; then
    echo -e "${GREEN}✓ ghostty configuration installed successfully${NC}"
else
    echo -e "${RED}✗ ghostty configuration not found${NC}"
fi

# check if wallpaper was installed
if [ -f "$HOME/Pictures/wallpapers/wallpaper.png" ]; then
    echo -e "${GREEN}✓ wallpaper installed successfully${NC}"
else
    echo -e "${YELLOW}⚠ wallpaper not found (add your wallpaper to assets/wallpaper.png)${NC}"
fi

echo -e "${GREEN}configuration deployed successfully!${NC}"
echo -e "${BLUE}to switch to hyprland:${NC}"
echo -e "  1. log out"
echo -e "  2. click the gear icon in gdm"
echo -e "  3. select 'hyprland'"
echo -e "  4. log back in"
