local M = {}
local state
local namespace = vim.api.nvim_create_namespace("MergeConflictSides")

local function define_highlights()
  local palette = vim.g.colors_name == "polarskal" and vim.g.polarskal_palette or {}
  if type(palette) ~= "table" then palette = {} end
  local function color(value)
    if type(value) == "number" then return value end
    if type(value) == "string" and value:match("^#%x%x%x%x%x%x$") then return tonumber(value:sub(2), 16) end
  end
  local function foreground(group, fallback)
    return vim.api.nvim_get_hl(0, { name = group, link = false }).fg or fallback
  end
  local background = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
    or color(palette.panel)
    or (vim.o.background == "light" and 0xffffff or 0x101418)
  local function mix(from, to, amount)
    local result = 0
    for shift = 0, 16, 8 do
      local fg = math.floor(to / 2 ^ shift) % 256
      local bg = math.floor(from / 2 ^ shift) % 256
      result = result + math.floor(fg * amount + bg * (1 - amount)) * 2 ^ shift
    end
    return result
  end
  local function tint(color, amount) return mix(background, color, amount) end
  local text = color(palette.text) or foreground("Normal", 0xdedede)
  -- Diagnostic colors (and Polarskal's ice token) need not be blue/green.
  -- Keep side identities distinct, but soften blue with the active theme's text
  -- and use its actual green accent when available. No generated theme edits.
  local left = vim.o.background == "light" and 0x2563a6 or 0x82aaff
  local right = vim.o.background == "light" and 0x237b4b or 0x9ece6a
  if next(palette) then
    left = color(palette.blue) or mix(left, text, 0.18)
    right = color(palette.green) or color(palette.alt) or right
  end
  if left == right then right = vim.o.background == "light" and 0x237b4b or 0x9ece6a end
  local base = color(palette.muted) or foreground("Comment", 0x808080)
  for _, side in ipairs({ { "Left", left, 0.20 }, { "Right", right, 0.20 }, { "Base", base, 0.08 } }) do
    vim.api.nvim_set_hl(0, "Merge" .. side[1], { bg = tint(side[2], side[3]) })
    vim.api.nvim_set_hl(0, "Merge" .. side[1] .. "Strong", { bg = tint(side[2], 0.32) })
    vim.api.nvim_set_hl(0, "Merge" .. side[1] .. "Header", {
      bg = tint(side[2], 0.40),
      fg = text,
      bold = true,
    })
    vim.api.nvim_set_hl(0, "Merge" .. side[1] .. "Filler", { fg = tint(side[2], 0.4), bg = tint(side[2], 0.08) })
    vim.api.nvim_set_hl(0, "Merge" .. side[1] .. "Label", { fg = side[2], bold = true })
  end
  -- Built-in diff backgrounds take precedence over decorations. RESULT uses
  -- conflict-side shading instead, while the source panes retain tinted diffs.
  vim.api.nvim_set_hl(0, "MergeResultDiff", {})
end

local function marker(line)
  local run, rest = line:match("^([<|=>]+)(.*)$")
  if not run or #run < 7 or (rest ~= "" and not rest:match("^%s")) then return end
  local char = run:sub(1, 1)
  if run ~= string.rep(char, #run) then return end
  return char, #run
end

-- Git-style markers are shared by Git and jj's configured merge tool.
-- Keep malformed/partial markers visible to the finish guard as well.
function M.conflicts(lines)
  local conflicts, current, has_markers = {}, nil, false
  for row, line in ipairs(lines) do
    local char, width = marker(line)
    if char then
      has_markers = true
      if char == "<" then
        -- Nested regions are ambiguous; require manual repair rather than
        -- offering a choice that could discard an enclosing conflict.
        if current then return {}, true end
        current = { first = row, width = width, left = {}, right = {} }
        current.side = "left"
      elseif current and width == current.width then
        if char == "|" and current.side == "left" then
          current.base, current.side = {}, "base"
        elseif char == "=" and current.side ~= "right" then
          current.side = "right"
        elseif char == ">" and current.side == "right" then
          current.last = row
          conflicts[#conflicts + 1] = current
          current = nil
        else
          current = nil
        end
      else
        current = nil
      end
    elseif current then
      table.insert(current[current.side], line)
    end
  end
  return conflicts, has_markers
end

local function result_window()
  local win = vim.fn.bufwinid(state.result)
  if win == -1 then
    vim.notify("The RESULT panel has been closed", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_set_current_win(win)
  return win
end

local function conflicts()
  return M.conflicts(vim.api.nvim_buf_get_lines(state.result, 0, -1, false))
end

local function highlight_conflicts()
  vim.api.nvim_buf_clear_namespace(state.result, namespace, 0, -1)
  local function paint(first, last, group)
    for row = first, last - 1 do
      vim.api.nvim_buf_set_extmark(state.result, namespace, row, 0, {
        end_row = row + 1,
        end_col = 0,
        hl_group = group,
        hl_eol = true,
        priority = 250,
      })
    end
  end
  for _, block in ipairs(conflicts()) do
    local left_end = block.first + #block.left
    paint(block.first - 1, block.first, "MergeLeftHeader")
    paint(block.first, left_end, "MergeLeft")
    if block.base then
      paint(left_end, left_end + 1, "MergeBaseHeader")
      paint(left_end + 1, left_end + 1 + #block.base, "MergeBase")
    end
    local separator = block.last - #block.right - 2
    paint(separator, separator + 1, "MergeRightHeader")
    paint(separator + 1, block.last - 1, "MergeRight")
    paint(block.last - 1, block.last, "MergeRightHeader")
  end
end

function M.jump(direction)
  if not result_window() then return end
  local blocks = conflicts()
  if #blocks == 0 then
    vim.notify("No complete conflict regions remain", vim.log.levels.INFO)
    return
  end
  local row = vim.fn.line(".")
  local target = direction > 0 and blocks[1].first or blocks[#blocks].first
  for _, block in ipairs(blocks) do
    if direction > 0 and block.first > row then
      target = block.first
      break
    elseif direction < 0 and block.first < row then
      target = block.first
    end
  end
  vim.api.nvim_win_set_cursor(0, { target, 0 })
  vim.cmd("normal! zvzz")
end

function M.take(side)
  if not result_window() then return end
  local row = vim.fn.line(".")
  for _, block in ipairs(conflicts()) do
    if row >= block.first and row <= block.last then
      local replacement = block[side]
      if side == "both" or side == "both_reverse" then
        local first, second = "left", "right"
        if side == "both_reverse" then first, second = second, first end
        replacement = vim.list_extend(vim.deepcopy(block[first]), block[second])
      end
      if not replacement then
        vim.notify("This conflict has no BASE section; use :diffget from the BASE buffer", vim.log.levels.WARN)
        return
      end
      vim.api.nvim_buf_set_lines(state.result, block.first - 1, block.last, false, replacement)
      highlight_conflicts()
      vim.cmd("diffupdate")
      vim.api.nvim_win_set_cursor(0, { math.min(block.first, vim.api.nvim_buf_line_count(state.result)), 0 })
      vim.cmd("normal! zvzz")
      return
    end
  end
  vim.notify("Place the RESULT cursor inside a conflict first (]c / [c)", vim.log.levels.INFO)
end

function M.finish()
  if not result_window() then return end
  local _, has_markers = conflicts()
  if has_markers then
    vim.notify("Conflict markers remain. Resolve them before finishing (]c / [c)", vim.log.levels.WARN)
    return
  end
  -- Only write RESULT, never the temporary source files. Write failures prevent exit.
  vim.cmd("write")
  vim.cmd("qall")
end

local function leader()
  local key = vim.g.mapleader or "\\"
  return key == " " and "SPC" or key:gsub("%%", "%%%%")
end

function M.statusline()
  if not state then return "" end
  local blocks, has_markers = conflicts()
  local count = #blocks .. (#blocks == 1 and " conflict" or " conflicts")
  local status = #blocks > 0 and count or (has_markers and "Check markers" or "Ready to finish")
  local hl = has_markers and "DiagnosticWarn" or "DiagnosticOk"
  local prefix = leader() .. " m"
  local help = vim.o.columns >= 125
      and ("[c ]c conflicts  " .. prefix .. " → l/b/r choose · a/A both · h source hunk · e result · f finish · q abort")
    or ("[c ]c  " .. prefix .. " → l/b/r choose · a/A both · h hunk · f finish · q abort")
  return "%#Title# MERGE %* %#" .. hl .. "#" .. status .. "%*  %<" .. help .. "%= %l:%c "
end

local function resize()
  if state and vim.api.nvim_win_is_valid(state.window) then
    -- Equal top columns, with slightly more than half the height reserved for RESULT.
    vim.api.nvim_win_call(state.window, function()
      vim.cmd("wincmd =")
      if vim.api.nvim_win_is_valid(state.source_window) then
        local height = vim.api.nvim_win_get_height(state.window) + vim.api.nvim_win_get_height(state.source_window)
        vim.cmd("resize " .. math.max(3, math.floor(height * 0.6)))
      end
    end)
  end
end

function M.setup()
  local files = vim.fn.argv()
  if #files ~= 4 then error("Merge layout requires result, left, base and right files") end
  local buffers = {}
  for i, file in ipairs(files) do
    local buf = vim.fn.bufnr(file)
    if buf == -1 or vim.fn.bufwinid(buf) == -1 then error("Merge file is not displayed: " .. file) end
    buffers[i] = buf
  end
  local output = vim.fn.fnamemodify(files[1], ":p")
  state = {
    result = buffers[1],
    window = vim.fn.bufwinid(buffers[1]),
    source_window = vim.fn.bufwinid(buffers[2]),
    output = output,
    initial_output = vim.fn.readfile(output, "b"),
  }
  vim.o.write = true
  -- -M changes the defaults inherited by new buffers too. Restore those for
  -- plugin scratch buffers (notably mini.clue), then lock only the inputs below.
  vim.go.modifiable = true
  vim.go.readonly = false
  vim.o.autowrite = false
  vim.o.autowriteall = false
  vim.o.laststatus = 3
  vim.o.showmode = false
  vim.o.statusline = "%!v:lua.require'config.merge'.statusline()"
  vim.opt.diffopt:append({ "algorithm:histogram", "linematch:60" })
  define_highlights()

  local roles = {
    { "RESULT", "Title", "editable · u undo" },
    { "LEFT", "MergeLeftLabel", "l" },
    { "BASE", "MergeBaseLabel", "b" },
    { "RIGHT", "MergeRightLabel", "r" },
  }
  for i, buf in ipairs(buffers) do
    local role = roles[i]
    vim.b[buf].merge_label = role[1]
    vim.bo[buf].modifiable = i == 1
    vim.bo[buf].readonly = i ~= 1
    vim.diagnostic.enable(false, { bufnr = buf })
    local win = vim.fn.bufwinid(buf)
    vim.wo[win].number = true
    vim.wo[win].relativenumber = false
    vim.wo[win].signcolumn = "no"
    vim.wo[win].foldcolumn = "0"
    vim.wo[win].wrap = false
    vim.wo[win].cursorline = i == 1
    vim.api.nvim_win_call(win, function()
      vim.opt_local.fillchars:append({ diff = "╱" })
    end)
    if i ~= 1 then
      local side = ({ [2] = "MergeLeft", [3] = "MergeBase", [4] = "MergeRight" })[i]
      local overrides = {
        "DiffAdd:" .. side,
        "DiffChange:" .. side,
        "DiffText:" .. side .. "Strong",
        "DiffTextAdd:" .. side .. "Strong",
        "DiffDelete:" .. side .. "Filler",
      }
      local existing = vim.wo[win].winhighlight
      vim.wo[win].winhighlight = (existing == "" and "" or (existing .. ",")) .. table.concat(overrides, ",")
    else
      local overrides = {
        "DiffAdd:MergeResultDiff",
        "DiffChange:MergeResultDiff",
        "DiffText:MergeResultDiff",
        "DiffTextAdd:MergeResultDiff",
        "DiffDelete:MergeBaseFiller",
      }
      local existing = vim.wo[win].winhighlight
      vim.wo[win].winhighlight = (existing == "" and "" or (existing .. ",")) .. table.concat(overrides, ",")
    end
    vim.wo[win].winbar = "%#" .. role[2] .. "# " .. role[1] .. " %*  "
      .. (i == 1 and role[3] or (leader() .. " m " .. role[3] .. " choose · " .. leader() .. " m h hunk"))

    local function map(key, action, desc)
      vim.keymap.set("n", key, action, { buffer = buf, silent = true, desc = "Merge: " .. desc })
    end
    map("]x", function() M.jump(1) end, "next conflict")
    map("[x", function() M.jump(-1) end, "previous conflict")
    map("]c", function() M.jump(1) end, "next conflict")
    map("[c", function() M.jump(-1) end, "previous conflict")
    for _, side in ipairs({ { "ml", "left", 2 }, { "mb", "base", 3 }, { "mr", "right", 4 } }) do
      map("<leader>" .. side[1], function() M.take(side[2]) end, "take " .. side[2])
      if i == 1 then
        -- A colon mapping preserves Vim's automatically inserted Visual range.
        vim.keymap.set("x", "<leader>" .. side[1], ":diffget " .. buffers[side[3]] .. "<CR>", {
          buffer = buf,
          silent = true,
          desc = "Merge: selected lines from " .. side[2],
        })
      end
    end
    if i ~= 1 then
      local focus = "<Cmd>call win_gotoid(" .. state.window .. ")<CR>"
      map("<leader>mh", "<Cmd>diffput " .. state.result .. "<CR>" .. focus, "copy this hunk to result")
      vim.keymap.set("x", "<leader>mh", ":diffput " .. state.result .. "<CR>" .. focus, {
        buffer = buf,
        silent = true,
        desc = "Merge: copy selected lines to result",
      })
    end
    map("<leader>ma", function() M.take("both") end, "take both (left then right)")
    map("<leader>mA", function() M.take("both_reverse") end, "take both (right then left)")
    map("<leader>me", result_window, "focus result")
    map("<leader>mf", M.finish, "finish (check, save and exit)")
    map("<leader>mq", function() vim.cmd("cquit") end, "abort without saving")
  end

  -- mini.clue's prefix triggers must be newer than the buffer-local mappings
  -- they discover. These merge mappings are installed after BufWinEnter.
  local ok, clue = pcall(require, "mini.clue")
  if ok then
    for _, buf in ipairs(buffers) do
      local config = vim.b[buf].miniclue_config or {}
      config.window = vim.tbl_extend("force", config.window or {}, { delay = 200 })
      vim.b[buf].miniclue_config = config
      clue.ensure_buf_triggers(buf)
    end
  end

  vim.api.nvim_set_current_win(state.window)
  vim.cmd("wincmd J")
  resize()
  local group = vim.api.nvim_create_augroup("MergeLayout", { clear = true })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      if vim.v.exiting ~= 0 then return end
      -- Inspect the saved output, not pending edits: :qa! must not accidentally
      -- tell Git that an untouched/discarded conflict has been resolved.
      local ok, saved = pcall(vim.fn.readfile, state.output, "b")
      if not ok or vim.deep_equal(saved, state.initial_output) then
        vim.cmd("cquit 1")
        return
      end
      local _, has_markers = M.conflicts(saved)
      if has_markers then vim.cmd("cquit 1") end
    end,
  })
  vim.api.nvim_create_autocmd("VimResized", { group = group, callback = resize })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      define_highlights()
      highlight_conflicts()
    end,
  })
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
    group = group,
    buffer = state.result,
    callback = function()
      highlight_conflicts()
      vim.cmd("redrawstatus")
    end,
  })
  highlight_conflicts()
  local blocks = conflicts()
  if #blocks > 0 then
    vim.api.nvim_win_set_cursor(state.window, { blocks[1].first, 0 })
    vim.cmd("normal! zvzz")
  end
end

return M
