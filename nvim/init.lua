-- Make Neovim see globally installed npm binaries (prettier, eslint_d)
vim.env.PATH = vim.env.PATH .. ":" .. "/home/adefolarin/.nvm/versions/node/v20.19.6/bin"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("plugins.vim-tmux-navigator")

-- function Transparent(color)
--   color = color or "tokyonight"
--   vim.cmd.colorscheme(color)
--   vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--   vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--   vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
-- end
-- Transparent()

-- added transparency to background
function Transparent(color)
  color = color or "tokyonight"
  vim.cmd.colorscheme(color)

  local groups = {
    "Normal",
    "NormalNC", -- inactive windows
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "EndOfBuffer",
    "LineNr",
    "FoldColumn",
    "StatusLine",
    "StatusLineNC",
    "VertSplit",
  }

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

Transparent()

-- Add this at the very top of your init.lua (or before lazy.nvim setup)
vim.env.PATH = "/home/linuxbrew/.linuxbrew/bin:" .. vim.env.PATH
