{ config
, lib
, ...
}:
{
  options.profiles.kanshi.enable = lib.mkEnableOption "host-specific kanshi monitor profiles";

  config = lib.mkIf config.profiles.kanshi.enable {
    services.kanshi = {
      enable = true;
      settings = [
        {
          profile.name = "internal";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              scale = 1.0;
            }
          ];
        }
        {
          profile.name = "work";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "Lenovo Group Limited E24-28 VVQ36240";
              status = "enable";
              # position = "2784,0";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "Lenovo Group Limited E24-28 VVQ36235";
              status = "enable";
              position = "1920,0";
              # position = "4704x0";
              scale = 1.0;
            }
          ];
        }
        {
          profile.name = "home";
          profile.outputs = [
            {
              criteria = "eDP-1";
              # status = "disable";
              position = "1920,0";
            }
            {
              criteria = "HP Inc. HP V24i 1CR1161GPX";
              status = "enable";
              position = "0,0";
              scale = 1.0;
            }
          ];
        }
      ];
    };
  };
}
