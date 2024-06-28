{ pkgs, nixvim, ... }:
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
        };
      };

      plugins = {
        telescope = {
          enable = true;
          keymaps = {
            "<leader>pf" = {
              action = "find_files";
            };
            "<C-p>" = {
              action = "git_files";
            };
          };
        };

        gitsigns.enable = true;

        treesitter = {
          enable = true;
          nixvimInjections = true;
        };

        harpoon = {
          enable = true;
          keymaps = {
            addFile = "<leader>a";
            toggleQuickMenu = "<C-e>";

            navFile = {
              "1" = "<C-h>";
              "2" = "<C-t>";
              "3" = "<C-n>";
              "4" = "<C-h>";
            };
          };
        };

        fugitive.enable = true;

        lsp = {
          enable = true;
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
            java-language-server.enable = true;
            kotlin-language-server.enable = true;
            lua-ls = {
              enable = true;
              settings.diagnostics.globals = [ "vim" ];
            };
            # nixd.enable = true;
            phpactor.enable = true;
            omnisharp.enable = true;
            rust-analyzer = {
              enable = true;
              package = null;
              installCargo = false;
              installRustc = false;
            };
            tsserver.enable = true;
            typst-lsp.enable = true;
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

        presence-nvim = {
          enable = false;
          autoUpdate = true;
          neovimImageText = "NixVim";
          mainImage = "file";
          enableLineNumber = false;
          showTime = true;
        };

        nvim-tree = {
          enable = true;
          hijackCursor = true;
          sortBy = "name";
          syncRootWithCwd = true;

          view.width = 40;
          renderer.icons.gitPlacement = "signcolumn";

          filters.custom = [
            "^.git$"
          ];

          git.ignore = false;
        };

        packer = {
          enable = true;
          plugins = [
            "s1n7ax/nvim-terminal"
            "rhaiscript/vim-rhai"
          ];
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        feline-nvim
        nvim-web-devicons
        tabby-nvim
        plenary-nvim
      ];

      extraConfigLua = ''
        if vim.g.neovide then
          vim.g.neovide_refresh_rate = 144
          vim.g.neovide_cursor_animation_length = 0
        end

        require('gitsigns').setup()
        require('nvim-terminal').setup()
        require('tabby').setup({
          tabline = require("tabby.presets").active_tab_with_wins
        })
        require("feline").setup()

        vim.keymap.set('n', '<Leader>gs', vim.cmd.Git);

        vim.diagnostic.config({
          virtual_text = true
        })

        local function open_nvim_tree()
          require("nvim-tree.api").tree.open()
        end
        -- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

        local tele = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ps', function ()
            tele.grep_string({ search = vim.fn.input("Grep> ") })
            end, {})
      '';
    };
  };
}
