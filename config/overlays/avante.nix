final: prev: {
  vimPlugins = prev.vimPlugins // {
    avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs (_old: {
      version = "0.0.27-unstable-2025-10-16";
      src = final.fetchFromGitHub {
        owner = "yetone";
        repo = "avante.nvim";
        rev = "cc7a41262e4dc38003b7578c3553a75c0ec4b8d2";
        sha256 = "sha256-+tsKEMnVd8jd6WabMfOXrWLb+xWiH56LSNgFdz3H7DM=";
      };
    });
  };
}
