{
  lib,
  config,
  ...
}:
{
  options.niquisvim.ui.edgy.enable = lib.mkEnableOption "Enable edgy.nvim for Niquisvim";
  config =
    let
      cfg = config.niquisvim.ui.edgy;
    in
    lib.mkIf cfg.enable {
      plugins.edgy = {
        enable = true;
        settings = {
          animate = {
            enable = true;
            fps = 120;
            cps = 120;
          };
          options = {
            left.size = 40;
            right.size = 125;
            bottom.size = 20;
          };
          bottom = [
            {
              ft = "snacks_terminal";
              title = "> terminal";
              filter = lib.nixvim.utils.mkRaw /* lua */ ''
                function(_buf, win)
                  return vim.w[win].snacks_win
                    and vim.w[win].snacks_win.position == "bottom"
                    and vim.w[win].snacks_win.relative == "editor"
                    and not vim.w[win].trouble_preview
                end
              '';
            }
            "Trouble"
            {
              ft = "qf";
              title = "QuickFix";
            }
          ];
          left = [
            {
              title = "Buffers";
              ft = "neo-tree";
              filter = lib.nixvim.utils.mkRaw /* lua */ ''
                function(buf)
                  return vim.b[buf].neo_tree_source == "buffers"
                end
              '';
              pinned = true;
              open = "Neotree position=left buffers";
            }
            {
              title = "Neo-Tree";
              ft = "neo-tree";
              filter = lib.nixvim.utils.mkRaw /* lua */ ''
                function(buf)
                  return vim.b[buf].neo_tree_source == "filesystem"
                end
              '';
              pinned = true;
              open = "Neotree position=left";
            }
            {
              title = "Outline";
              ft = "sagaoutline";
              open = "Lspsaga outline";
              pinned = true;
            }
          ];
          right = [
            {
              title = "Maurício Kubrusly";
              ft = "codecompanion";
            }
            {
              ft = "snacks_terminal";
              title = "> terminal";
              filter = lib.nixvim.utils.mkRaw /* lua */ ''
                function(_buf, win)
                  return vim.w[win].snacks_win
                    and vim.w[win].snacks_win.position == "right"
                    and vim.w[win].snacks_win.relative == "editor"
                    and not vim.w[win].trouble_preview
                end
              '';
            }
          ];
        };
      };
    };
}
