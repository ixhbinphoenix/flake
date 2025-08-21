{ pkgs, ... }:
{
  imports = [];

  options = {};

  config = {
    # TODO: Make this a stand-alone nixvim module
    programs.nixvim = {
      enable = true;

      opts = {
        number = true;
        relativenumber = true;

        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        smartindent = true;

        wrap = true;

        swapfile = false;
        backup = false;
        undofile = true;

        hlsearch = false;
        incsearch  = true;

        termguicolors = true;

        hidden = true;
        encoding = "utf-8";
      };
      globals = {
        mapleader = " ";
        astro_typescript = "enable";
      };

      keymaps = [
      {action = ":w<cr>";key = "<C-s>";mode = "n";}
      {action = ":m >+1<CR>gv=gv";key = "J";mode = "v";}
      {action = ":m <-2<CR>gb=gb";key = "K";mode = "v";}
      {action = "mzJ`z";key = "J";mode = "n";}
      {action = "<C-d>zz";key = "<C-d>";mode = ["n" "v"];}
      {action = "<C-u>zz";key = "<C-u>";mode = ["n" "v"];}
      {action = "nzzzv";key = "n";mode = "n";}
      {action = "Nzzzv";key = "N";mode = "n";}
      {action = "\"+y";key = "<leader>y";}
      {action = "\"+y";key = "Y";mode = "n";}
      ];

      clipboard.register = "unnamedplus";
      clipboard.providers.wl-copy.enable = true;

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          transparent_background = true;
          flavour = "mocha";
          integrations = {
            cmp = true;
            gitsigns = true;
            nvimtree = true;
            treesitter = true;
          };
          color_overrides.mocha = {
            blue = "#cba6f7";
          };
        };
      };

      plugins = {
        telescope = {
          enable = true;
          keymaps = {
            "<leader>pf" = {
              action = "find_files";
            };
            "<leader>pr" = {
              action = "live_grep";
            };
            "<leader>pg" = {
              action = "git_files";
            };
            "<leader>bb" = {
              action = "buffers";
            };
          };
        };

        gitsigns.enable = true;

        treesitter = {
          enable = true;
          folding = false;
          nixvimInjections = true;
        };

        fugitive.enable = true;

        lsp = {
          enable = true;
          capabilities = "capabilities.semanticTokensProvider = nil";
          keymaps = {
            diagnostic = {
              "[d" = "goto_next";
              "]d" = "goto_prev";
            };
            lspBuf = {
              "gD" = "declaration";
              "gd" = "definition";
              "gi" = "implementation";
              "gr" = "references";
              "K" = "hover";
              "<leader>rn" = "rename";
              "<leader>rf" = "references";
              "<leader>ca" = "code_action";
            };
          };
          servers = {
            astro.enable = true;
            bashls.enable = true;
            cssls.enable = true;
            gleam.enable = true;
            gopls.enable = true;
            html.enable = true;
            hls = {
              enable = true;
              installGhc = false;
            };
            java_language_server.enable = true;
            kotlin_language_server.enable = true;
            lua_ls = {
              enable = true;
              settings.diagnostics.globals = [ "vim" ];
            };
            nixd.enable = true;
            phpactor.enable = true;
            #omnisharp.enable = true;
            rust_analyzer = {
              enable = true;
              package = null;
              installCargo = false;
              installRustc = false;
            };
            ts_ls.enable = true;
            zls.enable = true;
          };
        };

        cmp-nvim-lsp.enable = true;
        cmp-buffer.enable = true;
        cmp-path.enable = true;
        cmp-nvim-lua.enable = true;

        luasnip.enable = true;

        cmp_luasnip.enable = true;

        cmp = {
          enable = true;
          settings = {
            preselect = "cmp.PreselectMode.None";
            snippet.expand = ''
              function(args)
                require('luasnip').lsp_expand(args.body)
              end
            '';
            mapping = {
              "<C-p>" = "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})";
              "<C-n>" = "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";
              "<Up>" = "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})";
              "<Down>" = "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";
              "<Tab>" = "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";
              "<CR>" = ''cmp.mapping({
                i = function(fallback)
                if cmp.visible and cmp.get_active_entry() then
                    cmp.confirm({behavior = cmp.SelectBehavior.Replace, select = false})
                  else
                    fallback()
                  end
                end,
                s = cmp.mapping.confirm({select = true}),
                c = cmp.mapping.confirm({behavior = cmp.SelectBehavior.Replace, select = true}),
              })'';
              "<C-Space>" = "cmp.mapping.complete()";
            };
            sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
            ];
          };
        };

        web-devicons.enable = true;

        render-markdown = {
          enable = true;
          settings = {
            render_modes = [
              "n" "i" "t" "c"
            ];
          };
        };

        lualine = {
          enable = true;
        };

        rainbow-delimiters = {
          enable = true;
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        plenary-nvim
        (pkgs.vimUtils.buildVimPlugin {
          name = "nvim-terminal";
          src = pkgs.fetchFromGitHub {
            owner = "s1n7ax";
            repo = "nvim-terminal";
            rev = "e058de4b8029d7605b17275f30f83be8f8df5f62";
            hash = "sha256-+sP7BDPVc+XbWfCjRkWV/n3dHh6VYiunrCAhf3mImWQ=";
          };
        })
      ];

      extraConfigLua = ''
        if vim.g.neovide then
          vim.g.neovide_refresh_rate = 144
          vim.g.neovide_cursor_animation_length = 0
        end

        require('nvim-terminal').setup()
        vim.keymap.set('n', '<Leader>gs', vim.cmd.Git);

        vim.diagnostic.config({
          virtual_text = true
        })
      '';
    };
  };
}
