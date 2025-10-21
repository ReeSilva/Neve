final: prev: {
  codex-acp = final.rustPlatform.buildRustPackage {
    pname = "codex-acp";
    version = "0.3.2";
    src = final.fetchFromGitHub {
      owner = "zed-industries";
      repo = "codex-acp";
      rev = "v0.3.2";
      hash = "sha256-t/QqRCEMuM1MGbi5P5lPuZw3SjyayLffG04mN//Mupk=";
    };
    cargoHash = "sha256-TD4iADzLIyv65JcaPm1LnvXipSaCRJMF67D/sDa/lBU=";
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
}
