{ lib, config, ... }: {
  options = { blink.enable = lib.mkEnableOption "Enable blink.nvim"; };
  config = lib.mkIf config.blink.enable {
    plugins = {
      blink-cmp = {
        enable = true;
        settings = {
          completion = {
            ghost_text.enabled = true;
            menu.draw.components.kind_icon = {
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
          signature.enabled = true;
          snippets.preset = "luasnip";
          sources = {
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
            ];
            copilot = {
              async = true;
              module = "blink-cmp-copilot";
              name = "copilot";
              score_offset = 100;
            };
            git = {

            };
            providers = {
              avante_commands = {
                name = "avante_commands";
                module = "blink.compat.source";
                score_offset = 90; # # show at a higher priority than lsp
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
                score_offset = 1000; # # show at a higher priority than lsp
                opts = { };
              };
              git = {
                module = "blink-cmp-git";
                name = "git";
                score_offset = 100;
                opts = {
                  commit = { };
                  git_centers.git_hub = { };
                };
              };
              ripgrep = {
                async = true;
                module = "blink-ripgrep";
                name = "Ripgrep";
                score_offset = 100;
                opts = {
                  prefix_min_len = 3;
                  context_size = 5;
                  max_filesize = "1M";
                  project_root_marker = ".git";
                  project_root_fallback = true;
                  search_casing = "--ignore-case";
                  additional_rg_options = { };
                  fallback_to_regex_highlighting = true;
                  ignore_paths = { };
                  additional_paths = { };
                  debug = false;
                };
              };
            };
          };
        };
      };
      blink-compat.enable = true;
    };
  };
}
