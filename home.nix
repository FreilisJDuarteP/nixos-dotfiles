# /etc/nixos/home.nix
# ============================================================
# CONFIGURACIÓN DE USUARIO - Home Manager
# ============================================================
# 🎨 TEMA PRINCIPAL: GitHub Dark / Catppuccin Mocha
# 💻 Stack: CSS, HTML, JS, Node.js, React, Java + Spring Boot
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
    ./modules/shell.nix
    ./modules/kitty.nix
    ./modules/neovim.nix
    ./modules/niri.nix
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
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # ============================================================
  # CARPETAS XDG
  # ============================================================
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

    theme = {
      name = "catppuccin-mocha-blue-standard+normal";
      package = pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        variant = "mocha";
        size = "standard";
        tweaks = ["normal"];
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  # ============================================================
  # NOCTALIA
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
  # PAQUETES DEL USUARIO
  # ============================================================
  home.packages = with pkgs; [
    # ─────────────────────────────────────────────────────────
    # 🔧 UTILIDADES DEL SISTEMA
    # ─────────────────────────────────────────────────────────
    fastfetch
    nerd-fonts.jetbrains-mono
    wl-clipboard
    ripgrep
    fd
    jq
    unzip
    zip
    unrar

    # ─────────────────────────────────────────────────────────
    # 📁 GESTOR DE ARCHIVOS
    # ─────────────────────────────────────────────────────────
    thunar
    thunar-archive-plugin
    thunar-volman
    ffmpegthumbnailer
    file-roller
    tumbler

    # ─────────────────────────────────────────────────────────
    # 💻 DESARROLLO - JAVA / MAVEN / GRADLE
    # ─────────────────────────────────────────────────────────
    jdk
    maven
    gradle
    netbeans
    jdt-language-server
    lombok

    # ─────────────────────────────────────────────────────────
    # 💻 DESARROLLO - WEB / JAVASCRIPT / TYPESCRIPT / REACT
    # ─────────────────────────────────────────────────────────
    # ⭐ ACTUALIZADO: nodePackages eliminado en nixpkgs reciente
    nodejs
    yarn
    typescript
    typescript-language-server
    prettier
    eslint

    # ─────────────────────────────────────────────────────────
    # 💻 DESARROLLO - HTML / CSS
    # ─────────────────────────────────────────────────────────
    vscode-langservers-extracted
    stylelint

    # ─────────────────────────────────────────────────────────
    # 💻 DESARROLLO - IDE
    # ─────────────────────────────────────────────────────────
    jetbrains.idea

    # ─────────────────────────────────────────────────────────
    # 🎵 MULTIMEDIA Y CREACIÓN
    # ─────────────────────────────────────────────────────────
    bitwig-studio
    vlc
    ffmpeg

    # ─────────────────────────────────────────────────────────
    # 🎮 JUEGOS / PERSONAL
    # ─────────────────────────────────────────────────────────
    ankama-launcher
  ];

  # ============================================================
  # HERRAMIENTAS DE DESARROLLO
  # ============================================================
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ============================================================
  # GIT
  # ============================================================
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "freilisjduartep";
        email = "freilisjduartep@gmail.com";
      };
      credential.helper = "libsecret";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      safe.directory = "/etc/nixos";
      alias = {
        st = "status";
        br = "branch";
        co = "checkout";
        ci = "commit";
        lg = "log --oneline --graph --decorate";
        last = "log -1 HEAD";
        unstage = "reset HEAD --";
      };
    };

    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
      "result"
    ];
  };

  # ============================================================
  # SSH
  # ============================================================
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        Compression = "no";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
        ForwardAgent = "no";
        HashKnownHosts = "no";
        ServerAliveCountMax = 3;
        ServerAliveInterval = 0;
        UserKnownHostsFile = "~/.ssh/known_hosts";
      };

      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        AddKeysToAgent = "yes";
      };
    };
  };

  # ============================================================
  # GNUPG
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
