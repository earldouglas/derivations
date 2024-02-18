{ pkgs ? import <nixpkgs> {}, ... }:

let

  nvim-metals_vim =
    builtins.readFile(./nvim-metals.vim);

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
        customRC = nvim-metals_vim + nerdtree_vim + vimrc;
        packages.myVimPackage =
          with pkgs.vimPlugins; {
            start = [
              plenary-nvim     # required by nvim-metals
              nvim-dap         # required by nvim-metals?
              nvim-cmp
              cmp-nvim-lsp
              nvim-metals
              vim-airline
              vim-nix
              vim-scala
              nerdtree
              vim-vsnip
            ];
          };
      };
    };

in 

  pkgs.runCommand "nvim" {
    buildInputs = [ pkgs.makeWrapper ];
  }
  ''
    mkdir -p $out/bin
    makeWrapper ${nvim_with_plugins}/bin/nvim $out/bin/nvim-scala \
      --set PATH ${pkgs.lib.makeBinPath [
        pkgs.bash # without this, nvim crashes with "Client 1 quit with exit code 127 and signal 0"
        pkgs.coursier
        pkgs.metals
        pkgs.jdk
        pkgs.xclip # for clipboard access
      ]}
  ''
