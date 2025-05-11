-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local servers =
  {"jsonls", "lua_ls", "html", "cssls", "ts_ls", "tailwindcss", "emmet_ls", "gopls", "prismals", "clangd", "pylsp", "vala_ls", "hyprls", "zls", "pbls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

vim.api.nvim_command [[autocmd BufWritePre *.go lua vim.lsp.buf.format()]]
