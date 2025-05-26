# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };
  
  home = {
    username = "an";
    homeDirectory = "/home/an";
  };

  # Place your configuration files
  xdg.configFile."hypr/hyprland.conf".source = ./config/hyprland.conf;
  
  # Wofi configuration
  xdg.configFile."wofi/config".text = "show=drun";
  xdg.configFile."wofi/style.css".source = ./config/wofi/style.css;
  
  # Waybar configuration
  xdg.configFile."waybar/config".source = ./config/waybar/config;
  xdg.configFile."waybar/style.css".source = ./config/waybar/style.css;
  
  # Ghostty configuration
  xdg.configFile."ghostty/config".source = ./config/ghostty/config;
  
  # Wallpaper
  home.file."Pictures/wallpapers/wallpaper.png".source = ../assets/wallpaper.png;

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  
  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName  = "anngo-1";
    userEmail = "andngo2004@gmail.com";
  };
  
  home.file.".oh-my-zsh/custom/themes/an.zsh-theme".text = ''
    PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%} %{$fg_bold[white]%}%~ %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
    ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
  '';
  
  home.file.".zshrc".text = ''
    export ZSH_CUSTOM="${config.home.homeDirectory}/.oh-my-zsh/custom"
    export PATH=/home/an/.local/bin:$PATH
    source $ZSH_CUSTOM/themes/an.zsh-theme
  '';
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    shellAliases = {
      ll = "ls -l";
      rebuild-nix = "sudo nixos-rebuild switch --flake /home/an/Documents/nix-config/.#nixos";
      config-nix = "sudo nvim /home/an/Documents/nix-config/nixos/configuration.nix";
      hmrebuild-nix = "home-manager switch --flake /home/an/Documents/nix-config/.#an@nixos";
      hmconfig-nix = "sudo nvim /home/an/Documents/nix-config/home-manager/home.nix";
      vim = "nvim";
    };
  };
  
  services.gnome-keyring.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.05";
}
