return {
  -- Suggestions come from the native inline completion API, enabled by the
  -- `lazyvim.plugins.extras.ai.copilot-native` extra.
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "<C-e>",
        function()
          vim.lsp.inline_completion.get()
        end,
        mode = "i",
        desc = "Accept Copilot suggestion",
      },
    },
  },
}
