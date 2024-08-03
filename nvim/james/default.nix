{ pkgs ? import <nixpkgs> {}, ... }:

let

  coc_nvim_vim =
    builtins.readFile(./coc.nvim.vim);

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
        customRC =
          builtins.concatStringsSep "\n" [
            coc_nvim_vim
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

              ## misc ##################################################
              vim-airline
              nerdtree

              ## scala #################################################
              plenary-nvim     # required by nvim-metals
              nvim-dap         # required by nvim-metals?
              nvim-cmp
              cmp-nvim-lsp
              nvim-metals
              vim-nix
              vim-scala
              vim-vsnip

              ## java ##################################################
              coc-nvim
              coc-java

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
      --set JAVA_HOME ${pkgs.jdk}/lib/openjdk \
      --set PATH ${pkgs.lib.makeBinPath [
        pkgs.bash # without this, nvim crashes with "Client 1 quit with exit code 127 and signal 0"
        pkgs.coursier
        pkgs.metals
        pkgs.jdk
        pkgs.xclip # for clipboard access
      ]}
  ''
