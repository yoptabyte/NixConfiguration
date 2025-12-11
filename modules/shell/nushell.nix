{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.nushell = {
    enable = mkEnableOption "Nushell";
    defaultShell = mkOption {
      type = types.bool;
      default = true;
      description = "Set nushell as default shell for all users";
    };
  };

  config = mkIf config.modules.shell.nushell.enable {
    # Enable nushell
    #programs.nushell.enable = true;

    # Set as default shell for users
    users.defaultUserShell = mkIf config.modules.shell.nushell.defaultShell pkgs.nushell;

    # Install nushell
    environment.systemPackages = with pkgs; [
      nushell
      fzf
      nushellPlugins.gstat
      nushellPlugins.skim
      nushellPlugins.query
      nushellPlugins.desktop_notifications
    ];

    # Shell aliases
    environment.shellAliases = {
      ll = "ls -lh";
      la = "ls -lah";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };
}
