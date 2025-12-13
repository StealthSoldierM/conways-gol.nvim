-- SPDX-License-Identifier: MIT
local gol = require('conway')

vim.api.nvim_buf_create_user_command(0, 'Conway', gol.open, {})

vim.api.nvim_set_keymap('n', '<leader>cg', ':Conway<CR>', { noremap = true, silent = true, })
