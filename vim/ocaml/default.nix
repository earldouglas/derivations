{ pkgs ? import <nixpkgs> {} }:

let

  coc-settings = builtins.toJSON {
    languageserver = {
      ocaml = {
        command = "ocamllsp";
        filetypes = [ "ml" "ocaml" ];
        rootPatterns = [ "dune-project" "dune-workspace" ".git" ];
      };
    };
  };

  vim =
    pkgs.vim_configurable.customize {
      vimrcConfig = {
        customRC =
          builtins.concatStringsSep "\n" [
            (builtins.readFile ./vim/vimrc.vim)
            ''
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

              let g:coc_user_config = ${coc-settings}

              " GoTo code navigation
              nmap <silent> gd <Plug>(coc-definition)
              nmap <silent> gy <Plug>(coc-type-definition)
              nmap <silent> gi <Plug>(coc-implementation)
              nmap <silent> gr <Plug>(coc-references)

              " Use K to show documentation in preview window
              nnoremap <silent> K :call ShowDocumentation()<CR>
              function! ShowDocumentation()
                if CocAction('hasProvider', 'hover')
                  call CocActionAsync('doHover')
                else
                  call feedkeys('K', 'in')
                endif
              endfunction
            ''
          ];
        packages.myVimPackage.start = [
          pkgs.vimPlugins.coc-nvim
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
    makeWrapper ${vim}/bin/vim $out/bin/vim-ocaml \
      --set PATH ${pkgs.lib.makeBinPath [
        pkgs.ocamlPackages.ocaml-lsp
        pkgs.ocamlformat
        pkgs.nodejs
        pkgs.ocamlPackages.dune_3
      ]}
  ''
