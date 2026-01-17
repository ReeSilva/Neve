{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    nvim-lint.enable = lib.mkEnableOption "Enable nvim-lint module";
  };
  config = lib.mkIf config.nvim-lint.enable {
    plugins.lint = {
      enable = true;
      linters = {
        statix.cmd = lib.getExe pkgs.statix;
        selene.cmd = lib.getExe pkgs.selene;
        tflint.cmd = lib.getExe pkgs.tflint;
        jsonlint.cmd = lib.getExe pkgs.python314Packages.demjson3;
        shellcheck.cmd = lib.getExe pkgs.shellcheck;
        yamllint.cmd = lib.getExe pkgs.yamllint;
        vale.cmd = lib.getExe pkgs.vale;
      };
      lintersByFt = {
        nix = [ "statix" ];
        lua = [ "selene" ];
        terraform = [ "tflint" ];
        json = [ "jsonlint" ];
        bash = [ "shellcheck" ];
        yaml = [ "yamllint" ];
        markdown = [ "vale" ];
      };
    };
  };
}
