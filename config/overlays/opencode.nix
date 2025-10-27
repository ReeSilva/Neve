final: prev: {
  opencode = prev.opencode.overrideAttrs {
    version = "dev-2026-10-26";
    src = prev.fetchFromGitHub {
      owner = "sst";
      repo = "opencode";
      rev = "dev";
      sha256 = "sha256-CaqQ32Wryhq8uNCwNeTcPR30Inp+QPATk8C/j4pQO7k=";
    };
    node_modules = prev.opencode.node_modules.overrideAttrs {
      inherit (final.opencode) version src;
      outputHash =
        {
          x86_64-linux = "sha256-zQfbh4X/FtoVh2A7YEEZKmCHnot6lsCzxwTJwkEdu10=";
          aarch64-darwin = "sha256-oICPefgikykFWNDlxCXH4tILdjv4NytgQdejdQBeQ+A=";
        }
        .${prev.system};
    };
  };
}
