
  return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
    },
    config = function()
      vim.g.loaded_netrwPlugin = 1
      require("oil").setup({
        default_file_explorer = true,
        view_options = {
          show_hidden = true,
        },
        columns = {
          "icon",
          "permissions",
          "size",
          -- "mtime",
        },
        keymaps = {},
      })
      vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, desc = "Open Parent Directory" })
      vim.keymap.set("n", "<leader>-", "<cmd>Oil .<CR>", { noremap = true, desc = "Open nvim root directory" })
    end,
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    lazy = false,
  }
