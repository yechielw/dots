{
  writeShellApplication,
  lib,
  pkgs,
  wrappers,
  inputs,
  ...
}:
{}
# let
#   conf = {
#     onboarding = false;
#     prefix = "ctrl+s";
#     theme = {
#       name = "dracula";
#       auto_switch = false;
#     };
#   };
# in
# wrappers.lib.wrapPackage {
#   inherit pkgs;
#   package = pkgs.herdr;
#   env = {
#     HERDR_CONFIG_PATH = "${pkgs.writers.writeTOML "config.toml" conf}";
#   };
# }
#

#
# writeShellApplication {
#   name = "herdr";
#   runtimeInputs = [ pkgs.herdr ];
#   text = ''
#     HERDR_CONFIG_PATH=${pkgs.writers.writeTOML "config.toml" {
#      # =============================================
#
#       onboarding = false;
#       prefix = "ctrl+s";
#       theme = {
#         name = "dracula";
#         auto_switch = false;
#       };
#
#       # ============================================
#     }
#     } ${lib.getExe pkgs.herdr}
#   '';
# }
