{ lib, config, ... }: {
  imports = [
    ./alpha.nix
    ./barbecue.nix
    ./dressing-nvim.nix
    ./indent-blankline.nix
    ./noice.nix
    ./nui.nix
    ./notify.nix
    ./snacks.nix
    ./ufo.nix
    ./web-devicons.nix
  ];

  options = { ui.enable = lib.mkEnableOption "Enable ui module"; };
  config = lib.mkIf config.ui.enable {
    alpha.enable = lib.mkDefault true;
    barbecue.enable = lib.mkDefault true;
    dressing-nvim.enable = lib.mkDefault false;
    indent-blankline.enable = lib.mkDefault false;
    noice.enable = lib.mkDefault true;
    notify.enable = lib.mkDefault true;
    nui.enable = lib.mkDefault true;
    snacks.enable = lib.mkDefault true;
    ufo.enable = lib.mkDefault true;
    web-devicons.enable = lib.mkDefault true;
  };
}
