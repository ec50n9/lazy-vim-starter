-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- 关闭 markdown 文件中的拼写检查，避免红色波浪线
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown.mdx" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- 或者，如果你想完全禁用 LazyVim 默认的 wrap + spell 自动命令组，可以取消下面这行的注释：
-- vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- im-select: Esc 切英文，进入插入模式恢复之前的输入法（fcitx5）
if vim.fn.executable("im-select") == 1 then
  local grp = vim.api.nvim_create_augroup("ImSelect", { clear = true })
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = grp,
    callback = function() vim.fn.jobstart({ "im-select", "save" }) end,
  })
  vim.api.nvim_create_autocmd("InsertEnter", {
    group = grp,
    callback = function() vim.fn.jobstart({ "im-select", "restore" }) end,
  })
  -- 退出 nvim 时恢复输入法，避免终端里停留在英文
  vim.api.nvim_create_autocmd("VimLeave", {
    group = grp,
    callback = function() vim.fn.system({ "im-select", "restore" }) end,
  })
end
