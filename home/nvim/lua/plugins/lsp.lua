return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = { "clangd" },
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
