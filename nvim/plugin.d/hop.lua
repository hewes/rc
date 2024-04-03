local hop = require'hop'

hop.setup {keys = 'etovxqpdygfblzhckisuran'}
vim.keymap.set('', 'Fw', function()
    hop.hint_words()
end, {remap=true})
