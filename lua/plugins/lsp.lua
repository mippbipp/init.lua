local function ts_filter_diagnostics(err, result, ctx)
  if result and result.diagnostics then
    -- Code 6196 is "Unused variable" in standard TypeScript (tsserver)
    local ignored_codes = { [6196] = true }
    local filtered = {}

    for _, diagnostic in ipairs(result.diagnostics) do
      -- Filter out only if it's the specific code AND severity is Hint (4)
      if not (ignored_codes[diagnostic.code] and diagnostic.severity == 4) then
        table.insert(filtered, diagnostic)
      end
    end
    result.diagnostics = filtered
  end
  vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
end

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
        vtsls = {
          handlers = {
            ["textDocument/publishDiagnostics"] = ts_filter_diagnostics,
          },
        },
        oxlint = {},
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
