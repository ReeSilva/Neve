{ lib, config, ... }:
{
  options = {
    overlays.codex-acp.enable = lib.mkEnableOption "Enable avante.nvim overlay";
  };

  config =
    let
      cfg = config.overlays.codex-acp;
    in
    lib.mkIf cfg.enable {
      nixpkgs.overlays = [
        (final: prev: {
          codex-acp = final.rustPlatform.buildRustPackage {
            pname = "codex-acp";
            version = "0.3.11";
            src = final.fetchFromGitHub {
              owner = "zed-industries";
              repo = "codex-acp";
              rev = "aa2c68f68d36035c9c5e4b67eede0c38e43b9f83";
              hash = "sha256-dwn2OToZqmaxxXqSwo1dG3Swb5y0cD4J9UXMnPxHOkc=";
            };
            cargoHash = "sha256-/7t0HIWcuKOUBAqg4hqGzeXGBgHAp64LZec+9J0+Zr4=";
            nativeBuildInputs = [ final.pkg-config ];
            buildInputs = [
              final.openssl
              final.dbus
            ];
            OPENSSL_NO_VENDOR = "1";
            meta = with final.lib; {
              description = "Agent Client Protocol adapter for Codex";
              homepage = "https://github.com/zed-industries/codex-acp";
              license = licenses.asl20;
              mainProgram = "codex-acp";
            };
          };
        })
      ];
    };
}
