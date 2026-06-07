# home.nix
{
  config,
  pkgs,
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

  home.packages = with pkgs; [
    # --- UTILIDADES DEL SISTEMA ---
    fastfetch
    nerd-fonts.jetbrains-mono
    wl-clipboard
    ripgrep # requerido por Telescope live_grep
    fd # mejora búsqueda de archivos en Telescope
    direnv
    jq
    # --- ENTORNO DE DESARROLLO ---
    jdk
    maven
    nodejs
  ];

  programs.home-manager.enable = true;

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
}
