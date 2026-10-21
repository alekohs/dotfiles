return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  dependencies = {
    { "smart-splits-nvim/backend-tmux", main = "smart-splits-backend-tmux" },
  },
  opts = {
    mux = { backend = "smart-splits-backend-tmux" },
  },
  keys = {
    { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left split/pane" },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to below split/pane" },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to above split/pane" },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right split/pane" },
    { "<C-Left>", function() require("smart-splits").resize_left() end, desc = "Resize split left" },
    { "<C-Down>", function() require("smart-splits").resize_down() end, desc = "Resize split down" },
    { "<C-Up>", function() require("smart-splits").resize_up() end, desc = "Resize split up" },
    { "<C-Right>", function() require("smart-splits").resize_right() end, desc = "Resize split right" },
  },
}
