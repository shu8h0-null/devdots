local go_config = {}

function go_config.go_mod_tidy()
  vim.cmd [[!go mod tidy]] -- run go mod tidy
  vim.cmd [[lsprestart]] -- restart the lsp server
end

function go_config.go_mod_vendor()
  vim.cmd [[!go mod vendor]] -- run go mod tidy
  vim.cmd [[lsprestart]] -- restart the lsp server
end

vim.api.nvim_create_user_command("Gomodtidy", go_config.go_mod_tidy, {})
vim.api.nvim_create_user_command("Gomodvendor", go_config.go_mod_vendor, {})

local map = vim.keymap.set
map("n", "<leader>gm", function()
  vim.cmd("Gomodtidy")      -- Run GoModTidy
  vim.cmd("LspRestart")     -- Restart the LSP
end, { desc = "Run go mod tidy and restart LSP" })

map("n", "<leader>gv", function()
  vim.cmd("Gomodvendor")      -- Run GoModTidy
  vim.cmd("LspRestart")     -- Restart the LSP
end, { desc = "Run go mod vendor and restart LSP" })

return go_config
