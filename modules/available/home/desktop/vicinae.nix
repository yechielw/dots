{ lib, ... }:
{
  programs.vicinae = {
    enable = true; # default: false
    systemd = {
      enable = true; # default: false
      autoStart = true; # default: false
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
  };
  wayland.windowManager.hyprland.settings = {
    layer_rule = [
      {
        match = {
          namespace = "vicinae";
        };
        blur = true;
        ignore_alpha = 0;
        name = "vicinae-blur";
      }
      {
        match = {
          namespace = "vicinae";
        };
        no_anim = true;
        name = "vicinae-no-animation";
      }
    ];
    bind = [
      {
        _args = [
          "SUPER + space"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"vicinae toggle\")")
        ];
      }

      {
        _args = [
          "SUPER + V"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"vicinae vicinae://launch/clipboard/history\")")
        ];
      }

      {
        _args = [
          "SUPER + period"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"vicinae vicinae://launch/core/search-emojis\")")
        ];
      }
    ];
  };
}
