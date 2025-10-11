{ lib, config, ... }:
{
  imports = [
    ./conform.nix
    ./fidget.nix
    ./lsp-nvim.nix
    ./lspsaga.nix
    ./terragrunt-ls.nix
    ./trouble.nix
  ];

  options = {
    lsp-setup.enable = lib.mkEnableOption "Enable lsp module";
  };
  config = lib.mkIf config.lsp-setup.enable {
    conform.enable = lib.mkDefault true;
    fidget.enable = lib.mkDefault true;
    lsp-nvim.enable = lib.mkDefault true;
    lspsaga.enable = lib.mkDefault true;
    terragrunt-ls.enable = lib.mkDefault false;
    trouble.enable = lib.mkDefault true;
  };
}
