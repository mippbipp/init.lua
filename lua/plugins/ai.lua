return {
  {
    "supermaven-inc/supermaven-nvim",
    opts = {
      keymaps = {
        accept_suggestion = "<C-e>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-h>",
      },
      condition = function()
        local filename = vim.api.nvim_buf_get_name(0)

        -- Check if the file exists on disk (prevents errors on new, unsaved buffers)
        local stats = vim.uv.fs_stat(filename)
        if stats then
          local size_limit = 1024 * 1024 -- 1 MB
          if stats.size > size_limit then
            return true -- Stop Supermaven
          end
        end

        return false -- Continue Supermaven
      end,
    },
  },
}
