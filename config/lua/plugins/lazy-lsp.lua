return {
  {
    "dundalek/lazy-lsp.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
      preferred_servers = {
        cpp = { "clangd", "marksman" },
      },
    },
  },
}
