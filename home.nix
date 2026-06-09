# home.nix
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./modules/shell.nix
    ./modules/kitty.nix
    ./modules/neovim.nix
    ./modules/niri.nix
  ];

  home.username = "freilis";
  home.homeDirectory = "/home/freilis";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk}";
  };

  # ⭐ AHORA SÍ FUNCIONA porque importamos el módulo en flake.nix
  programs.noctalia = {
    enable = true;
    #systemd.enable = true; # Habilita el servicio systemd

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        default.path = "/home/freilis/Imágenes/wallpaper.png"; # Ajusta esta ruta
      };
    };
  };

  home.packages = with pkgs; [
    # --- UTILIDADES DEL SISTEMA ---
    fastfetch
    nerd-fonts.jetbrains-mono
    wl-clipboard
    ripgrep
    fd
    jq

    # --- GESTOR DE ARCHIVOS ---
    thunar
    thunar-archive-plugin
    ffmpegthumbnailer
    file-roller

    # --- ENTORNO DE DESARROLLO ---
    jdk
    maven
    nodejs
    netbeans
    jetbrains.idea

    # --- SOFTWARE PERSONAL ---
    ankama-launcher
    bitwig-studio
  ];

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "freilisjduartep";
        email = "freilisjduartep@gmail.com";
      };
      safe = {
        directory = "/etc/nixos";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}
