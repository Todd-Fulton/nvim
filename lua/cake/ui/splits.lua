local M = {}

--- Check if this split is at the top edge of the window
---@return boolean
function M.at_top_edge()
  return vim.fn.winnr() == vim.fn.winnr('k')
end

--- Check if this split is at the bottom edge of the window
---@return boolean
function M.at_bottom_edge()
  return vim.fn.winnr() == vim.fn.winnr('j')
end

--- Check if this split is at the left edge of the window
---@return boolean
function M.at_left_edge()
  return vim.fn.winnr() == vim.fn.winnr('h')
end

--- Check if this split is at the right edge of the window
---@return boolean
function M.at_right_edge()
  return vim.fn.winnr() == vim.fn.winnr('l')
end

--- Check if this split is in the middle of the window vertically
---@return boolean
function M.between_top_and_bottom()
  return not (M.at_bottom_edge() or M.at_top_edge())
end

--- Check if this split is in the middle of the window horizontally
---@return boolean
function M.between_left_and_right()
  return not (M.at_left_edge() or M.at_right_edge())
end


function M.resize_split(d)
  local v = vim.api

  d = d or "left" -- default to left if d is falsey

  local lr = d == "left" or d == "right"
  -- 5 for left right, 3 for up down
  local amt = lr and 3 or 1

  local w = v.nvim_win_get_width(0)
  local h = v.nvim_win_get_height(0)

  local win = 0

  if lr then
    local l = M.at_left_edge()
    local r = M.at_right_edge()
    -- If we are leftmost and rightmost, don't resize
    if l and r then
      return
    elseif not (l or r) then
      if d == "left" then
        amt = -amt
      end
    elseif d == "left" and l then
      amt = -amt
    elseif d == "right" and r then
      amt = -amt
    end
  else
    local t = M.at_top_edge()
    local b = M.at_bottom_edge()

    -- If we are topmost and bottommost, don't resize
    if t and b then
      return
    elseif not (t or b) then
      if d == "up" then
        amt = -amt
      end
    elseif d == "up" and t then
      amt = -amt
    elseif d == "down" and b then
      amt = -amt
    end
  end

  if lr then
    v.nvim_win_set_width(win, w + amt)
  else
    v.nvim_win_set_height(win, h + amt)
  end
end

return M
