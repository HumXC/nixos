{ stdenv, lib }:
stdenv.mkDerivation {
  name = "clash-premium";
  src = ./clash-premium;
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/clash-premium
    chmod +x $out/bin/clash-premium
  '';

  meta = with lib; {
    description = "It`s not clash";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
