{ inputs, pkgs, neovim-nightly, lib, ... }:
let
  # Build plugins from github
  huez-nvim = pkgs.vimUtils.buildVimPlugin { name = "huez.nvim"; src = inputs.huez-nvim; };
  blame-me-nvim = pkgs.vimUtils.buildVimPlugin { name = "blame-me.nvim"; src = inputs.blame-me-nvim; };
  cmake-tools-nvim = pkgs.vimUtils.buildVimPlugin { name = "cmake-tools.nvim"; src = inputs.cmake-tools-nvim; };
  cmake-gtest-nvim = pkgs.vimUtils.buildVimPlugin { name = "cmake-gtest.nvim"; src = inputs.cmake-gtest-nvim; };
  symbol-usage-nvim = pkgs.vimUtils.buildVimPlugin { name = "symbol-usage.nvim"; src = inputs.symbol-usage-nvim; };
  yanky-nvim = pkgs.vimUtils.buildVimPlugin { name = "yanky.nvim"; src = inputs.yanky-nvim; };

  # List of all plugins to install
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
    tmux-navigator
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
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
