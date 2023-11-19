{ pkgs ? import <nixpkgs> {} }:
let

  unison-nix = import ./unison.nix {};

in

  pkgs.mkShell {
    nativeBuildInputs = [
      (import (./default.nix) {})
      unison-nix.unison-ucm
    ];
  }
