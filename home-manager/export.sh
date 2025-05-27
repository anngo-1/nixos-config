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
    # gnome shell settings
    "org/gnome/shell" = {
      enabled-extensions = [ "dash-to-dock@micxgx.gmail.com" ];
    };

EOF

echo -e "${YELLOW}exporting dash to dock settings...${NC}"
cat >> "$OUTPUT_FILE" << 'EOF'
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

# export workspace switching and common keybindings
for key in close switch-applications switch-applications-backward switch-to-workspace-left switch-to-workspace-right switch-to-workspace-1 switch-to-workspace-2 switch-to-workspace-3 switch-to-workspace-4 switch-to-workspace-5 switch-to-workspace-6 switch-to-workspace-7 switch-to-workspace-8 switch-to-workspace-9 switch-to-workspace-10; do
    value=$(gsettings get org.gnome.desktop.wm.keybindings $key 2>/dev/null || echo "null")
    if [ "$value" != "null" ] && [ "$value" != "@as []" ]; then
        # simple conversion for arrays
        if [[ "$value" == *"'"* ]]; then
            # has single quotes, convert to nix format
            clean_array=$(echo "$value" | sed "s/@as //; s/\[/[ /; s/\]/]/; s/'//g; s/,/ /g")
            # add quotes around each item
            nix_array=$(echo "$clean_array" | sed 's/\([^[\] ]\+\)/"\1"/g')
            echo "      $key = $nix_array;" >> "$OUTPUT_FILE"
        fi
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'
    };

EOF

echo -e "${YELLOW}exporting media keys and custom keybindings...${NC}"

# get custom keybindings
custom_bindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings 2>/dev/null || echo "[]")

cat >> "$OUTPUT_FILE" << 'EOF'
    # media keys and custom keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
EOF

# if there are custom keybindings, export the list
if [ "$custom_bindings" != "[]" ] && [ "$custom_bindings" != "@as []" ]; then
    # convert custom keybindings array
    if [[ "$custom_bindings" == *"'"* ]]; then
        clean_bindings=$(echo "$custom_bindings" | sed "s/@as //; s/\[/[ /; s/\]/]/; s/'//g; s/,/ /g")
        nix_bindings=$(echo "$clean_bindings" | sed 's|\(/[^[\] ]*\)|"\1"|g')
        echo "      custom-keybindings = $nix_bindings;" >> "$OUTPUT_FILE"
    fi
fi

cat >> "$OUTPUT_FILE" << 'EOF'
    };

EOF

# export individual custom keybindings if they exist
if [ "$custom_bindings" != "[]" ] && [ "$custom_bindings" != "@as []" ]; then
    echo -e "${YELLOW}exporting individual custom keybindings...${NC}"
    
    # extract paths from the custom bindings
    echo "$custom_bindings" | grep -o '/[^,\]]*' | while read -r binding_path; do
        if [ -n "$binding_path" ]; then
            name=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$binding_path name 2>/dev/null || echo "")
            command=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$binding_path command 2>/dev/null || echo "")
            binding=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$binding_path binding 2>/dev/null || echo "")
            
            if [ "$name" != "" ] && [ "$command" != "" ] && [ "$binding" != "" ]; then
                # clean up the values
                clean_name=$(echo "$name" | sed "s/^'//; s/'$//")
                clean_command=$(echo "$command" | sed "s/^'//; s/'$//")
                clean_binding=$(echo "$binding" | sed "s/^'//; s/'$//")
                
                cat >> "$OUTPUT_FILE" << EOF
    # custom keybinding: $clean_name
    "$binding_path" = {
      name = "$clean_name";
      command = "$clean_command";
      binding = "$clean_binding";
    };

EOF
            fi
        fi
    done
fi

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
  };
}
EOF

echo -e "${GREEN}✓ settings exported to $OUTPUT_FILE${NC}"
echo -e "${BLUE}to use these settings:${NC}"
echo -e "  1. make sure './dconf.nix' is in your imports in home.nix"
echo -e "  2. run: home-manager switch --flake .#an@nixos"
echo ""
echo -e "${YELLOW}the dconf.nix file has been created and is ready to use!${NC}"
