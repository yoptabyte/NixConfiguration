{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.windowManagers.sway = {
    enable = mkEnableOption "Sway window manager";
  };

  config = mkIf config.modules.windowManagers.sway.enable {
    # Enable Wayland
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        waybar
        wofi
      ];
        extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
      '';
    };

    # Sway notifications and screenshots
    environment.systemPackages = with pkgs; [
      mako           # notifications for Wayland
      libnotify      # notification daemon
      grim           # screenshots (Wayland)
      slurp          # screen area selection (Wayland)
      wl-clipboard   # clipboard utilities for Wayland
      wl-gammarelay-applet
      wl-gammarelay-rs
      swaybg         # wallpaper
      #rofi-wayland   # application launcher for Wayland
      kanshi         # display configuration for Wayland
      lxappearance   # GTK theme configuration
      gvfs           # virtual filesystem support

      brightnessctl     

      # Additional packages needed by sway config
      dex            # XDG autostart
      networkmanagerapplet  # nm-applet
      xterm          # Fallback terminal
      xdg-utils      # For sway-sensible-terminal

      # Blur and transparency support
      gtk-layer-shell
            
      # Wayland compatibility
      xwayland       # X11 compatibility layer

      #pwvucontrol # Modern PipeWire volume control
      ncpamixer
      
      blueman # Bluetooth manager GUI 

      #xfce.thunar
      #xfce.thunar-volman
      #xfce.thunar-archive-plugin
    ];


    # Faster app startup
    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    # Enable dbus for notifications
    services.dbus.enable = true;

    # Enable polkit for privilege escalation
    security.polkit.enable = true;

    services.blueman.enable = true;

    # Enable wl-gammarelay service
    systemd.user.services.wl-gammarelay = {
      description = "Wayland gamma adjustment service";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.wl-gammarelay-rs}/bin/wl-gammarelay-rs";
        Restart = "on-failure";
      };
   };

    
    # Enable XDG portal for screen sharing
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    security.pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };
}
