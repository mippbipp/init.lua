local data_path = vim.fn.stdpath("config") .. "/lua/plugins/data"
local markdownlint_cli2_path = data_path .. "/.markdownlint.jsonc"

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        oxfmt = {},
        ["markdownlint-cli2"] = {
          args = { "--config", markdownlint_cli2_path, "--fix", "$FILENAME" },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", markdownlint_cli2_path, "--" },
        },
      },
    },
  },
}
