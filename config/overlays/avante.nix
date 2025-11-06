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
            avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs {
              src = final.fetchFromGitHub {
                owner = "yetone";
                repo = "avante.nvim";
                rev = "44b594863c1abf72690ae82651fb70c0b9adeeaa";
                sha256 = "sha256-i8B1JsoEUXUHSTCc1Bu6HdhMp3k5RKDuyJHFkjFUze0=";
              };
              version = "0.0.27-unstable-2025-11-06";
              avante-nvim-lib = final.rustPlatform.buildRustPackage {
                pname = "avante-nvim-lib";
                inherit (final.vimPlugins.avante-nvim) version src;

                cargoHash = "sha256-pTWCT2s820mjnfTscFnoSKC37RE7DAPKxP71QuM+JXQ=";

                nativeBuildInputs = [
                  final.pkg-config
                  final.makeWrapper
                  final.perl
                ];

                buildInputs = [
                  final.openssl
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
                  ext = final.stdenv.hostPlatform.extensions.sharedLibrary;
                in
                ''
                  mkdir -p $out/build
                  ln -s ${final.vimPlugins.avante-nvim.avante-nvim-lib}/lib/libavante_repo_map${ext} $out/build/avante_repo_map${ext}
                  ln -s ${final.vimPlugins.avante-nvim.avante-nvim-lib}/lib/libavante_templates${ext} $out/build/avante_templates${ext}
                  ln -s ${final.vimPlugins.avante-nvim.avante-nvim-lib}/lib/libavante_tokenizers${ext} $out/build/avante_tokenizers${ext}
                  ln -s ${final.vimPlugins.avante-nvim.avante-nvim-lib}/lib/libavante_html2md${ext} $out/build/avante_html2md${ext}
                '';
            };
          };
        })
      ];
    };
}
