local ht = require("haskell-tools")
local buf = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = buf }
local map = function(key, what)
  vim.keymap.set("n", key, what, opts)
end

map("<leader>cl", vim.lsp.codelens.run)
map("<leader>hs", ht.hoogle.hoogle_signature)
map("<leader>rr", ht.repl.toggle)
map("<leader>rq", ht.repl.quit)
