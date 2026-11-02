{ pkgs }:
pkgs.writeShellApplication {
  name = "simulator-cleanup";
  runtimeInputs = [ pkgs.nodejs ];
  text = builtins.readFile ./simulator-cleanup.sh;
}
