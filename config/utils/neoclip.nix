{ lib, config, ... }:
{
  options.neoclip.enable = lib.mkEnableOption "Enable neoclip plugin";
  config =
    let
      cfg = config.neoclip;
    in
    lib.mkIf cfg.enable {
      plugins.sqlite-lua = {
        enable = true;
        lazyLoad.settings.lazy = true;
      };
      plugins.neoclip = {
        enable = true;
        lazyLoad.settings = {
          before = lib.nixvim.utils.mkRaw ''
            function()
              require('lz.n').trigger_load('sqlite-lua')
            end
          '';
          keys = [
            "<leader>nc"
          ];
        };
        settings = {
          enable_persistent_history = true;
          keys.telescope.i.paste = "<C-l>";
        };
      };
      keymaps = [
        {
          mode = [ "n" ];
          key = "<leader>n";
          action = "<Nop>";
          options = {
            silent = true;
            noremap = true;
            desc = "Neoclip";
          };
        }
        # {
        #   mode = [ "n" ];
        #   key = "<leader>nc";
        #   action = ":Telescope neoclip<CR>";
        #   options.desc = "Neoclip for register '\"'";
        # }
      ];
    };
}
