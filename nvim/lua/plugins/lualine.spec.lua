return {
  helpers.get_plugin("lualine.nvim", "nvim-lualine/lualine.nvim", {
    cond = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = {
      helpers.get_plugin("mini-nvim", "echasnovski/mini.icons"),
      helpers.get_plugin_by_repo("SmiteshP/nvim-navic"),
    },
    config = function()
      local palettes = {
        ["rose-pine"] = function()
          local p = require("rose-pine.palette")
          return {
            base = p.base, text = p.text, muted = p.muted,
            accent_n = p.rose, accent_i = p.foam, accent_v = p.iris,
            accent_r = p.pine, accent_c = p.love, accent_t = p.pine,
          }
        end,
        ["vague"] = function()
          return {
            base = "#141415", text = "#cdcdcd", muted = "#606079",
            accent_n = "#be8c8c", accent_i = "#b4d4cf", accent_v = "#bb9dbd",
            accent_r = "#7894ab", accent_c = "#d8647e", accent_t = "#7894ab",
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

      local function navic_cond()
        local buf_size_limit = 1024 * 1024 -- 1MB
        local lines = vim.api.nvim_buf_line_count(0)
        if vim.api.nvim_buf_get_offset(0, lines) > buf_size_limit then return false end
        return require("nvim-navic").is_available()
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
          lualine_c = {},
          lualine_x = {
            {
              function()
                local reg = vim.fn.reg_recording()
                if reg ~= "" then return " rec @" .. reg end
                return ""
              end,
              color = { fg = "#9ccfd8" },
            },
            {
              "searchcount",
              color = { fg = "#eb6f92" },
            },
          },
          lualine_y = { { location_progress } },
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
          lualine_c = {
            {
              "navic",
              cond = navic_cond,
            },
          },
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

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local lualine = require("lualine")
          local cfg = lualine.get_config()
          cfg.options.theme = build_theme()
          lualine.setup(cfg)
        end,
      })
    end,
  }),
}
