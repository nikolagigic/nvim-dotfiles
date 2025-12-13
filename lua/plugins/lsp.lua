return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "rust_analyzer",
          "gopls",
          "ts_ls",
          "html",
          "cssls",
          "jsonls",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Keymaps for diagnostics
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open diagnostic" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics list (location list)" })
      -- Open all diagnostics in quickfix list
      vim.keymap.set("n", "<leader>d", function()
        vim.diagnostic.setqflist()
      end, { desc = "Open all diagnostics in quickfix" })
      -- Open workspace diagnostics in quickfix
      vim.keymap.set("n", "<leader>D", function()
        vim.diagnostic.setqflist({ severity = vim.diagnostic.severity })
      end, { desc = "Open workspace diagnostics" })

      -- on_attach function for LSP clients
      local on_attach = function(client, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
        nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        nmap("<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")
        nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
        nmap("<leader>f", function()
          local ok, conform = pcall(require, "conform")
          if ok and conform then
            conform.format({ async = true, lsp_fallback = true })
          else
            vim.lsp.buf.format({ async = true })
          end
        end, "[F]ormat code")
      end

      -- Setup language servers
      local servers = {
        "pyright",
        "rust_analyzer",
        "gopls",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
      }

      -- Setup Lua LSP with special configuration
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      -- Setup other language servers
      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
          on_attach = on_attach,
        })
        vim.lsp.enable(server)
      end

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = true,
        signs = false, -- Disable diagnostic signs to avoid indentation issues
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
    end,
  },
}

