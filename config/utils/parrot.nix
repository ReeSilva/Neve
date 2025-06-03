{ lib, config, ... }: {
  options = { parrot.enable = lib.mkEnableOption "Enable parrot.nvim"; };
  config = let cfg = config.parrot;
  in lib.mkIf cfg.enable {
    plugins.parrot = {
      enable = true;
      settings = {
        providers = {
          perplexity = {
            name = "perplexity";
            endpoint = "https://api.perplexity.ai/chat/completions";
            api_key = lib.nixvim.utils.mkRaw "os.getenv 'PERPLEXITY_API_KEY'";
            models = [
              "llama-3.1-sonar-small-128k-chat"
              "llama-3.1-sonar-small-128k-online"
              "llama-3.1-sonar-large-128k-chat"
              "llama-3.1-sonar-large-128k-online"
              "llama-3.1-8b-instruct"
              "llama-3.1-70b-instruct"
            ];
          };
        };
      };
    };
  };
}
