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
              version = "v18.3.0";
              src = prev.fetchFromGitHub {
                owner = "olimorris";
                repo = "codecompanion.nvim";
                tag = "v18.3.0";
                sha256 = "sha256-uI6PqqFJO1vN++Xma3MkAVY4kCDL4iBjiQyiBFNs9Es=";
              };
            };
          };
        })
      ];
    };
}
