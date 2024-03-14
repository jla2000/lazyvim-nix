local hints_toggled = true
local hints_enabled = true

return {
  {
    "simrat39/rust-tools.nvim",
    opts = {
      tools = {
        inlay_hints = {
          auto = false,
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "<leader>uh",
        function()
          vim.lsp.inlay_hint.enable(0, not hints_toggled)
          hints_toggled = not hints_toggled
        end,
        desc = "Toggle inlay hints",
      },
    },
    opts = {
      inlay_hints = {
        enabled = hints_enabled,
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              hint = { enable = hints_enabled },
            },
          },
        },
        clangd = {
          inlay_hints = hints_enabled,
        },
      },
    },
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
