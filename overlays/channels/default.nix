# overlays/channels/default.nix
{
  channels,
  inputs,
  ...
}: final: prev: {
  stable = channels.stable;
  master = channels.master;
  herdr = inputs.herdr.packages.${prev.system}.default;
}
