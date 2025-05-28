# gnome dconf settings exported from your current configuration
# this file is imported by home.nix
{
  dconf.settings = {
    # gnome shell settings
    "org/gnome/shell" = {
      enabled-extensions = ['dash-to-dock@micxgx.gmail.com'];
      favorite-apps = ['org.gnome.Console.desktop', 'firefox.desktop', 'org.gnome.Nautilus.desktop', 'code.desktop', 'discord.desktop'];
    };

    # Dynamic workspaces setting
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      num-workspaces = 4;
    };

    # dash to dock settings
    "org/gnome/shell/extensions/dash-to-dock" = {
      hot-keys = false;
    };

    # Custom keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = ['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/'];
    };

    # Custom keybinding: term
    "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" = {
      name = "term";
      command = "kgx";
      binding = "<Super>Return";
    };

    # window manager keybindings
    "org/gnome/desktop/wm/keybindings" = {
      close = ['<Super>q'];
      switch-applications = ['<Super>Tab', '<Alt>Tab'];
      switch-applications-backward = ['<Shift><Super>Tab', '<Shift><Alt>Tab'];
      switch-to-workspace-left = ['<Super>Page_Up', '<Super><Alt>Left', '<Control><Alt>Left'];
      switch-to-workspace-right = ['<Super>Page_Down', '<Super><Alt>Right', '<Control><Alt>Right'];
      switch-to-workspace-1 = ['<Super>1'];
      switch-to-workspace-2 = ['<Super>2'];
      switch-to-workspace-3 = ['<Super>3'];
      switch-to-workspace-4 = ['<Super>4'];
    };

    # interface settings
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
      clock-show-weekday = false;
      clock-show-seconds = false;
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
  };
}
