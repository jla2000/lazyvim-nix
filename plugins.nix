{ pkgs, inputs, lib, ... }:
let
  # Build plugins from github
  huez-nvim = pkgs.vimUtils.buildVimPlugin { name = "huez.nvim"; src = inputs.huez-nvim; };
  blame-me-nvim = pkgs.vimUtils.buildVimPlugin { name = "blame-me.nvim"; src = inputs.blame-me-nvim; };
  cmake-tools-nvim = pkgs.vimUtils.buildVimPlugin { name = "cmake-tools.nvim"; src = inputs.cmake-tools-nvim; };
  cmake-gtest-nvim = pkgs.vimUtils.buildVimPlugin { name = "cmake-gtest.nvim"; src = inputs.cmake-gtest-nvim; };

  mkEntryFromDrv = drv:
    if lib.isDerivation drv then
      { name = "${lib.getName drv}"; path = drv; }
    else
      drv;

  plugins = with pkgs.vimPlugins; [
    LazyVim
    better-escape-nvim
    clangd_extensions-nvim
    cmp-buffer
    cmp-nvim-lsp
    cmp-path
    cmp_luasnip
    conform-nvim
    crates-nvim
    dracula-nvim
    dressing-nvim
    flash-nvim
    friendly-snippets
    gitsigns-nvim
    headlines-nvim
    indent-blankline-nvim
    kanagawa-nvim
    lualine-nvim
    marks-nvim
    neo-tree-nvim
    neoconf-nvim
    neodev-nvim
    neorg
    nix-develop-nvim
    noice-nvim
    none-ls-nvim
    nui-nvim
    nvim-cmp
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
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
    oil-nvim
    overseer-nvim
    persistence-nvim
    plenary-nvim
    project-nvim
    rust-tools-nvim
    sqlite-lua
    telescope-fzf-native-nvim
    telescope-nvim
    tmux-navigator
    todo-comments-nvim
    tokyonight-nvim
    trouble-nvim
    vim-illuminate
    vim-startuptime
    vscode-nvim
    which-key-nvim
    { name = "LuaSnip"; path = luasnip; }
    { name = "blame-me.nvim"; path = blame-me-nvim; }
    { name = "catppuccin"; path = catppuccin-nvim; }
    { name = "cmake-gtest.nvim"; path = cmake-gtest-nvim; }
    { name = "cmake-tools.nvim"; path = cmake-tools-nvim; }
    { name = "huez.nvim"; path = huez-nvim; }
    { name = "mini.ai"; path = mini-nvim; }
    { name = "mini.bufremove"; path = mini-nvim; }
    { name = "mini.comment"; path = mini-nvim; }
    { name = "mini.indentscope"; path = mini-nvim; }
    { name = "mini.pairs"; path = mini-nvim; }
    { name = "mini.surround"; path = mini-nvim; }
    { name = "yanky.nvim"; path = yanky-nvim; }
  ];
in
# Link together all plugins into a single derivation
pkgs.linkFarm "lazyvim-nix-plugins" (builtins.map mkEntryFromDrv plugins)
