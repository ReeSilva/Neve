{ lib, config, ... }:
{
  options = {
    overlays.avante.enable = lib.mkEnableOption "Enable avante.nvim overlay";
  };

  config =
    let
      cfg = config.overlays.avante;
    in
    lib.mkIf cfg.enable {
      nixpkgs.overlays = [
        (final: prev: {
          vimPlugins = prev.vimPlugins // {
            avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs (_old: {
              version = "0.0.27-unstable-2025-10-31";
              src = prev.fetchFromGitHub {
                owner = "yetone";
                repo = "avante.nvim";
                rev = "7e9f7b57de46534a9113980ec950a2b05eb8861f";
                sha256 = "sha256-5kyttSOLDX1M0rC+9mhW4dD2U/0ry9bKBqkJBE+m3tQ=";
              };
              avante-nvim-lib = prev.rustPlatform.buildRustPackage {
                pname = "avante-nvim-lib";
                inherit (final.vimPlugins.avante-nvim) version src;

                cargoHash = "sha256-pTWCT2s820mjnfTscFnoSKC37RE7DAPKxP71QuM+JXQ=";

                nativeBuildInputs = [
                  prev.pkg-config
                  prev.makeWrapper
                  prev.perl
                ];

                buildInputs = [
                  prev.openssl
                ];

                buildFeatures = [ "luajit" ];
                fito = "barbarian";

                checkFlags = [
                  # Disabled because they access the network.
                  "--skip=test_hf"
                  "--skip=test_public_url"
                  "--skip=test_roundtrip"
                  "--skip=test_fetch_md"
                ];
              };

              postInstall =
                let
                  ext = prev.stdenv.hostPlatform.extensions.sharedLibrary;
                in
                ''
                  mkdir -p $out/build
                  ln -s ${final.vimPlugins.avante-nvim.avante-nvim-lib}/lib/libavante_repo_map${ext} $out/build/avante_repo_map${ext}
                  ln -s ${final.vimPlugins.avante-nvim.avante-nvim-lib}/lib/libavante_templates${ext} $out/build/avante_templates${ext}
                  ln -s ${final.vimPlugins.avante-nvim.avante-nvim-lib}/lib/libavante_tokenizers${ext} $out/build/avante_tokenizers${ext}
                  ln -s ${final.vimPlugins.avante-nvim.avante-nvim-lib}/lib/libavante_html2md${ext} $out/build/avante_html2md${ext}
                '';

            });
          };
        })
      ];
    };
}
