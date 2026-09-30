# Hand-rolled base16 schemes. Every background sits in the same darkness band as
# sandcastle (#282c34) - dark, but never near-black.
#
# The last three deliberately mismatch the usual base16 roles (red where green
# is expected, and so on), the way sandcastle puts a teal on base08.
{
  driftwood = import ./driftwood.nix;
  fernglow = import ./fernglow.nix;
  graphite = import ./graphite.nix;
  harbour = import ./harbour.nix;
  plumsmoke = import ./plumsmoke.nix;

  bruise = import ./bruise.nix;
  crosswire = import ./crosswire.nix;
  seaglass = import ./seaglass.nix;
}
