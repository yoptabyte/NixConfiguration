{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.editors = {
    enable = mkEnableOption "text editors";
    helix.enable = mkEnableOption "Helix editor";
    neovim.enable = mkEnableOption "Neovim editor";
    windsurf.enable = mkEnableOption "Windsurf editor";
    code-cursor-fhs.enable = mkEnableOption "Cursor editor";
    zed-editor-fhs.enable = mkEnableOption "Zed editor";
  };

  config = mkIf config.modules.editors.enable {
    environment.systemPackages = with pkgs; [
      (mkIf config.modules.editors.helix.enable helix)
      (mkIf config.modules.editors.neovim.enable neovim)
      (mkIf config.modules.editors.windsurf.enable windsurf)
      (mkIf config.modules.editors.zed-editor-fhs.enable zed-editor-fhs)
      (mkIf config.modules.editors.code-cursor-fhs.enable code-cursor-fhs)
    ] ++ optionals (config.modules.editors.helix.enable || config.modules.editors.neovim.enable || config.modules.editors.windsurf.enable || config.modules.editors.zed-editor-fhs.enable || config.modules.editors.code-cursor-fhs.enable ) [
      # Language servers
      nil                 # Nix LSP
      rust-analyzer       # Rust LSP
      nodePackages.typescript-language-server
      pyright
      lua-language-server
      jdt-language-server # Java LSP
      vue-language-server
      vscode-langservers-extracted # CSS/HTML LSP
      haskell-language-server # Haskell LSP
      dockerfile-language-server # Docker LSP

      # Development tools
      tree-sitter
      ripgrep
      fd
      git
    ];
  };
}
