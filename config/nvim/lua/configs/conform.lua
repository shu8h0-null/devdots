local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = false,
  },
}

return options
