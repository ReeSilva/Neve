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
            api_key = lib.nixvim.utils.mkRaw "os.getenv('PERPLEXITY_API_KEY')";
            topic = { model = "llama-3.1-70b-instruct"; };
            # models = {
            #   __unkeyed-1 = "llama-3.1-sonar-small-128k-chat";
            #   __unkeyed-2 = "llama-3.1-sonar-small-128k-online";
            #   __unkeyed-3 = "llama-3.1-sonar-large-128k-chat";
            #   __unkeyed-4 = "llama-3.1-sonar-large-128k-online";
            #   __unkeyed-5 = "llama-3.1-8b-instruct";
            #   __unkeyed-6 = "llama-3.1-70b-instruct";
            # };
          };
        };
      };
    };
  };
}
