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
            {
              ft = "dapui_console";
              title = "DAP Console";
              size.width = 70;
            }
            {
              ft = "dap-repl";
              size.width = 30;
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
              size.height = 20;
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
              size.height = 50;
            }
            {
              title = "Outline";
              ft = "sagaoutline";
              open = "Lspsaga outline";
              size.height = 30;
            }
            {
              ft = "dapui_scopes";
              title = "DAP Scopes";
            }
            {
              ft = "dapui_breakpoints";
              title = "DAP Breakpoints";
            }
          ];
          right = [
            {
              title = "Maurício Kubrusly";
              ft = "codecompanion";
              pinned = true;
            }
            {
              ft = "dapui_stacks";
              title = "DAP Stacks";
            }
            {
              ft = "dapui_watches";
              title = "DAP Watches";
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
