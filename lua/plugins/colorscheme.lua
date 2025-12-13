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
    vim.cmd.colorscheme("cyberdream")
  end,
}
