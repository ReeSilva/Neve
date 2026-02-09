{ lib, config, ... }:
{
  options = {
    copilot.enable = lib.mkEnableOption "Enable copilot module";
  };
  config = lib.mkIf config.copilot.enable {
    plugins.copilot-lua = {
      enable = true;
      settings = {
        # Disabled for copilot-cmp
        panel.enabled = false;
        suggestion.enabled = false;
        filetypes = {
          yaml = true;
          markdown = true;
          help = false;
          gitcommit = false;
          gitrebase = false;
          hgcommit = false;
          svn = false;
          cvs = false;
          "." = false;
        };
        copilot_model = "gpt-41-copilot";
      };
    };
  };
}
