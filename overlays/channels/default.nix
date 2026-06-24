# overlays/channels/default.nix
{ channels, ... }:

final: prev: {
  stable = channels.stable;
  master = channels.master;
}
