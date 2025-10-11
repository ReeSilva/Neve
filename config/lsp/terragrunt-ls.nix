{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  # Build the terragrunt-ls plugin from GitHub
  terragrunt-ls-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "terragrunt-ls";
    src = pkgs.fetchFromGitHub {
      owner = "gruntwork-io";
      repo = "terragrunt-ls";
      rev = "a82e24338bae87e5a3d1e8cf81179ce8a848ae3e";
      hash = "sha256-Ni9TccTLbixtczJvKDUJqgGwFCj9TRNX0zp6421BaYY=";
    };
  };
in
{
  options = {
    terragrunt-ls = {
      enable = lib.mkEnableOption "Enable terragrunt-ls language server";

      cmd = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "terragrunt-ls" ];
        description = "Command to start terragrunt-ls language server";
        example = [ "terragrunt-ls" ];
      };

      logPath = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Path to terragrunt-ls log file. Set to enable logging.";
        example = "/tmp/terragrunt-ls.log";
      };

      autoAttach = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Automatically attach terragrunt-ls to HCL files";
      };
    };
  };

  config = lib.mkIf config.terragrunt-ls.enable {
    # Add the plugin to extraPlugins
    filetype.extension.hcl = "hcl";
    extraPlugins = [ terragrunt-ls-plugin ];

    # Setup the terragrunt-ls integration
    extraConfigLua = ''
      -- Setup terragrunt-ls
      local terragrunt_ls = require('terragrunt-ls')

      terragrunt_ls.setup({
        cmd = { "${lib.getExe inputs.pangaea.packages.${pkgs.system}.terragrunt-ls}" },
      })

      ${lib.optionalString config.terragrunt-ls.autoAttach ''
        -- Auto-attach terragrunt-ls to HCL files
        if terragrunt_ls.client then
          vim.api.nvim_create_autocmd('FileType', {
            pattern = 'hcl',
            callback = function()
              vim.lsp.buf_attach_client(0, terragrunt_ls.client)
            end,
          })
        end
      ''}
    '';
  };
}
