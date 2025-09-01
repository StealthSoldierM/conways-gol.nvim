-- SPDX-License-Identifier: MIT

local M = {}

local state = {
  buf = nil,
  win = nil,
  timer = nil,
  grid = {},
  width = 40,
  height = 20,
  running = false,
}


local alive_char = '*'
local dead_char = '.'



local function init_grid()
  state.grid = {}
  for y = 1, state.height do
    state.grid[y] = {}
    for x = 1, state.width do
      state.grid[y][x] = math.random() < 0.3 and 1 or 0 -- random seeds
    end
  end
end

local function neighbors(x, y)
  local count = 0
  for dy = -1, 1 do
    for dx = -1, 1 do
      if not (dx == 0 and dy == 0) then
        local nx, ny = x + dx, y + dy
        if nx >= 1 and nx <= state.width and ny >= 1 and ny <= state.height then
          count = count + state.grid[ny][nx]
        end
      end
    end
  end
  return count
end


local function step()
  local new_grid = {}
  for y = 1, state.height do
    new_grid[y] = {}
    for x = 1, state.width do
      local num = neighbors(x, y)
      local cell = state.grid[y][x]
      if cell == 1 and (num == 2 or num == 3) then
        new_grid[y][x] = 1
      elseif cell == 0 and num == 3 then
        new_grid[y][x] = 1
      else
        new_grid[y][x] = 0
      end
    end
  end
  state.grid = new_grid
end

local function render()
  if not vim.api.nvim_buf_is_valid(state.buf) then return end
  local lines = {}
  for y = 1, state.height do
    local row = {}
    for x = 1, state.width do
      table.insert(row, state.grid[y][x] == 1 and alive_char or dead_char)
    end
    table.insert(lines, table.concat(row, ' '))
  end
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
end


local function stop()
  if state.timer then
    state.timer:stop()
    state.timer:close()
    state.timer = nil
  end
  state.running = false
end


local function start()
  if state.running then return end
  state.running = true
  state.timer = vim.loop.new_timer()
  state.timer:start(0, 200, vim.schedule_wrap(function()
    step()
    render()
  end))
end

function M.togggle()
  if state.running then stop() else start() end
end


function M.open()
  if state.win and vim.api.nvim_win_is_valid(state.win) then return end
  init_grid()

  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = state.buf })
  vim.api.nvim_set_option_value('modifiable', true, { buf = state.buf })


  local width = state.width * 2
  local height = state.height

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
  }

  state.win = vim.api.nvim_open_win(state.buf, true, opts)

  vim.keymap.set('n', 'q', M.close, { buffer = state.buf, nowait = true })
  vim.keymap.set('n', 'p', M.togggle, { buffer = state.buf, nowait = true })

  render()
  start()
end

function M.close()
  stop()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end
  state.win, state.buf = nil, nil
end

return M
