-- ============================================================
-- AUTOCMDS
-- ============================================================

local group = vim.api.nvim_create_augroup("ViniciusConfig", {
  clear = true,
})

-- ============================================================
-- PESQUISA
-- ============================================================

vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = group,
  pattern = { "/", "?" },

  callback = function()
    vim.opt.hlsearch = true
  end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
  group = group,

  callback = function()
    if vim.v.hlsearch == 1 and vim.fn.searchcount().total == 0 then
      vim.cmd("nohlsearch")
    end
  end,
})

-- ============================================================
-- RESTAURAR POSIÇÃO DO CURSOR
-- ============================================================

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,

  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')

    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ============================================================
-- TEXTO / MARKDOWN
-- ============================================================

vim.api.nvim_create_autocmd("FileType", {
  group = group,

  pattern = {
    "markdown",
    "text",
    "gitcommit",
  },

  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
  end,
})

-- ============================================================
-- CÓDIGO
-- ============================================================

vim.api.nvim_create_autocmd("FileType", {
  group = group,

  pattern = {
    "lua",
    "sh",
    "bash",
    "json",
    "yaml",
    "toml",
    "python",
    "javascript",
    "typescript",
  },

  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.spell = false
  end,
})

-- ============================================================
-- TERMINAL
-- ============================================================

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,

  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.cursorline = false
  end,
})
