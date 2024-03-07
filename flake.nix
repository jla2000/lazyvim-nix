{
  description = "Setup LazyVim using NixVim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-parts.follows = "flake-parts";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    neovim-nightly.url = "github:neovim/neovim?dir=contrib";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";

    # Plugins not available in nixpkgs
    huez-nvim = { url = "github:vague2k/huez.nvim"; flake = false; };
    blame-me-nvim = { url = "github:hougesen/blame-me.nvim"; flake = false; };
    cmake-tools-nvim = { url = "github:Civitasv/cmake-tools.nvim"; flake = false; };
    symbol-usage-nvim = { url = "github:Wansmer/symbol-usage.nvim"; flake = false; };
    cmake-gtest-nvim = { url = "github:hfn92/cmake-gtest.nvim"; flake = false; };
    yanky-nvim = { url = "github:gbprod/yanky.nvim"; flake = false; };
  };

  outputs = { self, nixpkgs, nixvim, flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = { pkgs, lib, system, ... }:
        let
          # Build plugins from github
          huez-nvim = pkgs.vimUtils.buildVimPlugin { name = "huez.nvim"; src = inputs.huez-nvim; };
          blame-me-nvim = pkgs.vimUtils.buildVimPlugin { name = "blame-me.nvim"; src = inputs.blame-me-nvim; };
          cmake-tools-nvim = pkgs.vimUtils.buildVimPlugin { name = "cmake-tools.nvim"; src = inputs.cmake-tools-nvim; };
          cmake-gtest-nvim = pkgs.vimUtils.buildVimPlugin { name = "cmake-gtest.nvim"; src = inputs.cmake-gtest-nvim; };
          symbol-usage-nvim = pkgs.vimUtils.buildVimPlugin { name = "symbol-usage.nvim"; src = inputs.symbol-usage-nvim; };
          yanky-nvim = pkgs.vimUtils.buildVimPlugin { name = "yanky.nvim"; src = inputs.yanky-nvim; };

          # Create derivation containing the lua configuration files
          luaconfig = pkgs.stdenv.mkDerivation {
            name = "luaconfig";
            src = ./config;
            installPhase = ''
              mkdir -p $out/
              cp -r ./ $out/
            '';
          };

          config = {
            extraPackages = with pkgs; [
              # LazyVim dependencies
              lazygit
              ripgrep
              fd
              # LSP's
              lua-language-server
              clang-tools
              nil
              # Formatters
              stylua
              nixpkgs-fmt
            ];

            package = inputs.neovim-nightly.packages.${system}.neovim;
            extraPlugins = [ pkgs.vimPlugins.lazy-nvim ];

            extraConfigLua =
              let
                plugins = with pkgs.vimPlugins; [
                  # Extra plugins
                  oil-nvim
                  neorg
                  crates-nvim
                  rust-tools-nvim
                  none-ls-nvim
                  marks-nvim
                  overseer-nvim
                  better-escape-nvim
                  clangd_extensions-nvim
                  { name = "yanky.nvim"; path = yanky-nvim; }
                  { name = "huez.nvim"; path = huez-nvim; }
                  { name = "blame-me.nvim"; path = blame-me-nvim; }
                  { name = "cmake-tools.nvim"; path = cmake-tools-nvim; }
                  { name = "symbol-usage.nvim"; path = symbol-usage-nvim; }
                  { name = "cmake-gtest.nvim"; path = cmake-gtest-nvim; }

                  # LazyVim
                  LazyVim
                  bufferline-nvim
                  cmp-buffer
                  cmp-nvim-lsp
                  cmp-path
                  cmp_luasnip
                  conform-nvim
                  dashboard-nvim
                  dressing-nvim
                  flash-nvim
                  friendly-snippets
                  gitsigns-nvim
                  indent-blankline-nvim
                  lualine-nvim
                  neo-tree-nvim
                  neoconf-nvim
                  neodev-nvim
                  noice-nvim
                  nui-nvim
                  nvim-cmp
                  nvim-lint
                  nvim-lspconfig
                  nvim-notify
                  nvim-spectre
                  nvim-treesitter
                  nvim-treesitter-context
                  nvim-treesitter-textobjects
                  nvim-ts-autotag
                  nvim-ts-context-commentstring
                  nvim-web-devicons
                  persistence-nvim
                  plenary-nvim
                  telescope-fzf-native-nvim
                  telescope-nvim
                  todo-comments-nvim
                  tokyonight-nvim
                  trouble-nvim
                  vim-illuminate
                  vim-startuptime
                  which-key-nvim
                  project-nvim
                  { name = "LuaSnip"; path = luasnip; }
                  { name = "catppuccin"; path = catppuccin-nvim; }
                  { name = "mini.ai"; path = mini-nvim; }
                  { name = "mini.bufremove"; path = mini-nvim; }
                  { name = "mini.comment"; path = mini-nvim; }
                  { name = "mini.indentscope"; path = mini-nvim; }
                  { name = "mini.pairs"; path = mini-nvim; }
                  { name = "mini.surround"; path = mini-nvim; }
                ];
                mkEntryFromDrv = drv:
                  if lib.isDerivation drv then
                    { name = "${lib.getName drv}"; path = drv; }
                  else
                    drv;
                lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
                treesitter-parsers = pkgs.symlinkJoin {
                  name = "treesitter-parsers";
                  paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
                };
              in
                /* lua */ ''
                require("lazy").setup({
                  defaults = {
                    lazy = true,
                  },
                  dev = {
                    -- reuse files from pkgs.vimPlugins.*
                    path = "${lazyPath}",
                    patterns = { "." },
                    -- fallback to download
                    fallback = false,
                  },
                  spec = {
                    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
                    --{ import = "lazyvim.plugins.extras.coding.yanky" },
                    { import = "lazyvim.plugins.extras.dap.core" },
                    { import = "lazyvim.plugins.extras.lang.clangd" },
                    { import = "lazyvim.plugins.extras.lang.cmake" },
                    { import = "lazyvim.plugins.extras.lang.markdown" },
                    { import = "lazyvim.plugins.extras.lang.rust" },
                    { import = "lazyvim.plugins.extras.lang.yaml" },
                    { import = "lazyvim.plugins.extras.lsp.none-ls" },
                    { import = "lazyvim.plugins.extras.test.core" },
                    { import = "lazyvim.plugins.extras.util.project" },
                    -- The following configs are needed for fixing lazyvim on nix
                    -- force enable telescope-fzf-native.nvim
                    { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
                    -- disable mason.nvim, use config.extraPackages
                    { "williamboman/mason-lspconfig.nvim", enabled = false },
                    { "williamboman/mason.nvim", enabled = false },
                    -- uncomment to import/override with your plugins
                    { import = "plugins" },
                    -- put this line at the end of spec to clear ensure_installed
                    { 
                      "nvim-treesitter/nvim-treesitter",
                      init = function()
                        -- Put treesitter path as first entry in rtp
                        vim.opt.rtp:prepend("${treesitter-parsers}")
                      end,
                      opts = { auto_install = false, ensure_installed = {} },
                    },
                  },
                  performance = {
                    rtp = {
                      paths = { "${luaconfig}" },
                      disabled_plugins = {
                        "gzip",
                        "matchit",
                        "matchparen",
                        "netrwPlugin",
                        "tarPlugin",
                        "tohtml",
                        "tutor",
                        "zipPlugin",
                      }
                    }
                  },
                })'';
          };
          nixvim' = nixvim.legacyPackages."${system}";
          nvim = nixvim'.makeNixvim config;
        in
        {
          packages = {
            inherit nvim;
            default = nvim;
          };
        };
    };
}
