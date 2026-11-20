{ config, lib, pkgs, ... }:
let
  user = config.system.primaryUser;
  home = config.users.users.${user}.home;
  appData = "${home}/Library/Application Support";
  helm = "${appData}/helm";
  mindMap = "${appData}/Mind Map Sync";
  retent = "${appData}/retent-ios";
  projects = "${home}/projects";
  openRouterKey = config.sops.secrets.openrouter_api_key.path;
  runHelm = pkgs.writeShellScript "run-helm" ''
    OPENROUTER_API_KEY="$(/bin/cat ${lib.escapeShellArg openRouterKey})" || exit 1
    export OPENROUTER_API_KEY
    exec "${projects}/helm/.helm-service/bin/helm" serve --listen 127.0.0.1:4780
  '';

  service =
    { arguments, variables, log }:
    {
      serviceConfig = {
        ProgramArguments = arguments;
        EnvironmentVariables = {
          HOME = home;
          PATH = "${home}/.nix-profile/bin:/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        } // variables;
        UserName = user;
        WorkingDirectory = home;
        RunAtLoad = true;
        KeepAlive = true;
        ThrottleInterval = 10;
        StandardOutPath = log;
        StandardErrorPath = log;
      };
    };
in
{
  launchd.daemons = lib.mapAttrs (_: service) {
    "dev.keone.helm" = {
      arguments = [ "${runHelm}" ];
      variables = {
        HELM_HOME = helm;
        HELM_PROJECTS = projects;
      };
      log = "${helm}/logs/launchd.log";
    };

    "dev.keone.mind-map-sync" = {
      arguments = [ "${mindMap}/board-sync" ];
      variables = {
        MIND_MAP_DATABASE = "${mindMap}/workspace.sqlite3";
        MIND_MAP_LISTEN = "127.0.0.1:47832";
      };
      log = "${mindMap}/server.log";
    };

    "dev.keone.retent-server" = {
      arguments = [ "${projects}/retent/.retent-service/bin/retent-service" ];
      variables = {
        RETENT_ROOT = "${projects}/retent";
        RETENT_TOKEN_FILE = "${retent}/api-token";
        RETENT_OPENAI_KEY_FILE = "${retent}/openai-api-key";
      };
      log = "${retent}/server.log";
    };
  };
}
