return {
  -- Lua LSP knowledge for the nvim API
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", cmd = "Mason", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
        update_in_insert = false,
        virtual_text = { spacing = 2, prefix = "●" },
        float = { border = "rounded", source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      })

      -- Shared settings for every server
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            hint = { enable = true },
          },
        },
      })

      -- Install servers, and auto-enable them via vim.lsp.enable()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "bashls", "pyright", "ts_ls", "jsonls", "yamlls", "marksman" },
        automatic_enable = true,
      })

      -- Formatters (used by conform.nvim)
      require("mason-tool-installer").setup({
        ensure_installed = { "stylua", "prettier", "shfmt", "ruff" },
      })

      -- Buffer-local keymaps. Neovim 0.11+ already provides defaults:
      --   K hover, grn rename, gra code action, grr references, gri implementation,
      --   gO symbols, <C-s> (insert) signature help, [d ]d diagnostics.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(ev)
          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          local tb = function(fn)
            return function()
              require("telescope.builtin")[fn]()
            end
          end
          map("n", "gd", tb("lsp_definitions"), "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gr", tb("lsp_references"), "References")
          map("n", "gI", tb("lsp_implementations"), "Implementations")
          map("n", "gy", tb("lsp_type_definitions"), "Type definition")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
          map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            map("n", "<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
            end, "Toggle inlay hints")
          end
        end,
      })
    end,
  },
}
