# flake.nix
{
  description = "Configuración base de NixOS con Flakes, Home Manager, NVF y Noctalia v5";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ⭐ URL CORRECTA según documentación oficial
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            # ⭐ IMPORTAR EL MÓDULO DE NOCTALIA
            home-manager.sharedModules = [
              inputs.noctalia.homeModules.default
            ];

            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.freilis = import ./home.nix;
          }
        ];
      };
    };
  };
}
