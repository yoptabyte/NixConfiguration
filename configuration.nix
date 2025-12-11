# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix
    
    # Import modular configurations
    ./modules/window-managers/sway.nix
    ./modules/terminals/default.nix
    ./modules/editors/default.nix
    ./modules/browsers/default.nix
    ./modules/applications/default.nix
    ./modules/development/default.nix
    ./modules/hardware/nvidia.nix
    ./modules/desktop/gnome.nix
    ./modules/shell/nushell.nix
    ./modules/games/default.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Europe/Lisbon";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver = {
  enable = true;
  # Configure keyboard layouts
  xkb = {
      layout = "us,ru";
      options = "grp:caps_toggle";  # Toggle layouts with Caps Lock
    };
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Define a user account
  users.users.yoptabyte = {
    isNormalUser = true;
    description = "Nikolai Telin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      claude-code
      cursor-cli
      devenv
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes for modular configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Module configurations
  modules = {

    # Window manager
    #windowManagers.i3.enable = true;
    windowManagers.sway.enable = true;
    
    # Terminals
    terminals = {
      enable = true;
      ghostty.enable = true;
      warp-terminal.enable = true;
    };
    
    # Editors
    editors = {
      enable = true;
      helix.enable = true;
      neovim.enable = true;
      windsurf.enable = true;
      zed-editor-fhs.enable = true;
      code-cursor-fhs.enable = true;
  };
    
    # Browsers
    browsers = {
      enable = true;
      chromium.enable = true;
      firefox.enable = true;
      qutebrowser.enable = true;
    };
    
   # Applications
    applications = {
      enable = true;
      obs.enable = true;
      telegram.enable = true;
      discord.enable = true;
      obsidian.enable = true;
      anki.enable = true;
      qbittorrent.enable = true;
   };

   #Games
    games = {
      enable = true;
      lutris.enable = true;
    };
    
    # Development tools
    development = {
      enable = true;
      git.enable = true;
      ssh.enable = true;
      docker.enable = true;
    };

    # Hardware
    hardware.nvidia.enable = true;

    # Desktop environments 
    desktop.gnome.enable = true;

    # Shell
    shell.nushell = {
      enable = true;
      defaultShell = true;
    };
  };

  environment.systemPackages = with pkgs; [
    curl
  ];
  
  # Enable dconf for GTK applications
  programs.dconf.enable = true;
  
  # Enable gvfs for file manager
  services.gvfs.enable = true;
  
  # System state version
  system.stateVersion = "25.11";
}
