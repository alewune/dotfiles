return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- prebuilt fuzzy binaries
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      keymap = { preset = "enter" }, -- <CR> accept, <C-n>/<C-p> select, <C-space> open docs
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
    },
  },
}
