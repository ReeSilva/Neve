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
      extraConfigLua = /* lua */ ''
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
      keymaps = [
        {
          mode = "n";
          key = "<leader>acc";
          action = ":CodeCompanionActions<cr>";
          options = {
            silent = true;
            desc = "Toggle Maurício Kubrusly chat";
          };
        }
        {
          mode = "n";
          key = "<leader>acct";
          action = ":CodeCompanionChat Toggle<cr>";
          options = {
            silent = true;
            desc = "Toggle Maurício Kubrusly chat";
          };
        }
        {
          mode = "v";
          key = "<leader>acce";
          action = ":'<,'>CodeCompanion<cr>";
          options = {
            silent = true;
            desc = "Maurício Kubrusly inline (NO ACP)";
          };
        }
        {
          mode = "v";
          key = "<leader>acca";
          action = ":'<,'>CodeCompanionChat<cr>";
          options = {
            silent = true;
            desc = "Ask to Maurício Kubrusly";
          };
        }
      ];
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
              "codecompanion"
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
            shortcuts = [
              {
                name = "dora";
                description = "Write Slack messages and send them to Slack channels through MCP tools";
                details = "Automatic understand the context where it is running and lates code changes to write several type of Slack messages";
                prompt = "Have a conversation with me to understand the context and help me to write a Slack message. We should compose the message in an agentic flow where you show me updates and I'll keeep giving you feedbacks until we reach a good message. Once this is done, ask me informations about where in Slack I want to send the message and, once I provide you, use the Slack MCP tools you have available to send this message there.";
              }
              {
                name = "fumacinha";
                description = "Help to create and maintain a cloud infrastructure in GCP using Terragrunt as a wrapper for several OpenTofu module";
                details = "A experienced Senior Cloud Engineer that masters at Terragrunt and OpenTofu to create and maintain a self-service cloudinfrastructure in GCP";
                prompt = ''
                  You're an experienced Senior Cloud Engineer, who masters at Google Cloud Platform (GCP), OpenTofu and Terragrunt. You're also very proficient in the organization of projects suggested by Gruntwork: [terragrunt-infrastructure-live-example](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example). You're tasked to help to maintain a codebase tha manages a whole organization cloud in GCP based on the terragrunt-infrastructure-live-example and using Terragrunt as a wrapper for OpenTofu. For maintaining, you'll help to: implement new OpenTofu modules to install resources with Terragrunt Units, maintain code that already exists and also help to keep the code on this repository up-to-date and well-written. You achieve that through writing good, clean, efficient, easy to read and well-documented Terragrunt and OpenTofu code. You can use all the MCP tools you have available to help you in this task, and you should always try to use MCP tools where it looks more suitable before anything else. Especially, knowing the purpose of some of these tools you have available:
                    - Notion MCP Tool: The company uses Notion as our knowledge-base, and you're connected to a Notion MCP Server to get documentation about the project, especially anything you can find about `Altitudo`, which is the name of the project that manages the cloud infrastructure codebase.
                    - Slack MCP tool: The company uses Slack as our communication tool. For that, you'll help me to write messages in Slack about the project, and you should use this MCP tool to send these messages
                    - Context7: Context7 is a platform that provides documentation about several technologies, and tailored for be easy-understandable by LLMs. You are connected to context7 MCP server and you should always try to first use context7 when you need to get any documentation.
                    - Gcloud [USE THIS SERVER ONLY IN READ-ONLY MODE]: You're connected to a Gcloud MCP server, that allows you to interact with the `gcloud` commnad-line to get informations about our cloud infrastructure. Use this tool everytime you need to check a deployed resource to match with the configuration we have in the repo. BUT NEVER CHANGE ANYTHING, YOU'RE ONLY ALLOWED TO READ USING THIS TOOL.
                    - mcp_k8s [USE THIS SERVER ONLY IN READ-ONLY MODE]: You're connected to a Kubernetes MCP server, that allows you to get information about the cluster we have deployed. Use this tool everytime you need to check the config of a deployed kubernetes cluster. BUT NEVER CHANGE ANYTHING, YOU'RE ONLY ALLOWED TO READ USING THIS TOOL.

                  But, you don't need to be restricted to these tools. Always update and check the MCP tools you have available to see if you have a more suitable tool for the task you're doing.
                '';
              }
            ];
            acp_providers =
              if pkgs.stdenv.isDarwin then
                {
                  codex = {
                    command = lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex-acp;
                    env = {
                      OPENAI_API_KEY = lib.nixvim.utils.mkRaw "os.getenv 'OPENAI_API_KEY'";
                    };
                  };
                  gemini-cli = {
                    command = lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gemini-cli;
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
                    command = lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code-acp;
                    env = {
                      NODE_NO_WARNINGS = "1";
                      ANTHROPIC_API_KEY = lib.nixvim.utils.mkRaw "os.getenv 'ANTHROPIC_API_KEY'";
                      ACP_PERMISSION_MODE = "acceptEdits";
                    };
                  };
                  codex = {
                    command = lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex-acp;
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
          };
        };
        codecompanion = {
          enable = true;
          settings = {
            strategies = {
              chat = {
                adapter = "opencode";
                roles = {
                  llm = lib.nixvim.utils.mkRaw /* lua */ ''
                    function(adapter)
                      return "Maurício Kubrusly usa " .. adapter.formatted_name
                    end
                  '';
                  user = "engenheiro do fim do mundo";
                };
              };
              inline.adapter = if pkgs.stdenv.isDarwin then "gemini" else "openai";
              cmd.adapter = "opencode";
            };
            extensions = {
              mcphub = {
                callback = "mcphub.extensions.codecompanion";
                opts = {
                  make_tools = true;
                  show_server_tools_in_chat = true;
                  add_mcp_prefix_to_tool_names = false; # Add mcp__ prefix (e.g `@mcp__github`; `@mcp__neovim__list_issues`)
                  show_result_in_chat = true; # Show tool results directly in chat buffer
                  # MCP Resources
                  make_vars = true; # Convert MCP resources to #variables for prompts
                  # MCP Prompts
                  make_slash_commands = true; # Add MCP prompts as /slash commands
                };
              };
            };
            adapters.acp = {
              codex = lib.nixvim.utils.mkRaw /* lua */ ''
                function()
                  return require("codecompanion.adapters").extend("codex", {
                    commands = {
                      default = {
                        "${lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex-acp}"
                      },
                    },
                  })
                end
              '';
              claude_code = lib.mkIf pkgs.stdenv.isLinux (
                lib.nixvim.utils.mkRaw /* lua */ ''
                  function()
                    return require("codecompanion.adapters").extend("claude_code", {
                      commands = {
                        default = {
                          "${
                            lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code-acp
                          }"
                        },
                      },
                    })
                  end
                ''
              );
              gemini_cli = lib.mkIf pkgs.stdenv.isDarwin (
                lib.nixvim.utils.mkRaw /* lua */ ''
                  function()
                    return require("codecompanion.adapters").extend("gemini_cli", {
                      commands = {
                        default = {
                          "${lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gemini-cli}",
                          "--experimental-acp"
                        },
                      },
                      defaults = {
                        auth_method = "gemini-api-key",
                      },
                    })
                  end
                ''
              );
              opencode = lib.nixvim.utils.mkRaw /* lua */ ''
                function()
                  return require("codecompanion.adapters").extend("opencode", {
                    commands = {
                      default = {
                        "${lib.getExe inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default}",
                        "acp"
                      },
                    },
                  })
                end
              '';
            };
          };
        };
      };
    };
}
