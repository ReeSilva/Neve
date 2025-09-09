{ lib, config, ... }: {
  options = {
    treesitter-nvim.enable = lib.mkEnableOption "Enable treesitter-nvim module";
  };
  config = lib.mkIf config.treesitter-nvim.enable {
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;
          disable = ''
            function(lang, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                  return true
              end
            end
          '';
        };
        indent = { enable = true; };
        autopairs = { enable = true; };
        folding = { enable = false; };
        ensure_installed = [
          "bash"
          "json"
          "hcl"
          "lua"
          "luadoc"
          "luap"
          "nix"
          "markdown"
          "markdown_inline"
          "query"
          "regex"
          "terraform"
          "typescript"
          "vim"
          "vimdoc"
          "toml"
          "yaml"
          "gotmpl"
          "helm"
          "go"
        ];
        auto_install = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<C-space>";
            node_incremental = "<C-space>";
            scope_incremental = false;
            node_decremental = "<bs>";
          };
        };
      };
      nixvimInjections = true;
    };

    plugins.treesitter-textobjects = {
      enable = true;
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "aa" = "@parameter.outer";
          "ia" = "@parameter.inner";
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          "ic" = "@class.inner";
          "ii" = "@conditional.inner";
          "ai" = "@conditional.outer";
          "il" = "@loop.inner";
          "al" = "@loop.outer";
          "at" = "@comment.outer";
        };
      };
      move = {
        enable = true;
        gotoNextStart = {
          "]m" = "@function.outer";
          "]]" = "@class.outer";
        };
        gotoNextEnd = {
          "]M" = "@function.outer";
          "][" = "@class.outer";
        };
        gotoPreviousStart = {
          "[m" = "@function.outer";
          "[[" = "@class.outer";
        };
        gotoPreviousEnd = {
          "[M" = "@function.outer";
          "[]" = "@class.outer";
        };
      };
      swap = {
        enable = true;
        swapNext = { "<leader>a" = "@parameters.inner"; };
        swapPrevious = { "<leader>A" = "@parameter.outer"; };
      };
    };

    plugins.ts-autotag = { enable = false; };

    plugins.treesitter-context = { enable = true; };

    plugins.ts-context-commentstring = {
      enable = true;
      disableAutoInitialization = false;
    };
  };
}
