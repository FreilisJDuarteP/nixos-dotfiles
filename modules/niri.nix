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

        // --- AYUDA ---
       Mod+F1 { spawn "noctalia-shell" "ipc" "call" "plugin" "togglePanel" "keybind-cheatsheet"; } 
        // --- APLICACIONES ---
        Mod+Return { spawn "kitty"; }
        Mod+T      { spawn "kitty"; }
        Mod+B      { spawn "firefox"; }
        Mod+E      { spawn "dolphin"; }

        // --- NOCTALIA IPC ---
        Mod+Space     { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Mod+A         { spawn "noctalia-shell" "ipc" "call" "controlCenter" "toggle"; }
        Mod+Backslash { spawn "noctalia-shell" "ipc" "call" "settings" "toggle"; }
        Mod+X         { spawn "noctalia-shell" "ipc" "call" "sessionMenu" "toggle"; }

        // --- SISTEMA ---
        Mod+Q             repeat=false { close-window; }
        Mod+Shift+E       repeat=false { quit; }
        Mod+Shift+P       { power-off-monitors; }
        Mod+Escape        allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
        Super+Alt+L       { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }

        // --- OVERVIEW ---
        Mod+Tab repeat=false { toggle-overview; }

        // --- FOCUS: NAVEGACIÓN ---
        Mod+H     { focus-column-left; }
        Mod+L     { focus-column-right; }
        Mod+K     { focus-window-up; }
        Mod+J     { focus-window-down; }
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up    { focus-window-up; }
        Mod+Down  { focus-window-down; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }

        // --- MOVER VENTANAS ---
        Mod+Ctrl+H     { move-column-left; }
        Mod+Ctrl+L     { move-column-right; }
        Mod+Ctrl+K     { move-window-up; }
        Mod+Ctrl+J     { move-window-down; }
        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+Down  { move-window-down; }

        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        // --- TAMAÑO DE COLUMNA / VENTANA ---
        Mod+R       { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R  { reset-window-height; }

        Mod+Minus       { set-column-width "-10%"; }
        Mod+Equal       { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // --- PANTALLA COMPLETA / MAXIMIZAR ---
        Mod+F      { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+M      { maximize-window-to-edges; }
        Mod+Ctrl+F { expand-column-to-available-width; }

        // --- CENTRAR ---
        Mod+C      { center-column; }
        Mod+Ctrl+C { center-visible-columns; }

        // --- FLOTANTE ---
        Mod+V       { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }

        // --- TABS EN COLUMNA ---
        Mod+W { toggle-column-tabbed-display; }

        // --- CONSUMIR / EXPULSAR VENTANAS DE COLUMNA ---
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        // --- WORKSPACES: FOCO ---
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        // --- WORKSPACES: MOVER COLUMNA ---
        Mod+Ctrl+1 { move-column-to-workspace 1; }
        Mod+Ctrl+2 { move-column-to-workspace 2; }
        Mod+Ctrl+3 { move-column-to-workspace 3; }
        Mod+Ctrl+4 { move-column-to-workspace 4; }
        Mod+Ctrl+5 { move-column-to-workspace 5; }
        Mod+Ctrl+6 { move-column-to-workspace 6; }
        Mod+Ctrl+7 { move-column-to-workspace 7; }
        Mod+Ctrl+8 { move-column-to-workspace 8; }
        Mod+Ctrl+9 { move-column-to-workspace 9; }

        // --- WORKSPACES: SCROLL ---
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up   { focus-workspace-up; }
        Mod+U { focus-workspace-down; }
        Mod+I { focus-workspace-up; }

        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
        Mod+Ctrl+U { move-column-to-workspace-down; }
        Mod+Ctrl+I { move-column-to-workspace-up; }

        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }

        // --- SCROLL CON RUEDA ---
        Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp   cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }
        Mod+WheelScrollRight { focus-column-right; }
        Mod+WheelScrollLeft  { focus-column-left; }

        // --- MULTI-MONITOR ---
        Mod+Shift+H { focus-monitor-left; }
        Mod+Shift+J { focus-monitor-down; }
        Mod+Shift+K { focus-monitor-up; }
        Mod+Shift+L { focus-monitor-right; }
        Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L { move-column-to-monitor-right; }

        // --- SCREENSHOTS ---
        Print      { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print  { screenshot-window; }

        // --- AUDIO (Noctalia IPC) ---
        XF86AudioRaiseVolume allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "increase"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "decrease"; }
        XF86AudioMute        allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput"; }
        XF86AudioMicMute     allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "muteInput"; }

        // --- MEDIA ---
        XF86AudioPlay allow-when-locked=true { spawn "playerctl" "play-pause"; }
        XF86AudioStop allow-when-locked=true { spawn "playerctl" "stop"; }
        XF86AudioPrev allow-when-locked=true { spawn "playerctl" "previous"; }
        XF86AudioNext allow-when-locked=true { spawn "playerctl" "next"; }

        // --- BRILLO (Noctalia IPC) ---
        XF86MonBrightnessUp   allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "brightness" "increase"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "brightness" "decrease"; }
    }
  '';
}

