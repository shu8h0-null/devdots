local options = {
    ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "go",
        "gomod",
        "gosum",
        "lua",
        "luadoc",
        "javascript",
        "typescript",
        "rust",
        "python",
        "html",
        "css",
        "markdown",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
    },

    highlight = {
        enable = true,
        use_languagetree = true,
    },

    indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
