-- lua/config/go.lua
local go_config = {}

function go_config.go_mod_tidy()
  vim.cmd [[!go mod tidy]] -- Run go mod tidy
  vim.cmd [[LspRestart]] -- Restart the LSP server
end

vim.api.nvim_create_user_command("GoModTidy", go_config.go_mod_tidy, {})

return go_config
