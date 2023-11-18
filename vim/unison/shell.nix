{ pkgs ? import <nixpkgs> {} }:

let

  unison-nix =
    let src =
      pkgs.fetchFromGitHub {
        owner = "ceedubs";
        repo = "unison-nix";
        rev = "378814b43702c78b8daca0e6f9444e73cb6c9955";
        sha256 = "sha256:0zk3cjxcz41nf0nfqj3nss9j8r9qns90a0r2kgpyf4qf3slzz6bq";
      };
    in import "${src}/default.nix" {};

  vim =
    pkgs.vim_configurable.customize {
      vimrcConfig = {
        customRC = ''
          filetype indent on
          filetype plugin on
          syntax on
          set expandtab
          set shiftwidth=2
          set autoindent
          set clipboard=unnamedplus
          set noswapfile
          set ruler
          set number
          set backspace=indent,eol,start
          set textwidth=72
          set colorcolumn=73
          set background=dark
          set paste
        '';
        packages.myVimPackage.start = [
          unison-nix.vim-unison
        ];
      };
    };

in 

  pkgs.mkShell {
    nativeBuildInputs = [
      vim
      unison-nix.unison-ucm
    ];
  }
