return {
  {
    "nemanjamalesija/ts-expand-hover.nvim",
    opts = {
      keymaps = { hover = false }, -- replaces vim.lsp.buf.hover
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        -- It falls back to vim.lsp.buf.hover() when no supported TS server is
        -- attached, so this is safe globally.
        -- Must live here (not a FileType autocmd): LazyVim sets K on LspAttach,
        -- which fires after FileType and would overwrite a FileType mapping.
        ["*"] = {
          keys = {
            {
              "K",
              function()
                require("ts_expand_hover").hover()
              end,
              desc = "Hover",
            },
          },
        },
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
        tsc = {
          capabilities = { experimental = { hoverVerbosityLevel = true } },
          settings = { ["js/ts"] = { maximumHoverLength = 5000 } },
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
