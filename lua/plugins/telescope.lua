return {
  'nvim-telescope/telescope.nvim', branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "tiagovla/scope.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
  },
  lazy = true,
  cmd = { "Telescope", "TodoTelescope" },
  init = function()
        -- Setup mappings
    require'user.configs.keymaps.init'.add({
      mode = { "n" },
      { "<Leader>f", group="Find" },
      { "<Leader>ff", function() return require("telescope.builtin").find_files() end, desc="Find Files" },
      { "<Leader>fg", function() return require("telescope.builtin").live_grep() end, desc="Grep" },
      { "<Leader>fb", function() return require("telescope.builtin").buffers() end, desc="Buffers" },
      { "<Leader>fr", function() return require("telescope.builtin").oldfiles() end, desc="Recent Files" },
      { "<Leader>fh", function() return require("telescope.builtin").help_tags() end, desc="Help" },
      { "<Leader>fc", function() return require("telescope.builtin").grep_string() end, desc="Grep String Under Cursor" },
      { "<Leader>ft", "<CMD>TodoTelescope=TODO,FIX,FIXME,BUG<CR>", desc="Find todos" },
    })
  end,
  config = function(_, opts)
    opts = opts and opts or {}
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_layout = require("telescope.actions.layout")

    opts = vim.tbl_deep_extend('force', opts, {
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
            ["<C-k>"] = actions.move_selection_previous, -- move up in search results
            ["<C-j>"] = actions.move_selection_next, -- move down in search results
          },
        },
      }
    })

    telescope.setup(opts)
    telescope.load_extension("scope")
    telescope.load_extension("fzf")
  end,
}
