return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buf, desc = desc })
        end
        map("n", "]h", function()
          gs.nav_hunk("next")
        end, "Next hunk")
        map("n", "[h", function()
          gs.nav_hunk("prev")
        end, "Prev hunk")
        map("n", "<leader>ghs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame line")
        map("n", "<leader>ghd", gs.diffthis, "Diff this")
      end,
    },
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" } },
  },
}
