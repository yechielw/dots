{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.omniflake.flakes.burpsuite-nix.homeManagerModules.default
  ];

  programs.burp = {
    enable = true;
    proEdition = true;

    cliArgs = [
      "--suppress-jre-check"
      "--i-accept-the-license-agreement"
      "--disable-auto-update"
      "--disable-check-for-updates-dialog"
    ];

    wordlists.seclists = "${pkgs.seclists}/share/wordlists/seclists";

    extensions = {
      sharpener.enable = true;
      param-miner.enable = true;
      json-web-tokens.enable = true;
      autorize = {
        enable = true;
        loaded = false;
      };
      js-miner.enable = true;
      copy-as-python-requests.enable = true;
      auto-repeater.enable = true;
      turbo-intruder.enable = true;
      web-cache-deception-scanner.enable = true;
      content-type-converter.enable = true;
      oauth-scan.enable = true;
      http-request-smuggler.enable = true;
      extensibility-helper.enable = true;
      active-scan-plus-plus.enable = true;
      backslash-powered-scanner.enable = true;
      iis-tilde-enumeration-scanner.enable = true;
      mcp-server.enable = true;
      customizer.enable = true;
      exporter-plus-plus.enable = true;
    };

    settings = {
      ai.enabled = true;

      connections.socks_proxy = {
        dns_over_socks = true;
        host = "127.0.0.1";
        port = 1080;
        use_proxy = false;
      };

      display = {
        http_message_display = {
          font_name = "CaskaydiaMono NF";
          font_size = 16;
        };
        title_bar.actions = [
          { action = "open_embedded_browser"; }
          { action = "open_command_palette"; }
          { action = "open_burp_suite_search"; }
        ];
        user_interface = {
          font_size = 16;
          look_and_feel = "Dark";
        };
        window_decoration.use_custom_window_decorations = false;
      };

      extender = {
        # These extensions are private/local and intentionally remain outside
        # the Nix store. Their paths come from the existing Burp configuration.
        extensions = [
          {
            errors = "ui";
            extension_file = "${config.home.homeDirectory}/Documents/maccabi/burpscripts/try2/goversion/maccabi_reauth.py";
            extension_type = "python";
            loaded = false;
            name = "maccabi_reauth.py";
            output = "ui";
          }
          {
            errors = "ui";
            extension_file = "${config.home.homeDirectory}/Documents/maccabi/burpscripts/try2/goversion/burp_ext/build/libs/burp_ext-1.0-SNAPSHOT.jar";
            extension_type = "java";
            loaded = true;
            name = "Maccabi Auth Refresher";
            output = "ui";
          }
          {
            errors = "ui";
            extension_file = "${config.home.homeDirectory}/tools/req-res-snap/dist/reqres-snap.jar";
            extension_type = "java";
            loaded = true;
            name = "ReqRes Snap";
            output = "ui";
          }
        ];

        # The extension packages are managed by Nix, so Burp should not
        # replace them with mutable BApp updates.
        settings.automatically_update_bapps_on_startup = false;
      };

      misc = {
        automatic_project_backup.show_progress = false;
        hotkeys = [
          {
            action = "explain_this";
            hotkey = "Ctrl+E";
          }
          {
            action = "open_embedded_browser";
            hotkey = "Ctrl+Q";
          }
          {
            action = "open_burp_suite_search";
            hotkey = "Ctrl+P";
          }
          {
            action = "open_command_palette";
            hotkey = "Ctrl+K";
          }
          {
            action = "editor_copy_prettified";
            hotkey = "Ctrl+Alt+C";
          }
          {
            action = "send_to_burp_at";
            hotkey = "Ctrl+G";
          }
          {
            action = "open_burp_at";
            hotkey = "Ctrl+Shift+G";
          }
        ];
        suppress_confirm_on_close = true;
      };
      target.view = "left_right_split";
    };
  };
}
