return {
  "selimacerbas/markdown-preview.nvim",
  dependencies = { "selimacerbas/live-server.nvim" },
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewRefresh" },
  keys = {
    { "<leader>mp", "<cmd>MarkdownPreview<CR>", ft = { "markdown", "mermaid" }, desc = "Markdown preview" },
    { "<leader>mP", "<cmd>MarkdownPreviewStop<CR>", ft = { "markdown", "mermaid" }, desc = "Markdown preview stop" },
  },
  config = function()
    require("markdown_preview").setup({
      port = 8421,
      open_browser = false,
      hooks = {
        on_start = function(url) vim.notify("Markdown preview: " .. url) end,
      },
    })
  end,
}
