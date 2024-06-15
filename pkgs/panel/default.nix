{
  lib,
  stdenv,
  fetchurl
}:

stdenv.mkDerivation rec {
  pname = "panel";
  version = "1.11.7";

  meta = with lib; {
    homepage = "https://pterodactyl.io/";
    description = "Open-source game server management panel.";
    license = licenses.mit;
  };

  src = fetchurl {
    url = "https://github.com/pterodactyl/panel/releases/download/v${version}/panel.tar.gz";
    hash = "sha256-tBd0pscEa9/UMDlpxnANf0bwabUlDfrSX5G7w4nJwGM=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/panel
    cp -r * $out/share/panel

    runHook postInstall
  '';
}
