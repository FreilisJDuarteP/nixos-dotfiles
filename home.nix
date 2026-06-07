{ config, pkgs, ... }:

{
  # 1. Importamos tus módulos externos aquí
  imports = [
    ./modules/shell.nix
    ./modules/kitty.nix
    ./modules/neovim.nix
  ];

  home.username = "freilis";
  home.homeDirectory = "/home/freilis";

  # Esta versión debe coincidir con la versión de tu sistema
  home.stateVersion = "26.05";

  # 2. Paquetes instalados en el entorno de usuario
  home.packages = with pkgs; [
    # Utilidades del sistema y terminal
    fastfetch
    nerd-fonts.jetbrains-mono
    wl-clipboard

    # --- ENTORNO DE DESARROLLO ---
    # Java
    jdk         # Instala el OpenJDK por defecto del sistema
    maven       # Gestor de dependencias y construcción para Java

    # JavaScript / Node.js
    nodejs      # Instala Node.js junto con el binario de npm de forma nativa
        ];

  # Dejamos que Home Manager se gestione a sí mismo
  programs.home-manager.enable = true;

# --- CONFIGURACIÓN GLOBAL DE GIT ---
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "freilisjduartep";
        email = "freilisjduartep@gmail.com";
      };
      # NUEVO: Esto le dice a Git de manera declarativa que confíe en /etc/nixos
      safe = {
        directory = "/etc/nixos";
      };
    };
  };
}
