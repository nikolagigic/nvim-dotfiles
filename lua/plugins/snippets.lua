return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local luasnip = require("luasnip")
    local types = require("luasnip.util.types")

    luasnip.setup({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { "choice", "Comment" } },
          },
        },
      },
    })

    -- Load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}

