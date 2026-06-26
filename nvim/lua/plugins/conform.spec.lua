local function format_with_progress()
  local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local idx = 1
  local buf = vim.api.nvim_create_buf(false, true)

  local function render()
    local text = " " .. frames[idx] .. " Formatting… "
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })
    return vim.fn.strdisplaywidth(text)
  end

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    anchor = "SE",
    row = vim.o.lines - vim.o.cmdheight - 1,
    col = vim.o.columns,
    width = render(),
    height = 1,
    style = "minimal",
    border = "rounded",
    focusable = false,
    noautocmd = true,
  })
  vim.cmd("redraw")

  local timer = vim.uv.new_timer()
  timer:start(0, 80, vim.schedule_wrap(function()
    idx = idx % #frames + 1
    if vim.api.nvim_buf_is_valid(buf) then
      render()
      vim.cmd("redraw")
    end
  end))

  local function cleanup()
    if timer then
      timer:stop()
      timer:close()
      timer = nil
    end
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
  end

  require("conform").format({ async = true }, function(err)
    cleanup()
    if err then vim.notify(err, vim.log.levels.ERROR, { title = "conform" }) end
  end)
end

return {
  "stevearc/conform.nvim",
  cmd = "ConformInfo",
  event = "VeryLazy",
  opts = {
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters = {
      sqlfluff = {
        -- sqlfluff exits 1 when non-fixable lint violations remain (ST09, RF04, ...);
        -- accept it so conform still applies the auto-fixes instead of discarding them.
        exit_codes = { 0, 1 },
        cwd = function(self, ctx)
          return require("conform.util").root_file({
            ".sqlfluff",
            "pyproject.toml",
            "setup.cfg",
            "tox.ini",
            ".git",
          })(self, ctx)
        end,
      },
    },
    formatters_by_ft = {
      bash = { "shellcheck", "shellharden", "shfmt" },
      sh = { "shellcheck", "shellharden", "shfmt" },

      -- TODO: Update to use biome instead of prettier
      -- html = { "biome" },
      html = { "prettierd", "prettier", timeout_ms = 2000, stop_after_first = true },
      css = { "stylelint", "prettierd" },

      javascript = { "biome-check" },
      javascriptreact = { "biome-check" },
      typescript = { "biome-check" },
      typescriptreact = { "biome-check" },

      swift = { "swiftformat" },

      go = { "gofmt", "goimports" },

      json = { "biome-check", "jq", stop_after_first = true },
      jsonc = { "biome-check", "jq", stop_after_first = true },
      yaml = { "yamlfmt" },
      lua = { "stylua" },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      nix = { "nixfmt" },
      fish = { "fish_indent" },
      ps1 = { "powershell_es" },
      sql = { "sqlfluff", timeout_ms = 10000 },
      -- ["*"] = { "codespell" },
      ["_"] = { "squeeze_blanks", "trim_whitespace", "trim_newlines", lsp_format = "last" },
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)

    vim.api.nvim_create_user_command("FormatGlob", function()
      vim.ui.input({ prompt = "Enter pattern (e.g. **/*.tsx): " }, function(glob)
        if not glob or glob == "" then
          print("Aborted: no pattern provided.")
          return
        end

        local files = vim.fn.glob(glob, true, true)
        if vim.tbl_isempty(files) then
          print("No files matched glob: " .. glob)
          return
        end

        local conform = require("conform")

        for _, file in ipairs(files) do
          local bufnr = vim.fn.bufadd(file)
          vim.fn.bufload(bufnr)
          conform.format({ bufnr = bufnr, lsp_fallback = true })
          vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)
        end

        print("Formatted " .. #files .. " file(s).")
      end)
    end, {})
  end,
  keys = {
    { "<leader>cg", ":FormatGlob<CR>", mode = "n", silent = true, desc = "Format files by glob" },
    {
      "<leader>cf",
      format_with_progress,
      mode = "n",
      desc = "Format injected language",
    },
    {
      "<leader>cF",
      function()
        require("conform").format({
          range = {
            ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
            ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
          },
        })
      end,
      mode = "v",
      desc = "Format injected language",
    },
  },
}
