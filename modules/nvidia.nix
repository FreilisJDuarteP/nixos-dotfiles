# modules/nvidia.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # Habilitar soporte gráfico acelerado por hardware (OpenGL / Vulkan)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Necesario para compatibilidad (Steam, Wine, Discord)

    # Paquetes adicionales para aceleración de video por hardware (VA-API)
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
    ];
  };

  # Cargar el driver en el entorno gráfico
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modsetting es vital para Wayland (KDE Plasma 6 y Niri lo requieren)
    modesetting.enable = true;

    # Gestión de energía avanzada (Offload Dinámico)
    # Apaga la GPU por completo cuando no se usa para ahorrar batería
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    # Usar el driver estable propietario de producción
    open = false;

    # Panel de control de Nvidia
    nvidiaSettings = true;

    # Asegura la versión del driver sincronizada con tu kernel
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # --- CONFIGURACIÓN HÍBRIDA (PRIME) ---
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Crea el comando mágico 'nvidia-offload'
      };
      # Tus Bus IDs verificados
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
