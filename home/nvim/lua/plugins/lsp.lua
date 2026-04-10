return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = { "/etc/profiles/per-user/markie/bin/clangd" },
        },
        pyright = {
          cmd = { "pyright-langserver", "--stdio" },
        },
        ruff = {
          cmd = { "ruff", "server" },
        },
        lua_ls = {
          cmd = { "lua-language-server" },
        },
        jdtls = {
          cmd = { "jdtls" },
        },
      },
    },
  },
}
