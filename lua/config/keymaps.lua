-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- 1. 快速退出插入模式 (非常常用)
-- 输入 jk 即可退出编辑模式，不用去按 ESC
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- 3. 移动选中的行 (Visual 模式下)
-- 选中几行代码，按 J 或 K 上下移动
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up" })

-- 4. 取消高亮 (搜索后)
-- LazyVim 默认可能是 <leader>ur，很多人习惯用 <leader>h
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear highlight" })
