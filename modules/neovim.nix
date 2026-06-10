# /etc/nixos/modules/neovim.nix
# ============================================================
# CONFIGURACIÓN DE NEOVIM - NVF
# ============================================================
# 🎨 TEMA: GitHub Dark (el que te encanta)
# 💻 Stack: CSS, HTML, JS, Node.js, React, Java + Spring Boot
# ============================================================
{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        # ============================================================
        # OPCIONES BÁSICAS
        # ============================================================
        options = {
          clipboard = "unnamedplus";
          relativenumber = true;
          number = true;
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
          smartindent = true;
          ignorecase = true;
          smartcase = true;
          scrolloff = 8;
          wrap = false;
          shada = "!,'100,<50,s10,h";
        };

        # ============================================================
        # 🎨 TEMA - GITHUB DARK (el que te encanta)
        # ============================================================
        theme = {
          enable = true;
          name = "github";
          style = "dark_default"; # ⭐ GitHub Dark oficial
          transparent = false;
        };

        # ============================================================
        # INTERFAZ
        # ============================================================
        statusline.lualine = {
          enable = true;
          theme = "github_dark"; # Lualine con tema GitHub
        };

        tabline.nvimBufferline.enable = true;
        telescope.enable = true;
        binds.whichKey.enable = true;

        visuals = {
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          indent-blankline.enable = true;
          rainbow-delimiters.enable = true;
        };

        # ============================================================
        # AUTOCOMPLETADO
        # ============================================================
        autocomplete.nvim-cmp.enable = true;

        # ============================================================
        # LSP
        # ============================================================
        lsp = {
          enable = true;
          formatOnSave = true;
        };

        # ============================================================
        # GIT
        # ============================================================
        git = {
          enable = true;
          gitsigns = {
            enable = true;
            codeActions.enable = true;
          };
        };

        # ============================================================
        # UTILIDADES
        # ============================================================
        autopairs.nvim-autopairs.enable = true;
        comments.comment-nvim.enable = true;

        terminal.toggleterm = {
          enable = true;
          setupOpts = {
            open_mapping = "[[<C-t>]]";
            direction = "float";
            shade_terminals = true;
          };
        };

        filetree.nvimTree = {
          enable = true;
          openOnSetup = false;
        };

        utility = {
          undotree.enable = true;
          smart-splits.enable = true;
          surround.enable = true;
          snacks-nvim.enable = true;
          yanky-nvim = {
            enable = true;
            setupOpts.ring.storage = "shada";
          };
          direnv.enable = true;
        };

        # ============================================================
        # LENGUAJES
        # ============================================================
        languages = {
          enableTreesitter = true;
          enableFormat = true;

          # Nix (para tus configs)
          nix = {
            enable = true;
            lsp.enable = true;
            format.enable = true;
          };

          # Java + Spring Boot + Maven/Gradle + Lombok
          java = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          # JavaScript/TypeScript/React/Node.js
          typescript = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };

          # CSS
          css = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };

          # HTML
          html = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };

          # Bash
          bash = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };

          # Lua
          lua = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };

          # Markdown
          markdown = {
            enable = true;
            treesitter.enable = true;
          };
        };

        # ============================================================
        # KEYMAPS
        # ============================================================
        keymaps = [
          # --- ARCHIVO ---
          {
            key = "<leader>e";
            mode = ["n"];
            action = ":NvimTreeToggle<CR>";
            desc = "Toggle File Tree";
          }
          {
            key = "<leader>w";
            mode = ["n"];
            action = ":w<CR>";
            desc = "Guardar";
          }
          {
            key = "<leader>q";
            mode = ["n"];
            action = ":q<CR>";
            desc = "Salir";
          }
          {
            key = "<leader>wq";
            mode = ["n"];
            action = ":wq<CR>";
            desc = "Guardar y salir";
          }

          # --- BUFFERS ---
          {
            key = "<leader>bn";
            mode = ["n"];
            action = ":bnext<CR>";
            desc = "Buffer siguiente";
          }
          {
            key = "<leader>bp";
            mode = ["n"];
            action = ":bprevious<CR>";
            desc = "Buffer anterior";
          }
          {
            key = "<leader>bd";
            mode = ["n"];
            action = ":bdelete<CR>";
            desc = "Cerrar buffer";
          }

          # --- SPLITS ---
          {
            key = "<leader>sv";
            mode = ["n"];
            action = ":vsplit<CR>";
            desc = "Split vertical";
          }
          {
            key = "<leader>sh";
            mode = ["n"];
            action = ":split<CR>";
            desc = "Split horizontal";
          }
          {
            key = "<leader>sx";
            mode = ["n"];
            action = ":close<CR>";
            desc = "Cerrar split";
          }

          # --- TERMINAL ---
          {
            key = "<C-t>";
            mode = ["t"];
            action = "<C-\\><C-n>:ToggleTerm<CR>";
            desc = "Cerrar terminal";
          }

          # --- TELESCOPE ---
          {
            key = "<leader>ff";
            mode = ["n"];
            action = ":Telescope find_files<CR>";
            desc = "Buscar archivos";
          }
          {
            key = "<leader>fg";
            mode = ["n"];
            action = ":Telescope live_grep<CR>";
            desc = "Buscar texto";
          }
          {
            key = "<leader>fb";
            mode = ["n"];
            action = ":Telescope buffers<CR>";
            desc = "Buscar buffers";
          }
          {
            key = "<leader>fh";
            mode = ["n"];
            action = ":Telescope help_tags<CR>";
            desc = "Buscar ayuda";
          }
          {
            key = "<leader>fr";
            mode = ["n"];
            action = ":Telescope oldfiles<CR>";
            desc = "Archivos recientes";
          }
          {
            key = "<leader>gs";
            mode = ["n"];
            action = ":Telescope git_status<CR>";
            desc = "Git status";
          }
          {
            key = "<leader>gc";
            mode = ["n"];
            action = ":Telescope git_commits<CR>";
            desc = "Git commits";
          }

          # --- LSP ---
          {
            key = "gd";
            mode = ["n"];
            action = ":lua vim.lsp.buf.definition()<CR>";
            desc = "Ir a definición";
          }
          {
            key = "gr";
            mode = ["n"];
            action = ":lua vim.lsp.buf.references()<CR>";
            desc = "Ver referencias";
          }
          {
            key = "gi";
            mode = ["n"];
            action = ":lua vim.lsp.buf.implementation()<CR>";
            desc = "Ir a implementación";
          }
          {
            key = "K";
            mode = ["n"];
            action = ":lua vim.lsp.buf.hover()<CR>";
            desc = "Documentación";
          }
          {
            key = "<leader>ca";
            mode = ["n"];
            action = ":lua vim.lsp.buf.code_action()<CR>";
            desc = "Code actions";
          }
          {
            key = "<leader>rn";
            mode = ["n"];
            action = ":lua vim.lsp.buf.rename()<CR>";
            desc = "Renombrar símbolo";
          }
          {
            key = "<leader>f";
            mode = ["n"];
            action = ":lua vim.lsp.buf.format()<CR>";
            desc = "Formatear archivo";
          }

          # --- DIAGNÓSTICOS ---
          {
            key = "<leader>d";
            mode = ["n"];
            action = ":lua vim.diagnostic.open_float()<CR>";
            desc = "Ver diagnóstico";
          }
          {
            key = "[d";
            mode = ["n"];
            action = ":lua vim.diagnostic.goto_prev()<CR>";
            desc = "Diagnóstico anterior";
          }
          {
            key = "]d";
            mode = ["n"];
            action = ":lua vim.diagnostic.goto_next()<CR>";
            desc = "Diagnóstico siguiente";
          }
          {
            key = "<leader>dl";
            mode = ["n"];
            action = ":Telescope diagnostics<CR>";
            desc = "Lista diagnósticos";
          }

          # --- UNDOTREE ---
          {
            key = "<leader>u";
            mode = ["n"];
            action = ":UndotreeToggle<CR>";
            desc = "Toggle Undotree";
          }

          # --- YANKY ---
          {
            key = "p";
            mode = ["n" "x"];
            action = "<Plug>(YankyPutAfter)";
            desc = "Pegar después";
          }
          {
            key = "P";
            mode = ["n" "x"];
            action = "<Plug>(YankyPutBefore)";
            desc = "Pegar antes";
          }
          {
            key = "<C-p>";
            mode = ["n"];
            action = "<Plug>(YankyPreviousEntry)";
            desc = "Yank anterior";
          }
          {
            key = "<C-n>";
            mode = ["n"];
            action = "<Plug>(YankyNextEntry)";
            desc = "Yank siguiente";
          }
          {
            key = "<leader>fy";
            mode = ["n"];
            action = ":Telescope yank_history<CR>";
            desc = "Historial de yanks";
          }

          # --- BÚSQUEDA ---
          {
            key = "<leader>nh";
            mode = ["n"];
            action = ":nohl<CR>";
            desc = "Limpiar resaltado";
          }

          # --- MODO VISUAL ---
          {
            key = "J";
            mode = ["v"];
            action = ":m '>+1<CR>gv=gv";
            desc = "Mover selección abajo";
          }
          {
            key = "K";
            mode = ["v"];
            action = ":m '<-2<CR>gv=gv";
            desc = "Mover selección arriba";
          }
          {
            key = "<";
            mode = ["v"];
            action = "<gv";
            desc = "Indentar izquierda";
          }
          {
            key = ">";
            mode = ["v"];
            action = ">gv";
            desc = "Indentar derecha";
          }
        ];
      };
    };
  };
}
