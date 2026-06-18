# SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

# The package on its own only produces a patched binary tree in the Nix
# store. The `NSGClient` binary hardcodes absolute `/opt/Citrix/...`
# paths and needs three pieces of system integration that a package
# cannot provide:
#
#   1. CAP_NET_RAW on the binary - it opens raw sockets for the VPN data path.
#   2. The `nsgverctl` system service - privileged route/nftables setup.
#   3. The `/opt/Citrix` tree on disk - because the paths are not relocatable.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.citrix-secure-access;

  optTree = "${cfg.package}/opt/Citrix";
  resolvectlCompat = pkgs.writeShellScript "citrix-resolvectl-compat" ''
    if [ "''${1:-}" = "flush-caches" ]; then
      ${pkgs.systemd}/bin/resolvectl flush-caches >/dev/null 2>&1 || true
      exit 0
    fi

    exec ${pkgs.systemd}/bin/resolvectl "$@"
  '';

  readOnlyEntries = [
    "resx"
    "service"
    "libAnalyticsInterface.so"
    "libsentry.so"
    "crashpad_handler"
    "pubkey.asc"
    "citrix_va.conf"
    "rt_csa.conf"
    "globalConfiguration.conf"
    "userConfiguration.conf"
    "bin/nsgclient.desktop"
    "bin/nsgtsb.sh"
    "bin/startnsgclient.sh"
  ];

  mkCopy = entry: "C /opt/Citrix/NSGClient/${entry} 0644 root root - ${optTree}/NSGClient/${entry}";
  mkSymlink = entry: "L+ /opt/Citrix/NSGClient/${entry} - - - - ${optTree}/NSGClient/${entry}";

  staticTreeRules = [
    "d /opt/Citrix 0755 root root -"
    "d /opt/Citrix/NSGClient 0755 root root -"
    "d /opt/Citrix/NSGClient/bin 0755 root root -"
    # The EPA (Endpoint Analysis) library is dlopen()ed by absolute path.
    "L+ /opt/Citrix/EPA - - - - ${optTree}/EPA"
    # bin/NSGClient must resolve to the capability wrapper so that the
    # service-spawned instance also gets CAP_NET_RAW, not just desktop launches.
    "L+ /opt/Citrix/NSGClient/bin/NSGClient - - - - /run/wrappers/bin/NSGClient"
  ]
  ++ map mkSymlink readOnlyEntries;

  runtimeStateRules = [
    "f /opt/Citrix/NSGClient/.socketpath 0644 root root - -"
    "f /opt/Citrix/NSGClient/nft_commands.txt 0644 root root - -"
    "d /opt/Citrix/NSGClient/tmp 0755 root root -"
    (mkCopy "globalConfiguration.json")
  ];
in
{
  options.services.citrix-secure-access = {
    enable = lib.mkEnableOption "the Citrix Secure Access VPN client";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.citrix-secure-access;
      defaultText = lib.literalMD "`pkgs.citrix-secure-access`";
      description = "The citrix-secure-access package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # NSGClient needs CAP_NET_RAW for the VPN data path. `setcap` cannot
    # be applied to a read-only store path, so we route launches through
    # a security wrapper. NixOS capability wrappers raise the cap as
    # *ambient*, so it survives the exec chain: wrapper -> gApps wrapper
    # -> real ELF.
    security.wrappers.NSGClient = {
      source = "${cfg.package}/bin/NSGClient";
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+eip";
    };

    # Privileged daemon: route/nftables/DNS plumbing for the tunnel.
    systemd.services.nsgverctl = {
      description = "Citrix NSG Version Control Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      # The daemon shells out to route/firewall tooling at runtime.
      path = with pkgs; [
        iproute2
        nftables
        procps
      ];
      serviceConfig = {
        ExecStart = "${optTree}/NSGClient/service/nsgverctl";
        Restart = "always";
        KillMode = "process";
      };
    };

    # The tunnel interface (`Citrix_VA`) must be left alone by NetworkManager,
    # and the client needs its dedicated routing-table id registered.
    networking.networkmanager.enable = lib.mkDefault true;
    environment.etc."NetworkManager/conf.d/citrix_va.conf".source =
      "${optTree}/NSGClient/citrix_va.conf";
    environment.etc."iproute2/rt_tables.d/rt_csa.conf".source = "${optTree}/NSGClient/rt_csa.conf";

    # Materialise the hardcoded /opt/Citrix tree.
    systemd.tmpfiles.rules = staticTreeRules ++ runtimeStateRules ++ [
      "L+ /usr/bin/resolvectl - - - - ${resolvectlCompat}"
      "L+ /usr/bin/systemctl - - - - ${pkgs.systemd}/bin/systemctl"
      "d /usr/sbin 0755 root root -"
      "L+ /usr/sbin/nft - - - - ${pkgs.nftables}/bin/nft"
    ];
  };
}
