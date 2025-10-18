final: prev: {
  vimPlugins = prev.vimPlugins // {
    avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs (_old: {
      version = "0.0.27-unstable-2025-10-16";
      src = final.fetchFromGitHub {
        owner = "yetone";
        repo = "avante.nvim";
        rev = "f0ad738e5aa15605a73d34b3b0a803b48e47d519";
        sha256 = "sha256-+tsKEMnVd8jd6WabMfOXrWLb+xWiH56LSNgFdz3H7DM=";
      };
    });
  };
}
