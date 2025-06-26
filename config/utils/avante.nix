{ lib, config, pkgs, ... }: {
  options = { avante.enable = lib.mkEnableOption "Enable avante.nvim"; };
  config = let cfg = config.avante;
  in lib.mkIf cfg.enable {
    plugins.avante = {
      enable = true;
      settings = {
        provider = if pkgs.stdenv.isDarwin then "copilot" else "perplexity";
        cursor_applying_provider =
          if pkgs.stdenv.isDarwin then "copilot" else "perplexity";
        behaviour = { enable_cursor_planning_mode = true; };
        auto_suggestions_provider = "perplexity";
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
