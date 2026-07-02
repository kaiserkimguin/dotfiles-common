-- Follow the machine's theme switcher (dotfiles-arch), same pattern as
-- omarchy-theme.lua: the switcher generates a tiny spec setting the
-- LazyVim colorscheme; fall back to everforest where no switcher runs.
local theme = vim.fn.expand("~/.config/theme-switcher/nvim.lua")
if vim.fn.filereadable(theme) == 1 then
  return dofile(theme)
end
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
