## Installation
```sh
nixos-rebuild switch --flake github:yechiel/dots?dir=work
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
