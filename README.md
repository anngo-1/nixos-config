# an's nixos-config

This is the NixOS configuration I use on my personal desktop and laptop. This repo will be updated as I refine my setup and workflow. 

## Usage

I add packages in nixos/configuration.nix, use home-manager to manage dotfiles for desktop environments (GNOME & Hyprland), and use a flake for the whole repository. This goal of this project is to make my entire setup as reproducible and declarative as possible. The install.sh script will automatically deploy the configuration in this repository to a fresh install of NixOS.

### Instructions:
From a fresh install of NixOS, you can use clone the configuration like so:

```bash
nix-shell -p git 
git clone https://github.com/anngo-1/nixos-config
```

Then, run the installation script in the directory.

```bash
cd nixos-config
chmod +x install.sh
./install,sh
```

This will build and switch the entire system configuration into my fully configured system.

## Features

### Desktop Environments

This configuration uses both GNOME and Hyprland (I prefer to use Hyprland on my laptop, and GNOME on my desktop). The two desktop enviroments can be switched between by logging out and selecting the environment after clicking the gear icon in the bottom right of the GNOME login screen.

#### Hyprland Environment

I use waybar, ghostty, and wofi as an application launcher. The hyprland config file can be found in home-manager/config/hyprland.conf (along with more configs). This file is imported into the home-manager setup, so editing this then switching home-manager will update the hyprland configuration. The same is true for all configs in home-manager/config.

I prefer a very simple, dark themed config with no animations, and a small waybar.

#### GNOME Environment

My GNOME settings have been exported into home-manager/dconf.nix. This was done using dconf2nix. If settings are changed, they can be exported again after creating a shell with dconf2nix installed:

```bash
nix-shell -p dconf2nix
```

Then, running the export.sh script which will generate the dconf.nix from your current GNOME settings

```bash
sh export.sh
```
