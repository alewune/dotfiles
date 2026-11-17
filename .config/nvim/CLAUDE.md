# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A hand-written, modular Neovim config (Neovim 0.12, lazy.nvim, Tokyo Night). It is **not** LazyVim, even though the parent `~/.config/CLAUDE.md` says so. It has no build or test step.

## Commands

- Format Lua: `stylua .` (config in `stylua.toml`: 2 spaces, 120 columns)
- Smoke-test startup headless: `nvim --headless "+Lazy! load all" +qa` (any error prints to stderr)
- Sync plugins headless: `nvim --headless "+Lazy! sync" +qa`
- Install mason tools headless: `nvim --headless "+MasonToolsInstallSync" +qa`
- Treesitter parsers install asynchronously, so a headless run needs `require('nvim-treesitter').install({...}):wait(ms)` to finish them.
- In a shell here `ls` is aliased to `eza`. Use `command ls`.

## Architecture

Load order is fixed in `init.lua`: leader keys, then `config.options`, `config.keymaps`, `config.autocmds`, then `config.lazy`, which bootstraps lazy.nvim and imports every file in `lua/plugins/`.

- `lua/config/` holds the non-plugin settings. Global keymaps and autocmds live here. Plugin keymaps live in the plugin's own spec (`keys = {}` or `on_attach`) so lazy-loading works.
- `lua/plugins/` has one file per concern. Add a plugin by adding a spec to the matching file, or a new file. lazy.nvim defaults to `lazy = true`, so give each spec an `event`, `cmd`, `keys` or `ft` trigger, or `lazy = false`.

Cross-file wiring that needs several files to understand:

- **LSP** (`plugins/lsp.lua`): uses the native `vim.lsp.config()` API, not the old `lspconfig.X.setup()` calls. mason-lspconfig's `automatic_enable = true` calls `vim.lsp.enable()` for the `ensure_installed` servers. Per-server overrides go in `vim.lsp.config("<name>", {...})`. Capabilities come from `blink.cmp` through `vim.lsp.config("*", ...)`. Neovim's built-in LSP maps (`K`, `grn`, `gra`, `grr`, `gri`, `[d`/`]d`) are kept, and extra maps are added in the `LspAttach` autocmd.
- **Formatters** are two lists that must stay in sync. conform's `formatters_by_ft` is in `plugins/formatting.lua`, and the matching binaries are installed by mason-tool-installer's `ensure_installed` in `plugins/lsp.lua`.
- **Lua editing:** `lazydev.nvim` (in `lsp.lua`) feeds the nvim API to `lua_ls` and is also registered as a blink.cmp source in `completion.lua`.
- **Treesitter** uses the `main` branch API: `require("nvim-treesitter").install{}` plus a `FileType` autocmd that calls `vim.treesitter.start`. It does not use `ensure_installed` or `configs.setup`, and it needs the `tree-sitter` CLI. `options.lua` also sets treesitter folding.
- **oil.nvim** is `lazy = false` so it can hijack directory buffers, and it is the file explorer. There is no neo-tree or nvim-tree.
- **Which-key groups** are declared in `plugins/ui.lua`. When you add a new `<leader>x` prefix, add a group there.

## Conventions

- Leader is `Space`, local leader is `\`. Keymaps always carry a `desc`.
- Font: kitty uses JetBrains Mono. The Nerd Font glyphs used in the config come from the installed `ttf-nerd-fonts-symbols` fallback.
