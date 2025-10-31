{ lib, config, ... }:
{
  options = {
    overlays.opencode.enable = lib.mkEnableOption "Enable avante.nvim overlay";
  };

  config =
    let
      cfg = config.overlays.opencode;
    in
    lib.mkIf cfg.enable {
      nixpkgs.overlays = [
        (final: prev: {
          opencode = prev.opencode.overrideAttrs {
            version = "1.0.0";
            src = prev.fetchFromGitHub {
              owner = "sst";
              repo = "opencode";
              rev = "v1.0.0";
              sha256 = "sha256-t/06HE2okPQ6Q2WGdU+r51vSWgVeAH3YuXftwA32UL8=";
            };
            node_modules = prev.opencode.node_modules.overrideAttrs {
              inherit (final.opencode) version src;
              outputHash =
                {
                  x86_64-linux = "sha256-O9GsCf6pXGOYIu7ogM0OB172bQkIuIyiSD3+OVUNjVE=";
                  aarch64-darwin = "sha256-oICPefgikykFWNDlxCXH4tILdjv4NytgQdejdQBeQ+A=";
                }
                .${prev.system};
            };
            tui = prev.opencode.tui.overrideAttrs {
              inherit (final.opencode) version src;
              vendorHash = "sha256-muwry7B0GlgueV8+9pevAjz3Cg3MX9AMr+rBwUcQ9CM=";
            };
          };
        })
      ];
    };
}
