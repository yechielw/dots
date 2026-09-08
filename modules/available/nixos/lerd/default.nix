{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # 1. Rootless Podman — lerd runs everything in containers.
  virtualisation.podman.enable = true;
  virtualisation.containers.enable = true;

  # 2. Move Podman's default subnet pool off 10.x.
  #    REQUIRED ONLY IF a route on your machine claims 10.0.0.0/8 (common with
  #    corporate VPNs — check `ip route`). Podman's default pool lives in 10.x,
  #    and an overlapping route makes network creation fail with
  #    "could not find free subnet from subnet pools". Harmless to keep even
  #    without a VPN.
  virtualisation.containers.containersConf.settings.network.default_subnet_pools = [
    {
      base = "172.20.0.0/16";
      size = 24;
    }
  ];

  # 3. Let rootless nginx bind 80/443. Without this, lerd asks for sudo to set
  #    the sysctl at runtime on every install; declaring it makes it permanent.
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

  # 4. Keep lerd's user containers alive outside an active graphical session
  #    (otherwise systemd-logind tears them down on lock/logout).
  users.users.yechiel.linger = true;

  # 5. DNS for *.test — owned by NixOS, NOT by lerd (see notes below).
  #    Routes ONLY *.test to lerd's DNS container on 127.0.0.1:5300; everything
  #    else stays on your normal resolver, so a stopped lerd-dns can only ever
  #    break .test, never the whole internet.
  services.resolved.enable = true;
  services.resolved.settings.Resolve = {
    DNS = "127.0.0.1:5300";
    Domains = [ "~test" ];
  };
  networking.networkmanager.dns = "systemd-resolved"; # if you use NetworkManager

  # 6. Trust lerd's mkcert root CA system-wide (curl, PHP, Node, …).
  #    The file doesn't exist yet on a fresh install — add this line AFTER the
  #    "First-time lerd setup" step below generates and copies it in.
  # security.pki.certificateFiles = [ ./certs/lerd-rootCA.pem ];

  # 7. Point lerd's host-binary services at the Nix profile.
  #    lerd-ui and lerd-watcher exec `~/.local/bin/lerd`, where lerd would
  #    self-install on other distros. On NixOS the binary comes from the Nix
  #    profile, so without this symlink both fail with status=203/EXEC.
  #    /run/current-system/sw/bin/lerd tracks the current generation, so this
  #    survives nixos-rebuild and lerd updates.
  systemd.user.tmpfiles.rules = [
    "L %h/.local/bin/lerd - - - - /run/current-system/sw/bin/lerd"
  ];

  # 8. OPTIONAL host PHP + Composer (for editor tooling and `lerd new`'s
  #    initial scaffold). lerd serves your app's PHP from containers regardless
  #    of this — pin the per-project version with `lerd isolate <ver>`.
  environment.systemPackages = with pkgs; [
    php84
    php84Packages.composer
    inputs.omniflake.flakes.lerd-nixos.packages.x86_64-linux.default
  ];
}
