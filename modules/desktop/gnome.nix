{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.gnome = {
    enable = mkEnableOption "GNOME desktop environment";
  };

  config = mkIf config.modules.desktop.gnome.enable {
    # Enable the X11 windowing system (also enables Wayland support)
    services.xserver.enable = true;

    # Enable GNOME Desktop Environment with GDM
    services.desktopManager.gnome.enable = true;

    # Enable GDM - standard GNOME display manager
    services.displayManager.gdm.enable = true;

    # Allow both Wayland and X11 sessions
    services.displayManager.gdm.wayland = true;

    services.displayManager.gdm.autoSuspend = false;

    # Exclude some default GNOME applications
    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
      cheese # webcam tool
      gnome-music
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-maps
      gnome-clocks
      gnome-console
      gnome-calendar
      gnome-calculator
      gnome-connections
      gnome-system-monitor
      gnome-usage
      gnome-font-viewer
      gnome-doc-utils
      gnome-user-docs
      gnome-disk-utility
      gnome-color-manager
    ]) ++ (with pkgs; [
      gnome-contacts
      gnome-initial-setup
    ]);

    # Additional GNOME packages
    environment.systemPackages = with pkgs; [
      gnome-tweaks
      dconf-editor
      gnomeExtensions.appindicator
      gnomeExtensions.app-hider
      gnomeExtensions.dash-to-dock
      gnomeExtensions.user-themes
    ];

    # Enable dconf for GNOME settings
    programs.dconf.enable = true;
  };

}
