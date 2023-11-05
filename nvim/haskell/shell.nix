{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  nativeBuildInputs = [
    (import (./default.nix) {})
    pkgs.haskell-language-server
    pkgs.cabal-install
    pkgs.zlib
  ];
}
