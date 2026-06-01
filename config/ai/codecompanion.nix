{
  lib,
  config,
  pkgs,
  inputs,
  opencode,
  ...
}:
{
  options = {
    niquisvim.ai.codecompanion.enable = lib.mkEnableOption "Install CodeCompanion AI assistant for Niquisvim";
  };
  config =
    let
      cfg = config.niquisvim.ai.codecompanion;
    in
    lib.mkIf cfg.enable {
      extraConfigLuaPre = /* lua */ ''
        local progress = require("fidget.progress")
        local M = {}
        M.handles = {}

        function M:store_progress_handle(id, handle)
          M.handles[id] = handle
        end

        function M:pop_progress_handle(id)
          local handle = M.handles[id]
          M.handles[id] = nil
          return handle
        end

        function M:create_progress_handle(request)
          return progress.handle.create({
            title = " Requesting assistance (" .. request.data.interaction .. ")",
            message = "In progress...",
            lsp_client = {
              name = M:llm_role_title(request.data.adapter),
            },
          })
        end

        function M:llm_role_title(adapter)
          local parts = {}
          table.insert(parts, adapter.formatted_name)
          if adapter.model and adapter.model ~= "" then
            table.insert(parts, "(" .. adapter.model .. ")")
          end
          return table.concat(parts, " ")
        end

        function M:report_exit_status(handle, request)
          if request.data.status == "success" then
            handle.message = "Completed"
          elseif request.data.status == "error" then
            handle.message = " Error"
          else
            handle.message = "󰜺 Cancelled"
          end
        end
      '';
      autoGroups = {
        CodeCompanionFidgetHooks = { };
      };
      autoCmd = [
        {
          group = "CodeCompanionFidgetHooks";
          event = "User";
          pattern = "CodeCompanionRequestStarted";
          callback = lib.nixvim.utils.mkRaw ''
            function(request)
              local handle = M:create_progress_handle(request)
              M:store_progress_handle(request.data.id, handle)
            end
          '';
        }
        {
          group = "CodeCompanionFidgetHooks";
          event = "User";
          pattern = "CodeCompanionRequestFinished";
          callback = lib.nixvim.utils.mkRaw ''
            function(request)
              local handle = M:pop_progress_handle(request.data.id)
              if handle then
                M:report_exit_status(handle, request)
                handle:finish()
              end
            end
          '';
        }
      ];
      keymaps = [
        {
          mode = "n";
          key = "<leader>acc";
          action = ":CodeCompanionActions<cr>";
          options = {
            silent = true;
            desc = "codecompanion: mauricio kubrusly actions";
          };
        }
        {
          mode = "n";
          key = "<leader>acct";
          action = ":CodeCompanionChat Toggle<cr>";
          options = {
            silent = true;
            desc = "codecompanion: mauricio kubrusly chat";
          };
        }
        {
          mode = "v";
          key = "<leader>acce";
          action = ":'<,'>CodeCompanion<cr>";
          options = {
            silent = true;
            desc = "codecompanion: mauricio kubrusly inline (no acp)";
          };
        }
        {
          mode = "v";
          key = "<leader>acca";
          action = ":'<,'>CodeCompanionChat<cr>";
          options = {
            silent = true;
            desc = "codecompanion: ask mauricio kubrusly";
          };
        }
      ];
      nixpkgs.overlays = [
        (final: prev: {
          vimPlugins = prev.vimPlugins // {
            codecompanion-nvim = prev.vimPlugins.codecompanion-nvim.overrideAttrs rec {
              pname = "codecompanion.nvim";
              version = "19.13.0-unstable-2026-06-01";
              name = "vimplugin-${pname}-${version}";
              src = prev.fetchFromGitHub {
                owner = "olimorris";
                repo = "codecompanion.nvim";
                rev = "57989aca2e92083b16a2500ad47f285d82d5c43b";
                hash = "sha256-zGJyVC5Fkk9j23UG8D/NbQBODCvouGwKp0DDONqSvnM=";
              };
            };
          };
        })
      ];
      plugins.codecompanion = {
        enable = true;
        lazyLoad.settings.cmd = [
          "CodeCompanion"
          "CodeCompanionChat"
          "CodeCompanionActions"
          "CodeCompanionCmd"
          "CodeCompanionCLI"
        ];
        settings = {
          interactions = {
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
            cli = {
              agent = "opencode";
              agents = {
                claude_code = {
                  cmd = lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
                  description = "Claude Code CLI";
                  provider = "terminal";
                };
                opencode = {
                  cmd = lib.getExe opencode;
                  description = "OpenCode TUI";
                  provider = "terminal";
                };
              };
            };
            inline.adapter =
              if pkgs.stdenv.isDarwin then
                {
                  name = "copilot";
                  model = "claude-sonnet-4.6";
                }
              else
                "opencode_completions";
            cmd.adapter =
              if pkgs.stdenv.isDarwin then
                {
                  name = "copilot";
                  model = "claude-sonnet-4.6";
                }
              else
                "opencode_completions";
            background.adapter =
              if pkgs.stdenv.isDarwin then
                {
                  name = "copilot";
                  model = "claude-sonnet-4.6";
                }
              else
                "opencode_completions";
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
                # Set to false for now to supress errors (I don't use it yet)
                make_vars = false; # Convert MCP resources to #variables for prompts
                # MCP Prompts
                make_slash_commands = true; # Add MCP prompts as /slash commands
              };
            };
          };
          adapters = {
            acp = {
              claude_code = lib.nixvim.utils.mkRaw /* lua */ ''
                function()
                  return require("codecompanion.adapters").extend("claude_code", {
                    commands = {
                      default = {
                        "${
                          lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-agent-acp
                        }"
                      },
                    },
                  })
                end
              '';
              copilot_acp = lib.nixvim.utils.mkRaw /* lua */ ''
                function()
                  return require("codecompanion.adapters").extend("copilot_acp", {
                    commands = {
                      default = {
                        "${lib.getExe pkgs.github-copilot-cli}",
                        "--acp",
                        "--stdio",
                      },
                    }
                  })
                end
              '';
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
                        auth_method = "oauth-personal",
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
                        "${lib.getExe opencode}",
                        "acp"
                      },
                    },
                  })
                end
              '';
            };
            http = {
              opencode_responses = lib.mkIf pkgs.stdenv.isLinux (
                lib.nixvim.utils.mkRaw /* lua */ ''
                  function()
                    return require("codecompanion.adapters").extend("openai_responses", {
                      name = "opencode_responses",
                      formatted_name = "OpenCode Responses",
                      url = "https://opencode.ai/zen/v1/responses",
                      env = { api_key = "OPENCODE_ZEN_API_KEY" },
                      schema = {
                        model = {
                          default = "gpt-5",
                          choices = {
                            ["gpt-5.4-pro"]         = { formatted_name = "GPT 5.4 Pro",          meta = { context_window = 1050000 }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5.4"]             = { formatted_name = "GPT 5.4",              meta = { context_window = 1050000 }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5.4-mini"]        = { formatted_name = "GPT 5.4 Mini",         meta = { context_window = 400000  }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5.4-nano"]        = { formatted_name = "GPT 5.4 Nano",         meta = { context_window = 400000  }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5.3-codex"]       = { formatted_name = "GPT 5.3 Codex",        meta = { context_window = 400000  }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5.3-codex-spark"] = { formatted_name = "GPT 5.3 Codex Spark",  meta = { context_window = 400000  }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5.2"]             = { formatted_name = "GPT 5.2",              meta = { context_window = 400000  }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5.2-codex"]       = { formatted_name = "GPT 5.2 Codex",        meta = { context_window = 400000  }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5.1"]             = { formatted_name = "GPT 5.1",              meta = { context_window = 400000  }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5.1-codex-max"]   = { formatted_name = "GPT 5.1 Codex Max",    meta = { context_window = 400000  }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5.1-codex-mini"]  = { formatted_name = "GPT 5.1 Codex Mini",   meta = { context_window = 400000  }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5.1-codex"]       = { formatted_name = "GPT 5.1 Codex",        meta = { context_window = 400000  }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5"]               = { formatted_name = "GPT 5",                meta = { context_window = 400000  }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5-codex"]         = { formatted_name = "GPT 5 Codex",          meta = { context_window = 400000  }, opts = { has_function_calling = true, has_vision = true, can_reason = true } },
                            ["gpt-5-nano"]          = { formatted_name = "GPT 5 Nano",           meta = { context_window = 400000  }, opts = { has_function_calling = false, has_vision = false, can_reason = false } },
                          },
                        },
                      },
                    })
                  end
                ''
              );
              opencode_messages = lib.mkIf pkgs.stdenv.isLinux (
                lib.nixvim.utils.mkRaw /* lua */ ''
                  function()
                    return require("codecompanion.adapters").extend("anthropic", {
                      name = "opencode_messages",
                      formatted_name = "OpenCode Messages",
                      url = "https://opencode.ai/zen/v1/messages",
                      env = { api_key = "OPENCODE_ZEN_API_KEY" },
                      headers = {
                        ["content-type"] = "application/json",
                        Authorization = "Bearer ''${api_key}",
                        ["anthropic-version"] = "2023-06-01",
                      },
                      schema = {
                        model = {
                          default = "claude-sonnet-4-6",
                          choices = {
                            ["claude-opus-4-6"]   = { formatted_name = "Claude Opus 4.6",   meta = { context_window = 200000 }, opts = { has_vision = true, can_reason = true  } },
                            ["claude-opus-4-5"]   = { formatted_name = "Claude Opus 4.5",   meta = { context_window = 200000 }, opts = { has_vision = true, can_reason = true  } },
                            ["claude-opus-4-1"]   = { formatted_name = "Claude Opus 4.1",   meta = { context_window = 200000 }, opts = { has_vision = true, can_reason = true  } },
                            ["claude-sonnet-4-6"] = { formatted_name = "Claude Sonnet 4.6", meta = { context_window = 200000 }, opts = { has_vision = true, can_reason = true  } },
                            ["claude-sonnet-4-5"] = { formatted_name = "Claude Sonnet 4.5", meta = { context_window = 200000 }, opts = { has_vision = true, can_reason = true  } },
                            ["claude-sonnet-4"]   = { formatted_name = "Claude Sonnet 4",   meta = { context_window = 200000 }, opts = { has_vision = true, can_reason = false } },
                            ["claude-haiku-4-5"]  = { formatted_name = "Claude Haiku 4.5",  meta = { context_window = 200000 }, opts = { has_vision = true, can_reason = true  } },
                            ["claude-3-5-haiku"]  = { formatted_name = "Claude Haiku 3.5",  meta = { context_window = 200000 }, opts = { has_vision = true, can_reason = false } },
                          },
                        },
                      },
                    })
                  end
                ''
              );
              opencode_completions = lib.mkIf pkgs.stdenv.isLinux (
                lib.nixvim.utils.mkRaw /* lua */ ''
                  function()
                    return require("codecompanion.adapters").extend("openai", {
                      name = "opencode_completions",
                      formatted_name = "OpenCode Completions",
                      url = "https://opencode.ai/zen/v1/chat/completions",
                      env = { api_key = "OPENCODE_ZEN_API_KEY" },
                      schema = {
                        model = {
                          default = "minimax-m2.5-free",
                          choices = {
                            ["minimax-m2.5"]          = { formatted_name = "MiniMax M2.5",         opts = { has_vision = false } },
                            ["minimax-m2.5-free"]     = { formatted_name = "MiniMax M2.5 Free",    opts = { has_vision = false } },
                            ["glm-5.1"]               = { formatted_name = "GLM 5.1",              opts = { has_vision = false } },
                            ["glm-5"]                 = { formatted_name = "GLM 5",                opts = { has_vision = false } },
                            ["kimi-k2.5"]             = { formatted_name = "Kimi K2.5",            opts = { has_vision = false } },
                            ["big-pickle"]            = { formatted_name = "Big Pickle",           opts = { has_vision = false } },
                            ["qwen3.6-plus-free"]     = { formatted_name = "Qwen3.6 Plus Free",    opts = { has_vision = false } },
                            ["nemotron-3-super-free"] = { formatted_name = "Nemotron 3 Super Free", opts = { has_vision = false } },
                          },
                        },
                      },
                    })
                  end
                ''
              );
            };
          };
        };
      };
    };
}
