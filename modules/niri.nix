# modules/niri.nix
{ config, pkgs, inputs, ... }:

{
  home.packages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.brightnessctl
    pkgs.imagemagick
    pkgs.pavucontrol
    pkgs.xwayland-satellite
    pkgs.grim
    pkgs.slurp
    pkgs.playerctl
  ];

  home.file.".config/niri/config.kdl".text = ''
    // ================================================================
    // INPUT
    // ================================================================
    input {
        keyboard {
            xkb {
                layout "es"
            }
            numlock
            repeat-delay 300
            repeat-rate 50
        }
        touchpad {
            tap
            natural-scroll
            accel-speed 0.2
        }
        mouse {
            accel-speed 0.0
        }
        focus-follows-mouse max-scroll-amount="0%"
    }

    // ================================================================
    // OUTPUT
    // ================================================================
    output "eDP-1" {
        scale 1.0
    }

    // ================================================================
    // LAYOUT
    // ================================================================
    layout {
        gaps 8
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 1.0
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 2
            active-color "#c0c0c0"
            inactive-color "#3a3a3a"
        }

        border {
            off
        }

        shadow {
            on
            softness 20
            spread 2
            offset x=0 y=3
            color "#00000066"
        }
    }

    // ================================================================
    // PREFER-NO-CSD
    // ================================================================
    prefer-no-csd

    // ================================================================
    // SCREENSHOTS
    // ================================================================
    screenshot-path "~/Imágenes/Capturas/Screenshot %Y-%m-%d %H-%M-%S.png"

    // ================================================================
    // ANIMACIONES
    // ================================================================
    animations {
    }

    // ================================================================
    // HOTKEY OVERLAY
    // ================================================================
    hotkey-overlay {
        skip-at-startup
    }

    // ================================================================
    // REGLAS DE VENTANA
    // ================================================================
    window-rule {
        geometry-corner-radius 10
        clip-to-geometry true
        draw-border-with-background true
    }

    window-rule {
        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
        open-floating true
    }

    // ================================================================
    // DEBUG (requerido por Noctalia)
    // ================================================================
    debug {
        honor-xdg-activation-with-invalid-serial
    }

    // ================================================================
    // LAYER RULES
    // ================================================================
    layer-rule {
        match namespace="^noctalia-overview*"
        place-within-backdrop true
    }

    // ================================================================
    // ENVIRONMENT
    // ================================================================
    environment {
        DISPLAY ":0"
        XDG_CURRENT_DESKTOP "niri"
        XDG_SESSION_TYPE "wayland"
        XDG_SESSION_DESKTOP "niri"
        QT_QPA_PLATFORM "wayland"
        MOZ_ENABLE_WAYLAND "1"
    }

    // ================================================================
    // AUTOSTART
    // ================================================================
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "noctalia-shell"
    spawn-at-startup "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"

    // ================================================================
    // KEYBINDS
    // ================================================================
    binds {

        // #Ayuda
        Mod+F1 hotkey-overlay-title="Atajos de teclado" { spawn "noctalia-shell" "ipc" "call" "plugin" "togglePanel" "keybind-cheatsheet"; }

        // #Aplicaciones
        Mod+Return hotkey-overlay-title="Terminal (kitty)" { spawn "kitty"; }
        Mod+T      hotkey-overlay-title="Terminal (kitty)" { spawn "kitty"; }
        Mod+B      hotkey-overlay-title="Navegador (Firefox)" { spawn "firefox"; }
        Mod+E      hotkey-overlay-title="Archivos (Dolphin)" { spawn "dolphin"; }

        // #Noctalia
        Mod+Space     hotkey-overlay-title="Lanzador de apps" { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Mod+A         hotkey-overlay-title="Centro de control" { spawn "noctalia-shell" "ipc" "call" "controlCenter" "toggle"; }
        Mod+Backslash hotkey-overlay-title="Configuración" { spawn "noctalia-shell" "ipc" "call" "settings" "toggle"; }
        Mod+X         hotkey-overlay-title="Menú de sesión" { spawn "noctalia-shell" "ipc" "call" "sessionMenu" "toggle"; }

        // #Sistema
        Mod+Q             repeat=false hotkey-overlay-title="Cerrar ventana" { close-window; }
        Mod+Shift+E       repeat=false hotkey-overlay-title="Salir de niri" { quit; }
        Mod+Shift+P       hotkey-overlay-title="Apagar monitores" { power-off-monitors; }
        Mod+Escape        allow-inhibiting=false hotkey-overlay-title="Alternar inhibidor de atajos" { toggle-keyboard-shortcuts-inhibit; }
        Super+Alt+L       hotkey-overlay-title="Bloquear pantalla" { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }

        // #Navegación
        Mod+Tab   repeat=false hotkey-overlay-title="Vista general" { toggle-overview; }
        Mod+H     hotkey-overlay-title="Foco izquierda" { focus-column-left; }
        Mod+L     hotkey-overlay-title="Foco derecha" { focus-column-right; }
        Mod+K     hotkey-overlay-title="Foco arriba" { focus-window-up; }
        Mod+J     hotkey-overlay-title="Foco abajo" { focus-window-down; }
        Mod+Left  hotkey-overlay-title="Foco izquierda" { focus-column-left; }
        Mod+Right hotkey-overlay-title="Foco derecha" { focus-column-right; }
        Mod+Up    hotkey-overlay-title="Foco arriba" { focus-window-up; }
        Mod+Down  hotkey-overlay-title="Foco abajo" { focus-window-down; }
        Mod+Home  hotkey-overlay-title="Primera columna" { focus-column-first; }
        Mod+End   hotkey-overlay-title="Última columna" { focus-column-last; }

        // #Mover ventanas
        Mod+Ctrl+H     hotkey-overlay-title="Mover columna izquierda" { move-column-left; }
        Mod+Ctrl+L     hotkey-overlay-title="Mover columna derecha" { move-column-right; }
        Mod+Ctrl+K     hotkey-overlay-title="Mover ventana arriba" { move-window-up; }
        Mod+Ctrl+J     hotkey-overlay-title="Mover ventana abajo" { move-window-down; }
        Mod+Ctrl+Left  hotkey-overlay-title="Mover columna izquierda" { move-column-left; }
        Mod+Ctrl+Right hotkey-overlay-title="Mover columna derecha" { move-column-right; }
        Mod+Ctrl+Up    hotkey-overlay-title="Mover ventana arriba" { move-window-up; }
        Mod+Ctrl+Down  hotkey-overlay-title="Mover ventana abajo" { move-window-down; }
        Mod+Ctrl+Home  hotkey-overlay-title="Mover a primera columna" { move-column-to-first; }
        Mod+Ctrl+End   hotkey-overlay-title="Mover a última columna" { move-column-to-last; }

        // #Tamaño
        Mod+R           hotkey-overlay-title="Ciclar anchos preset" { switch-preset-column-width; }
        Mod+Shift+R     hotkey-overlay-title="Ciclar alturas preset" { switch-preset-window-height; }
        Mod+Ctrl+R      hotkey-overlay-title="Restablecer altura" { reset-window-height; }
        Mod+Minus       hotkey-overlay-title="Reducir ancho columna" { set-column-width "-10%"; }
        Mod+Equal       hotkey-overlay-title="Aumentar ancho columna" { set-column-width "+10%"; }
        Mod+Shift+Minus hotkey-overlay-title="Reducir altura ventana" { set-window-height "-10%"; }
        Mod+Shift+Equal hotkey-overlay-title="Aumentar altura ventana" { set-window-height "+10%"; }

        // #Pantalla completa
        Mod+F       hotkey-overlay-title="Maximizar columna" { maximize-column; }
        Mod+Shift+F hotkey-overlay-title="Pantalla completa" { fullscreen-window; }
        Mod+M       hotkey-overlay-title="Maximizar ventana" { maximize-window-to-edges; }
        Mod+Ctrl+F  hotkey-overlay-title="Expandir al espacio disponible" { expand-column-to-available-width; }
        Mod+C       hotkey-overlay-title="Centrar columna" { center-column; }
        Mod+Ctrl+C  hotkey-overlay-title="Centrar columnas visibles" { center-visible-columns; }

        // #Flotante y columnas
        Mod+V            hotkey-overlay-title="Alternar flotante" { toggle-window-floating; }
        Mod+Shift+V      hotkey-overlay-title="Cambiar foco flotante/tiling" { switch-focus-between-floating-and-tiling; }
        Mod+W            hotkey-overlay-title="Alternar vista en pestañas" { toggle-column-tabbed-display; }
        Mod+BracketLeft  hotkey-overlay-title="Consumir/expulsar izquierda" { consume-or-expel-window-left; }
        Mod+BracketRight hotkey-overlay-title="Consumir/expulsar derecha" { consume-or-expel-window-right; }
        Mod+Comma        hotkey-overlay-title="Consumir ventana en columna" { consume-window-into-column; }
        Mod+Period       hotkey-overlay-title="Expulsar ventana de columna" { expel-window-from-column; }

        // #Espacios de trabajo
        Mod+1 hotkey-overlay-title="Espacio 1" { focus-workspace 1; }
        Mod+2 hotkey-overlay-title="Espacio 2" { focus-workspace 2; }
        Mod+3 hotkey-overlay-title="Espacio 3" { focus-workspace 3; }
        Mod+4 hotkey-overlay-title="Espacio 4" { focus-workspace 4; }
        Mod+5 hotkey-overlay-title="Espacio 5" { focus-workspace 5; }
        Mod+6 hotkey-overlay-title="Espacio 6" { focus-workspace 6; }
        Mod+7 hotkey-overlay-title="Espacio 7" { focus-workspace 7; }
        Mod+8 hotkey-overlay-title="Espacio 8" { focus-workspace 8; }
        Mod+9 hotkey-overlay-title="Espacio 9" { focus-workspace 9; }
        Mod+Ctrl+1 hotkey-overlay-title="Mover al espacio 1" { move-column-to-workspace 1; }
        Mod+Ctrl+2 hotkey-overlay-title="Mover al espacio 2" { move-column-to-workspace 2; }
        Mod+Ctrl+3 hotkey-overlay-title="Mover al espacio 3" { move-column-to-workspace 3; }
        Mod+Ctrl+4 hotkey-overlay-title="Mover al espacio 4" { move-column-to-workspace 4; }
        Mod+Ctrl+5 hotkey-overlay-title="Mover al espacio 5" { move-column-to-workspace 5; }
        Mod+Ctrl+6 hotkey-overlay-title="Mover al espacio 6" { move-column-to-workspace 6; }
        Mod+Ctrl+7 hotkey-overlay-title="Mover al espacio 7" { move-column-to-workspace 7; }
        Mod+Ctrl+8 hotkey-overlay-title="Mover al espacio 8" { move-column-to-workspace 8; }
        Mod+Ctrl+9 hotkey-overlay-title="Mover al espacio 9" { move-column-to-workspace 9; }
        Mod+Page_Down      hotkey-overlay-title="Espacio anterior" { focus-workspace-down; }
        Mod+Page_Up        hotkey-overlay-title="Espacio siguiente" { focus-workspace-up; }
        Mod+U              hotkey-overlay-title="Espacio anterior" { focus-workspace-down; }
        Mod+I              hotkey-overlay-title="Espacio siguiente" { focus-workspace-up; }
        Mod+Ctrl+Page_Down hotkey-overlay-title="Mover espacio anterior" { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   hotkey-overlay-title="Mover espacio siguiente" { move-column-to-workspace-up; }
        Mod+Ctrl+U         hotkey-overlay-title="Mover espacio anterior" { move-column-to-workspace-down; }
        Mod+Ctrl+I         hotkey-overlay-title="Mover espacio siguiente" { move-column-to-workspace-up; }
        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }

        // #Rueda del ratón
        Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }
        Mod+WheelScrollRight { focus-column-right; }
        Mod+WheelScrollLeft  { focus-column-left; }

        // #Multi-monitor
        Mod+Shift+H      hotkey-overlay-title="Foco monitor izquierda" { focus-monitor-left; }
        Mod+Shift+J      hotkey-overlay-title="Foco monitor abajo" { focus-monitor-down; }
        Mod+Shift+K      hotkey-overlay-title="Foco monitor arriba" { focus-monitor-up; }
        Mod+Shift+L      hotkey-overlay-title="Foco monitor derecha" { focus-monitor-right; }
        Mod+Shift+Ctrl+H hotkey-overlay-title="Mover a monitor izquierda" { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J hotkey-overlay-title="Mover a monitor abajo" { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K hotkey-overlay-title="Mover a monitor arriba" { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L hotkey-overlay-title="Mover a monitor derecha" { move-column-to-monitor-right; }

        // #Capturas
        Print      hotkey-overlay-title="Captura de área" { screenshot; }
        Ctrl+Print hotkey-overlay-title="Captura de pantalla" { screenshot-screen; }
        Alt+Print  hotkey-overlay-title="Captura de ventana" { screenshot-window; }

        // #Audio y brillo
        XF86AudioRaiseVolume  allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "increase"; }
        XF86AudioLowerVolume  allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "decrease"; }
        XF86AudioMute         allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput"; }
        XF86AudioMicMute      allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "muteInput"; }
        XF86AudioPlay         allow-when-locked=true { spawn "playerctl" "play-pause"; }
        XF86AudioStop         allow-when-locked=true { spawn "playerctl" "stop"; }
        XF86AudioPrev         allow-when-locked=true { spawn "playerctl" "previous"; }
        XF86AudioNext         allow-when-locked=true { spawn "playerctl" "next"; }
        XF86MonBrightnessUp   allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "brightness" "increase"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "brightness" "decrease"; }
    }
  '';
}
