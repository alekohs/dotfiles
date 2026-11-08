-- Let nvim (smart-splits) and tmux handle their own navigation
local function is_passthrough(ctx)
  local proc = rex.block.call('com.superlogical.terminal', 'process', { block_id = ctx.block_id })
  local fg = proc and proc.foreground
  if not fg then
    return false
  end
  -- `name` is not always the executable's name, so check `argv0` too
  for _, s in ipairs({ fg.name or '', (fg.argv0 or ''):match('[^/]*$') }) do
    if s:match('^n?vim') or s:match('^tmux') then
      return true
    end
  end
  return false
end

rex.action({
  name = 'smart_splits_resize',
  title = 'Smart Splits: Resize Pane',
  run = function(ctx, args)
    if is_passthrough(ctx) then
      rex.client.queue('pane.send_key', { key = args.key })
    else
      rex.client.queue('pane.resize', { direction = args.direction, amount = 3 })
    end
  end,
})

for key, direction in pairs({ h = 'left', j = 'down', k = 'up', l = 'right' }) do
  rex.bind('ctrl+' .. key, function(ctx)
    if is_passthrough(ctx) then
      return false
    end
    rex.session.focus_direction({ direction = direction })
    return true
  end)
end

for _, direction in ipairs({ 'left', 'down', 'up', 'right' }) do
  rex.bind('ctrl+' .. direction, 'smart_splits_resize', { key = 'ctrl+' .. direction, direction = direction })
end
