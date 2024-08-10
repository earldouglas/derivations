{ pkgs ? import <nixpkgs> {}, ... }:

let

  nvim-metals_vim =
    builtins.readFile(./nvim-metals.vim);

  nerdtree_vim =
    builtins.readFile(./nerdtree.vim);

  vimrc =
    builtins.readFile(./vimrc);

  nvim_with_plugins =
    pkgs.neovim.override {
      configure = {
        customRC =
          builtins.concatStringsSep "\n" [
            nvim-metals_vim
            nerdtree_vim
            ''
            let g:NERDTreeCopyCmd='${pkgs.coreutils}/bin/cp -r'
            let g:NERDTreeRemoveDirCmd='${pkgs.coreutils}/bin/rm -rf'
            ''
            vimrc
          ];

        packages.myVimPackage =
          with pkgs.vimPlugins; {
            start = [
              vim-airline
              nerdtree
              plenary-nvim     # required by nvim-metals
              nvim-dap         # required by nvim-metals?
              nvim-cmp
              cmp-nvim-lsp
              nvim-metals
              vim-nix
              vim-scala
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
    makeWrapper ${nvim_with_plugins}/bin/nvim $out/bin/vim \
      --set PATH ${pkgs.lib.makeBinPath [
        pkgs.bash # without this, nvim crashes with "Client 1 quit with exit code 127 and signal 0"
        pkgs.coursier
        pkgs.metals
        pkgs.jdk
        pkgs.xclip # for clipboard access
      ]}
  ''
