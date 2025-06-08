{ lib, config, ... }: {
  options = { avante.enable = lib.mkEnableOption "Enable avante.nvim"; };
  config = let cfg = config.avante;
  in lib.mkIf cfg.enable {
    plugins.avante = {
      enable = true;
      settings = {
        provider = "openai";
        openai = {
          api_key_name = "PERPLEXITY_API_KEY";
          endpoint = "https://api.perplexity.ai";
          model = "llama-3.1-sonar-large-128k-online";
        };
        providers = [{
          perplexity = {
            __inherited_from = "openai";
            api_key_name = "PERPLEXITY_API_KEY";
            endpoint = "https://api.perplexity.ai";
            model = "sonar-reasoning-pro";
          };
        }];
      };
    };
  };
}
