#!/usr/bin/env bash

# export gnome settings for nixos home-manager dconf configuration
# run this script after you've customized gnome to your liking

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

OUTPUT_FILE="dconf.nix"

echo -e "${GREEN}exporting gnome settings for home-manager...${NC}"

# create the output file
cat > "$OUTPUT_FILE" << 'EOF'
# gnome dconf settings exported from your current configuration
# this file is imported by home.nix
{
  dconf.settings = {
EOF

echo -e "${YELLOW}exporting dash to dock settings...${NC}"
cat >> "$OUTPUT_FILE" << 'EOF'
    # gnome shell settings
    "org/gnome/shell" = {
      enabled-extensions = [ "dash-to-dock@micxgx.gmail.com" ];
    };

    # dash to dock settings
    "org/gnome/shell/extensions/dash-to-dock" = {
EOF

# export dash-to-dock settings
for key in dash-max-icon-size dock-position dock-fixed autohide pressure-threshold show-apps-at-top apply-custom-theme running-indicator-style; do
    value=$(gsettings get org.gnome.shell.extensions.dash-to-dock $key 2>/dev/null || echo "null")
    if [ "$value" != "null" ]; then
        # handle different data types
        if [[ "$value" == "true" || "$value" == "false" ]]; then
            echo "      $key = $value;" >> "$OUTPUT_FILE"
        elif [[ "$value" =~ ^[0-9]+$ ]]; then
            echo "      $key = $value;" >> "$OUTPUT_FILE"
        else
            # string value, remove quotes and re-add them properly
            clean_value=$(echo "$value" | sed "s/^'//; s/'$//")
            echo "      $key = \"$clean_value\";" >> "$OUTPUT_FILE"
        fi
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

EOF

echo -e "${YELLOW}exporting keybindings...${NC}"
cat >> "$OUTPUT_FILE" << 'EOF'
    # window manager keybindings
    "org/gnome/desktop/wm/keybindings" = {
EOF

# export common keybindings
for key in close switch-applications switch-applications-backward switch-to-workspace-left switch-to-workspace-right; do
    value=$(gsettings get org.gnome.desktop.wm.keybindings $key 2>/dev/null || echo "null")
    if [ "$value" != "null" ] && [ "$value" != "@as []" ]; then
        # convert gsettings array format to nix format
        # example: ['<Super>q'] or ['<Super>Tab', '<Alt>Tab'] -> [ "<Super>q" ] or [ "<Super>Tab" "<Alt>Tab" ]
        nix_value=$(echo "$value" | python3 -c "
import sys, re
line = sys.stdin.read().strip()
# remove @as prefix if present
line = re.sub(r'^@as\s+', '', line)
# extract items between quotes
items = re.findall(r\"'([^']+)'\", line)
if items:
    formatted_items = '\" \"'.join(items)
    print(f'[ \"{formatted_items}\" ]')
else:
    print('[]')
")
        echo "      $key = $nix_value;" >> "$OUTPUT_FILE"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

EOF

echo -e "${YELLOW}exporting media keys...${NC}"
cat >> "$OUTPUT_FILE" << 'EOF'
    # media keys
    "org/gnome/settings-daemon/plugins/media-keys" = {
EOF

# export media keys
for key in terminal; do
    value=$(gsettings get org.gnome.settings-daemon.plugins.media-keys $key 2>/dev/null || echo "null")
    if [ "$value" != "null" ] && [ "$value" != "@as []" ]; then
        # convert gsettings array format to nix format
        nix_value=$(echo "$value" | python3 -c "
import sys, re
line = sys.stdin.read().strip()
# remove @as prefix if present
line = re.sub(r'^@as\s+', '', line)
# extract items between quotes
items = re.findall(r\"'([^']+)'\", line)
if items:
    formatted_items = '\" \"'.join(items)
    print(f'[ \"{formatted_items}\" ]')
else:
    print('[]')
")
        echo "      $key = $nix_value;" >> "$OUTPUT_FILE"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

EOF

echo -e "${YELLOW}exporting interface settings...${NC}"
cat >> "$OUTPUT_FILE" << 'EOF'
    # interface settings
    "org/gnome/desktop/interface" = {
EOF

# export interface settings
for key in gtk-theme color-scheme clock-show-weekday clock-show-seconds; do
    value=$(gsettings get org.gnome.desktop.interface $key 2>/dev/null || echo "null")
    if [ "$value" != "null" ]; then
        if [[ "$value" == "true" || "$value" == "false" ]]; then
            echo "      $key = $value;" >> "$OUTPUT_FILE"
        else
            clean_value=$(echo "$value" | sed "s/^'//; s/'$//")
            echo "      $key = \"$clean_value\";" >> "$OUTPUT_FILE"
        fi
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

EOF

echo -e "${YELLOW}exporting desktop settings...${NC}"
cat >> "$OUTPUT_FILE" << 'EOF'
    # desktop background settings
    "org/gnome/desktop/background" = {
EOF

# export desktop background settings
for key in show-desktop-icons; do
    value=$(gsettings get org.gnome.desktop.background $key 2>/dev/null || echo "null")
    if [ "$value" != "null" ]; then
        echo "      $key = $value;" >> "$OUTPUT_FILE"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

EOF

echo -e "${YELLOW}exporting peripheral settings...${NC}"
cat >> "$OUTPUT_FILE" << 'EOF'
    # mouse settings
    "org/gnome/desktop/peripherals/mouse" = {
EOF

# export mouse settings
for key in natural-scroll; do
    value=$(gsettings get org.gnome.desktop.peripherals.mouse $key 2>/dev/null || echo "null")
    if [ "$value" != "null" ]; then
        echo "      $key = $value;" >> "$OUTPUT_FILE"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

    # touchpad settings
    "org/gnome/desktop/peripherals/touchpad" = {
EOF

# export touchpad settings
for key in natural-scroll tap-to-click; do
    value=$(gsettings get org.gnome.desktop.peripherals.touchpad $key 2>/dev/null || echo "null")
    if [ "$value" != "null" ]; then
        echo "      $key = $value;" >> "$OUTPUT_FILE"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

EOF

echo -e "${YELLOW}exporting nautilus settings...${NC}"
cat >> "$OUTPUT_FILE" << 'EOF'
    # nautilus settings
    "org/gnome/nautilus/preferences" = {
EOF

# export nautilus settings
for key in default-folder-viewer; do
    value=$(gsettings get org.gnome.nautilus.preferences $key 2>/dev/null || echo "null")
    if [ "$value" != "null" ]; then
        clean_value=$(echo "$value" | sed "s/^'//; s/'$//")
        echo "      $key = \"$clean_value\";" >> "$OUTPUT_FILE"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

    # file chooser settings
    "org/gtk/settings/file-chooser" = {
EOF

# export file chooser settings
for key in show-hidden; do
    value=$(gsettings get org.gtk.settings.file-chooser $key 2>/dev/null || echo "null")
    if [ "$value" != "null" ]; then
        echo "      $key = $value;" >> "$OUTPUT_FILE"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };
EOF

# close the configuration
cat >> "$OUTPUT_FILE" << 'EOF'
  };
}
EOF

echo -e "${GREEN}✓ settings exported to $OUTPUT_FILE${NC}"
echo -e "${BLUE}to use these settings:${NC}"
echo -e "  1. make sure './dconf.nix' is in your imports in home.nix"
echo -e "  2. run: home-manager switch --flake .#an@nixos"
echo ""
echo -e "${YELLOW}the dconf.nix file has been created and is ready to use!${NC}"
