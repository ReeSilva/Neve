{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    blink.enable = lib.mkEnableOption "Enable blink.nvim";
  };
  config = lib.mkIf config.blink.enable {
    extraPlugins = with pkgs; [ vimPlugins.blink-cmp-conventional-commits ];
    plugins = {
      colorful-menu.enable = true;
      blink-cmp = {
        enable = true;
        settings = {
          completion = {
            accept.auto_brackets.enabled = true;
            documentation = {
              auto_show = false;
              auto_show_delay_ms = 200;
            };
            ghost_text = {
              enabled = true;
            };
            list.selection = {
              preselect = true;
              auto_insert = false;
            };
            menu = {
              auto_show = false;
              direction_priority = lib.nixvim.utils.mkRaw ''
                function()
                  local ctx = require('blink.cmp').get_context()
                  local item = require('blink.cmp').get_selected_item()
                  if ctx == nil or item == nil then return { 's', 'n' } end

                  local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
                  local is_multi_line = item_text:find('\n') ~= nil

                  -- after showing the menu upwards, we want to maintain that direction
                  -- until we re-open the menu, so store the context id in a global variable
                  if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
                    vim.g.blink_cmp_upwards_ctx_id = ctx.id
                    return { 'n', 's' }
                  end
                  return { 's', 'n' }
                end
              '';
              draw = {
                treesitter = {
                  __unkeyed-1 = "lsp";
                };
                columns = [
                  {
                    __unkeyed-1 = "label";
                    __unkeyed-2 = "label_description";
                    gap = 1;
                  }
                  {
                    __unkeyed-1 = "kind_icon";
                    __unkeyed-2 = "kind";
                  }
                  {
                    __unkeyed-1 = "source_name";
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
          signature = {
            enabled = true;
            window.show_documentation = false;
          };
          snippets.preset = "luasnip";
          sources = {
            min_keyword_length = 3;
            default = [
              "avante"
              "conventional_commits"
              "copilot"
              "emoji"
              "lsp"
              "buffer"
              "path"
              "snippets"
              "git"
              "ripgrep"
            ];
            per_filetype = {
              codecompanion = [ "codecompanion" ];
            };
            git = { };
            providers = {
              avante = {
                module = "blink-cmp-avante";
                name = "Avante";
                score_offset = 20;
              };
              buffer.max_items = 5;
              conventional_commits = {
                name = "Conventional Commits";
                module = "blink-cmp-conventional-commits";
                enabled = lib.nixvim.utils.mkRaw ''
                  function()
                    return vim.bo.filetype == "gitcommit"
                  end
                '';
                opts = { };
              };
              copilot = {
                async = true;
                module = "blink-cmp-copilot";
                name = "copilot";
                score_offset = 10;
              };
              emoji = {
                name = "Emoji";
                module = "blink-emoji";
                score_offset = 15;
                opts.insert = true;
              };
              git = {
                module = "blink-cmp-git";
                name = "git";
                opts = {
                  commit = { };
                  git_centers.git_hub = { };
                };
              };
              ripgrep = {
                async = true;
                module = "blink-ripgrep";
                name = "Ripgrep";
                score_offset = -100;
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
          keymap = {
            preset = "super-tab";
          };
        };
      };
      blink-cmp-avante.enable = true;
      blink-cmp-copilot.enable = true;
      blink-cmp-git.enable = true;
      blink-emoji.enable = true;
      blink-ripgrep.enable = true;
    };
  };
}
