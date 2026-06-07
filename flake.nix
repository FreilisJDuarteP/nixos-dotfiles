{
  description = "Configuración base de NixOS con Flakes y Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 1. Añadimos el repositorio oficial de NVF
    nvf.url = "github:notashelf/nvf";

    # --- NUEVO: Input oficial de Noctalia Shell v4 ---
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            # Le pasamos los 'inputs' a Home Manager para que pueda leer NVF y Noctalia
            home-manager.extraSpecialArgs = { inherit inputs; };
            
            home-manager.users.freilis = import ./home.nix;
          }
        ];
      };
    };
  };
}
