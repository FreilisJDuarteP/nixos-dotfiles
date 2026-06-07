{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    # Usaremos la JetBrains Mono Nerd Font que instalamos antes
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    settings = {
      # Configuración de la ventana
      window_padding_width = 0;
      background_opacity = "0.98"; # Un toque sutil de transparencia
      confirm_os_window_close = 0;

      # Cursor
      cursor_shape = "block";
      shell_integration = "no-cursor";

      # --- PALETA MONOCROMÁTICA ---
      foreground = "#c1c1c1";
      background = "#000000";
      selection_foreground = "#000000";
      selection_background = "#ffffff";

      # Colores Negros/Grises
      color0 = "#000000";
      color8 = "#333333";

      # Colores Rojos -> Grises
      color1 = "#444444";
      color9 = "#555555";

      # Colores Verdes -> Grises
      color2 = "#888888";
      color10 = "#999999";

      # Colores Amarillos -> Grises
      color3 = "#b0b0b0";
      color11 = "#c0c0c0";

      # Colores Azules -> Grises
      color4 = "#666666";
      color12 = "#888888";

      # Colores Magentas -> Grises
      color5 = "#aaaaaa";
      color13 = "#cccccc";

      # Colores Cyan -> Grises
      color6 = "#dcdcdc";
      color14 = "#eeeeee";

      # Colores Blancos
      color7 = "#c1c1c1";
      color15 = "#ffffff";

                };
  };
}
