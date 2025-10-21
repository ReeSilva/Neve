final: prev: {
  codex-acp = final.rustPlatform.buildRustPackage {
    pname = "codex-acp";
    version = "0.3.5";
    src = final.fetchFromGitHub {
      owner = "zed-industries";
      repo = "codex-acp";
      rev = "v0.3.5";
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
}
