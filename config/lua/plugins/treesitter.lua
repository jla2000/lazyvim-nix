return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ia"] = "@parameter.inner",
            ["aa"] = "@parameter.outer",
            ["ix"] = "@comment.inner",
            ["ax"] = "@comment.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]a"] = "@parameter.inner",
            ["]m"] = "@function.outer",
          },
          goto_next_end = {
            ["]A"] = "@parameter.outer",
            ["]M"] = "@function.outer",
          },
          goto_previous_start = {
            ["[a"] = "@parameter.outer",
            ["[m"] = "@function.outer",
          },
          goto_previous_end = {
            ["[A"] = "@parameter.outer",
            ["[M"] = "@function.outer",
          },
        },
      },
    },
  },
}
