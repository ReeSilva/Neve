{
  description = "Neve is a Neovim configuration built with Nixvim, which allows you to use Nix language to manage Neovim plugins/options";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?shallow=1";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:nix-community/nixvim";
    mcphub-nvim = {
      url = "github:ravitemer/mcphub.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-hub = {
      url = "github:ravitemer/mcp-hub";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "github:anomalyco/opencode?ref=v1.2.24";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rustacean = {
      url = "github:mrcjkb/rustaceanvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixvim,
      flake-utils,
      mcphub-nvim,
      mcp-hub,
      llm-agents,
      nixpkgs,
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
            pkgs-master = import nixpkgs {
              inherit (pkgs.stdenv.hostPlatform) system;
            };
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
