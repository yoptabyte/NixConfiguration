{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.games= {
    enable = mkEnableOption "games";
    lutris.enable = mkEnableOption "Lutris";
  };

  config = mkIf config.modules.applications.enable {
    environment.systemPackages = with pkgs; [
      (mkIf config.modules.games.lutris.enable lutris)
    ];
  };
}
