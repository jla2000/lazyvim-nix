{ inputs, pkgs, neovim-nightly, lib, ... }:
let
  # List of all plugins to install
  plugins = import ./plugins.nix { inherit pkgs inputs; };

  # Link together all plugins into a single derivation
  mkEntryFromDrv = drv:
    if lib.isDerivation drv then
      { name = "${lib.getName drv}"; path = drv; }
    else
      drv;
  lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);

  # Link together all treesitter grammars into single derivation
  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };

  # Create derivation containing the lua configuration files
  luaconfig = pkgs.stdenv.mkDerivation {
    name = "luaconfig";
    src = ./config;
    installPhase = ''
      mkdir -p $out/
      cp -r ./ $out/
    '';
  };

  # codelldb executable is not exported by default
  codelldb = (pkgs.writeShellScriptBin "codelldb" ''
    ${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb "$@"
  '');
in
{
  extraPackages = with pkgs; [
    # LazyVim dependencies
    lazygit
    ripgrep
    fd

    # LSP's
    lua-language-server
    clang-tools
    nil
    taplo
    rust-analyzer

    # Debuggers
    codelldb

    # Formatters
    stylua
    nixpkgs-fmt
  ];

  package = neovim-nightly;
  extraPlugins = [ pkgs.vimPlugins.lazy-nvim ];

  extraConfigLua = /* lua */ ''
    require("lazy").setup({
      defaults = { lazy = true },
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
        { "jaybaby/mason-nvim-dap.nvim", enabled = false },
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
}
