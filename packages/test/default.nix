{pkgs, ...}: let
  f = pkgs.formats.json {};
in (f.generate "e.json" {
  a = "dd";
  r = "ff";
})
