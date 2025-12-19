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
              src = prev.fetchFromGitHub {
                owner = "yetone";
                repo = "avante.nvim";
                rev = "80f7079556c6acf3d3effa13c22f0e4fd00bcffd";
                sha256 = "sha256-P8liuX2z0LNvtaIYeG5vOd5fEZyCfTwKd6UwFiBKPsM=";
              };
              version = "0.0.27-unstable-2025-12-18";
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

                # Allow undefined symbols on Darwin - they will be provided by Neovim's LuaJIT runtime
                env.RUSTFLAGS = lib.optionalString prev.stdenv.hostPlatform.isDarwin "-C link-arg=-undefined -C link-arg=dynamic_lookup";

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
            };
          };
        })
      ];
    };
}
