# configuration.nix
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/nvidia.nix
  ];

  # --- BOOTLOADER ---
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "acpi_backlight=native" ];
    kernelModules = [ "acer_wmi" ];
    extraModprobeConfig = ''
      options acer_wmi force_series=1
    '';
  };

  # --- RED ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # --- ZONA HORARIA E IDIOMA ---
  time.timeZone = "America/Bogota";
  i18n.defaultLocale = "es_CO.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT    = "es_CO.UTF-8";
    LC_MONETARY       = "es_CO.UTF-8";
    LC_NAME           = "es_CO.UTF-8";
    LC_NUMERIC        = "es_CO.UTF-8";
    LC_PAPER          = "es_CO.UTF-8";
    LC_TELEPHONE      = "es_CO.UTF-8";
    LC_TIME           = "es_CO.UTF-8";
  };

  # --- DISPLAY / ESCRITORIO ---
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };
  console.keyMap = "es";

  # --- IMPRESIÓN ---
  services.printing.enable = true;

  # --- AUDIO ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- BLUETOOTH ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # --- USUARIO ---
  users.users."freilis" = {
    isNormalUser = true;
    description = "freilis";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # --- PROGRAMAS DEL SISTEMA ---
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.niri.enable = true;

  # --- SERVICIOS DE NOCTALIA ---
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # --- NIX ---
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # --- PAQUETES DEL SISTEMA ---
  # git y mpv se mantienen a nivel sistema para disponibilidad global
  # kitty se gestiona via home-manager en modules/niri.nix
  environment.systemPackages = with pkgs; [
    git
    mpv
  ];

  system.stateVersion = "26.05";
}
