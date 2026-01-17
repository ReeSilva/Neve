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
              version = "v18.4.1";
              src = prev.fetchFromGitHub {
                owner = "olimorris";
                repo = "codecompanion.nvim";
                tag = "v18.4.1";
                sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                # sha256 = "sha256-f3Fin46KtArc5XxA2whagloFxPev/bThCTK+52fzQoM=";
              };
            };
          };
        })
      ];
    };
}
