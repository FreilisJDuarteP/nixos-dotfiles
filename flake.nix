# /etc/nixos/flake.nix
# ============================================================
# FLAKE PRINCIPAL - Entrypoint de la configuración NixOS
# ============================================================
{
  description = "Configuración NixOS: Niri + Noctalia + NVF";

  # ============================================================
  # INPUTS (Fuentes externas de la configuración)
  # ============================================================
  inputs = {
    # Nixpkgs principal (canal inestable - paquetes más recientes)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager - Gestión de configuración de usuario
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NVF - Neovim preconfigurado declarativo
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia - Shell para Niri (barra, lanzador, notificaciones)
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ============================================================
  # OUTPUTS (Resultado del flake - configuraciones generadas)
  # ============================================================
  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    # Configuración del sistema NixOS
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};

        modules = [
          # Configuración de hardware (generada por nixos-generate-config)
          ./hardware-configuration.nix

          # Configuración principal del sistema
          ./configuration.nix

          # Módulo de Home Manager integrado con NixOS
          home-manager.nixosModules.home-manager
          {
            # Compartir los paquetes globales con Home Manager
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            # Importar el módulo de Noctalia para Home Manager
            home-manager.sharedModules = [
              inputs.noctalia.homeModules.default
            ];

            # Pasar inputs a los módulos de usuario
            home-manager.extraSpecialArgs = {inherit inputs;};

            # Configuración del usuario 'freilis'
            home-manager.users.freilis = import ./home.nix;
          }
        ];
      };
    };
  };
}
