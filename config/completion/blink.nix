{ lib, config, ... }: {
  options = { blink.enable = lib.mkEnableOption "Enable blink.nvim"; };
  config = lib.mkIf config.blink.enable {
    plugins = {
      colorful-menu.enable = true;
      blink-cmp = {
        enable = true;
        settings = {
          completion = {
            ghost_text = { enabled = true; };
            menu = {
              max_height = 7;
              draw = {
                treesitter = { __unkeyed-1 = "lsp"; };
                columns = [
                  { __unkeyed-1 = "kind_icon"; }
                  {
                    __unkeyed-1 = "label";
                    gap = 1;
                  }
                ];
                components = {
                  label = {
                    text = lib.nixvim.mkRaw ''
                      function(ctx)
                        return require('colorful-menu').blink_components_text(ctx)
                      end
                    '';
                    highlight = lib.nixvim.mkRaw ''
                      function(ctx)
                        return require('colorful-menu').blink_components_highlight(ctx)
                      end
                    '';
                  };
                  kind_icon = {
                    text = lib.nixvim.mkRaw ''
                      function(ctx)
                        local icon = ctx.kind_icon
                        if vim.tbl_contains({ "Path" }, ctx.source_name) then
                            local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                            if dev_icon then
                                icon = dev_icon
                            end
                        else
                            icon = require("lspkind").symbolic(ctx.kind, {
                                mode = "symbol",
                            })
                        end

                        return icon .. ctx.icon_gap
                      end
                    '';

                    ## Optionally, use the highlight groups from nvim-web-devicons
                    ## You can also add the same function for `kind.highlight` if you want to
                    ## keep the highlight groups in sync with the icons.
                    highlight = lib.nixvim.mkRaw ''
                      function(ctx)
                        local hl = ctx.kind_hl
                        if vim.tbl_contains({ "Path" }, ctx.source_name) then
                          local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                          if dev_icon then
                            hl = dev_hl
                          end
                        end
                        return hl
                      end
                    '';
                  };
                };
              };
            };
          };
          signature.enabled = true;
          snippets.preset = "luasnip";
          sources = {
            min_keyword_length = 3;
            default = [
              "lsp"
              "path"
              "copilot"
              "snippets"
              "buffer"
              "git"
              "ripgrep"
              "avante_commands"
              "avante_files"
              "avante_mentions"
              "avante_shortcuts"
            ];
            git = { };
            providers = {
              avante_commands = {
                name = "avante_commands";
                module = "blink.compat.source";
                score_offset = 100; # # show at a higher priority than lsp
                opts = { };
              };
              avante_files = {
                name = "avante_files";
                module = "blink.compat.source";
                score_offset = 100; # # show at a higher priority than lsp
                opts = { };
              };
              avante_mentions = {
                name = "avante_mentions";
                module = "blink.compat.source";
                score_offset = 100; # # show at a higher priority than lsp
                opts = { };
              };
              avante_shortcuts = {
                name = "avante_shortcuts";
                module = "blink.compat.source";
                score_offset = 100; # # show at a higher priority than lsp
                opts = { };
              };
              copilot = {
                async = true;
                module = "blink-cmp-copilot";
                name = "copilot";
                score_offset = 100;
              };
              git = {
                module = "blink-cmp-git";
                name = "git";
                score_offset = 200;
                opts = {
                  commit = { };
                  git_centers.git_hub = { };
                };
              };
              ripgrep = {
                async = true;
                module = "blink-ripgrep";
                name = "Ripgrep";
                score_offset = 500;
                opts = {
                  prefix_min_len = 8;
                  backend.ripgrep = {
                    context_size = 5;
                    max_filesize = "1M";
                    project_root_fallback = true;
                    search_casing = "--ignore-case";
                    additional_rg_options = { };
                    ignore_paths = { };
                    additional_paths = { };
                  };
                  project_root_marker = ".git";
                  fallback_to_regex_highlighting = true;
                  debug = false;
                };
              };
            };
          };
          keymap = { "<CR>" = [ "accept" "fallback" ]; };
        };
      };
      blink-compat.enable = true;
      blink-cmp-copilot.enable = true;
      blink-cmp-git.enable = true;
      blink-ripgrep.enable = true;
    };
  };
}
