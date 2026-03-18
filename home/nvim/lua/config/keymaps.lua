-- Keymaps — твої хоткеї
-- LazyVim вже має багато хоткеїв, тут тільки додаткові

local map = vim.keymap.set

-- ── Загальні ───────────────────────────────────────────────────────────────
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- ── Переміщення між сплітами (без Ctrl-W prefix) ───────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })

-- ── Переміщення рядків у visual mode ───────────────────────────────────────
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- ── Зберегти ───────────────────────────────────────────────────────────────
map({ "n", "i" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })

-- ── Буфери ─────────────────────────────────────────────────────────────────
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })

-- ── Terminal ───────────────────────────────────────────────────────────────
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ── Quickfix ───────────────────────────────────────────────────────────────
map("n", "<leader>qo", "<cmd>copen<CR>",  { desc = "Open quickfix" })
map("n", "<leader>qn", "<cmd>cnext<CR>",  { desc = "Next quickfix" })
map("n", "<leader>qp", "<cmd>cprev<CR>",  { desc = "Prev quickfix" })
