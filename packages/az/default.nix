{ pkgs, ... }:
pkgs.azure-cli.withExtensions (with pkgs.azure-cli-extensions; [ azure-devops ])
