-- BASIC SETTINGS
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.cmd('syntax enable')
vim.cmd('colorscheme default')

-- vim.cmd('colorscheme desert')

-- PLUGIN MANAGER: lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- PLUGINS
require("lazy").setup({
  -- Mason & LSP
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "java", "lua" },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      }
    end,
  },
})

-- MASON SETUP
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "jdtls" },
}

-- LSP CONFIG
local lspconfig = require("lspconfig")

lspconfig.jdtls.setup {
  cmd = { "jdtls" },
}

-- LSP KEYMAPS
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)         -- Go to definition
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)               -- Hover info
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)     -- Rename symbol
  end,
})

-- TAB SETTINGS
vim.opt.tabstop = 4          -- A tab is 4 spaces
vim.opt.shiftwidth = 4       -- Indents will use 4 spaces
vim.opt.expandtab = true     -- Use spaces instead of actual tab characters
vim.opt.smarttab = true      -- Smarter tab behavior

-- Shift+Tab to unindent in visual mode
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })