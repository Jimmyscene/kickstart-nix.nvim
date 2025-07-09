vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

        map(
            "gv",
            function() require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" }) end,
            "[G]oto Definition in [V]Split"
        )

        -- Find references for the word under your cursor.
        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map(
                "<leader>th",
                function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end,
                "[T]oggle Inlay [H]ints"
            )
        end
    end,
})

vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
    callback = function(event)
        local group_name = "kickstart-lsp-highlight"
        vim.lsp.buf.clear_references()
        local exists = pcall(vim.api.nvim_get_autocmds, { group = group_name })

        -- If it exists, clear the group
        if exists then
            vim.api.nvim_clear_autocmds({ group = group_name, buffer = event.buf })
        end
    end,
})

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

local servers = {
    bashls = {
        on_attach = function(client, bufnr)
            -- Function to prevent bashls from starting based on file patterns
            local function prevent_bashls_for_patterns(filename)
                -- List of file patterns where bashls should not start
                local excluded_patterns = {
                    "PKGBUILD",
                    ".*.install",
                    "makepkg.conf",
                    ".*.ebuild",
                    ".*.eclass",
                    "make.conf",
                }

                for _, pattern in ipairs(excluded_patterns) do
                    if filename:match(pattern) then
                        return false
                    end
                end
                return true
            end
            local filename = vim.api.nvim_buf_get_name(bufnr)
            local should_start = prevent_bashls_for_patterns(vim.fs.basename(filename))
            if should_start == false then
                client.stop() -- Stop the server from starting
                vim.print("Stopped bashls for excluded file pattern")
            end
        end,
        settings = {
            filetypes = { "sh" },
            bashIde = {
                shfmt = {
                    indent = 4,
                    caseIndent = true,
                    spaceRedirects = true,
                    -- funcNextLine = true,
                },
                shellcheckArguments = { "-e", "SC1091" },
            },
        },
    },
    clangd = {},
    docker_compose_language_service = {},
    dockerls = {},
    gitlab_ci_ls = {},
    gopls = {},
    lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim", "spec" },
                },
                runtime = {
                    version = "LuaJIT",
                    special = {
                        spec = "require",
                    },
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true,
                    },
                },
                completion = {
                    callSnippet = "Replace",
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
            },
        },
    },
    neocmake = {},
    nil_ls = {
        settings = {
            ["nil"] = {
                nix = {
                    flake = { autoArchive = false },
                },
            },
        },
    },
    pyright = {},
    ruff = {},
    rust_analyzer = {},
    taplo = {},
    terraformls = {},
    yamlls = {
        settings = {
            formatter = {
                enable = false,
            },
        },
    },
}

for server_name, _ in pairs(servers) do
    local server = servers[server_name] or {}
    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
    require("lspconfig")[server_name].setup(server)
end
