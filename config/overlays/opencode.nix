final: prev: {
  opencode = prev.opencode.overrideAttrs {
    version = "0.15.13";
    src = prev.fetchFromGitHub {
      owner = "sst";
      repo = "opencode";
      rev = "v0.15.13";
      sha256 = "sha256-SIfNi3nRgMaWuqOtlPdbmDTRPqoSO4qwGCSMXoye9Ro=";
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
