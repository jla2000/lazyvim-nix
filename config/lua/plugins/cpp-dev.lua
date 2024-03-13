return {
  {
    "hfn92/cmake-gtest.nvim",
    dependencies = {
      "nvimtools/none-ls.nvim",
    },
    ft = { "cpp" },
    config = function()
      local cmake_gtest = require("cmake-gtest")
      local overseer = require("overseer")

      cmake_gtest.setup({
        gtest_quickfix_opts = { show = "only_on_error" },
        hooks = {
          run = function(_, _, cwd, cmd, args, env)
            local task = overseer.new_task({
              cmd = cmd,
              cwd = cwd,
              args = { '"' .. args[1] .. '"' },
              name = string.match(args[1], "[%w_.]+$"),
              env = env,
            })
            task:start()
            overseer.open({ enter = false })
          end,
        },
      })

      require("null-ls").register({
        name = "GTestActions",
        method = { require("null-ls").methods.CODE_ACTION },
        filetypes = { "cpp" },
        generator = {
          fn = function()
            local actions = require("cmake-gtest").get_code_actions()
            if actions == nil then
              return
            end
            local result = {}
            for idx, v in ipairs(actions.display) do
              table.insert(result, { title = v, action = actions.fn[idx] })
            end
            return result
          end,
        },
      })
    end,
  },
  {
    "stevearc/overseer.nvim",
    event = "VeryLazy",
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 20,
        height = 20,
      },
    },
    keys = {
      { "<leader>o", "<cmd>OverseerToggle!<cr>", desc = "Toggle overseer" },
    },
  },
  {
    "Civitasv/cmake-tools.nvim",
    event = false,
    opts = {
      cmake_regenerate_on_save = false,
      cmake_build_options = { "-j12" },
      cmake_soft_link_compile_commands = true,
      cmake_executor = {
        name = "quickfix",
        opts = {
          show = "only_on_error",
        },
      },
      cmake_runner = {
        name = "overseer",
        opts = {
          on_new_task = function(task)
            require("overseer").open({ enter = false })
            task.name = string.match(task.name, "[%w_]+$")
          end,
        },
      },
      cmake_notifications = {
        runner = { enabled = false },
      },
    },
    keys = {
      { "<leader>cx", "<cmd>CMakeStop<CR>", desc = "CMake Stop" },
      { "<leader>cb", "<cmd>CMakeBuild<CR>", desc = "CMake Build" },
      { "<leader>cg", "<cmd>CMakeGenerate<CR>", desc = "CMake Regenerate" },
      { "<leader>ce", "<cmd>CMakeRun<CR>", desc = "CMake Execute" },
      { "<leader>cd", "<cmd>CMakeDebug<CR>", desc = "CMake Debug" },
      { "<leader>cs", "<cmd>CMakeSelectCwd<CR>", desc = "CMake PWD" },
      { "<leader>ct", "<cmd>CMakeSelectLaunchTarget<CR>", desc = "CMake Launch Target" },
      { "<leader>cc", "<cmd>CMakeSettings<CR>", desc = "CMake Settings" },
      { "<leader>cp", "<cmd>CMakeSelectConfigurePreset<CR>", desc = "CMake Presets" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cpp = { "clang_format", "doxyformat" },
        cmake = { "cmake_format" },
      },
      formatters = {
        doxyformat = {
          command = "doxyformat",
          args = { "-i", "$FILENAME" },
          stdin = false,
          condition = function(self, ctx)
            return string.match(ctx.dirname, "amsr%-vector%-fs%-ipcbinding") ~= nil
          end,
        },
        cmake_format = {
          prepend_args = { "--autosort=true" },
        },
      },
    },
  },
  {
    "jla2000/msr-nvim-tools",
    enabled = false,
    ft = "cpp",
    dir = "~/code/msr-nvim-tools",
    config = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "rcarriga/nvim-notify",
      "L3MON4D3/LuaSnip",
    },
    keys = {
      {
        "<leader>ba",
        "<cmd>BauhausAnalyze<CR>",
        desc = "Bauhaus Single File Analysis",
      },
    },
  },
}
