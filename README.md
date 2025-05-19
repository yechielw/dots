# Nixos and home-manager config

![screenshot](images/screenshot.png)

## Hyprland/NixOS/GNU/Linux
- lanzaboote for TPM backed FDE with auto unlock
- Bar: waybar
- Notification daemon: swaync
- Terminal: ghostty
- Design principle: Apple

## Installation

```sh
nixos-rebuild switch --flake github:yechiel/dots?dir=work \
–-extra-experimental-features nix-command flake
```

or

```sh
nix-env -p git
git clone git@github.com:yechielw/dots 
nixos-rebuild switch --flake ./dots/work
```

## post installation

enable fingerprint login

```sh
fprintd-enroll yechiel
```

enable atuin

```sh
atuin login
atuin sync
```
