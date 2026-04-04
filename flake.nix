{
  description = "markie's NixOS config — thinkpadik";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.thinkpadik = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.markie = import ./home/home.nix;
          }
        ];
      };

      devShells.${system} = {
        python = import ./shells/python.nix { inherit pkgs; };
        java = import ./shells/java.nix { inherit pkgs; };
      };

      # якщо колись додаси мінімальну конфігурацію для іншої машини:
      # nixosConfigurations.minimalbox = nixpkgs.lib.nixosSystem { ... };
    };
}
