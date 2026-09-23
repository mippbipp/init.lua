-- mason pypi -> uv (#1640) and npm -> pnpm (#1977) overrides.
-- Both PRs are unmerged; register custom compilers that use `uv` / `pnpm`.
-- Runs after setup so it applies before mason-lspconfig / ensure_installed installs.
-- Requires `uv`, `pnpm` in PATH (provided by modules/hm/devenv/default.nix).
return {
  {
    "mason-org/mason.nvim",
    opts_extend = { "ensure_installed" },
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)

      local Result = require("mason-core.result")
      local path = require("mason-core.path")
      local compiler = require("mason-core.installer.compiler")
      local pypi = require("mason-core.installer.compiler.compilers.pypi")

      local uv = {
        ---@async
        ---@param ctx InstallContext
        ---@param source ParsedPypiSource
        install = function(ctx, source)
          if vim.fn.executable("uv") ~= 1 then
            return pypi.install(ctx, source)
          end
          return Result.try(function(try)
            ctx:promote_cwd()
            try(ctx.spawn.uv({ "venv", "venv" }))
            try(ctx.spawn.uv({
              "pip",
              "install",
              source.extra and ("%s[%s]==%s"):format(source.package, source.extra, source.version)
                or ("%s==%s"):format(source.package, source.version),
              source.extra_packages or vim.NIL,
              env = { VIRTUAL_ENV = path.concat({ ctx.cwd:get(), "venv" }) },
            }))
          end)
        end,
      }
      setmetatable(uv, { __index = pypi })
      compiler.register_compiler("pypi", uv)

      local npm = require("mason-core.installer.compiler.compilers.npm")
      local pnpm_compiler = {
        ---@async
        ---@param ctx InstallContext
        ---@param source ParsedNpmSource
        install = function(ctx, source)
          if vim.fn.executable("pnpm") ~= 1 then
            return npm.install(ctx, source)
          end
          return Result.try(function(try)
            ctx:promote_cwd()
            try(ctx.spawn.pnpm({ "init" }))
            local pkg_json = try(Result.pcall(vim.json.decode, ctx.fs:read_file("package.json")))
            pkg_json.name = "@mason/" .. pkg_json.name
            ---@diagnostic disable-next-line: missing-parameter
            ctx.fs:write_file("package.json", try(Result.pcall(vim.json.encode, pkg_json)))
            ctx.stdio_sink:stdout(("Installing npm package %s@%s…\n"):format(source.package, source.version))
            try(ctx.spawn.pnpm({
              "add",
              ("%s@%s"):format(source.package, source.version),
              source.extra_packages or vim.NIL,
              source.npm.extra_args or vim.NIL,
            }))
          end)
        end,
      }
      setmetatable(pnpm_compiler, { __index = npm })
      compiler.register_compiler("npm", pnpm_compiler)

      -- Keep LazyVim's ensure_installed behavior.
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed or {}) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
