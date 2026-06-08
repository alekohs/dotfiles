local M = {}

M.icons = {
  diagnostics = {
    error = "󰅖", -- nf-md-close  (small “x”)
    warn  = "", -- nf-md-alert
    hint  = "", -- nf-md-lightbulb
    info  = "", -- nf-md-information
  },
  git = {
    added     = "", -- nf-oct-diff_
    modified  = "",
    removed   = "",
    renamed   = "",
    untracked = "",
    ignored   = "",
    unmerged  = "󰕚",
  },
}

-- Define the globals under helpers
_G.helpers = M
