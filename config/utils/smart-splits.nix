{ lib, config, ... }: {
  options = {
    niquisvim.utils.smart-splits.enable =
      lib.mkEnableOption "Enable Nvim Smart Splits";
  };
  config = let cfg = config.niquisvim.utils.smart-splits;
  in lib.mkIf cfg.enable {
    plugins.smart-splits = {
      enable = true;
      settings = {
        ignored_events = [ "BufEnter" "WinEnter" ];
        ignored_filetypes = [ "neo-tree" ];
        resize_mode = {
          quit_key = "<ESC>";
          resize_keys = [ "h" "j" "k" "l" ];
          silent = true;
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        action = lib.nixvim.mkRaw "require('smart-splits').move_cursor_left";
        key = "<C-h>";
        options = { desc = "Go nth splits to left"; };
      }
      {
        mode = "n";
        action = lib.nixvim.mkRaw "require('smart-splits').move_cursor_down";
        key = "<C-j>";
        options = { desc = "Go nth splits to down"; };
      }
      {
        mode = "n";
        action = lib.nixvim.mkRaw "require('smart-splits').move_cursor_up";
        key = "<C-k>";
        options = { desc = "Go nth splits to up"; };
      }
      {
        mode = "n";
        action = lib.nixvim.mkRaw "require('smart-splits').move_cursor_right";
        key = "<C-l>";
        options = { desc = "Go nth splits to right"; };
      }
      {
        mode = "n";
        action =
          lib.nixvim.mkRaw "require('smart-splits').move_cursor_previous";
        key = "<C-\\>";
        options = { desc = "Go to previous split"; };
      }
      {
        mode = "n";
        action = lib.nixvim.mkRaw "require('smart-splits').resize_left";
        key = "<A-h>";
        options = { desc = "resize split left"; };
      }
      {
        mode = "n";
        action = lib.nixvim.mkRaw "require('smart-splits').resize_down";
        key = "<A-j>";
        options = { desc = "resize split down"; };
      }
      {
        mode = "n";
        action = lib.nixvim.mkRaw "require('smart-splits').resize_up";
        key = "<A-k>";
        options = { desc = "resize split up"; };
      }
      {
        mode = "n";
        action = lib.nixvim.mkRaw "require('smart-splits').resize_right";
        key = "<A-l>";
        options = { desc = "resize split right"; };
      }
      {
        mode = "n";
        action = lib.nixvim.mkRaw "require('smart-splits').swap_buf_left";
        key = "<leader>wh";
        options = { desc = "swap splits left"; };
      }
      {
        mode = "n";
        action = lib.nixvim.mkRaw "require('smart-splits').swap_buf_down";
        key = "<leader>wj";
        options = { desc = "swap splits down"; };
      }
      {
        mode = "n";
        action = lib.nixvim.mkRaw "require('smart-splits').swap_buf_up";
        key = "<leader>wk";
        options = { desc = "swap splits up"; };
      }
      {
        mode = "n";
        action = lib.nixvim.mkRaw "require('smart-splits').swap_buf_right";
        key = "<leader>wl";
        options = { desc = "swap splits right"; };
      }
    ];
  };
}
