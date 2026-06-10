# /etc/nixos/configuration.nix
# ============================================================
# CONFIGURACIÓN DEL SISTEMA - NixOS + Niri + Noctalia
# ============================================================
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./modules/nvidia.nix
  ];

  # ============================================================
  # BOOTLOADER Y KERNEL
  # ============================================================
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;

    # Parámetros específicos para laptop Acer (brillo de pantalla)
    kernelParams = ["acpi_backlight=native"];
    kernelModules = ["acer_wmi"];
    extraModprobeConfig = ''
      options acer_wmi force_series=1
    '';
  };

  # ============================================================
  # RED
  # ============================================================
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # ============================================================
  # ZONA HORARIA E IDIOMA
  # ============================================================
  time.timeZone = "America/Bogota";

  i18n = {
    defaultLocale = "es_CO.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "es_CO.UTF-8";
      LC_IDENTIFICATION = "es_CO.UTF-8";
      LC_MEASUREMENT = "es_CO.UTF-8";
      LC_MONETARY = "es_CO.UTF-8";
      LC_NAME = "es_CO.UTF-8";
      LC_NUMERIC = "es_CO.UTF-8";
      LC_PAPER = "es_CO.UTF-8";
      LC_TELEPHONE = "es_CO.UTF-8";
      LC_TIME = "es_CO.UTF-8";
    };
  };

  # ============================================================
  # TECLADO
  # ============================================================
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };
  console.keyMap = "es";

  # ============================================================
  # DISPLAY MANAGER - LY (minimalista y rápido)
  # ============================================================
  # Ly es un display manager ligero en TUI que funciona perfecto
  # con sesiones Wayland sin los problemas de SDDM + NVIDIA
  services.xserver.enable = true; # Necesario para compatibilidad con Xwayland
  services.displayManager.ly = {
    enable = true;
    # Configuración para tema oscuro
    settings = {
      animation = "matrix"; # Animación al iniciar (matrix, none)
      hide_borders = false; # Mostrar bordes de las cajas
      blank_box = false;
    };
  };

  # ============================================================
  # SESIONES DISPONIBLES
  # ============================================================
  programs.niri.enable = true; # Niri como compositor Wayland

  # ============================================================
  # SERVICIOS ESENCIALES PARA WAYLAND PURO
  # ============================================================
  # Sin DE necesitamos habilitar manualmente servicios que
  # XFCE/KDE inician por nosotros

  # Audio (Pipewire - reemplaza PulseAudio)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true; # Para Steam/Wine
    };
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Gestión de energía (batería, perfiles)
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Montaje de USBs y gestión de discos (para Thunar)
  services.gvfs.enable = true; # Virtual filesystem para Trash, redes, etc
  services.udisks2.enable = true; # Montaje automático de dispositivos

  # Portales XDG (para que apps puedan abrir archivos, elegir tema, etc)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Keyring para guardar contraseñas (Firefox, Discord, etc)
  services.gnome.gnome-keyring.enable = true;

  # Impresión
  services.printing.enable = true;

  # ============================================================
  # USUARIO
  # ============================================================
  users.users."freilis" = {
    isNormalUser = true;
    description = "freilis";
    extraGroups = ["networkmanager" "wheel" "video" "audio"];
    shell = pkgs.zsh;
  };

  # ============================================================
  # PROGRAMAS DEL SISTEMA (a nivel global)
  # ============================================================
  programs = {
    firefox.enable = true;
    zsh.enable = true;
  };

  # ============================================================
  # PAQUETES DEL SISTEMA (disponibles para todos los usuarios)
  # ============================================================
  environment.systemPackages = with pkgs; [
    # --- Herramientas básicas del sistema ---
    git
    vim
    pciutils
    htop

    # --- Multimedia del sistema ---
    mpv # Reproductor de video ligero

    # --- Tema de cursor (necesario a nivel sistema para Niri) ---
    bibata-cursors # Cursor moderno que funciona perfecto en Wayland
  ];

  # ============================================================
  # CONFIGURACIÓN DE NIX
  # ============================================================
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    # Habilitar caché binario (acelera compilaciones)
    substituters = ["https://cache.nixos.org/"];
  };

  # ============================================================
  # VERSIÓN DEL ESTADO DEL SISTEMA
  # ============================================================
  system.stateVersion = "26.05"; # ⚠️ NO cambiar este valor
}
