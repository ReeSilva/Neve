{ lib, config, ... }:
{
  options = {
    overlays.codecompanion.enable = lib.mkEnableOption "Enable codecompanion.nvim overlay";
  };

  config =
    let
      cfg = config.overlays.codecompanion;
    in
    lib.mkIf cfg.enable {
      nixpkgs.overlays = [
        (final: prev: {
          vimPlugins = prev.vimPlugins // {
            codecompanion-nvim = prev.vimPlugins.codecompanion-nvim.overrideAttrs {
              version = "v18.2.1";
              src = prev.fetchFromGitHub {
                owner = "olimorris";
                repo = "codecompanion.nvim";
                tag = "v18.2.1";
                sha256 = "sha256-94uX1Ie+BiKSPGCYcUwoZ6DZwSz8tUxaNsa+xTv1ejw=";
              };
            };
          };
        })
      ];
    };
}
