final: prev: {
  opencode = prev.opencode.overrideAttrs {
    version = "0.15.8";
    src = prev.fetchFromGitHub {
      owner = "reesilva";
      repo = "opencode";
      rev = "dev";
      sha256 = "sha256-Zb3xtwXbvafbFXlIoFatU6HoxmyfaPosTHI/uEMCz8c=";
    };
    node_modules = prev.opencode.node_modules.overrideAttrs {
      inherit (final.opencode) version src;
      outputHash =
        {
          x86_64-linux = "sha256-iJbflfKwDwKrJQgy5jxrEhkyCie2hsEMmiLf2btE60E=";
          aarch64-darwin = "sha256-oICPefgikykFWNDlxCXH4tILdjv4NytgQdejdQBeQ+A=";
        }
        .${prev.system};
    };
  };
}
