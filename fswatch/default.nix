{ pkgs ? import <nixpkgs> {}, ... }:
pkgs.stdenv.mkDerivation {
  name = "fswatch";
  src = ./.;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    install -D -m755 fswatch.sh $out/bin/fswatch
    wrapProgram $out/bin/fswatch \
      --prefix PATH ":" ${pkgs.inotify-tools}/bin
  '';
}
