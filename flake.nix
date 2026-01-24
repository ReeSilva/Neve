{
  description = "Neve is a Neovim configuration built with Nixvim, which allows you to use Nix language to manage Neovim plugins/options";

  inputs = {

    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:nix-community/nixvim";
    mcphub-nvim = {
      url = "github:ravitemer/mcphub.nvim";
      inputs.nixpkgs.follows = "nixvim/nixpkgs";
    };
    mcp-hub = {
      url = "github:ravitemer/mcp-hub";
      inputs.nixpkgs.follows = "nixvim/nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix?ref=main";
      inputs.nixpkgs.follows = "nixvim/nixpkgs";
    };
    opencode = {
      url = "github:anomalyco/opencode";
    };
    pangaea = {
      url = "git+https://codeberg.org/reesilva/pangaea?ref=feat/v2";
      inputs = {
        nixpkgs.follows = "nixvim/nixpkgs";
        opencode.follows = "opencode";
        mcp-hub.follows = "mcp-hub";
      };
    };
    rustacean.url = "github:mrcjkb/rustaceanvim";
  };

  outputs =
    {
      self,
      nixvim,
      flake-utils,
      mcphub-nvim,
      mcp-hub,
      llm-agents,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        config = import ./config;
        pkgs = import inputs.nixvim.inputs.nixpkgs {
          inherit system;
        };

        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nvim = nixvim'.makeNixvimWithModule {
          # inherit pkgs;
          module = config;
          extraSpecialArgs = {
            inherit self;
            inherit mcphub-nvim;
            inherit mcp-hub;
            inherit inputs;
            inherit llm-agents;
          };
        };
      in
      {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "Neve";
          };
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
