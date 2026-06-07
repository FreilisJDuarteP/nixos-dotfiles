{ inputs, pkgs, ... }:

{
  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        options.clipboard = "unnamedplus";

        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
          transparent = false;
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        binds.whichKey.enable = true;
        
        # 1. RUTA CORRECTA PARA EL LSP (Sin warnings)
        lsp.enable = true;

        tabline.nvimBufferline.enable = true;

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

        keymaps = [
          {
            key = "<leader>e";
            mode = ["n"];
            action = ":NvimTreeToggle<CR>";
            desc = "Toggle File Tree";
          }
          {
            key = "<leader>wq";
            mode = ["n"];
            action = ":wq<CR>";
            desc = "Save and Quit Neovim";
          }
          {
            key = "<C-t>";
            mode = ["t"];
            action = "<C-\\><C-n>:ToggleTerm<CR>";
            desc = "Close Terminal";
          }
        ];

        languages = {
          enableTreesitter = true;
          enableFormat = true;

          nix.enable = true;

          java = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          bash = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };

          lua = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };

          # 2. NOMBRE CORRECTO DEL MÓDULO (Sin warnings)
          typescript = {
            enable = true; 
            lsp.enable = true;
            treesitter.enable = true;
            format.enable = true;
          };
        };
      };
    };
  };
}
