return {
  {
    "2KAbhishek/nerdy.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
    keys = {
      { "<leader>n", "<cmd>Nerdy<CR>", "Pick icon" },
    },
  },
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    config = true,
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open Oil" },
    },
    opts = {
      default_file_explorer = true,
      columns = {
        "icon",
        "size",
      },
    },
  },
}
