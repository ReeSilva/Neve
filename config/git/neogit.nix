{ lib, config, ... }:
{
  options = {
    neogit.enable = lib.mkEnableOption "Enable neogit module";
  };
  config = lib.mkIf config.neogit.enable {
    plugins.neogit = {
      enable = true;
      lazyLoad.settings = {
        cmd = "Neogit";
        keys = [
          "<leader>gg"
          "<leader>gn"
        ];
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>Neogit<CR>";
      }
      {
        mode = "n";
        key = "<leader>gn";
        action = "<cmd>Neogit<CR>";
      }
    ];
  };
}
