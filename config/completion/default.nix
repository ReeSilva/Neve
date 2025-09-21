{ lib, config, ... }: {
  imports = [ ./blink.nix ./cmp.nix ./codeium.nix ./copilot.nix ./lspkind.nix ];

  options = {
    completion.enable = lib.mkEnableOption "Enable completion module";
  };
  config = lib.mkIf config.completion.enable {
    cmp.enable = lib.mkDefault false;
    blink.enable = lib.mkDefault true;
    codeium.enable = lib.mkDefault false;
    copilot.enable = lib.mkDefault true;
    lspkind.enable = lib.mkDefault true;
  };
}
