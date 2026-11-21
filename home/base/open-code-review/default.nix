{ pkgs, ... }:
{
  home.packages = [ (pkgs.callPackage ../../../pkgs/open-code-review { }) ];
}
