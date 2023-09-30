{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  nativeBuildInputs = [
    (import (./default.nix) {})
    pkgs.bash
    pkgs.gradle
    pkgs.jdk
    pkgs.maven
    pkgs.scala-cli
  ];
}
