return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.enable("ruby_lsp")
    vim.lsp.enable("ts_ls")
    vim.lsp.enable("tailwindcss")
    vim.lsp.enable("basedpyright")

    vim.diagnostic.config({
      virtual_lines = {
        current_line = true,
      },
    })
  end,
}
