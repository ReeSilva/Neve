{ lib, config, ... }: {
  options = { cmp.enable = lib.mkEnableOption "Enable cmp module"; };
  config = lib.mkIf config.cmp.enable {
    plugins = {
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          experimental = { ghost_text = true; };
          mapping = {
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end, { "i", "s" })
            '';

            "<S-Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';

            "<C-e>" = "cmp.mapping.abort()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" =
              "cmp.mapping.confirm({ select = false })"; # Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            "<S-CR>" =
              "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })";
          };
          sources = [
            {
              name = "nvim_lsp";
              keyword_length = 3;
            }
            # { name = "parrot"; }
            {
              name = "luasnip";
              keyword_length = 3;
            }
            {
              name = "buffer";
              keyword_length = 3;
            }
            {
              name = "path";
              keyword_length = 3;
            }
            {
              name = "cmdline";
              keyword_length = 3;
            }
            {
              name = "copilot";
              keyword_length = 3;
            }
          ];

          # Enable pictogram icons for lsp/autocompletion
          formatting = {
            fields = [ "kind" "abbr" "menu" ];
            expandable_indicator = true;
          };
          performance = {
            debounce = 60;
            fetching_timeout = 200;
            max_view_entries = 30;
          };
          window = {
            completion = {
              border = "rounded";
              winhighlight =
                "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
            };
            documentation = { border = "rounded"; };
          };
        };
      };
    };
    extraConfigLua = ''
      luasnip = require("luasnip")
      kind_icons = {
        Text = "󰊄",
        Method = "",
        Function = "󰡱",
        Constructor = "",
        Field = "",
        Variable = "󱀍",
        Class = "",
        Interface = "",
        Module = "󰕳",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
        Codeium = "",
      }

      local cmp = require'cmp'

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({'/', "?" }, {
        sources = {
          {
            name = 'buffer',
            keyword_length = 5
          }
        }
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          {
            name = 'cmp_git',
            keyword_length = 5
          }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          {
            name = 'buffer',
            keyword_length = 5
          },
        })
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          {
            name = 'path',
            keyword_length = 5
          }
        }, {
          {
            name = 'cmdline',
            keyword_length = 5
          }
        }),
      })
    '';
  };
}
