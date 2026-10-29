return {
  "selimacerbas/mdkite.nvim",
  cond = not vim.g.nvim_merge and not vim.wo.diff,
  dependencies = { "selimacerbas/kitehost.nvim" },
  cmd = { "MdKite" },
  keys = {
    { "<leader>mp", "<cmd>MdKite start<CR>", ft = { "markdown", "mermaid" }, desc = "Markdown preview" },
    { "<leader>mP", "<cmd>MdKite stop<CR>", ft = { "markdown", "mermaid" }, desc = "Markdown preview stop" },
  },
  config = function()
    require("mdkite").setup({
      port = 8421,
      open_browser = false,
      hooks = {
        on_start = function(url) vim.notify("Markdown preview: " .. url) end,
      },
    })
  end,
}
