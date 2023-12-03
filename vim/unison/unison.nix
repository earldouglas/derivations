{ pkgs ? import <nixpkgs> {} }:
let src =
  pkgs.fetchFromGitHub {
    owner = "ceedubs";
    repo = "unison-nix";
    rev = "d0c99d76a5beea2c0a829f0c5915d52b5341141e";
    sha256 = "1sirbbbnxg1b63vfdivv27vxd9lwh9yddg8qwwcgj8i5d3gzqa1q";
  };
in import "${src}/default.nix" {}
