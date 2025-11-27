{
  lib,
  config,
  pkgs,
  mcphub-nvim,
  mcp-hub,
  inputs,
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
      extraPlugins = [ mcphub-nvim.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      extraConfigLua = ''
        require("mcphub").setup({
          port = 3000,
          config = vim.fn.expand("~/.config/mcphub/servers.json"),
          cmd = "${mcp-hub.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/mcp-hub",
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
            provider = "opencode";
            behaviour = {
              enable_cursor_planning_mode = true;
              enable_fastapply = true;
              auto_approve_tool_permissions = false;
              confirmation_ui_style = "popup";
              enable_token_counting = false;
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
                model = "claude-sonnet-4-5-20250929";
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
                model = "auto";
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
                  codex = {
                    command = lib.getExe inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.codex-acp;
                    env = {
                      OPENAI_API_KEY = lib.nixvim.utils.mkRaw "os.getenv 'OPENAI_API_KEY'";
                    };
                  };
                  gemini-cli = {
                    command = lib.getExe inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.gemini-cli;
                    args = [ "--experimental-acp" ];
                    env = {
                      NODE_NO_WARNINGS = "1";
                      GEMINI_API_KEY = lib.nixvim.utils.mkRaw "os.getenv 'GEMINI_API_KEY'";
                    };
                  };
                  opencode = {
                    command = lib.getExe inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
                    args = [ "acp" ];
                    env = {
                      GEMINI_API_KEY = lib.nixvim.utils.mkRaw "os.getenv 'GEMINI_API_KEY'";
                      OPENAI_API_KEY = lib.nixvim.utils.mkRaw "os.getenv 'OPENAI_API_KEY'";
                    };
                  };
                }
              else
                {
                  claude-code = {
                    command =
                      lib.getExe
                        inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.claude-code-acp;
                    env = {
                      NODE_NO_WARNINGS = "1";
                      ANTHROPIC_API_KEY = lib.nixvim.utils.mkRaw "os.getenv 'ANTHROPIC_API_KEY'";
                      ACP_PERMISSION_MODE = "acceptEdits";
                    };
                  };
                  codex = {
                    command = lib.getExe inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.codex-acp;
                    env = {
                      OPENAI_API_KEY = lib.nixvim.utils.mkRaw "os.getenv 'OPENAI_API_KEY'";
                    };
                  };
                  opencode = {
                    command = lib.getExe inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
                    args = [ "acp" ];
                    env = {
                      ANTHROPIC_API_KEY = lib.nixvim.utils.mkRaw "os.getenv 'ANTHROPIC_API_KEY'";
                      OPENAI_API_KEY = lib.nixvim.utils.mkRaw "os.getenv 'OPENAI_API_KEY'";
                    };
                  };
                };
            web_search_engine = {
              provider = "brave";
            };
            windows = {
              width = 37;
              sidebar_header = {
                align = "right";
                rounded = false;
              };
              input = {
                border = "rounded";
                height = 12;
              };
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
            # for now, let's try use avante tools instead of mcphub
            # disabled_tools = [
            #   "list_files" # Built-in file operations
            #   "search_files"
            #   "read_file"
            #   "create_file"
            #   "rename_file"
            #   "delete_file"
            #   "create_dir"
            #   "rename_dir"
            #   "delete_dir"
            #   "bash" # Built-in terminal access
            # ];
          };
        };
      };
    };
}
