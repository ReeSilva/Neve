final: prev: {
  vimPlugins = prev.vimPlugins // {
    avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs (_old: {
      version = "0.0.27-unstable-2025-10-16";
      src = final.fetchFromGitHub {
        owner = "yetone";
        repo = "avante.nvim";
        rev = "fb2852006789c148c58f28612e458c0213bae6af";
        sha256 = "sha256-4Mq7ypksGUehZ+Dm+16pQLqXSy8JP7RBCJcOdzY2epo=";
      };
    });
  };
}
