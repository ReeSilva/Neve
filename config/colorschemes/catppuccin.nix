{ lib, config, ... }: {
  options = {
    catppuccin.enable = lib.mkEnableOption "Enable catppuccin module";
    catppuccin.flavour = lib.mkOption {
      type = lib.types.str;
      default = "frappe";
      description = "Flavour for Catppuccin Colorscheme";
    };
  };
  config = lib.mkIf config.catppuccin.enable {
    colorschemes = {
      catppuccin = {
        enable = true;
        settings = {
          inherit (config.catppuccin) flavour;
          background = {
            light = "macchiato";
            dark = "mocha";
          };
          disable_bold = false;
          disable_italic = false;
          disable_underline = false;
          transparent_background = true;
          term_colors = true;
          integrations = {
            cmp = true;
            noice = true;
            notify = true;
            neotree = true;
            harpoon = true;
            gitsigns = true;
            which_key = true;
            illuminate = { enabled = true; };
            treesitter = true;
            treesitter_context = true;
            telescope.enabled = true;
            indent_blankline.enabled = true;
            mini.enabled = true;
            native_lsp = {
              enabled = true;
              inlay_hints = { background = true; };
              underlines = {
                errors = [ "underline" ];
                hints = [ "underline" ];
                information = [ "underline" ];
                warnings = [ "underline" ];
              };
            };
          };
        };
      };
    };
  };
}
