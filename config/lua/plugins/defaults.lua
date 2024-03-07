return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      render = "compact",
    },
  },
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          enabled = false,
        },
        search = {
          enabled = false,
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      pickers = {
        lsp_dynamic_workspace_symbols = { symbol_width = 60 },
        lsp_document_symbols = { symbol_width = 60 },
      },
      defaults = {
        mappings = {
          i = {
            ["<c-h>"] = "which_key",
            ["<c-d>"] = require("telescope.actions").delete_buffer,
          },
          n = {
            ["<c-d>"] = require("telescope.actions").delete_buffer,
          },
        },
      },
    },
  },
}
