{ lib, config, pkgs, inputs, ... }:
{
  options.niquisvim.languages.rust.enable = lib.mkEnableOption "Enable Rust language support";
  config = let
    cfg = config.niquisvim.languages.rust;
  in lib.mkIf cfg.enable {
    plugins.rustaceanvim = {
      enable = true;
      settings = {
        dap.adapter = {
          type = "executable";
          command = lib.getExe' inputs.rustacean.packages.${pkgs.stdenv.hostPlatform.system}.codelldb "codelldb";
        };
        server.default_settings = {
          rust-analyzer.files.excludeDirs = [ ".direnv" ];
        };
      };
    };
  };
}
