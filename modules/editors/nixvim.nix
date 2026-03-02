{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # ==========================================================
    # 1. General Settings & UI
    # ==========================================================
    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      clipboard = "unnamedplus";
      splitright = true;
      splitbelow = true;
    };

    # Colorscheme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };

    # ==========================================================
    # 2. Core Plugins
    # ==========================================================
    plugins = {
      # web-devicons for telescope and other plugins
      web-devicons.enable = true;

      # File Explorer
      snacks = {
        enable = true;
        settings = {
          explorer = {
            enabled = true;
          };
          picker = {
            enabled = true;
          };
        };
      };

      # Copilot (Inline suggestions)
      copilot-lua = {
        enable = true;
        settings = {
          suggestion = {
            enabled = true;
            auto_trigger = true;
            keymap = {
              accept = "<Tab>";
            };
          };
          panel.enabled = false;
        };
      };

      # Navigation & UI
      telescope.enable = true;
      harpoon.enable = true;

      # Git Integration
      gitsigns.enable = true;
      fugitive.enable = true;

      # Mini Plugins (Pairs)
      mini = {
        enable = true;
        modules.pairs = { };
      };

      # Treesitter & Comments
      treesitter = {
        enable = true;
        settings.highlight.enable = true;
        settings.indent.enable = true;
      };
      ts-autotag.enable = true;
      ts-context-commentstring.enable = true; # Context-aware commenting
    };

    # ==========================================================
    # 3. LSP (Language Server Protocol)
    # ==========================================================
    plugins.lsp = {
      enable = true;
      servers = {
        pyright.enable = true; # Python
        jdtls.enable = true; # Java
        ts_ls.enable = true; # JS/TS/TSX (formerly tsserver)
        nil_ls.enable = true; # Nix
        marksman.enable = true; # Markdown
        texlab.enable = true; # LaTeX
        html.enable = true; # HTML
        cssls.enable = true; # CSS
        jsonls.enable = true; # JSON
        yamlls.enable = true; # YAML
        bashls.enable = true; # Bash/Shell
        clangd.enable = true; # C
        taplo.enable = true; # TOML
      };
    };

    # ==========================================================
    # 4. Formatters & Linters
    # ==========================================================
    # Conform for formatting
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = 500;
        };
        formatters_by_ft = {
          python = [ "black" ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          nix = [ "nixfmt" ];
          markdown = [ "prettier" ];
          html = [ "prettier" ];
          css = [ "prettier" ];
          json = [ "prettier" ];
          yaml = [ "prettier" ];
          sh = [ "shfmt" ];
          c = [ "clang-format" ];
          toml = [ "taplo" ];
        };
      };
    };

    # Nvim-lint for asynchronous linting
    plugins.lint = {
      enable = true;
      lintersByFt = {
        python = [ "flake8" ];
        javascript = [ "eslint_d" ];
        typescript = [ "eslint_d" ];
      };
    };

    # Ensure formatter/linter binaries are installed in the environment
    extraPackages = with pkgs; [
      black
      prettierd
      nixfmt-rfc-style
      shfmt
      clang-tools
      python3Packages.flake8
      nodePackages.eslint_d
      wl-clipboard
    ];

    # ==========================================================
    # 5. Keymaps
    # ==========================================================
    keymaps = [
      # Clear search highlight after ESC
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear search highlight";
      }

      # Snacks Explorer
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>lua Snacks.explorer()<CR>";
        options.desc = "Open Snacks Explorer";
      }

      # Telescope
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key = "<leader>sg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Live Grep";
      }
      {
        mode = "n";
        key = "<leader>sb";
        action = "<cmd>Telescope buffers<CR>";
        options.desc = "Search Buffers";
      }

      # Harpoon
      {
        mode = "n";
        key = "<leader>ha";
        action = "<cmd>lua require('harpoon.mark').add_file()<CR>";
        options.desc = "Harpoon Add File";
      }
      {
        mode = "n";
        key = "<leader>hm";
        action = "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>";
        options.desc = "Harpoon Menu";
      }

      # Git
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>Git<CR>";
        options.desc = "Git Status";
      }

      # --- Window Splitting ---
      {
        mode = "n";
        key = "<leader>|";
        action = "<cmd>vsplit<CR>";
        options.desc = "Split window right";
      }
      {
        mode = "n";
        key = "<leader>-";
        action = "<cmd>split<CR>";
        options.desc = "Split window below";
      }

      # --- Window Navigation ---
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Go to left window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Go to lower window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Go to upper window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Go to right window";
      }
    ];
  };
}
