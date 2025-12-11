{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.terminals = {
    enable = mkEnableOption "terminal applications";
    ghostty.enable = mkEnableOption "Ghostty terminal";
    warp-terminal.enable = mkEnableOption "Warp terminal"; 
 };

  config = mkIf config.modules.terminals.enable {
    environment.systemPackages = with pkgs; [
      (mkIf config.modules.terminals.ghostty.enable ghostty)
      (mkIf config.modules.terminals.warp-terminal.enable warp-terminal)
    ];

    # Fonts for terminals
    fonts.packages = with pkgs; [
      fira-code
      fira-code-symbols
      jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
  };
}
