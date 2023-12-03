# Usage

## nix-env

```
$ nix-env -i -f ./vim/unison/default.nix
$ nix-env -i -f ./vim/unison/unison.nix
```

## nix-shell

```
$ nix-shell ./vim/unison/shell.nix
```

## NixOS

*configuration.nix:*

```nix
let

  derivations =
    pkgs.fetchFromGitHub {
      owner = "earldouglas";
      repo = "derivations";
      rev = "816ff78c3da0f90b07eafd174a386c8f885cf14a";
      sha256 = "13sy7axxj6517iqkidq3s132adk4s217mm7i7ni92fh7p89scd2a";
    };

  vim-unison = import (derivations + "/vim/unison/default.nix") {};
  unison-nix = import (derivations + "/vim/unison/unison.nix") {};

in {

  environment.systemPackages = [
    vim-unison
    unison-nix.unison-ucm
  ];

}
```
