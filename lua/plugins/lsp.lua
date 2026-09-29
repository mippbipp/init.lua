return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        remark_ls = {
          settings = {
            remark = {
              requireConfig = true,
            },
          },
        },
        clangd = {
          mason = false, -- mason ships no aarch64 build; use nixpkgs clang-tools
        },
        qmlls = {
          mason = false,
        },
      },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        -- 1. Force the root directory to be the git root (to play nice with vscode settings)
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern(".git")(fname) or util.root_pattern("Cargo.toml")(fname)
        end,
      },
    },
  },
}
