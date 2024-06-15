{
  description = "Pterodactyl Wings Daemon";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      nixosModules.pterodactyl-wings = import ./modules/wings self;
      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          wings = pkgs.callPackage ./pkgs/wings {
            buildGoModule = pkgs.buildGo121Module;
          };
          panel = pkgs.callPackage ./pkgs/panel {};
        });
    };
}
