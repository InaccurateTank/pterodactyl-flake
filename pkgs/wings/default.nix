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
    hash = "sha256-JzbxROashDAL4NSeqMcWR9PgFqe9peBNpeofA347oE4=";
  };

  vendorHash = "sha256-fn+U91jX/rmL/gdMwRAIDEj/m0Zqgy81BUyv4El7Qxw=";
  subPackages = [ "." ];

  CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];
}
