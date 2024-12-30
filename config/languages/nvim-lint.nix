{ lib, config, ... }: {
  options = {
    nvim-lint.enable = lib.mkEnableOption "Enable nvim-lint module";
  };
  config = lib.mkIf config.nvim-lint.enable {
    plugins.lint = {
      enable = true;
      lintersByFt = {
        nix = [ "statix" ];
        lua = [ "selene" ];
        terraform = [ "tflint" ];
        json = [ "jsonlint" ];
        bash = [ "shellcheck" ];
        yaml = [ "yamllint" ];
      };
    };
  };
}
