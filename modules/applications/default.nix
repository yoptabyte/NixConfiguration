{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.applications = {
    enable = mkEnableOption "applications";
    obs.enable = mkEnableOption "OBS Studio";
    telegram.enable = mkEnableOption "Telegram Desktop";
    discord.enable = mkEnableOption "Discord";
    obsidian.enable = mkEnableOption "Obsidian";
    anki.enable = mkEnableOption "Anki";
    qbittorrent.enable = mkEnableOption "Qbittorrent";
   };

  config = mkIf config.modules.applications.enable {
    environment.systemPackages = with pkgs; [
      (mkIf config.modules.applications.obs.enable obs-studio)
      (mkIf config.modules.applications.telegram.enable telegram-desktop)
      (mkIf config.modules.applications.discord.enable discord)
      (mkIf config.modules.applications.obsidian.enable obsidian)
      (mkIf config.modules.applications.anki.enable anki)
      (mkIf config.modules.applications.qbittorrent.enable qbittorrent)

    ] ++ optionals config.modules.applications.obs.enable [
      obs-studio-plugins.wlrobs
      obs-studio-plugins.obs-backgroundremoval
      v4l-utils
    ];

    # Audio support for applications
    services.pipewire = mkIf config.modules.applications.enable {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
