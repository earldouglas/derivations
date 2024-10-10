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
            vimrc
            ''
            " Map \+c to convert Markdown to HTML and copy it into the clipboard
            map <leader>c :w !${pkgs.pandoc}/bin/pandoc -f markdown -t html \| ${pkgs.xclip}/bin/xclip -i -sel clipboard -t text/html<CR><CR>
            map <leader>v :r !${pkgs.xclip}/bin/xclip -o -sel clipboard -t text/html \| ${pkgs.pandoc}/bin/pandoc -f html -t markdown_strict<CR><CR>
            ''
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
        pkgs.coreutils # for nerdtree to use cp, rm, stat, etc.
      ]}
  ''
