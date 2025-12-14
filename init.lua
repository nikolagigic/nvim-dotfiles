-- Basic settings
vim.opt.termguicolors = true
vim.api.nvim_set_option("clipboard", "unnamed")

-- Line numbers (set after termguicolors to ensure visibility)
vim.opt.number = true
vim.opt.relativenumber = true

-- Scroll offset: keep lines above/below cursor for readability
vim.opt.scrolloff = 8

-- Function to set black background
local function set_black_background()
  vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#000000" })
end

-- Set black background immediately
set_black_background()

-- Set black background very early to prevent flash
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    set_black_background()
  end,
  once = true,
})

-- Ensure line numbers are visible and maintain black background
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Force line number visibility
    vim.opt.number = true
    vim.opt.relativenumber = true
    -- Maintain black background immediately after colorscheme loads
    set_black_background()
  end,
})

-- Indentation settings (2 spaces)
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.shiftwidth = 2     -- Number of spaces for auto-indent
vim.opt.tabstop = 2        -- Number of spaces a tab counts for
vim.opt.softtabstop = 2    -- Number of spaces for <Tab> key
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.autoindent = true  -- Copy indent from current line

-- Keymaps
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = false })

-- Remap 'd' and 'dd' to always use the black hole register
vim.keymap.set("n", "dd", [["_dd]])
vim.keymap.set("n", "d", [["_d]])
vim.keymap.set("v", "d", [["_d]])

-- Make 'x' behave like 'y' but cut (delete and yank)
-- 'x' now works as a cut operator with motions: xw (cut word), x$ (cut to end), etc.
-- 'xx' cuts the current line (like 'yy' yanks it)
vim.keymap.set("n", "x", "d", { desc = "Cut operator (works like y but cuts)" })
vim.keymap.set("n", "xx", "dd", { desc = "Cut current line" })
vim.keymap.set("v", "x", "d", { desc = "Cut selection" })
-- Preserve single character delete with 'dl' or use 'X' for backward delete
vim.keymap.set("n", "X", "X", { desc = "Delete character before cursor" })

-- Neo Tree
vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal toggle<CR>")
vim.keymap.set("n", "<C-e>", ":Neotree filesystem reveal focus<CR>")

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Replace word under cursor
vim.keymap.set("n", "<C-d>w", function()
  local word = vim.fn.expand("<cword>")
  vim.ui.input({ prompt = "Replace '" .. word .. "' with: " }, function(input)
    if input then
      vim.cmd("%s/\\<" .. vim.fn.escape(word, "/\\") .. "\\>/" .. vim.fn.escape(input, "/\\") .. "/gc")
    end
  end)
end, { desc = "Replace word under cursor" })

-- Clear search highlighting with Esc in normal mode
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlighting" })

-- Ensure colorscheme loads (fallback if plugin config doesn't run)
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.cmd.colorscheme("cyberdream")
    -- Set black background immediately after colorscheme loads
    set_black_background()
  end,
})

require("config.lazy")