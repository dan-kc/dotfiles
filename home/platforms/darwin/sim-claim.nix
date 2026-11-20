{ pkgs, device ? null }:
pkgs.writeShellApplication {
  name = "sim-claim";
  runtimeInputs = [ pkgs.nodejs pkgs.coreutils ];
  text = pkgs.lib.optionalString (device != null) ''
    export SIM_CLAIM_DEVICE="''${SIM_CLAIM_DEVICE:-${device}}"
  '' + builtins.readFile ./sim-claim.sh;
}
