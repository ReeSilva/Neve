{lib, config, ... }:
{
  options = {
    dial.enable = lib.mkEnableOption "Enable dial module";
  };
  config = lib.mkIf config.dial.enable {
    keymaps = [
      {
        mode = "n";
        key = "<C-a>";
        action = lib.nixvim.utils.mkRaw ''
          function()
            require("dial.map").manipulate("increment", "normal")
          end
        '';
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "<C-x>";
        action = lib.nixvim.utils.mkRaw ''
          function()
            require("dial.map").manipulate("decrement", "normal")
          end
        '';
      }
      {
        mode = "n";
        key = "g<C-a>";
        action = lib.nixvim.utils.mkRaw ''
          function()
            require("dial.map").manipulate("increment", "gnormal")
          end
        '';
      }
      {
        mode = "n";
        key = "g<C-x>";
        action = lib.nixvim.utils.mkRaw ''
          function()
            require("dial.map").manipulate("decrement", "gnormal")
          end
        '';
      }
      {
        mode = "x";
        key = "<C-a>";
        action = lib.nixvim.utils.mkRaw ''
          function()
            require("dial.map").manipulate("increment", "visual")
          end
        '';
      }
      {
        mode = "x";
        key = "<C-x>";
        action = lib.nixvim.utils.mkRaw ''
          function()
            require("dial.map").manipulate("decrement", "visual")
          end
        '';
      }
      {
        mode = "x";
        key = "g<C-a>";
        action = lib.nixvim.utils.mkRaw ''
          function()
            require("dial.map").manipulate("increment", "gvisual")
          end
        '';
      }
      {
        mode = "x";
        key = "g<C-x>";
        action = lib.nixvim.utils.mkRaw ''
          function()
            require("dial.map").manipulate("decrement", "gvisual")
          end
        '';
      }
    ];
    plugins.dial = {
      enable = true;
      luaConfig.post = /* lua */ ''
        local augend = require("dial.augend")
        require("dial.config").augends:register_group{
          default = {
            augend.integer.alias.decimal,
            augend.integer.alias.hex,
            augend.date.alias["%Y/%m/%d"],
            augend.date.alias["%d/%m/%Y"],
            augend.date.alias["%d.%m.%Y"],
            augend.date.alias["%Y-%m-%d"],
            augend.constant.alias.de_weekday,
            augend.constant.alias.de_weekday_full,
            augend.constant.alias.en_weekday,
            augend.constant.alias.en_weekday_full,
            augend.constant.alias.bool,
            augend.constant.alias.Bool,
            augend.constant.alias.alpha,
            augend.constant.alias.Alpha,
            augend.semver.alias.semver,
          },
        }
      '';
    };
  };
}
