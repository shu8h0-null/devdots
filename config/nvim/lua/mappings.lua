require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>lf", function()
  require("telescope.builtin").lsp_document_symbols { symbols = "function" }
end, { desc = "List all functions in the document" })


map("n", "<leader>gm", function()
  vim.cmd("GoModTidy")      -- Run GoModTidy
  vim.cmd("LspRestart")     -- Restart the LSP
end, { desc = "Run go mod tidy and restart LSP" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
