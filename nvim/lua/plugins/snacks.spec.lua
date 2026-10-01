return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    -- Inside tmux snacks can't detect Ghostty, so force it. Send image data instead of
    -- file paths so clients attached over SSH can display it too.
    if vim.env.TMUX and vim.env.GHOSTTY_RESOURCES_DIR then
      vim.env.SNACKS_GHOSTTY = "true"
      vim.env.SNACKS_SSH = "true"
    end
  end,
  opts = {
    image = { enabled = true },
  },
}
