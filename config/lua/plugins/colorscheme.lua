return {
  { "ellisonleao/gruvbox.nvim", priority = 1000, event = "VeryLazy" },
  { "sainnhe/everforest", priority = 1000, event = "VeryLazy" },
  { "rebelot/kanagawa.nvim", priority = 1000, event = "VeryLazy" },
  { "EdenEast/nightfox.nvim", priority = 1000, event = "VeryLazy" },
  { "Mofiqul/dracula.nvim", priority = 1000, event = "VeryLazy" },
  { "oxfist/night-owl.nvim", priority = 1000, event = "VeryLazy" },
  { "Wansmer/serenity.nvim", priority = 1000, event = "VeryLazy" },
  { "folke/tokyonight.nvim", priority = 1000, event = "VeryLazy" },
  { "mcchrish/zenbones.nvim", dependencies = "rktjmp/lush.nvim", priority = 1000, event = "VeryLazy" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    event = "VeryLazy",
    opts = {
      no_underline = true,
      show_end_of_buffer = true,
    },
  },
  {
    "LazyVim/LazyVim",
    dependencies = "vague2k/huez.nvim",
    opts = {
      news = { lazyvim = false },
      colorscheme = function()
        local colorscheme = require("huez.api").get_colorscheme()
        vim.cmd("colorscheme " .. colorscheme)
      end,
    },
  },
  {
    "vague2k/huez.nvim",
    opts = {
      -- Does not work somehow :(
      -- file_path = vim.fs.normalize("~/.nvim.huez.lua"),
      picker = "telescope",
      fallback = "retrobox",
      omit = {
        "desert",
        "evening",
        "industry",
        "koehler",
        "morning",
        "murphy",
        "pablo",
        "peachpuff",
        "ron",
        "shine",
        "slate",
        "torte",
        "zellner",
        "blue",
        "darkblue",
        "delek",
        "quiet",
        "elflord",
        "lunaperche",
        "sorbet",
        "vim",
        "wildcharm",
        "zaibatsu",
        "minicyan",
        "minischeme",
        "randomhue",
      },
    },
    keys = {
      { "<leader>uC", "<cmd>Huez<cr>", desc = "Select colorscheme" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>uC", false },
    },
  },
}
