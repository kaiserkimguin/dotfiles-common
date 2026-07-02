local theme = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
if vim.fn.filereadable(theme) == 1 then
  return dofile(theme)
end
return {}
