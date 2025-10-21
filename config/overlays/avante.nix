final: prev: {
  vimPlugins = prev.vimPlugins // {
    avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs (_old: {
      version = "0.0.27-unstable-2025-10-16";
      src = final.fetchFromGitHub {
        owner = "yetone";
        repo = "avante.nvim";
        rev = "3c3eca85181e3e7f466010251b09351dcfa4e043";
        sha256 = "sha256-4Mq7ypksGUehZ+Dm+16pQLqXSy8JP7RBCJcOdzY2epo=";
      };
    });
  };
}
