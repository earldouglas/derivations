let g:coc_user_config = {
\  "languageserver": {
\    "haskell": {
\      "command": "haskell-language-server-wrapper",
\      "args": ["--lsp"],
\      "rootPatterns": ["*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml"],
\      "filetypes": ["haskell", "lhaskell"]
\    }
\  }
\}
