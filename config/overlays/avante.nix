final: prev: {
  vimPlugins = prev.vimPlugins // {
    avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs (_old: {
      version = "0.0.27-unstable-2025-10-25";
      src = final.fetchFromGitHub {
        owner = "yetone";
        repo = "avante.nvim";
        rev = "7e9f7b57de46534a9113980ec950a2b05eb8861f";
        sha256 = "sha256-5kyttSOLDX1M0rC+9mhW4dD2U/0ry9bKBqkJBE+m3tQ=";
      };
    });
  };
}
