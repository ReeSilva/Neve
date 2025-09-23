{ lib, config, pkgs, ... }: {
  options = { avante.enable = lib.mkEnableOption "Enable avante.nvim"; };
  config = let cfg = config.avante;
  in lib.mkIf cfg.enable {
    plugins = {
      render-markdown = {
        enable = true;
        settings = { file_types = [ "markdown" "Avante" ]; };
      };
      avante = {
        enable = true;
        settings = {
          provider = if pkgs.stdenv.isDarwin then "gemini-cli" else "copilot";
          behaviour = {
            enable_cursor_planning_mode = true;
            enable_fastapply = true;
          };
          input = {
            provider = "snacks";
            provider_opts = {
              title = "Avante Input";
              icon = "󱚞";
            };
          };
          providers = {
            copilot = { model = "claude-sonnet-4"; };
            morph = { model = "morph-v3-large"; };
            perplexity = {
              __inherited_from = "openai";
              api_key_name = "PERPLEXITY_API_KEY";
              endpoint = "https://api.perplexity.ai";
              model = "sonar-reasoning-pro";
            };
          };
          acp_providers = lib.mkIf pkgs.stdenv.isDarwin {
            command = "gemini";
            args = [ "--experimental-acp" ];
            env = {
              NODE_NO_WARNINGS = "1";
              GEMINI_API_KEY =
                lib.nixvim.utils.mkRaw "os.getenv 'GEMINI_API_KEY'";
            };
          };
          web_search_engine = { provider = "brave"; };
          windows.input.height = 10;
        };
      };
    };
  };
}
