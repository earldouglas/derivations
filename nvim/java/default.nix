{ pkgs ? import <nixpkgs> {}, ... }:

let

  coc_nvim_vim =
    builtins.readFile(./coc.nvim.vim);

  nerdtree_vim =
    builtins.readFile(./nerdtree.vim);

  vimrc = ''
    if filereadable(expand('~/.vimrc'))
      exe 'source' '~/.vimrc'
    endif
  '';

  nvim_with_plugins =
    pkgs.neovim.override {
      configure = {
        customRC = coc_nvim_vim + nerdtree_vim + vimrc;
        packages.myVimPackage =
          with pkgs.vimPlugins; {
            start = [
              vim-airline
              nerdtree
              coc-nvim
              coc-java
            ];
          };
      };
    };

in 

  pkgs.runCommand "nvim" {
    buildInputs = [
      pkgs.makeWrapper
    ];
  }
  ''
    mkdir -p $out/bin
    makeWrapper ${nvim_with_plugins}/bin/nvim $out/bin/nvim-java \
      --set JAVA_HOME ${pkgs.jdk}/lib/openjdk \
      --set PATH ${pkgs.lib.makeBinPath [
        pkgs.xclip # for clipboard access
      ]}
  ''
