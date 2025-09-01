{ lib, config, ... }: {
  options = { helm.enable = lib.mkEnableOption "Enable vim-helm module"; };
  config = lib.mkIf config.helm.enable {
    autoCmd = [{
      command = "LspRestart";
      event = "FileType";
      pattern = "helm";
    }];
    plugins.helm = { enable = true; };
  };
}
