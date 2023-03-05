-- Setup nvim-cmp.
local cmp = require("cmp")

-- What does this do?
vim.opt.completeopt = {
    "menu",
    "menuone",
    "noselect"
}

cmp.setup({
    enabled = function()
        -- Tweak contexts where cmp is active

        -- Disallow in telescope prompts
        local buftype = vim.api.nvim_buf_get_option(0, "buftype")
        if buftype == "prompt" then
            return false
        end

        -- Allow in command mode
        if vim.api.nvim_get_mode().mode == 'c' then
            return true
        end

        -- keep command mode completion enabled when cursor is in a comment
        local context = require("cmp.config.context")
        return not context.in_treesitter_capture("comment")
        and not context.in_syntax_group("Comment")
    end,
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    window = {
        -- TODO: Border color not great
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        -- Accept currently selected item. Set `select` to `false` to only
        -- confirm explicitly selected items.
        -- TODO: I want to accept with <C-n> while typing
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        {
            name = "nvim_lsp",
            entry_filter = function(entry, ctx)
                -- Filter out keywords from completion
                kinds = require("cmp.types").lsp.CompletionItemKind
                return kinds[entry:get_kind()] ~= "Keyword"
            end
        },
        { name = "luasnip" },
    }, {
        { name = "buffer" },
    })
})

vim.keymap.set("i", "<C-n>", cmp.complete)
