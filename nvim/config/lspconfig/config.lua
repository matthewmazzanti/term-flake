-- PLUGIN: lsp_config
-- HOMEPAGE: https://github.com/neovim/nvim-lspconfig
local lspconfig = require("lspconfig")

local function setup(plugins)
    print("test")
    local function on_attach(_, bufnr)
        local function set(mode, keys, fn)
            vim.keymap.set(mode, keys, fn, { buffer = bufnr, silent = true })
        end

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        -- TODO: Make telescope keybinds rely on setup somehow
        set("n", "gD", vim.lsp.buf.declaration)
        set("n", "gd", plugins.telescope.lsp.defs)
        set("n", "gi", plugins.telescope.lsp.impls)
        set("n", "gr", plugins.telescope.lsp.refs)
        set("n", "gy", plugins.telescope.lsp.types)

        -- TODO: Reconsider this for opening help files. Possibly make function for if in comments?
        set("n", "K", vim.lsp.buf.hover)
        set("n", "<C-k>", vim.lsp.buf.signature_help)
        set("n", "<leader>a", vim.lsp.buf.code_action)
        set("n", "<leader>r", vim.lsp.buf.rename)
    end

    -- TODO: Make this optional based on availability
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- TODO: Make config for this use recursive sub-modules
    for name, cmd in pairs(language_servers) do
        lspconfig[name].setup({
            cmd = cmd,
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end

    lspconfig.lua_ls.setup({
        cmd = lua_ls,
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    path = runtime_path,
                },
                diagnostics = {
                    globals = { 'vim' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file('', true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end

return { setup = setup }
