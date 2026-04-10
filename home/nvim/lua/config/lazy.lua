-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to continue..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- base LazyVim
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- ── Languages ──────────────────────────────────────────────────────────
    { import = "lazyvim.plugins.extras.lang.java"   },
    { import = "lazyvim.plugins.extras.lang.python" },

    -- ── Your plugins ───────────────────────────────────────────────────────
    { import = "plugins" },
  },
  defaults = {
    lazy    = false,
    version = false, -- always latest
  },
  install  = { colorscheme = { "tokyonight", "habamax" } },
  checker  = { enabled = true }, -- auto-check for plugin updates
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})
