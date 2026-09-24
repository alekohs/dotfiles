return {
  "chrisgrieser/nvim-spider",
  keys = {
    { "<M-w>", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" }, desc = "Next subword" },
    { "<M-b>", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" }, desc = "Prev subword" },
    { "<M-e>", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" }, desc = "Next subword end" },
  },
}
