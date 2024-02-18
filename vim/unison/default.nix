{ pkgs ? import <nixpkgs> {} }:

let

  unison-nix = import ./unison.nix {};

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

  pkgs.runCommand "vim" {
    buildInputs = [
      pkgs.makeWrapper
    ];
  }
  ''
    mkdir -p $out/bin
    makeWrapper ${vim}/bin/vim $out/bin/vim-unison \
      --set PATH ${pkgs.lib.makeBinPath [
        unison-nix.unison-ucm
        pkgs.xclip # for clipboard access
      ]}
  ''
