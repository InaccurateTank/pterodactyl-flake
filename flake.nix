{
  description = "Pterodactyl Wings Daemon";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
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
      nixosModules.pterodactyl-wings = import ./modules/pterodactyl-wings self;
      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          pterodactyl-wings = pkgs.callPackage ./pkgs/pterodactyl-wings {
            buildGoModule = pkgs.buildGo120Module;
          };
          default = self.packages.${system}.pterodactyl-wings;
        });
    };
}
