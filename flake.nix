{
  description = "markie's NixOS config — thinkpadik";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

	nixgl.url = "github:nix-community/nixGL";
  };


  outputs = { self, nixpkgs, home-manager, nixgl }:
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

		  { nixpkgs.overlays = [ nixgl.overlay ]; }

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

      # minimal: Hyprland + essentials only, for a fresh install or recovery
      nixosConfigurations.minimal = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/configuration-minimal.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.markie = import ./home/home-minimal.nix;
          }
        ];
      };
    };
}
