-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- 行号设置
vim.opt.relativenumber = true -- 相对行号 (如果不习惯，设为 false 即可显示普通行号)
vim.opt.number = true -- 显示当前行号

-- 自动换行
vim.opt.wrap = false -- 代码通常不换行 (改为 true 则开启换行)

-- 光标行为
vim.opt.scrolloff = 8 -- 光标移动到屏幕边缘时保留 8 行距离

-- 忽略大小写搜索
vim.opt.ignorecase = true
vim.opt.smartcase = true -- 如果输入大写字母，则开启大小写敏感

-- 剪切板 (默认已开启与系统同步，如果遇到问题可以强制开启)
vim.opt.clipboard = "unnamedplus"

require("config.os").setup()
pcall(require, "config.local")
