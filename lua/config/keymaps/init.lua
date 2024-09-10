
local M = {}

-- TODO: Make configurable
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--- Stolen from https://github.com/AstroNvim/astrocore/blob/main/lua/astrocore/buffer.lua
--- Helper function to power a save confirmation prompt before `mini.bufremove`
---@param func fun(bufnr:integer,force:boolean?) The function to execute if confirmation is passed
---@param bufnr integer The buffer to close or the current buffer if not provided
---@param force? boolean Whether or not to foce close the buffers or confirm changes (default: false)
---@return boolean? # new value for whether to force save, `nil` to skip saving
local function mini_confirm(func, bufnr, force)
  if not force and vim.bo[bufnr].modified then
    local bufname = vim.fn.expand "%"
    local empty = bufname == ""
    if empty then bufname = "Untitled" end
    local confirm = vim.fn.confirm(('Save changes to "%s"?'):format(bufname), "&Yes\n&No\n&Cancel", 1, "Question")
    if confirm == 1 then
      if empty then return end
      vim.cmd.write()
    elseif confirm == 2 then
      force = true
    else
      return
    end
  end
  func(bufnr, force)
end

--- Get a plugin spec from lazy
---@param plugin string The plugin to search for
---@return LazyPlugin? available # The found plugin spec from Lazy
function M.get_plugin(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] or nil
end

function M.is_installed(plugin)
  return function() return M.get_plugin(plugin) ~= nil end
end


function M.exclusive(plugin, ...)
  local nos = {...}
  return function()
    if M.get_plugin(plugin) == nil then return false end
    for _, n in ipairs(nos) do
      if M.get_plugin(n) ~= nil then
        return false
      end
      return true
    end
  end
end

local enable_bufkeys = M.is_installed("bufferline.nvim")


-- TODO: Lift logic to packs of common plugins for which only one can be installed
local enable_fugit2 = M.exclusive("fugit2.nvim", "neogit")
local enable_neogit = M.exclusive("neogit", "fugit2.nvim")


function M.cmd(command)
  return "<cmd>" .. command .. "<cr>"
end

-- TODO: Set up dynamic key bindings using conditions, events, and which-key expand
M.mappings = {
  {
    mode = { "i" },
    { "jk", "<ESC>", desc = "Exit insert mode" },
  },
  {
    mode = { "n", "v" }, -- NORMAL and VISUAL mode
    { "<leader>q", "<cmd>confirm q<cr>", desc = "Quit Window" },
    { "<leader>Q", "<cmd>confirm qall<cr>", desc = "Exit" },
    { "<leader>w", "<cmd>w<cr>", desc = "Write" },
  },
  {
    mode = { "n", "i" },
    -- quick save
    { "<C-s>", "<Esc><CMD>silent! update! | redraw<CR>", desc = "Save File" }, -- change description but the same command

    -- switch buffer

  },
  {
    mode = { "n" },
    -- Buffer manipulation
    { "<Leader>b", group = "Buffers", cond = enable_bufkeys },
    { "<Leader>bb", M.cmd("BufferLinePick"), desc = "Pick", cond = enable_bufkeys },
    { "<Leader>bn", M.cmd("BufferLineCycleNext"), desc = "Next", cond = enable_bufkeys },
    { "<Leader>bp", M.cmd("BufferLineCyclePrev"), desc = "Prev", cond = enable_bufkeys },
    { "<Leader>br", M.cmd("BufferLineCloseRight"), desc = "Close buffers to the Left", cond = enable_bufkeys },
    { "<Leader>bl", M.cmd("BufferLineCloseLeft"), desc = "Close buffers to the Right", cond = enable_bufkeys },
    { "<C-m>", M.cmd("BufferLineCycleNext"), desc = "Next", cond = enable_bufkeys },
    { "<C-n>", M.cmd("BufferLineCyclePrev"), desc = "Prev", cond = enable_bufkeys },
    {
      "<Leader>c",
      function()
          mini_confirm(require("mini.bufremove").delete, 0, false)
      end,
      desc = "Close buffer"
    },

    -- Splits
    { "<Leader>s", group = "Split/Select" },
    { "<Leader>sv", "<C-w>v", desc = "Split verticle" },
    { "<Leader>sh", "<C-w>s", desc = "Split horizontal" },
    { "<C-\\>", "<C-w>v", desc = "Split verticle" },
    { "<C-Space>", "<C-w>s", desc = "Split horizontal" },
    { "<Leader>s=", "<C-w>=", desc = "Make split equal size" },
    { "<Leader>sx", "<CMD>close<CR>", desc = "Close split" },

    -- Toggles
    { "<Leader>t", group = "Toggle" },
    { "<Leader>th",
      function()
        vim.v.hlsearch = vim.v.hlsearch == 0 and 1 or 0
      end,
      desc = "Toggle search highlights"
    },

    -- Git
    { "<Leader>g", group = "Git"},
    { "<Leader>gv", M.cmd("Fugit2"), desc = "Open Fugit2", cond = enable_fugit2 },
    { "<Leader>gd", M.cmd("Fugit2Diff"), desc = "Open diff view", cond = enable_fugit2 },
    { "<Leader>gb", M.cmd("Fugit2Blame"), desc = "Open blame view", cond = enable_fugit2 },
    { "<Leader>gg", M.cmd("Fugit2Graph"), desc = "Open graph view", cond = enable_fugit2 },

    { "<Leader>gv", M.cmd("Neogit kind=floating"), desc = "Open Neogit", cond = enable_neogit },
  },
}


function M.add(maps)
  table.insert(M.mappings, maps)
end

return M
