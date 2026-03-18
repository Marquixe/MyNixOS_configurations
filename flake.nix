{
  description = "markie's NixOS config — thinkpadik";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {

    nixosConfigurations.thinkpadik = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true;
          home-manager.users.markie    = import ./home/home.nix;
        }
      ];
    };

    # якщо колись додаси мінімальну конфігурацію для іншої машини:
    # nixosConfigurations.minimalbox = nixpkgs.lib.nixosSystem { ... };

  };
}
