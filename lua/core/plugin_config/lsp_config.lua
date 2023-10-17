require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    'tsserver',
    'eslint',
    'html',
    'cssls',
    'tailwindcss',
  }
})

local on_attach = function(client, bufnr)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
  -- format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("eslint_d", { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.formatting_seq_sync() end
    })
  end
  if client.name == 'tsserver' then
    vim.keymap.set('n', '<leader>rf', ':TypescriptRenameFile<CR>')
  end
end



require("lspconfig").lua_ls.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
      workspaces = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      }
    }
  },
}

require("lspconfig").tsserver.setup {
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
  cmd = { "typescript-language-server", "--stdio" },
  on_attach = on_attach
}


require('lspconfig').tailwindcss.setup {}


vim.diagnostic.config({
  virtual_text = true,
})

vim.diagnostic.config({ virtual_lines = true })

vim.diagnostic.config({ virtual_lines = { only_current_line = true } })

vim.diagnostic.config({ virtual_lines = { highlight_whole_line = true } })
