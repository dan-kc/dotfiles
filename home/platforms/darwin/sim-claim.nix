{ pkgs }:
pkgs.writeShellApplication {
  name = "sim-claim";
  runtimeInputs = [ pkgs.nodejs pkgs.coreutils ];
  text = builtins.readFile ./sim-claim.sh;
}
