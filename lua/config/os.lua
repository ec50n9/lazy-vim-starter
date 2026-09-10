local M = {}

local uname = vim.uv and vim.uv.os_uname() or vim.loop.os_uname()

M.sysname = uname.sysname
M.is_macos = M.sysname == "Darwin"
M.is_linux = M.sysname == "Linux"
M.is_ssh = vim.env.SSH_TTY ~= nil or vim.env.SSH_CLIENT ~= nil

local function setup_ssh_clipboard()
  local function paste()
    return {
      vim.fn.split(vim.fn.getreg(""), "\n"),
      vim.fn.getregtype(""),
    }
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end

function M.setup()
  if M.is_ssh then
    setup_ssh_clipboard()
  end
end

return M
