{ lib, config, pkgs, mcp-hub, mcphub-nvim, ...}:
{
  options.niquisvim.ai.mcphub.enable = lib.mkEnableOption "Install MCP Hub for Niquisvim";
  config = 
    let
      cfg = config.niquisvim.ai.mcphub;
    in lib.mkIf cfg.enable {
      extraPlugins = [ mcphub-nvim.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      extraConfigLua = /* lua */ ''
        require("mcphub").setup({
          port = 3000,
          config = vim.fn.expand("~/.config/mcphub/servers.json"),
          cmd = "${ lib.getExe' mcp-hub.packages.${pkgs.stdenv.hostPlatform.system}.default "mcp-hub" }",
          extensions = {
            avante = {
              make_slash_commands = true,
            }
          }
        })
      '';
    };
}
