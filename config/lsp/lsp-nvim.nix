{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    lsp-nvim.enable = lib.mkEnableOption "Enable lsp-nvim module";
  };
  config = lib.mkIf config.lsp-nvim.enable {
    extraPlugins = with pkgs.vimPlugins; [ nvim-lsp-file-operations ];
    lsp = {
      servers = {
        "*" = {
          enable = true;
          config = {
            capabilities = {
              __unkeyed-1 = lib.nixvim.utils.mkRaw "vim.lsp.protocol.make_client_capabilities()";
              __unkeyed-2 = lib.nixvim.utils.mkRaw "require'lsp-file-operations'.default_capabilities()";
              offsetEncoding = [ "utf-16" ];
            };
          };
        };
        clangd = {
          enable = true;
        };
        lua_ls = {
          enable = true;
          config = {
            Lua = {
              completion = {
                callSnippet = "Replace";
              };
              diagnostics = {
                globals = [ "vim" ];
              };

              telemetry = {
                enabled = false;
              };
              hint = {
                enable = true;
              };
            };
          };
        };
        gopls.enable = true;
        golangci_lint_ls.enable = true;
        marksman.enable = true;
        # nil_ls = {
        #   enable = true;
        # };
        nixd = {
          enable = true;
        };
        terraformls = {
          enable = true;
        };
        tflint = {
          enable = true;
        };
        ts_ls = {
          enable = true;
          # autostart = true;
          config = {
            filetypes = [
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
            ];
            javascript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
                includeInlayFunctionParameterTypeHints = true;
                includeInlayParameterNameHints = "all";
                includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayVariableTypeHints = true;
                includeInlayVariableTypeHintsWhenTypeMatchesName = true;
              };
            };
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
                includeInlayFunctionParameterTypeHints = true;
                includeInlayParameterNameHints = "all";
                includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayVariableTypeHints = true;
                includeInlayVariableTypeHintsWhenTypeMatchesName = true;
              };
            };
          };
        };
        yamlls = {
          enable = true;
          config = {
            yaml = {
              schemas = {
                kubernetes = "'*.yaml";
                "http://json.schemastore.org/github-workflow" = ".github/workflows/*";
                "http://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
                "http://json.schemastore.org/ansible-stable-2.9" = "roles/tasks/*.{yml,yaml}";
                "http://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
                "http://json.schemastore.org/ansible-playbook" = "*play*.{yml,yaml}";
                "http://json.schemastore.org/chart" = "Chart.{yml,yaml}";
                "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";
                "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
                  "*docker-compose*.{yml,yaml}";
                "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json" =
                  "*flow*.{yml,yaml}";
              };
            };
          };
        };
        eslint = {
          enable = false;
        };
        rust_analyzer = {
          enable = true;
          config = {
            checkOnSave = true;
            check = {
              command = "clippy";
            };
            inlayHints = {
              enable = true;
              showParameterNames = true;
              parameterHintsPrefix = "<- ";
              otherHintsPrefix = "=> ";
            };
            procMacro = {
              enable = true;
            };
          };
        };
      };
      # keymaps = [
      #   {
      #     key = "gd";
      #     lspBufAction = "definition";
      #   }
      #   {
      #     key = "gr";
      #     lspBufAction = "references";
      #   }
      #   {
      #     key = "gD";
      #     lspBufAction = "declaration";
      #   }
      #   {
      #     key = "gI";
      #     lspBufAction = "implementation";
      #   }
      #   {
      #     key = "gT";
      #     lspBufAction = "type_definition";
      #   }
      #   {
      #     key = "K";
      #     lspBufAction = "<CMD>Lspsaga hover_doc<Enter>";
      #   }
      #   {
      #     key = "<leader>cw";
      #     lspBufAction = "workspace_symbol";
      #   }
      #   {
      #     key = "<leader>cr";
      #     lspBufAction = "rename";
      #   }
      #   {
      #     key = "<leader>ca";
      #     lspBufAction = "code_action";
      #   }
      #   {
      #     key = "<leader>ck";
      #     lspBufAction = "signature_help";
      #   }
      #   # {
      #   #   key = "<leader>cd";
      #   #   action = "open_float";
      #   # }
      #   # {
      #   #   key = "<leader>[d";
      #   #   action = "goto_next";
      #   # }
      #   # {
      #   #   key = "<leader>]d";
      #   #   action = "goto_prev";
      #   # }
      # ];
      onAttach = ''
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("UserLspConfig", {}),
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(false)
            end
            vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
          end,
        })
      '';
    };
    plugins = {
      lspconfig.enable = true;
      lsp-format.enable = false; # Enable it if you want lsp-format integration for none-ls
    };
    extraConfigLua = ''
        local _border = "rounded"

        require('lsp-file-operations').setup()

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
          vim.lsp.handlers.hover, {
            border = _border
          }
        )

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
          vim.lsp.handlers.signature_help, {
            border = _border
          }
        )

        vim.diagnostic.config({
          float = { border = "rounded" },
          virtual_text = {
            prefix = "",
          },
          signs = true,
          underline = true,
          update_in_insert = true,
        })

      --   vim.api.nvim_create_autocmd("LspAttach", {
      --   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      --   callback = function(args)
      --     local client = vim.lsp.get_client_by_id(args.data.client_id)
      --     if client.server_capabilities.inlayHintProvider then
      --       vim.lsp.inlay_hint.enable(false)
      --     end
      --     vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
      --
      --     local opts = { buffer = args.buf }
      --     vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      --     vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      --     vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      --     vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
      --     vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, opts)
      --     vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      --     vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      --     vim.keymap.set("n", "<space>cw", vim.lsp.buf.workspace_symbol, opts)
      --     vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, opts)
      --     vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
      --     vim.keymap.set("n", "<space>cf", function()
      --       vim.lsp.buf.format({ async = true })
      --     end, opts)
      --     vim.keymap.set("n", "<space>cd", vim.diagnostic.open_float, opts)
      --     vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
      --     vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
      --   end,
      -- })
    '';
  };
}
