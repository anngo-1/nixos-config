#!/usr/bin/env bash

# Focused export script for the specific GNOME settings you mentioned
# Run with: bash export.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

OUTPUT_FILE="dconf.nix"

echo -e "${GREEN}Exporting focused GNOME settings...${NC}"

# Start the file
cat > "$OUTPUT_FILE" << 'EOF'
# gnome dconf settings exported from your current configuration
# this file is imported by home.nix
{
  dconf.settings = {
    # gnome shell settings
    "org/gnome/shell" = {
EOF

echo -e "${YELLOW}Getting shell extensions and favorite apps...${NC}"

# Get enabled extensions
extensions=$(gsettings get org.gnome.shell enabled-extensions 2>/dev/null || echo "[]")
echo "      enabled-extensions = $extensions;" >> "$OUTPUT_FILE"
echo -e "${GREEN}✓ Extensions: $extensions${NC}"

# Get favorite apps (dock applications)
favorites=$(gsettings get org.gnome.shell favorite-apps 2>/dev/null || echo "[]")
echo "      favorite-apps = $favorites;" >> "$OUTPUT_FILE" 
echo -e "${GREEN}✓ Favorite apps: $favorites${NC}"

cat >> "$OUTPUT_FILE" << 'EOF'
    };

    # Dynamic workspaces setting
    "org/gnome/mutter" = {
EOF

echo -e "${YELLOW}Getting workspace settings...${NC}"

# Get dynamic workspaces
dynamic_ws=$(gsettings get org.gnome.mutter dynamic-workspaces 2>/dev/null || echo "true")
echo "      dynamic-workspaces = $dynamic_ws;" >> "$OUTPUT_FILE"
echo -e "${GREEN}✓ Dynamic workspaces: $dynamic_ws${NC}"

# Get number of workspaces (if not dynamic)
num_ws=$(gsettings get org.gnome.mutter num-workspaces 2>/dev/null || echo "4")
echo "      num-workspaces = $num_ws;" >> "$OUTPUT_FILE"
echo -e "${GREEN}✓ Number of workspaces: $num_ws${NC}"

cat >> "$OUTPUT_FILE" << 'EOF'
    };

    # dash to dock settings
    "org/gnome/shell/extensions/dash-to-dock" = {
EOF

echo -e "${YELLOW}Getting dash-to-dock settings...${NC}"

# Key dash-to-dock settings
dock_settings=(
    "dash-max-icon-size"
    "dock-position" 
    "dock-fixed"
    "autohide"
    "pressure-threshold"
    "show-apps-at-top"
    "apply-custom-theme"
    "running-indicator-style"
    "show-running"
    "show-favorites"
    "isolate-workspaces"
    "transparency-mode"
    "background-opacity"
    "click-action"
    "scroll-action"
    "hot-keys"
    "hotkeys-overlay"
    "hotkeys-show-dock"
)

for setting in "${dock_settings[@]}"; do
    value=$(gsettings get org.gnome.shell.extensions.dash-to-dock "$setting" 2>/dev/null || echo "null")
    
    # Force hot-keys to false to disable shift+number shortcuts
    if [[ "$setting" == "hot-keys" ]]; then
        value="false"
        echo -e "${BLUE}🔧 Forcing hot-keys = false (disabling shift+number shortcuts)${NC}"
    fi
    
    if [[ "$value" != "null" ]]; then
        # Format the value properly
        if [[ "$value" == "true" || "$value" == "false" ]]; then
            echo "      $setting = $value;" >> "$OUTPUT_FILE"
        elif [[ "$value" =~ ^[0-9]+$ ]] || [[ "$value" =~ ^[0-9]+\.[0-9]+$ ]]; then
            echo "      $setting = $value;" >> "$OUTPUT_FILE"
        else
            # String value - remove outer quotes and re-add them
            clean_value=$(echo "$value" | sed "s/^'//; s/'$//")
            echo "      $setting = \"$clean_value\";" >> "$OUTPUT_FILE"
        fi
        echo -e "${GREEN}✓ $setting: $value${NC}"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

    # Custom keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
EOF

echo -e "${YELLOW}Getting custom keybindings...${NC}"

# Get custom keybindings list
custom_kb=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings 2>/dev/null || echo "[]")
echo "      custom-keybindings = $custom_kb;" >> "$OUTPUT_FILE"
echo -e "${GREEN}✓ Custom keybindings list: $custom_kb${NC}"

cat >> "$OUTPUT_FILE" << 'EOF'
    };

EOF

# Export individual custom keybindings
if [[ "$custom_kb" != "[]" && "$custom_kb" != "@as []" ]]; then
    echo -e "${YELLOW}Exporting individual custom keybindings...${NC}"
    
    # Extract paths from the custom keybindings
    paths=$(echo "$custom_kb" | grep -o "'/[^']*'" | sed "s/'//g")
    
    for path in $paths; do
        schema="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path"
        
        name=$(gsettings get "$schema" name 2>/dev/null || echo "null")
        command=$(gsettings get "$schema" command 2>/dev/null || echo "null")
        binding=$(gsettings get "$schema" binding 2>/dev/null || echo "null")
        
        if [[ "$name" != "null" && "$command" != "null" && "$binding" != "null" ]]; then
            # Clean up the values
            clean_name=$(echo "$name" | sed "s/^'//; s/'$//")
            clean_command=$(echo "$command" | sed "s/^'//; s/'$//")
            clean_binding=$(echo "$binding" | sed "s/^'//; s/'$//")
            
            cat >> "$OUTPUT_FILE" << EOF
    # Custom keybinding: $clean_name
    "$schema" = {
      name = "$clean_name";
      command = "$clean_command";
      binding = "$clean_binding";
    };

EOF
            echo -e "${GREEN}✓ Custom keybinding: $clean_name -> $clean_command ($clean_binding)${NC}"
        fi
    done
fi

# Add the rest of your existing settings
cat >> "$OUTPUT_FILE" << 'EOF'
    # window manager keybindings
    "org/gnome/desktop/wm/keybindings" = {
EOF

echo -e "${YELLOW}Getting window manager keybindings...${NC}"

# Key WM keybindings
wm_keys=("close" "switch-applications" "switch-applications-backward" "switch-to-workspace-left" "switch-to-workspace-right" "switch-to-workspace-1" "switch-to-workspace-2" "switch-to-workspace-3" "switch-to-workspace-4")

for key in "${wm_keys[@]}"; do
    value=$(gsettings get org.gnome.desktop.wm.keybindings "$key" 2>/dev/null || echo "null")
    if [[ "$value" != "null" && "$value" != "@as []" ]]; then
        echo "      $key = $value;" >> "$OUTPUT_FILE"
        echo -e "${GREEN}✓ $key: $value${NC}"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

    # interface settings
    "org/gnome/desktop/interface" = {
EOF

# Interface settings
interface_keys=("gtk-theme" "color-scheme" "clock-show-weekday" "clock-show-seconds")
for key in "${interface_keys[@]}"; do
    value=$(gsettings get org.gnome.desktop.interface "$key" 2>/dev/null || echo "null")
    if [[ "$value" != "null" ]]; then
        if [[ "$value" == "true" || "$value" == "false" ]]; then
            echo "      $key = $value;" >> "$OUTPUT_FILE"
        else
            clean_value=$(echo "$value" | sed "s/^'//; s/'$//")
            echo "      $key = \"$clean_value\";" >> "$OUTPUT_FILE"
        fi
        echo -e "${GREEN}✓ $key: $value${NC}"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

    # mouse settings
    "org/gnome/desktop/peripherals/mouse" = {
EOF

mouse_keys=("natural-scroll")
for key in "${mouse_keys[@]}"; do
    value=$(gsettings get org.gnome.desktop.peripherals.mouse "$key" 2>/dev/null || echo "null")
    if [[ "$value" != "null" ]]; then
        echo "      $key = $value;" >> "$OUTPUT_FILE"
        echo -e "${GREEN}✓ mouse $key: $value${NC}"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

    # touchpad settings
    "org/gnome/desktop/peripherals/touchpad" = {
EOF

touchpad_keys=("natural-scroll" "tap-to-click")
for key in "${touchpad_keys[@]}"; do
    value=$(gsettings get org.gnome.desktop.peripherals.touchpad "$key" 2>/dev/null || echo "null")
    if [[ "$value" != "null" ]]; then
        echo "      $key = $value;" >> "$OUTPUT_FILE"
        echo -e "${GREEN}✓ touchpad $key: $value${NC}"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

    # nautilus settings
    "org/gnome/nautilus/preferences" = {
EOF

nautilus_keys=("default-folder-viewer")
for key in "${nautilus_keys[@]}"; do
    value=$(gsettings get org.gnome.nautilus.preferences "$key" 2>/dev/null || echo "null")
    if [[ "$value" != "null" ]]; then
        clean_value=$(echo "$value" | sed "s/^'//; s/'$//")
        echo "      $key = \"$clean_value\";" >> "$OUTPUT_FILE"
        echo -e "${GREEN}✓ nautilus $key: $value${NC}"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };
  };
}
EOF

echo -e "${GREEN}✅ Export complete! Settings saved to $OUTPUT_FILE${NC}"
echo -e "${BLUE}Key exports:${NC}"
echo -e "  • Dynamic workspaces setting"
echo -e "  • Favorite apps (dock applications)"  
echo -e "  • Comprehensive dash-to-dock settings"
echo -e "  • Custom keybindings (including your mod+enter terminal)"
echo -e "  • All other existing settings"
echo ""
echo -e "${YELLOW}To apply: home-manager switch --flake .#an@nixos${NC}"
