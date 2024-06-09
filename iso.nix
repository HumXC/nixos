#!/usr/bin/env nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
{ pkgs, ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  environment.systemPackages = with pkgs; [
    helix
    wget
    clash-meta
    wget
  ];
  environment.etc = {
    "configuration.nix".source = ./configuration.nix;
  };
}
