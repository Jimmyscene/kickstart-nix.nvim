vim.loader.enable()

require("options")

require("autocmds")
require("keymaps")

-- map templ files to be jinja
vim.filetype.add({ pattern = { [".*.tmpl"] = "jinja" } })
