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
      colorscheme = "tokyonight-storm",
    },
  },
}
