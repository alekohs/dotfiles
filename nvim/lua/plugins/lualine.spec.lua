return {
  {
    "nvim-lualine/lualine.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = {
      "echasnovski/mini.nvim",
    },
    config = function()
      local palettes = {
        ["rose-pine"] = function()
          local p = require("rose-pine.palette")
          return {
            base = p.base, text = p.text, muted = p.muted,
            accent_n = p.rose, accent_i = p.foam, accent_v = p.iris,
            accent_r = p.pine, accent_c = p.love, accent_t = p.pine,
            info = p.foam, warn = p.gold, love = p.love,
          }
        end,
        ["vague"] = function()
          return {
            base = "#141415", text = "#cdcdcd", muted = "#606079",
            accent_n = "#be8c8c", accent_i = "#b4d4cf", accent_v = "#bb9dbd",
            accent_r = "#7894ab", accent_c = "#d8647e", accent_t = "#7894ab",
            info = "#b4d4cf", warn = "#f3be7c", love = "#d8647e",
          }
        end,
      }

      local function build_theme()
        local scheme = vim.g.colors_name or "rose-pine"
        local resolver = palettes[scheme] or palettes["rose-pine"]
        local p = resolver()
        return {
          normal = {
            a = { bg = p.accent_n, fg = p.base, gui = "bold" },
            b = { bg = "NONE", fg = p.accent_n },
            c = { bg = "NONE", fg = p.text },
          },
          insert = {
            a = { bg = p.accent_i, fg = p.base, gui = "bold" },
            b = { bg = "NONE", fg = p.accent_i },
            c = { bg = "NONE", fg = p.text },
          },
          visual = {
            a = { bg = p.accent_v, fg = p.base, gui = "bold" },
            b = { bg = "NONE", fg = p.accent_v },
            c = { bg = "NONE", fg = p.text },
          },
          replace = {
            a = { bg = p.accent_r, fg = p.base, gui = "bold" },
            b = { bg = "NONE", fg = p.accent_r },
            c = { bg = "NONE", fg = p.text },
          },
          command = {
            a = { bg = p.accent_c, fg = p.base, gui = "bold" },
            b = { bg = "NONE", fg = p.accent_c },
            c = { bg = "NONE", fg = p.text },
          },
          terminal = {
            a = { bg = p.accent_t, fg = p.base, gui = "bold" },
            b = { bg = "NONE", fg = p.accent_t },
            c = { bg = "NONE", fg = p.text },
          },
          inactive = {
            a = { bg = "NONE", fg = p.muted, gui = "bold" },
            b = { bg = "NONE", fg = p.muted },
            c = { bg = "NONE", fg = p.muted },
          },
        }
      end

      local function ui_palette()
        local scheme = vim.g.colors_name or "rose-pine"
        return (palettes[scheme] or palettes["rose-pine"])()
      end

      local function project_name()
        return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end

      local function lsp_clients()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then return "" end
        local names = {}
        for _, client in ipairs(clients) do
          names[#names + 1] = client.name
        end
        return table.concat(names, " ")
      end

      local function search()
        if vim.v.hlsearch == 0 then return "" end
        local ok, sc = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
        if not ok or (sc.total or 0) == 0 then return "" end
        local term = vim.fn.getreg("/")
        if #term > 24 then term = term:sub(1, 23) .. "…" end
        return string.format("%s [%d/%d]", term, sc.current, sc.total)
      end

      local lsp_spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      local lsp_spin_i = 0
      local lsp_progress_msg = ""
      local function lsp_progress()
        return lsp_progress_msg
      end

      local function selection_count()
        local mode = vim.fn.mode()
        if mode == "V" then
          return (math.abs(vim.fn.line(".") - vim.fn.line("v")) + 1) .. "L"
        elseif mode == "\22" then
          local lines = math.abs(vim.fn.line(".") - vim.fn.line("v")) + 1
          local cols = math.abs(vim.fn.col(".") - vim.fn.col("v")) + 1
          return lines .. "×" .. cols
        elseif mode == "v" then
          return (vim.fn.wordcount().visual_chars or 0) .. "C"
        end
        return ""
      end

      local function lazy_updates()
        local ok, status = pcall(require, "lazy.status")
        if not ok or not status.has_updates() then return "" end
        return status.updates()
      end

      local function location_progress()
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")
        local pct = math.floor(line / vim.fn.line("$") * 100)
        return string.format("%d:%d · %d%%%%", line, col, pct)
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          globalstatus = true,
          theme = build_theme(),
          section_separators = { left = "", right = "" },
          component_separators = { left = "│", right = "│" },
          disabled_filetypes = {
            statusline = {
              "copilot-chat",
              "dapui_scopes",
              "dapui_breakpoints",
              "dapui_stacks",
              "dapui_watches",
              "dapui_console",
            },
            winbar = {
              "copilot-chat",
              "dap-repl",
              "dapui_scopes",
              "dapui_breakpoints",
              "dapui_stacks",
              "dapui_watches",
              "dapui_console",
              "neotest-summary",
              "qf",
              "help",
            },
          },
        },

        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "branch", icon = "" },
            { "diff", symbols = { added = helpers.icons.git.added .. " ", modified = helpers.icons.git.modified .. " ", removed = helpers.icons.git.removed .. " " } },
          },
          lualine_c = {
            { project_name, icon = "" },
          },
          lualine_x = {
            {
              function()
                local reg = vim.fn.reg_recording()
                if reg ~= "" then return " rec @" .. reg end
                return ""
              end,
              color = function() return { fg = ui_palette().info } end,
            },
            {
              search,
              icon = "",
              color = function() return { fg = ui_palette().love } end,
            },
            { lsp_progress, color = function() return { fg = ui_palette().info } end },
            { lsp_clients, icon = "" },
            { lazy_updates, icon = "󰚰", color = function() return { fg = ui_palette().warn } end },
          },
          lualine_y = {
            { selection_count, color = function() return { fg = ui_palette().muted } end },
            { location_progress },
          },
          lualine_z = {
            {
              "encoding",
              cond = function() return vim.opt.fileencoding:get() ~= "utf-8" end,
            },
            {
              "fileformat",
              cond = function() return vim.bo.fileformat ~= "unix" end,
              symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
            },
          },
        },

        winbar = {
          lualine_b = {
            {
              "filename",
              path = 1,
              symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
            },
          },
          lualine_c = {},
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_lsp" },
              symbols = {
                error = helpers.icons.diagnostics.error .. " ",
                warn  = helpers.icons.diagnostics.warn  .. " ",
                hint  = helpers.icons.diagnostics.hint  .. " ",
                info  = helpers.icons.diagnostics.info  .. " ",
              },
            },
          },
          lualine_y = { "filetype" },
          lualine_z = {},
        },

        inactive_winbar = {
          lualine_b = {
            {
              "filename",
              path = 1,
              symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
            },
          },
          lualine_y = { "filetype" },
        },
      })

      vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
        callback = require("lualine").refresh,
      })

      vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(ev)
          local val = ev.data and ev.data.params and ev.data.params.value
          if type(val) ~= "table" then return end
          if val.kind == "end" then
            lsp_progress_msg = ""
          else
            lsp_spin_i = (lsp_spin_i % #lsp_spinner) + 1
            lsp_progress_msg = lsp_spinner[lsp_spin_i] .. " " .. (val.title or "")
          end
          require("lualine").refresh()
        end,
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local lualine = require("lualine")
          local cfg = lualine.get_config()
          cfg.options.theme = build_theme()
          lualine.setup(cfg)
        end,
      })
    end,
  },
}
