{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.development = {
    enable = mkEnableOption "development tools";
    git.enable = mkEnableOption "Git version control";
    ssh.enable = mkEnableOption "SSH client and server";
    docker.enable = mkEnableOption "Docker and Docker Compose";
  };

  config = mkIf config.modules.development.enable {
    environment.systemPackages = with pkgs; [
      (mkIf config.modules.development.git.enable git)
      (mkIf config.modules.development.ssh.enable openssh)
      (mkIf config.modules.development.docker.enable docker-compose)
    ] ++ optionals config.modules.development.enable [
      # Additional development tools
      curl
      wget
      unzip
      zip
      tree
      btop
      fastfetch
      onefetch
      tmux
      yazi
      vicinae
      lsd
      bat
      lazygit
      lazydocker
      typst
      atac
    ];

    # Git configuration
    programs.git = mkIf config.modules.development.git.enable {
      enable = true;
    };

    # SSH configuration
    services.openssh = mkIf config.modules.development.ssh.enable {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # Docker configuration
    virtualisation.docker = mkIf config.modules.development.docker.enable {
      enable = true;
      enableOnBoot = true;
    };

    # Add user to docker group
    users.users.yoptabyte = mkIf config.modules.development.docker.enable {
      extraGroups = [ "docker" ];
    };

    # Enable SSH agent (disabled when GNOME is enabled to avoid conflicts)
    programs.ssh.startAgent = mkIf (config.modules.development.ssh.enable && !config.modules.desktop.gnome.enable) true;
  };
}
