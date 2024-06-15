{
  lib,
  buildGoModule,
  fetchFromGitHub
}:

buildGoModule rec {
  pname = "wings";
  version = "1.11.13";

  meta = with lib; {
    homepage = "https://pterodactyl.io/";
    description = "Pterodactyl wings backend built for NixOS";
  };

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    hash = "sha256-UpYUHWM2J8nH+srdKSpFQEaPx2Rj2+YdphV8jJXcoBU=";
  };

  vendorHash = "sha256-eWfQE9cQ7zIkITWwnVu9Sf9vVFjkQih/ZW77d6p/Iw0=";
  subPackages = [ "." ];

  CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];
}
