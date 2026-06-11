# /etc/nixos/configuration.nix
# ============================================================
# CONFIGURACIÓN DEL SISTEMA - NixOS + Niri + Noctalia
# ============================================================
{
  config,
  pkgs,
  lib,
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
  services.xserver.enable = true;
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      hide_borders = false;
      blank_box = false;
    };
  };

  # ============================================================
  # SESIONES DISPONIBLES
  # ============================================================
  programs.niri.enable = true;

  # ============================================================
  # SERVICIOS ESENCIALES PARA WAYLAND PURO
  # ============================================================
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Portales XDG
  # lib.mkForce necesario porque programs.niri.enable ya define
  # config.niri.default = "gnome;gtk" y entra en conflicto
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.niri.default = lib.mkForce ["gtk"];
    config.common.default = ["gtk"];
  };

  services.gnome.gnome-keyring.enable = true;
  services.printing.enable = true;

  # ============================================================
  # NIX-LD - Compatibilidad con ejecutables Linux genéricos
  # ============================================================
  # Necesario para Zed, Dofus y otros binarios no empaquetados
  # para NixOS. Después de activar por primera vez: cerrar sesión
  # y volver a entrar para propagar las variables de entorno.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      libGL
      SDL2
      openssl
      curl
      libpulseaudio
      alsa-lib
      udev
      dbus
      vulkan-loader
      wayland
      libxkbcommon
      fontconfig
      freetype
      libx11
      libxcursor
      libxrandr
      libxi
    ];
  };

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
    git
    vim
    pciutils
    htop
    mpv
    bibata-cursors
  ];

  # ============================================================
  # CONFIGURACIÓN DE NIX
  # ============================================================
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = ["https://cache.nixos.org/"];
  };

  # ============================================================
  # VERSIÓN DEL ESTADO DEL SISTEMA
  # ============================================================
  system.stateVersion = "26.05"; # ⚠️ NO cambiar este valor
}
