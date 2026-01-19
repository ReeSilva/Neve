{
  lib,
  config,
  pkgs,
  inputs,
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
      extraPlugins = with pkgs.vimPlugins; [
        codecompanion-history-nvim
      ];
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
            codecompanion-nvim = prev.vimPlugins.codecompanion-nvim.overrideAttrs {
              version = "v18.4.1";
              src = prev.fetchFromGitHub {
                owner = "olimorris";
                repo = "codecompanion.nvim";
                tag = "v18.4.1";
                sha256 = "sha256-f3Fin46KtArc5XxA2whagloFxPev/bThCTK+52fzQoM=";
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
        ];
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
            history = {
              enabled = true;
              opts.title_generation_opts.adapter = if pkgs.stdenv.isDarwin then "gemini" else "openai";
            };
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
}
