-- `query  *.nix` sugar for files/grep/grep_word.
-- Splits the prompt on the last double-space and passes the right-hand
-- side to ripgrep as `-g` globs (single, multiple and `!` negations).
-- Native `query -- -g *.nix` still passes through untouched.
local function glob_transform(picker, filter)
  local raw ---@type string?
  if picker and picker.input and picker.input.get then
    local ok, val = pcall(function()
      return picker.input:get()
    end)
    if ok and type(val) == "string" and val ~= "" then
      raw = val
    end
  end
  if not raw or raw == "" then
    raw = picker.opts.live and filter.search or filter.pattern
  end
  if not raw or raw == "" then
    return nil
  end
  if raw:find("%s%-%-%s") then
    return nil -- native `--` syntax: leave untouched
  end
  local q, g = raw:match("^(.*)  (.*)$")
  if not q then
    return nil
  end
  q = vim.trim(q)
  g = vim.trim(g)
  if g == "" then
    return nil -- dangling separator: trimmed clone already equals the query
  end
  local globs = {}
  for _, tok in ipairs(vim.split(g, "%s+")) do
    tok = vim.trim(tok:gsub("^['\"](.*)['\"]$", "%1"))
    if tok ~= "" then
      globs[#globs + 1] = tok
    end
  end
  if #globs == 0 then
    return nil
  end
  local args = {}
  for _, glob in ipairs(globs) do
    args[#args + 1] = "-g"
    args[#args + 1] = glob
  end
  -- Empty query keeps a leading space so `parse()` still splits off the args.
  filter.search = q .. " -- " .. table.concat(args, " ")
  if not picker.opts.live then
    filter.pattern = q
  end
  return true
end

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = { enabled = false },
    lazygit = { enabled = true },
    explorer = {
      replace_netrw = true,
    },
    picker = {
      hidden = true,
      dirs = {
        vim.uv.cwd(),
      },
      sources = {
        keymaps = {
          layout = { preset = "default", preview = false },
        },
        explorer = {
          layout = { preset = "default", preview = true },
          jump = {
            close = true,
          },
          win = {
            list = {
              keys = {
                ["<c-c>"] = false, -- disable changing dir on this key
              },
            },
          },
          hidden = true,
        },
        files = {
          hidden = true,
        },
        grep = {
          hidden = true,
          filter = { transform = glob_transform },
        },
        grep_word = {
          hidden = true,
          filter = { transform = glob_transform },
        },
      },
    },
  },
  keys = {
    { "<leader>e", false },
    {
      "<leader><space>",
      function()
        ---@diagnostic disable-next-line: missing-fields
        Snacks.explorer({ cwd = vim.uv.cwd() })
      end,
      desc = "Explorer Snacks (root dir)",
      remap = true,
    },
  },
}
