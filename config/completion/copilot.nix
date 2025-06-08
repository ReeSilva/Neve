{ lib, config, ... }: {
  options = { copilot.enable = lib.mkEnableOption "Enable copilot module"; };
  config = lib.mkIf config.copilot.enable {
    plugins.copilot-lua = {
      enable = true;
      settings = {
        # Disabled for copilot-cmp
        panel.enabled = false;
        suggestion.enabled = false;

        filetypes = {
          yaml = false;
          markdown = false;
          help = false;
          gitcommit = false;
          gitrebase = false;
          hgcommit = false;
          svn = false;
          cvs = false;
          "." = false;
        };
        copilot_model = "claude-3.7-sonnet";
      };
    };
  };
}
