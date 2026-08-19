-- ============================================================
-- KEYMAPS
-- ============================================================

local map = vim.keymap.set

local opts = {
  noremap = true,
  silent = true,
}

-- ============================================================
-- INSERT
-- ============================================================

map("i", "jk", "<Esc>", {
  desc = "Sair do modo de inserção",
})

-- ============================================================
-- SALVAR
-- ============================================================

map("n", "<leader>fs", "<cmd>w<cr>", {
  desc = "Salvar arquivo",
})

map("n", "<leader>fq", "<cmd>wq<cr>", {
  desc = "Salvar e fechar",
})

map("n", "<leader>fa", "<cmd>wa<cr>", {
  desc = "Salvar todos",
})

-- ============================================================
-- SAIR
-- ============================================================

map("n", "<leader>qq", "<cmd>qa<cr>", {
  desc = "Sair do Neovim",
})

map("n", "<leader>qQ", "<cmd>qa!<cr>", {
  desc = "Sair sem salvar",
})

-- ============================================================
-- BUFFERS
-- ============================================================

map("n", "<leader>bd", "<cmd>bd<cr>", {
  desc = "Fechar buffer",
})

map("n", "<leader>bD", "<cmd>bd!<cr>", {
  desc = "Fechar buffer sem salvar",
})

map("n", "<leader>bn", "<cmd>bnext<cr>", {
  desc = "Próximo buffer",
})

map("n", "<leader>bp", "<cmd>bprevious<cr>", {
  desc = "Buffer anterior",
})

-- ============================================================
-- JANELAS
-- ============================================================

map("n", "<leader>wv", "<cmd>vsplit<cr>", {
  desc = "Split vertical",
})

map("n", "<leader>ws", "<cmd>split<cr>", {
  desc = "Split horizontal",
})

map("n", "<leader>wq", "<cmd>close<cr>", {
  desc = "Fechar janela",
})

-- ============================================================
-- NAVEGAÇÃO ENTRE JANELAS
-- ============================================================

map("n", "<C-h>", "<C-w>h", {
  desc = "Janela esquerda",
})

map("n", "<C-j>", "<C-w>j", {
  desc = "Janela abaixo",
})

map("n", "<C-k>", "<C-w>k", {
  desc = "Janela acima",
})

map("n", "<C-l>", "<C-w>l", {
  desc = "Janela direita",
})

-- ============================================================
-- MOVIMENTO
-- ============================================================

map("n", "<C-d>", "<C-d>zz", {
  desc = "Descer",
})

map("n", "<C-u>", "<C-u>zz", {
  desc = "Subir",
})

map("n", "n", "nzzzv", {
  desc = "Próximo resultado",
})

map("n", "N", "Nzzzv", {
  desc = "Resultado anterior",
})

-- ============================================================
-- INDENTAÇÃO
-- ============================================================

map("v", "<", "<gv", {
  desc = "Diminuir indentação",
})

map("v", ">", ">gv", {
  desc = "Aumentar indentação",
})

-- ============================================================
-- MOVER LINHAS
-- ============================================================

map("n", "<A-j>", "<cmd>m .+1<cr>==", {
  desc = "Mover linha para baixo",
})

map("n", "<A-k>", "<cmd>m .-2<cr>==", {
  desc = "Mover linha para cima",
})

map("v", "<A-j>", ":m '>+1<cr>gv=gv", {
  desc = "Mover seleção para baixo",
})

map("v", "<A-k>", ":m '<-2<cr>gv=gv", {
  desc = "Mover seleção para cima",
})

-- ============================================================
-- DIAGNÓSTICOS
-- ============================================================

map("n", "<leader>xd", vim.diagnostic.open_float, {
  desc = "Mostrar diagnóstico",
})

map("n", "<leader>xq", vim.diagnostic.setloclist, {
  desc = "Lista de diagnósticos",
})

-- ============================================================
-- TERMINAL
-- ============================================================

map("n", "<leader>ot", "<cmd>terminal<cr>", {
  desc = "Terminal",
})
