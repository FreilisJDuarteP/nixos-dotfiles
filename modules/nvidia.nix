{ config, pkgs, lib, ... }:

{
  # Permitir el driver privativo de Nvidia
  nixpkgs.config.allowUnfree = true;

  # Habilitar soporte gráfico acelerado por hardware (OpenGL / Vulkan)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Necesario para compatibilidad (Steam/Wine)
  };

  # Cargar el driver en el entorno gráfico
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modsetting es vital para Wayland (KDE Plasma 6 lo usa por defecto)
    modesetting.enable = true;

    # Gestión de energía avanzada (Offload Dinámico)
    # Para arquitecturas modernas como tu RTX 2050, finegrained apaga la GPU por completo
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    # Usar el driver estable propietario de producción
    open = false;

    # Panel de control de Nvidia (Opcional)
    nvidiaSettings = true;

    # Asegura la versión del driver sincronizada con tu kernel 7.x
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # --- CONFIGURACIÓN HÍBRIDA (PRIME) ---
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Crea el comando mágico 'nvidia-offload'
      };

      # Tus Bus IDs verificados con lspci
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
