{ lib, config, ... }: {
  options = { parrot.enable = lib.mkEnableOption "Enable parrot.nvim"; };
  config = let cfg = config.parrot;
  in lib.mkIf cfg.enable {
    plugins.parrot = {
      enable = true;
      settings = {
        providers = {
          pplx = {
            name = "pplx";
            endpoint = "https://api.perplexity.ai/chat/completions";
            api_key = lib.nixvim.utils.mkRaw "os.getenv 'PERPLEXITY_API_KEY'";
            params = {
              chat = {
                temperature = 1.1;
                top_p = 1;
              };
              command = {
                temperature = 1.1;
                top_p = 1;
              };
            };
            topic = {
              model = "sonar-reasoning-pro";
              params = { max_tokens = 64; };
            };
            # models = [
            #   "llama-3.1-sonar-small-128k-chat"
            #   "llama-3.1-sonar-small-128k-online"
            #   "llama-3.1-sonar-large-128k-chat"
            #   "llama-3.1-sonar-large-128k-online"
            #   "llama-3.1-8b-instruct"
            #   "llama-3.1-70b-instruct"
            # ];
          };
          # github = {
          #   name = "github";
          #   api_key = lib.nixvim.utils.mkRaw "os.getenv 'GITHUB_TOKEN'";
          #   params = {
          #     chat = {
          #       temperature = 1.1;
          #       top_p = 1;
          #     };
          #     command = {
          #       temperature = 1.1;
          #       top_p = 1;
          #     };
          #   };
          #   topic = {
          #     model = "mistral-ai/Codestral-2501";
          #     params = { max_tokens = 64; };
          #   };
          # };
        };
      };
    };
  };
}
