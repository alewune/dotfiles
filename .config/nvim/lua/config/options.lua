local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false -- lualine shows it
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.pumheight = 12
opt.winborder = "rounded"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " " }

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftround = true
opt.smartindent = true
opt.virtualedit = "block"
opt.confirm = true
opt.clipboard = "unnamedplus" -- system clipboard
opt.mouse = "a"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

-- Files / performance
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = { "menu", "menuone", "noselect" }
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }

-- Folding via treesitter, but start fully open
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevelstart = 99
