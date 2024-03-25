vim.cmd [[
highlight LspReferenceText  cterm=underline ctermbg=239 gui=underline guibg=#104040
highlight LspReferenceRead  cterm=underline ctermbg=239 gui=underline guibg=#104040
highlight LspReferenceWrite cterm=underline ctermbg=239 gui=underline guibg=#104040
]]

local on_attach = function(client, bufnr)

  -- LSPが持つフォーマット機能を無効化する
  -- →例えばtsserverはデフォルトでフォーマット機能を提供しますが、利用したくない場合はコメントアウトを解除してください
  --client.server_capabilities.documentFormattingProvider = false

  -- 下記ではデフォルトのキーバインドを設定しています
  -- ほかのLSPプラグインを使う場合（例：Lspsaga）は必要ないこともあります

  local set = vim.keymap.set
  --set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  --set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  set("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  --set("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  set("n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  set("n", "ma", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
  set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")

  vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
  vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
  vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
    callback = vim.lsp.buf.document_highlight,
    buffer = bufnr,
    group = "lsp_document_highlight",
    desc = "Document Highlight",
  })

  vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
    callback = vim.lsp.buf.clear_references,
    buffer = bufnr,
    group = "lsp_document_highlight",
    desc = "Clear All the References",
  })
end

require('mason').setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  function (server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach, --keyバインドなどの設定を登録
    }
  end,
}
