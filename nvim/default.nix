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

in 

  (
    pkgs.neovim.overrideAttrs (finalAttrs: previousAttrs: {
      postFixup =
        (previousAttrs.postFixup or "") + ''
        wrapProgram $out/bin/nvim \
          --prefix PATH:${pkgs.lib.makeBinPath [ pkgs.coursier ]} \
          --prefix PATH:${pkgs.lib.makeBinPath [ pkgs.metals ]}
      '';
    })
  ).override {
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
          ];
        };
    };
  }
