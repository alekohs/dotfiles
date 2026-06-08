-- Key mappings for system clipboard
local mappings = {
  { mode = "n", keys = { "y", "Y", "p", "P" } },
  { mode = "v", keys = { "y", "p", "P" } },
}
local descriptions = {
  ["y"] = "Yank to system clipboard",
  ["Y"] = "Yank line to system clipboard",
  ["p"] = "Paste from system clipboard",
  ["P"] = "Paste before from system clipboard",
}

for _, map in ipairs(mappings) do
  for _, key in ipairs(map.keys) do
    local rhs = '"+' .. key
    vim.keymap.set(map.mode, "<leader>" .. key, rhs, { noremap = true, silent = true, desc = rhs .. " " .. descriptions[key] })
  end
end

-- Movement
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "Half-page down with center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "Half-page up with center" })

-- Tabs
vim.keymap.set("n", "<leader><tab>o", "<CMD>tabonly<CR>", { desc = "Close Other tabs" })
vim.keymap.set("n", "<leader><tab>l", "<CMD>tablast<CR>", { desc = "Last tab" })
vim.keymap.set("n", "<leader><tab>f", "<CMD>tabfirst<CR>", { desc = "First tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<CMD>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>d", "<CMD>tabclose<CR>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>]", "<CMD>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<tab>]", "<CMD>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>[", "<CMD>tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "<tab>[", "<CMD>tabprevious<CR>", { desc = "Previous Tab" })

-- Buffers
local function get_listed_buffers()
  return vim.tbl_map(function(buf) return buf.bufnr end, vim.fn.getbufinfo({ buflisted = 1 }))
end

local function get_buffer_label(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then return "[No Name]" end
  return vim.fn.fnamemodify(name, ":t")
end

local function delete_other_buffers()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(get_listed_buffers()) do
    if buf ~= current then vim.cmd("bdelete " .. buf) end
  end
end

local function goto_buffer(buf)
  if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_set_current_buf(buf) end
end

local function refresh_buffer_mappings()
  for i = 1, 9 do
    pcall(vim.keymap.del, "n", "<leader>b" .. i)
  end

  local bufs = get_listed_buffers()
  for i, buf in ipairs(vim.list_slice(bufs, 1, 9)) do
    vim.keymap.set("n", "<leader>b" .. i, function() goto_buffer(buf) end, {
      desc = get_buffer_label(buf),
    })
  end
end

vim.keymap.set("n", "<leader>bb", "<C-^>", { desc = "Alternate Buffer", remap = true })
vim.keymap.set("n", "<leader>bd", "<CMD>bdelete<CR>", { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bo", delete_other_buffers, { desc = "Delete Other Buffers" })
vim.keymap.set("n", "<leader>bn", "<CMD>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bp", "<CMD>bprevious<CR>", { desc = "Previous Buffer" })

refresh_buffer_mappings()
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufEnter", "VimEnter" }, {
  callback = refresh_buffer_mappings,
})

-- Windows
local window_mappings = {
  { lhs = "<leader>w+", rhs = "<C-w>+", desc = "Increase height" },
  { lhs = "<leader>w-", rhs = "<C-w>-", desc = "Decrease height" },
  { lhs = "<leader>w<lt>", rhs = "<C-w><lt>", desc = "Decrease width" },
  { lhs = "<leader>w>", rhs = "<C-w>>", desc = "Increase width" },
  { lhs = "<leader>w=", rhs = "<C-w>=", desc = "Make windows same dimensions" },
  { lhs = "<leader>w]", rhs = "<C-w>]", desc = "Split + jump to tag" },
  { lhs = "<leader>w^", rhs = "<C-w>^", desc = "Split + edit alternate file" },
  { lhs = "<leader>w_", rhs = "<C-w>_", desc = "Set height (def: very high)" },
  { lhs = "<leader>w<Bar>", rhs = "<C-w><Bar>", desc = "Set width (def: very wide)" },
  { lhs = "<leader>w}", rhs = "<C-w>}", desc = "Show tag in preview" },
  { lhs = "<leader>wb", rhs = "<C-w>b", desc = "Focus bottom" },
  { lhs = "<leader>wc", rhs = "<C-w>c", desc = "Close" },
  { lhs = "<leader>wd", rhs = "<C-w>d", desc = "Split + jump to definition" },
  { lhs = "<leader>wF", rhs = "<C-w>F", desc = "Split + edit file name + jump" },
  { lhs = "<leader>wf", rhs = "<C-w>f", desc = "Split + edit file name" },
  { lhs = "<leader>wg", rhs = "<C-w>g", desc = "+Extra actions" },
  { lhs = "<leader>wg]", rhs = "<C-w>g]", desc = "Split + list tags" },
  { lhs = "<leader>wg}", rhs = "<C-w>g}", desc = "Do :ptjump" },
  { lhs = "<leader>wg<C-]>", rhs = "<C-w>g<C-]>", desc = "Split + jump to tag with :tjump" },
  { lhs = "<leader>wg<Tab>", rhs = "<C-w>g<Tab>", desc = "Focus last accessed tab" },
  { lhs = "<leader>wgF", rhs = "<C-w>gF", desc = "New tabpage + edit file name + jump" },
  { lhs = "<leader>wgf", rhs = "<C-w>gf", desc = "New tabpage + edit file name" },
  { lhs = "<leader>wgT", rhs = "<C-w>gT", desc = "Focus previous tabpage" },
  { lhs = "<leader>wgt", rhs = "<C-w>gt", desc = "Focus next tabpage" },
  { lhs = "<leader>wH", rhs = "<C-w>H", desc = "Move to very left" },
  { lhs = "<leader>wh", rhs = "<C-w>h", desc = "Focus left" },
  { lhs = "<leader>wi", rhs = "<C-w>i", desc = "Split + jump to declaration" },
  { lhs = "<leader>wJ", rhs = "<C-w>J", desc = "Move to very bottom" },
  { lhs = "<leader>wj", rhs = "<C-w>j", desc = "Focus down" },
  { lhs = "<leader>wK", rhs = "<C-w>K", desc = "Move to very top" },
  { lhs = "<leader>wk", rhs = "<C-w>k", desc = "Focus up" },
  { lhs = "<leader>wL", rhs = "<C-w>L", desc = "Move to very right" },
  { lhs = "<leader>wl", rhs = "<C-w>l", desc = "Focus right" },
  { lhs = "<leader>wn", rhs = "<C-w>n", desc = "Open new" },
  { lhs = "<leader>wo", rhs = "<C-w>o", desc = "Close all but current" },
  { lhs = "<leader>wP", rhs = "<C-w>P", desc = "Focus preview" },
  { lhs = "<leader>wp", rhs = "<C-w>p", desc = "Focus last accessed" },
  { lhs = "<leader>wq", rhs = "<C-w>q", desc = "Quit current" },
  { lhs = "<leader>wR", rhs = "<C-w>R", desc = "Rotate up/left" },
  { lhs = "<leader>wr", rhs = "<C-w>r", desc = "Rotate down/right" },
  { lhs = "<leader>ws", rhs = "<C-w>s", desc = "Split horizontally" },
  { lhs = "<leader>wT", rhs = "<C-w>T", desc = "Create new tabpage + move" },
  { lhs = "<leader>wt", rhs = "<C-w>t", desc = "Focus top" },
  { lhs = "<leader>wv", rhs = "<C-w>v", desc = "Split vertically" },
  { lhs = "<leader>wW", rhs = "<C-w>W", desc = "Focus previous" },
  { lhs = "<leader>ww", rhs = "<C-w>w", desc = "Focus next" },
  { lhs = "<leader>wx", rhs = "<C-w>x", desc = "Exchange windows" },
  { lhs = "<leader>wz", rhs = "<C-w>z", desc = "Close preview" },
}

for _, map in ipairs(window_mappings) do
  vim.keymap.set("n", map.lhs, map.rhs, { desc = map.desc, remap = true })
end
