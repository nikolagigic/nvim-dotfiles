return {
  "nvim-treesitter/nvim-treesitter", 
  branch = 'master', 
  lazy = false, 
  build = ":TSUpdate",
  auto_install = true,
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { "html", "css", "javascript", "typescript", "python", "rust", "go", "lua" },
      auto_install = true,
      highlight = {
        enable = true,
      },
    }
  end,
}
