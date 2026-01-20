{ lib, config, ... }:
{
  options = {
    persistence.enable = lib.mkEnableOption "Enable persistence module";
  };
  config = lib.mkIf config.persistence.enable {
    plugins.persistence = {
      enable = true;
      lazyLoad.settings = {
        event = "BufReadPre";
        keys = [
          "<leader>qS"
          "<leader>qs"
          "<leader>ql"
          "<leader>qd"
        ];
      };
    };
  };
}
