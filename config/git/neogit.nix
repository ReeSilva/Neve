{ lib, config, ... }: {
  options = { neogit.enable = lib.mkEnableOption "Enable neogit module"; };
  config = lib.mkIf config.neogit.enable {
    plugins.neogit = { enable = true; };
    keymaps = [{
      mode = "n";
      key = "<leader>gn";
      action = "<cmd>Neogit<CR>";
    }];
  };
}
