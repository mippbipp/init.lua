return {
  -- modified from :LazyExtras
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default",
      -- fall through to the built-in behaviour
      ["<Tab>"] = { "fallback" },
      ["<S-Tab>"] = {},
      -- fall through to the <C-e> mapping in lua/plugins/ai.lua
      ["<C-e>"] = { "fallback" },
    },
  },
}
