return {
  "scottmckendry/cyberdream.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("cyberdream").setup({
      -- Optional: customize colorscheme settings
      transparent = false,
      italic_comments = true,
      hide_fillchars = true,
      borderless_telescope = false,
      modern_sidebar = true,
    })
    -- Set black background before colorscheme loads to prevent flash
    vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#000000" })
    -- Apply colorscheme
    vim.cmd.colorscheme("cyberdream")
    -- Reapply black background immediately after colorscheme loads
    vim.schedule(function()
      vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "LineNr", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#000000" })
    end)
  end,
}
