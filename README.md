## Usage with nix-env

```
$ nix-env -i -f ./nvim
```

## Usage with nix-shell

```
$ nix-shell --expr '
  { pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
      nativeBuildInputs = [ (import (./nvim) {}) ];   
  }
'
```

## Usage with NixOS

*configuration.nix:*

```nix
let
  derivations =
    pkgs.fetchFromGitHub {
      owner = "earldouglas";
      repo = "derivations";
      rev = "beb600429f929019e8a411d673e3c6c3fb33171d";
      sha256 = "sha256-zdlmrY493lX5T7hQonMKTL5X5+uA/7holkmkSqX0wNQ=";
    };
  neovim = import (derivations + "/nvim") {};
in {
  environment.systemPackages = [ neovim ];
}
```
