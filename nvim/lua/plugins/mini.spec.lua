return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      -- AI
      require("mini.ai").setup()

      require("mini.clue").setup({
        triggers = {
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          { mode = "i", keys = "<C-x>" },
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },
          { mode = "n", keys = "'" },
          { mode = "x", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "`" },
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
          { mode = "n", keys = "<C-w>" },
        },
        clues = {
          require("mini.clue").gen_clues.square_brackets(),
          require("mini.clue").gen_clues.builtin_completion(),
          require("mini.clue").gen_clues.g(),
          require("mini.clue").gen_clues.marks(),
          require("mini.clue").gen_clues.registers(),
          require("mini.clue").gen_clues.windows(),
          require("mini.clue").gen_clues.z(),
          { mode = { "n", "x" }, keys = "<Leader><Tab>", desc = "+tabs" },
          { mode = { "n", "x" }, keys = "<Leader>b", desc = "+buffer" },
          { mode = { "n", "x" }, keys = "<Leader>c", desc = "+code" },
          { mode = { "n", "x" }, keys = "<Leader>d", desc = "+debug" },
          { mode = { "n", "x" }, keys = "<Leader>dp", desc = "+profiler" },
          { mode = { "n", "x" }, keys = "<Leader>f", desc = "+file/find" },
          { mode = { "n", "x" }, keys = "<Leader>g", desc = "+git" },
          { mode = { "n", "x" }, keys = "<Leader>gh", desc = "+hunks" },
          { mode = { "n", "x" }, keys = "<Leader>h", desc = "+harpoon" },
          { mode = { "n", "x" }, keys = "<Leader>o", desc = "+oil" },
          { mode = { "n", "x" }, keys = "<Leader>q", desc = "+quit/session" },
          { mode = { "n", "x" }, keys = "<Leader>s", desc = "+search" },
          { mode = { "n", "x" }, keys = "<Leader>u", desc = "+ui" },
          { mode = "n", keys = "<Leader>uh", desc = "Toggle inlay hints (focus mode)" },
          { mode = { "n", "x" }, keys = "<Leader>w", desc = "+windows" },
          { mode = { "n", "x" }, keys = "<Leader>x", desc = "+diagnostics/quickfix" },
          { mode = "n", keys = "[", desc = "+prev" },
          { mode = "n", keys = "]", desc = "+next" },
        },
        window = {
          delay = 500,
        },
      })
      MiniClue.ensure_all_triggers()
      MiniClue.ensure_buf_triggers()

      require("mini.comment").setup({
        options = {
          custom_commentstring = function()
            local node = vim.treesitter.get_node({ ignore_injections = false })
            if not node then return vim.bo.commentstring end
            local parser = vim.treesitter.get_parser(0)
            if not parser then return vim.bo.commentstring end
            local lang = parser:language_for_range({ node:range() }):lang()
            local ft = vim.treesitter.language.get_filetypes(lang)[1] or lang
            local cs = vim.api.nvim_get_option_value("commentstring", { filetype = ft })
            return (cs ~= "") and cs or vim.bo.commentstring
          end,
        },
      })

      -- Icons
      require("mini.icons").setup({
        custom_icons = {
          lsp = {
            Copilot = "X", -- For use with blink.cmp
          },
        },
      })

      -- Move
      require("mini.move").setup({
        reindent_linewise = true,
      })

      -- Pairs
      require("mini.pairs").setup()
      require("mini.diff").setup()

      -- Surround
      require("mini.surround").setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      })
      -- Snippets
      require("mini.snippets").setup()
    end,
    lazy = false,
  },
}
