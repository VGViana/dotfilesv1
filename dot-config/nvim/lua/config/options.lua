-- ============================================================
-- OPTIONS
-- ============================================================

local opt = vim.opt

-- ============================================================
-- APARÊNCIA
-- ============================================================

opt.termguicolors = true

opt.number = true
opt.relativenumber = false

opt.cursorline = true
opt.cursorcolumn = false

opt.signcolumn = "yes"

opt.laststatus = 3
opt.showmode = false
opt.ruler = false
opt.cmdheight = 1

-- ============================================================
-- NAVEGAÇÃO
-- ============================================================

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.splitbelow = true
opt.splitright = true

opt.mouse = "a"

-- ============================================================
-- CLIPBOARD
-- ============================================================

-- Wayland / wl-clipboard
opt.clipboard = "unnamedplus"

-- ============================================================
-- EDIÇÃO
-- ============================================================

opt.expandtab = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

opt.smartindent = true

opt.wrap = false
opt.breakindent = true
opt.linebreak = true

-- ============================================================
-- ARQUIVOS
-- ============================================================

opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.undofile = true

opt.encoding = "utf-8"

-- ============================================================
-- PERFORMANCE
-- ============================================================

opt.updatetime = 200
opt.timeoutlen = 400

opt.lazyredraw = false

-- ============================================================
-- PESQUISA
-- ============================================================

opt.ignorecase = true
opt.smartcase = true

opt.incsearch = true
opt.hlsearch = true

-- ============================================================
-- COMPLETION
-- ============================================================

opt.completeopt = {
  "menu",
  "menuone",
}

-- ============================================================
-- MARKDOWN / TEXTO
-- ============================================================

opt.conceallevel = 2

-- ============================================================
-- INTERFACE
-- ============================================================

opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "▾",
  foldclose = "▸",
  foldsep = " ",
  diff = "╱",
  msgsep = "─",
}

-- ============================================================
-- DIAGNÓSTICOS
-- ============================================================

vim.diagnostic.config({
  virtual_text = false,

  signs = true,

  underline = true,

  update_in_insert = false,

  severity_sort = true,

  float = {
    border = "rounded",
    source = "if_many",
  },
})
