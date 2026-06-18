vim.cmd [[
highlight LspReferenceText  cterm=underline ctermbg=239 gui=underline guibg=#104040
highlight LspReferenceRead  cterm=underline ctermbg=239 gui=underline guibg=#104040
highlight LspReferenceWrite cterm=underline ctermbg=239 gui=underline guibg=#104040
]]

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('mason_lsp_attach', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    if not client or client.name == 'jdtls' then return end

    local set = vim.keymap.set
    set("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = bufnr })
    set("n", "rn",    "<cmd>lua vim.lsp.buf.rename()<CR>",          { buffer = bufnr })
    set("n", "ma",    "<cmd>lua vim.lsp.buf.code_action()<CR>",     { buffer = bufnr })
    set("n", "[d",    "<cmd>lua vim.diagnostic.goto_prev()<CR>",    { buffer = bufnr })
    set("n", "]d",    "<cmd>lua vim.diagnostic.goto_next()<CR>",    { buffer = bufnr })

    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = "lsp_document_highlight",
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = "lsp_document_highlight",
    })
  end
})

require('mason').setup()
require("mason-lspconfig").setup({
  automatic_enable = {
    exclude = { 'jdtls' },  -- handled by nvim-jdtls in after/ftplugin/java.lua
  }
})
