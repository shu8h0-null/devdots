---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "dark_horizon",
  transparency = false,

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.nvdash = {
  load_on_startup = true,
}

M.ui = {
  statusline = {
    theme = "minimal",
    separator_style = "round",
  }
}

return M
