---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",

        "clangd",

        "emmet-language-server",
        "typescript-language-server",
        "prettier",
        "prettierd",
        "tailwindcss-language-server",
        "css-lsp",

        "gopls",
        "gofumpt",
        "goimports",
        "golangci-lint",
        "golangci-lint-langserver",
        "buf",

        "postgres-language-server",

        "rust-analyzer",
        "codelldb",

        "pyright",

        "tree-sitter-cli",
      },
    },
  },
}
