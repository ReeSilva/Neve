{ lib, config, ... }:
{
  options = {
    niquisvim.git.octo.enable = lib.mkEnableOption "Enable Octo.nvim module";
  };
  config =
    let
      cfg = config.niquisvim.git.octo;
    in
    lib.mkIf cfg.enable {
      plugins.octo = {
        enable = true;
        lazyLoad.settings = {
          cmd = "Octo";
          keys = [
            "<leader>go"
            "<leader>goi"
            "<leader>gop"
            "<leader>gos"
          ];
        };
      };
      keymaps = [
        {
          mode = "n";
          key = "<leader>go";
          action = "<cmd>Octo actions<CR>";
          options.desc = "Octo Actions menu";
        }
        {
          mode = "n";
          key = "<leader>goi";
          action = "<cmd>Octo issue list<CR>";
          options.desc = "Octo: List issues";
        }
        {
          mode = "n";
          key = "<leader>gop";
          action = "<cmd>Octo pr list<CR>";
          options.desc = "Octo: List PRs";
        }
        {
          mode = "n";
          key = "<leader>gos";
          action = lib.nixvim.utils.mkRaw /* lua */ ''
            function()
              require("octo.utils").create_base_search_command { include_current_repo = true }
            end
          '';
          options.desc = "Search Github";
        }
      ];
    };
}
