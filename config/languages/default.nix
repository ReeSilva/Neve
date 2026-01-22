{ lib, config, ... }: {
  imports = [ ./helm.nix ./nvim-lint.nix ./rust.nix ./treesitter-nvim.nix ];

  options = {
    languages.enable = lib.mkEnableOption "Enable languages module";
  };
  config = lib.mkIf config.languages.enable {
    helm.enable = lib.mkDefault true;
    nvim-lint.enable = lib.mkDefault true;
    niquisvim.languages.rust.enable = lib.mkDefault true;
    treesitter-nvim.enable = lib.mkDefault true;
  };
}
