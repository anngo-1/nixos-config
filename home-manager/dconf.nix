# gnome dconf settings exported from your current configuration
# this file is imported by home.nix
{
  dconf.settings = {
    # gnome shell settings
    "org/gnome/shell" = {
      enabled-extensions = [ "dash-to-dock@micxgx.gmail.com" ];
    };

    # dash to dock settings
    "org/gnome/shell/extensions/dash-to-dock" = {
    };

    # window manager keybindings
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      switch-applications = [ "<Super>Tab" "<Alt>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" "<Shift><Alt>Tab" ];
      switch-to-workspace-left = [ "<Super>Page_Up" "<Super><Alt>Left" "<Control><Alt>Left" ];
      switch-to-workspace-right = [ "<Super>Page_Down" "<Super><Alt>Right" "<Control><Alt>Right" ];
    };

    # media keys
    "org/gnome/settings-daemon/plugins/media-keys" = {
    };

    # interface settings
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
      clock-show-weekday = false;
      clock-show-seconds = false;
    };

    # desktop background settings
    "org/gnome/desktop/background" = {
      show-desktop-icons = false;
    };

    # mouse settings
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };

    # touchpad settings
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
      tap-to-click = true;
    };

    # nautilus settings
    "org/gnome/nautilus/preferences" = {
    };

    # file chooser settings
    "org/gtk/settings/file-chooser" = {
    };
  };
}
