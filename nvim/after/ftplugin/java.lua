local ok, jdtls = pcall(require, 'jdtls')
if not ok then return end

local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
local launcher = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
if launcher == '' then return end

local project = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace = vim.fn.expand('~/.cache/jdtls/workspace/') .. project

local bundles = vim.fn.glob(
  vim.fn.stdpath('data') .. '/mason/packages/spring-boot-tools/extension/jars/*.jar',
  true, true)

local os_config = vim.loop.os_uname().sysname == 'Darwin' and 'config_mac' or 'config_linux'

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.level=ALL', '-Xmx2g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', launcher,
    '-configuration', jdtls_path .. '/' .. os_config,
    '-data', workspace,
  },
  root_dir = jdtls.setup.find_root({ 'pom.xml', 'build.gradle', 'build.gradle.kts', '.git' }),
  init_options = { bundles = bundles },
  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven   = { downloadSources = true },
      referencesCodeLens      = { enabled = true },
      implementationsCodeLens = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          'org.junit.jupiter.api.Assertions.*',
          'org.mockito.Mockito.*',
        },
      },
    },
  },
  on_attach = function(client, bufnr)
    jdtls.setup.add_commands()
    local set  = vim.keymap.set
    local opts = { buffer = bufnr, silent = true }
    set('n', '<C-m>', vim.lsp.buf.signature_help, opts)
    set('n', 'rn',    vim.lsp.buf.rename,         opts)
    set('n', 'ma',    vim.lsp.buf.code_action,    opts)
    set('n', '[d',    vim.diagnostic.goto_prev,   opts)
    set('n', ']d',    vim.diagnostic.goto_next,   opts)
    set('n', 'K',     vim.lsp.buf.hover,          opts)
    set('n', '<leader>oi', jdtls.organize_imports, opts)
    set('n', '<leader>ev', jdtls.extract_variable, opts)
    set('n', '<leader>em', jdtls.extract_method,   opts)
    local g = 'java_lsp_highlight'
    vim.api.nvim_create_augroup(g, { clear = true })
    vim.api.nvim_clear_autocmds { buffer = bufnr, group = g }
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      callback = vim.lsp.buf.document_highlight, buffer = bufnr, group = g,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      callback = vim.lsp.buf.clear_references, buffer = bufnr, group = g,
    })
  end,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

jdtls.start_or_attach(config)
