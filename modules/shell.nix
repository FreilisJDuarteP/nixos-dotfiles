{ config, pkgs, ... }:

{
  # 1. Configuración principal de Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Reemplazamos los comandos clásicos por eza con iconos
      ls = "eza --icons=always";
      ll = "eza -l --icons=always";
      la = "eza -a --icons=always";
      lla = "eza -la --icons=always";
      tree = "eza --tree --icons=always";

      edit = "sudo -e";
      # Tu alias actualizado para el nuevo sistema con Flakes
      update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = ["rm *" "pkill *" "cp *"];
  };

  # 2. Habilitar Eza (El reemplazo moderno de ls)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  # 3. Habilitar y configurar Starship (El prompt monocromático)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      
      # Forzar paleta monocromática (blanco y negro)
      character = {
        success_symbol = "[➜](bold white)";
        error_symbol = "[✗](bold white)";
      };
      directory = {
        style = "bold white";
        read_only = " 🔒";
        truncation_length = 3;
      };
      git_branch = {
        symbol = "🌱 ";
        style = "bold white";
      };
      git_status = {
        style = "bold white";
      };
      cmd_duration = {
        style = "white";
        min_time = 2000; # Solo muestra el tiempo si el comando tarda más de 2 segundos
      };
    };
  };
}
