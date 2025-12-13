return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered({
          border = "rounded",
          winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,PmenuSel:CmpSel,CursorLineNr:CmpSel,Search:None",
        }),
        documentation = cmp.config.window.bordered({
          border = "rounded",
        }),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = string.format("%s", vim_item.kind)
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
    })

    -- Function to set highlights
    local function set_cmp_highlights()
      -- Background for the menu
      vim.api.nvim_set_hl(0, "CmpPmenu", { bg = "#000000", fg = "#ffffff", default = true })
      -- Selected item highlight - very bright and visible (yellow background)
      vim.api.nvim_set_hl(0, "CmpSel", { bg = "#f1ff5e", fg = "#000000", bold = true, default = true })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#f1ff5e", fg = "#000000", bold = true, default = true })
      -- Also set CursorLine to match - this is key for visibility
      vim.api.nvim_set_hl(0, "CmpCursorLine", { bg = "#f1ff5e", fg = "#000000", bold = true, default = true })
      -- Border
      vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#ffffff", bold = true, default = true })
      -- Item kind (unselected)
      vim.api.nvim_set_hl(0, "CmpItemKind", { fg = "#f1ff5e", bold = true, default = true })
      -- Item menu (unselected)
      vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#acacac", italic = true, default = true })
      -- Item abbreviation (unselected)
      vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#ffffff", default = true })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#f1ff5e", bold = true, default = true })
      -- Selected item colors - high contrast
      vim.api.nvim_set_hl(0, "CmpItemAbbrSelected", { fg = "#000000", bold = true, default = true })
      vim.api.nvim_set_hl(0, "CmpItemKindSelected", { fg = "#000000", bold = true, default = true })
      vim.api.nvim_set_hl(0, "CmpItemMenuSelected", { fg = "#000000", italic = true, default = true })
      
      -- Also use vim.cmd as fallback to ensure it works
      vim.cmd("highlight CmpSel guibg=#f1ff5e guifg=#000000 gui=bold")
      vim.cmd("highlight PmenuSel guibg=#f1ff5e guifg=#000000 gui=bold")
      vim.cmd("highlight CmpCursorLine guibg=#f1ff5e guifg=#000000 gui=bold")
    end

    -- Set highlights initially
    set_cmp_highlights()

    -- Reapply highlights after colorscheme loads
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = set_cmp_highlights,
    })
    
    -- Also reapply on VeryLazy to ensure it's set after all plugins load
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = set_cmp_highlights,
    })
  end,
}

