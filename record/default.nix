{ pkgs ? import <nixpkgs> {}, ... }:
pkgs.stdenv.mkDerivation {
  name = "record";
  src = ./.;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    install -D -m755 record.sh $out/bin/record
    wrapProgram $out/bin/record \
      --prefix PATH ":" ${pkgs.xorg.xwininfo}/bin \
      --prefix PATH ":" ${pkgs.byzanz}/bin
  '';
}
