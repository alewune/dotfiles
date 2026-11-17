local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank"),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Reload files changed outside nvim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Restore last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Equalize splits on terminal resize
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize"),
  command = "tabdo wincmd =",
})

-- Close helper windows with q
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "help", "qf", "man", "checkhealth", "lspinfo", "notify" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
  end,
})

-- Wrap and spell for prose
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Create missing parent dirs on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("mkdir"),
  callback = function(ev)
    if ev.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    vim.fn.mkdir(vim.fn.fnamemodify(vim.uv.fs_realpath(ev.match) or ev.match, ":p:h"), "p")
  end,
})
