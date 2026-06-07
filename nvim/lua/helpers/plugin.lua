local utils = require("helpers.utils")

local M = {}

function M.get_plugin(local_dir, github, config)
  config = config or {}
  local path_config = { github }

  if utils.lazy_use_ssh then path_config["url"] = "git@github.com:" .. github end

  local combined_config = {}
  for k, v in pairs(path_config) do
    combined_config[k] = v
  end

  for k, v in pairs(config) do
    combined_config[k] = v
  end

  return combined_config
end

return M
