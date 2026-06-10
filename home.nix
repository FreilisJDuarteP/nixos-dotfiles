# /etc/nixos/home.nix
# ============================================================
# CONFIGURACIÓN DE USUARIO - Home Manager
# ============================================================
{
  config,
  pkgs,
  inputs,
  ...
}: {
  # ============================================================
  # MÓDULOS IMPORTADOS
  # ============================================================
  imports = [
    ./modules/shell.nix # Zsh, Starship, Eza
    ./modules/kitty.nix # Terminal Kitty
    ./modules/neovim.nix # Editor NVF
    ./modules/niri.nix # Window Manager Niri
  ];

  # ============================================================
  # INFORMACIÓN DEL USUARIO
  # ============================================================
  home.username = "freilis";
  home.homeDirectory = "/home/freilis";
  home.stateVersion = "26.05";

  # ============================================================
  # VARIABLES DE ENTORNO
  # ============================================================
  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk}";

    # ⭐ CURSOR - Bibata Modern Ice (funciona perfecto en Wayland/Niri)
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";

    # ⭐ VARIABLES PARA WAYLAND
    # Fuerzan a las aplicaciones a usar Wayland nativo cuando sea posible
    GDK_BACKEND = "wayland,x11"; # GTK apps
    QT_QPA_PLATFORM = "wayland;xcb"; # Qt apps
    SDL_VIDEODRIVER = "wayland"; # Juegos/SDL
    MOZ_ENABLE_WAYLAND = "1"; # Firefox
  };

  # ============================================================
  # CARPETAS XDG (Documentos, Descargas, etc)
  # ============================================================
  # Crea automáticamente las carpetas estándar del usuario
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "${config.home.homeDirectory}/Escritorio";
    documents = "${config.home.homeDirectory}/Documentos";
    download = "${config.home.homeDirectory}/Descargas";
    music = "${config.home.homeDirectory}/Música";
    pictures = "${config.home.homeDirectory}/Imágenes";
    videos = "${config.home.homeDirectory}/Videos";
    publicShare = "${config.home.homeDirectory}/Compartido";
    templates = "${config.home.homeDirectory}/Plantillas";

    extraConfig = {
      XDG_PROJECTS_DIR = "${config.home.homeDirectory}/Proyectos";
    };
  };

  # ============================================================
  # TEMA GLOBAL
  # ============================================================
  gtk = {
    enable = true;

    # ─────────────────────────────────────────────────────────
    # 🎨 TEMA GTK - CATPPUCCIN MOCHA (Coherente con Noctalia)
    # ─────────────────────────────────────────────────────────
    theme = {
      name = "catppuccin-mocha-blue-standard+normal";
      package = pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        variant = "mocha";
        size = "standard";
        tweaks = ["normal"];
      };
    };

    # ─────────────────────────────────────────────────────────
    # 📁 ICONOS - PAPIRUS DARK (Excelente con Catppuccin)
    # ─────────────────────────────────────────────────────────
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    # ─────────────────────────────────────────────────────────
    # 🖱️ CURSOR - BIBATA MODERN ICE (Recomendado para Wayland)
    # ─────────────────────────────────────────────────────────
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    # ─────────────────────────────────────────────────────────
    # 🌙 FORZAR TEMA OSCURO en apps GTK3 y GTK4
    # ─────────────────────────────────────────────────────────
    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  # ============================================================
  # NOCTALIA - Shell para Niri
  # ============================================================
  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      wallpaper = {
        enabled = true;
        default.path = "/home/freilis/Imágenes/wallpaper.png";
      };
    };
  };

  # ============================================================
  # PAQUETES DEL USUARIO (por categoría)
  # ============================================================
  home.packages = with pkgs; [
    # ─────────────────────────────────────────────────────────
    # 🔧 UTILIDADES DEL SISTEMA
    # ─────────────────────────────────────────────────────────
    fastfetch # Info del sistema al abrir terminal
    nerd-fonts.jetbrains-mono # Fuente para terminal
    wl-clipboard # Portapapeles para Wayland
    ripgrep # Buscador rápido (reemplazo de grep)
    fd # Buscador de archivos (reemplazo de find)
    jq # Procesador de JSON en terminal
    unzip # Descompresor ZIP
    zip # Compresor ZIP
    unrar # Descompresor RAR

    # ─────────────────────────────────────────────────────────
    # 📁 GESTOR DE ARCHIVOS
    # ─────────────────────────────────────────────────────────
    thunar # Gestor de archivos principal
    thunar-archive-plugin # Integración con archivos comprimidos
    thunar-volman # Montaje automático de USBs
    ffmpegthumbnailer # Miniaturas de videos en Thunar
    file-roller # Gestor gráfico de archivos comprimidos
    tumbler # Servicio de miniaturas para Thunar

    # ─────────────────────────────────────────────────────────
    # 💻 DESARROLLO - JAVA / MAVEN
    # ─────────────────────────────────────────────────────────
    jdk # Java Development Kit
    maven # Gestor de builds Java
    netbeans # IDE para Java

    # ─────────────────────────────────────────────────────────
    # 💻 DESARROLLO - WEB / JAVASCRIPT
    # ─────────────────────────────────────────────────────────
    nodejs # Runtime de JavaScript
    yarn # Gestor de paquetes alternativo a npm

    # ─────────────────────────────────────────────────────────
    # 💻 DESARROLLO - IDE
    # ─────────────────────────────────────────────────────────
    jetbrains.idea # IntelliJ IDEA

    # ─────────────────────────────────────────────────────────
    # 🎵 MULTIMEDIA Y CREACIÓN
    # ─────────────────────────────────────────────────────────
    bitwig-studio # DAW para producción musical
    vlc # Reproductor multimedia adicional
    ffmpeg # Conversor/procesador de video/audio

    # ─────────────────────────────────────────────────────────
    # 🎮 JUEGOS / PERSONAL
    # ─────────────────────────────────────────────────────────
    ankama-launcher # Launcher de juegos Ankama (Dofus, Wakfu)

    # ─────────────────────────────────────────────────────────
    # 🌐 NAVEGACIÓN / COMUNICACIÓN
    # ─────────────────────────────────────────────────────────
    # Firefox ya está en configuration.nix (nivel sistema)
    # discord             # Comunicación (descomentar si lo usas)
    # telegram-desktop    # Mensajería (descomentar si lo usas)
  ];

  # ============================================================
  # HERRAMIENTAS DE DESARROLLO
  # ============================================================

  # Home Manager
  programs.home-manager.enable = true;

  # Direnv - Cargar variables de entorno automáticamente por proyecto
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ============================================================
  # GIT - Control de versiones con autenticación completa
  # ============================================================
  programs.git = {
    enable = true;

    # Información del usuario
    userName = "freilisjduartep";
    userEmail = "freilisjduartep@gmail.com";

    # ⭐ CREDENTIAL HELPER - Guarda credenciales de forma segura
    # Usa libsecret (GNOME Keyring) para almacenar credenciales
    extraConfig = {
      credential = {
        helper = "libsecret";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true; # Usar rebase en lugar de merge al hacer pull
      };
      push = {
        autoSetupRemote = true; # Configurar remote automáticamente al hacer push
      };
      core = {
        editor = "nvim"; # Editor por defecto para commits
        autocrlf = "input"; # Manejo de saltos de línea
      };
      safe = {
        directory = "/etc/nixos"; # Marcar /etc/nixos como seguro
      };
    };

    # ⭐ ALIAS ÚTILES
    aliases = {
      st = "status";
      br = "branch";
      co = "checkout";
      ci = "commit";
      lg = "log --oneline --graph --decorate";
      last = "log -1 HEAD";
      unstage = "reset HEAD --";
    };

    # ⭐ IGNORES GLOBALES
    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
      "result"
    ];
  };

  # ============================================================
  # SSH - Configuración de claves SSH para GitHub
  # ============================================================
  programs.ssh = {
    enable = true;

    # Configuración específica para GitHub
    # ⚠️ NOTA: "UseKeychain" es solo para macOS, NO funciona en Linux
    extraConfig = ''
      Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519
        AddKeysToAgent yes
    '';
  };

  # ============================================================
  # GNUPG - Para firmar commits (opcional pero recomendado)
  # ============================================================
  programs.gpg = {
    enable = true;
    settings = {
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      fixed-list-mode = "";
      no-comments = "";
      no-emit-version = "";
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = "";
      require-cross-certification = "";
      no-greeting = "";
      armor = "";
    };
  };
}
