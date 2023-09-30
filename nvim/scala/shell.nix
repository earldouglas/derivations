{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  nativeBuildInputs = [
    (import (./default.nix) {})
    pkgs.bash
    pkgs.scala-cli
    pkgs.sbt
    pkgs.jdk
  ];   
}
