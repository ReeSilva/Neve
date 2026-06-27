{
  description = "Neve is a Neovim configuration built with Nixvim, which allows you to use Nix language to manage Neovim plugins/options";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master?shallow=1";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:nix-community/nixvim/main";
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
      url = "github:anomalyco/opencode";
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
        pkgs-master = nixpkgs.legacyPackages.${system};
        # opencode = inputs.llm-agents.packages.${system}.opencode;
        opencode = inputs.opencode.packages.${system}.default;

        nvim = nixvim.lib.evalNixvim {
          inherit system;
          modules = [ ./config ];
          extraSpecialArgs = {
            inherit self;
            inherit mcphub-nvim;
            inherit mcp-hub;
            inherit inputs;
            inherit llm-agents;
            inherit pkgs-master;
            inherit opencode;
          };
        };
      in
      {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nvim.config.build.test;
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim.config.build.package;
        };

        formatter = pkgs-master.nixfmt-rfc-style;
      }
    );
}
