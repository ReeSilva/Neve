{ lib, config, pkgs, ... }: {
  options = { avante.enable = lib.mkEnableOption "Enable avante.nvim"; };
  config = let cfg = config.avante;
  in lib.mkIf cfg.enable {
    plugins.avante = {
      enable = true;
      settings = {
        provider = "copilot";
        behaviour = { enable_cursor_planning_mode = true; };
        providers = {
          perplexity = {
            __inherited_from = "openai";
            api_key_name = "PERPLEXITY_API_KEY";
            endpoint = "https://api.perplexity.ai";
            model = "sonar-reasoning-pro";
          };
          copilot = { model = "claude-sonnet-4"; };
        };
      };
    };
  };
}
