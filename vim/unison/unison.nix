{ pkgs ? import <nixpkgs> {} }:
let src =
  pkgs.fetchFromGitHub {
    owner = "ceedubs";
    repo = "unison-nix";
    rev = "378814b43702c78b8daca0e6f9444e73cb6c9955";
    sha256 = "sha256:0zk3cjxcz41nf0nfqj3nss9j8r9qns90a0r2kgpyf4qf3slzz6bq";
  };
in import "${src}/default.nix" {}
