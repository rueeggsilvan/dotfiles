local cmd = vim.cmd -- to execute vim commands without any output
local fn = vim.fn -- to execute vim functions
local u = require("util")

vim.g.mapleader = " " -- Set leader to space.
vim.o.termguicolors = true -- Enable termguicolor support.

-- Load Plugins
require("plugins")

-- Automatically deletes all trailing whitespace and newlines at end of file on
-- save.
cmd([[
function! TrimTrailingLines()
  let lastLine = line('$')
  let lastNonblankLine = prevnonblank(lastLine)
  if lastLine > 0 && lastNonblankLine != lastLine
    silent! execute lastNonblankLine + 1 . ',$delete _'
  endif
endfunction
augroup remove_trailing_whitespaces_and_lines
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
  autocmd BufWritepre * call TrimTrailingLines()
augroup END
]])

-- Indentation
vim.opt.autoindent = true -- Allow filetype plugins and syntax highlighting
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.joinspaces = false -- No double spaces with join after a dot
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.smarttab = true -- Automatically tab to the next softtabstop
vim.opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while performing edition operations, like inserting a <Tab> or using <BS>
vim.opt.tabstop = 2 -- Number of spaces tabs count for

-- Key mappings
local opts = { noremap = true, silent = true }
-- remap "<ESC>" to "ii"
u.map("i", "ii", "<ESC>", opts)
