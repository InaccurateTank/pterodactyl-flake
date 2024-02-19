{
  lib,
  stdenv,
  fetchurl
}:

stdenv.mkDerivation rec {
  pname = "panel";
  version = "1.11.5";

  meta = with lib; {
    homepage = "https://pterodactyl.io/";
    description = "Open-source game server management panel.";
    license = licenses.mit;
  };

  src = fetchurl {
    url = "https://github.com/pterodactyl/panel/releases/download/v${version}/panel.tar.gz";
    hash = "sha256-sByXwUd1yEdyXFSjO1mBvXfSJlZCqcJuZ0jZCIFLlLM=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/panel
    cp -r * $out/share/panel

    runHook postInstall
  '';
}
