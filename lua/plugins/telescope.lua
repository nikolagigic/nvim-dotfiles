return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      -- Check if fd is available, otherwise use default finder
      -- fd and rg work fine without .gitignore - they just won't ignore anything
      local find_command = nil
      if vim.fn.executable("fd") == 1 then
        find_command = {
          "fd",
          "--type",
          "f",
          "--hidden",
          "--exclude",
          ".git",
        }
      end

      telescope.setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules/",
            ".git/",
            ".DS_Store",
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
          },
        },
        pickers = {
          find_files = find_command and {
            find_command = find_command,
          } or nil, -- Use default finder if fd not available
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- Load fzf extension (only if available)
      pcall(telescope.load_extension, "fzf")

      -- Keybindings
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Commands" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })
    end,
  },
}

