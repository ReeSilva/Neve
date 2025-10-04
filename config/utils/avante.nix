{
  lib,
  config,
  pkgs,
  mcphub-nvim,
  mcp-hub,
  ...
}:
{
  options = {
    avante.enable = lib.mkEnableOption "Enable avante.nvim";
  };
  config =
    let
      cfg = config.avante;
    in
    lib.mkIf cfg.enable {
      extraPlugins = [ mcphub-nvim.packages.${pkgs.system}.default ];
      extraConfigLua = ''
        require("mcphub").setup({
          port = 3000,
          config = vim.fn.expand("~/.config/mcphub/servers.json"),
          cmd = "${mcp-hub.packages.${pkgs.system}.default}/bin/mcp-hub",
          extensions = {
            avante = {
              make_slash_commands = true,
            }
          }
        })
      '';
      plugins = {
        img-clip = {
          enable = true;
          settings = {
            default = {
              embed_image_as_base64 = false;
              prompt_for_file_name = false;
              drag_and_drop = {
                insert_mode = true;
              };
            };
            filetypes.markdown.download_images = true;
          };
        };
        render-markdown = {
          enable = true;
          settings = {
            file_types = [
              "markdown"
              "Avante"
            ];
          };
        };
        avante = {
          enable = true;
          settings = {
            provider = if pkgs.stdenv.isDarwin then "gemini-cli" else "claude-code";
            behaviour = {
              enable_cursor_planning_mode = true;
              enable_fastapply = true;
            };
            input = {
              provider = "snacks";
              provider_opts = {
                title = "Avante Input";
                icon = "󱚞";
                border = "rounded";
              };
            };
            providers = {
              claude = lib.mkIf pkgs.stdenv.isLinux {
                endpoint = "https://api.anthropic.com";
                model = "claude-sonnet-4-20250514";
                timeout = 30000; # Timeout in milliseconds
                context_window = 200000;
                extra_request_body = {
                  temperature = 0.75;
                  max_tokens = 64000;
                };
              };
              copilot = {
                model = "claude-sonnet-4.5";
              };
              morph = {
                model = "morph-v3-large";
              };
              perplexity = {
                __inherited_from = "openai";
                api_key_name = "PERPLEXITY_API_KEY";
                endpoint = "https://api.perplexity.ai";
                model = "sonar-reasoning-pro";
              };
            };
            acp_providers =
              if pkgs.stdenv.isDarwin then
                {
                  gemini-cli = {
                    command = "gemini";
                    args = [ "--experimental-acp" ];
                    env = {
                      NODE_NO_WARNINGS = "1";
                      GEMINI_API_KEY = lib.nixvim.utils.mkRaw "os.getenv 'GEMINI_API_KEY'";
                    };
                  };
                }
              else
                {
                  claude-code = {
                    command = "npx";
                    args = [ "@zed-industries/claude-code-acp" ];
                    env = {
                      NODE_NO_WARNINGS = "1";
                      ANTHROPIC_API_KEY = lib.nixvim.utils.mkRaw "os.getenv 'ANTHROPIC_API_KEY'";
                      ACP_PERMISSION_MODE = "bypassPermissions";
                      ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = lib.nixvim.utils.mkRaw "vim.fn.exepath('claude')";
                    };
                  };
                };
            web_search_engine = {
              provider = "brave";
            };
            windows = {
              width = 35;
              input.border = "rounded";
              edit = {
                border = "rounded";
                start_insert = true;
              };
              ask = {
                border = "rounded";
              };
            };
            system_prompt = lib.nixvim.utils.mkRaw ''
              function()
                local hub = require("mcphub").get_hub_instance()
                return hub and hub:get_active_servers_prompt() or ""
              end
            '';
            custom_tools = lib.nixvim.utils.mkRaw ''
              function()
                local mcphub_avante = require("mcphub.extensions.avante")
                return mcphub_avante.mcp_tool()
              end
            '';
            disabled_tools = [
              "list_files" # Built-in file operations
              "search_files"
              "read_file"
              "create_file"
              "rename_file"
              "delete_file"
              "create_dir"
              "rename_dir"
              "delete_dir"
              "bash" # Built-in terminal access
            ];
          };
        };
      };
    };
}
