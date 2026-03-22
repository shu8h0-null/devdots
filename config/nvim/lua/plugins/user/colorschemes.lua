---@type LazySpec
return {
  {
    {
      "kungfusheep/mfd.nvim",
      lazy = false,
      priority = 1000,
    },
  },
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "nendix/zen.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "oskarnurm/koda.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
  },
  {
    "Mofiqul/adwaita.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "JCodV/autumn_night.nvim",
    dependencies = { "rktjmp/lush.nvim" },
  },
  {
    "Biscuit-Theme/nvim",
    name = "biscuit",
    lazy = false,
    config = function()
      -- vim.cmd('colorscheme biscuit')
    end,
  },
  {
    "blazkowolf/gruber-darker.nvim",
    name = "gruber",
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "gruber-darker",
        callback = function() vim.api.nvim_set_hl(0, "FoldColumn", { bg = "#181818" }) end,
      })
    end,
  },
  {
    "decaycs/decay.nvim",
    name = "decay",
    lazy = false,
    config = function()
      -- SNIP
    end,
  },
}
