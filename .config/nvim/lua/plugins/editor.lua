return {
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true<cr>", desc = "Buffers" },
      {
        "<leader>fc",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Config files",
      },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (cwd)" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", mode = { "n", "x" }, desc = "Word under cursor" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer lines" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command history" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  -- File explorer as a buffer: `-` opens the parent directory
  {
    "stevearc/oil.nvim",
    lazy = false, -- so `nvim some/dir` opens oil
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>e", "<cmd>Oil<cr>", desc = "File explorer" },
    },
    opts = {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      view_options = { show_hidden = true },
      keymaps = { ["<C-h>"] = false, ["<C-l>"] = false, ["q"] = "actions.close" },
    },
  },

  -- Text objects, surround, auto pairs
  {
    "echasnovski/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.surround").setup() -- gsa / gsd / gsr
      require("mini.pairs").setup()
    end,
  },
}
