{ pkgs ? import <nixpkgs> {} }:

let

  vim =
    pkgs.vim_configurable.customize {
      vimrcConfig = {
        customRC =
          builtins.concatStringsSep "\n" [
            (builtins.readFile ./vim/nerdtree.vim)
            (builtins.readFile ./vim/coc.nvim.vim)
            (builtins.readFile ./vim/coc-settings.json.vim)
            (builtins.readFile ./vim/vimrc.vim)
          ];
        packages.myVimPackage.start = [
          pkgs.vimPlugins.airline
          pkgs.vimPlugins.coc-nvim
          pkgs.vimPlugins.nerdtree
        ];
      };
    };

in 

  pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.ocamlPackages.ocaml-lsp
      vim
    ];
  }
