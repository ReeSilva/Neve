{ lib, config, ... }: {
  options = { snacks.enable = lib.mkEnableOption "Enable snacks module"; };
  config = lib.mkIf config.snacks.enable {
    plugins.snacks = {
      enable = true;
      settings = {
        animate = { enabled = true; };
        git = { enabled = true; };
        indent = { enabled = true; };
        input = { enabled = true; };
        lazygit = {
          enabled = true;
          configure = true;
          win.style = "lazygit";
        };
        notifier = { enabled = true; };
        rename = { enabled = true; };
        scope = { enabled = true; };
        statuscolumn = { enabled = true; };
        toggle = { enabled = true; };
        words = { enabled = true; };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>gg";
        action = ":lua Snacks.lazygit.open()<cr>";
        options = { desc = "LazyGit (Snacks)"; };
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = ":lua Snacks.git.blame_line()<cr>";
        options = { desc = "Blame line (Snacks)"; };
      }
      {
        mode = "n";
        key = "<leader>glr";
        action = ":lua Snacks.lazygit.log()<cr>";
        options = { desc = "Git log (repository)"; };
      }
      {
        mode = "n";
        key = "<leader>glf";
        action = ":lua Snacks.lazygit.log_file()<cr>";
        options = { desc = "Git log (current file)"; };
      }
    ];
  };
}
