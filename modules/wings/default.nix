flake: { config, lib, pkgs, ... }:

with lib;
let
  inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) pterodactyl-wings;

  cfg = config.services.pterodactyl.wings;
in {
  options.services.pterodactyl.wings = {
    enable = mkEnableOption ''
      Wings is the server control plane for Pterodactyl Panel.
    '';

    configuration = mkOption {
      type = with types; nullOr lines;
      default = null;
    };

    configurationFile = mkOption {
      type = with types; nullOr (either str path);
      default = null;
    };

    package = mkOption {
      type = types.package;
      default = pterodactyl-wings;
      description = ''
        The Wings package to use with the service.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.configuration != null && cfg.configurationFile == null) || (cfg.configuration == null && cfg.configurationFile != null);
        message = "Either configuration or configurationFile must be used while wings is enabled.";
      }
    ];

    virtualisation.docker.enable = true;
    environment.etc."pterodactyl/config.yml" = {
      text = mkIf (cfg.configuration != null) cfg.configuration;
      source = mkIf (cfg.configurationFile != null) cfg.configurationFile;
      mode = "0700";
    };

    systemd.services."pterodactyl-wings" = {
      description = "Pterodactyl Wings Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      partOf = [ "docker.service" ];
      startLimitIntervalSec = 180;
      startLimitBurst = 30;
      serviceConfig = {
        User = "root";
        WorkingDirectory = "/etc/pterodactyl";
        LimitNOFILE = 4096;
        PIDFile = "/var/run/wings/daemon.pid";
        ExecStart = "${cfg.package}/bin/wings";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
