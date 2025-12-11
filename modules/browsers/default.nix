{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.browsers = {
    enable = mkEnableOption "web browsers";
    chromium.enable = mkEnableOption "Chromium browser";
    firefox.enable = mkEnableOption "Firefox browser";
    qutebrowser.enable = mkEnableOption "Qutebrowser";
  };

  config = mkIf config.modules.browsers.enable {
    environment.systemPackages = with pkgs; [
      (mkIf config.modules.browsers.chromium.enable chromium)
      (mkIf config.modules.browsers.firefox.enable firefox)
      (mkIf config.modules.browsers.qutebrowser.enable qutebrowser)
      # Additional browser dependencies
      ffmpeg
      zathura
      nsxiv
    ];
  };
}
