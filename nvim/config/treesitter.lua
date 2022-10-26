-- PLUGIN: Treesitter - better syntax highlighting for most languages
-- HOMEPAGE: https://github.com/nvim-treesitter/nvim-treesitter
local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
    -- Modules and its options go here
    highlight = { enable = true },
    indent = {
        -- TODO: Indentation doesn't seem to work in many languages, at least nix possibly go.
        enable = false,
    },
    textobjects = {
        enable = true,
        select = {
            enable = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                -- TODO: More textobjects? These don't seem to work everywhere
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
            }
        }
    },
})

treesitter.setup({
})

-- PLUGIN: Spellsitter - spelling check for comments
-- HOMEPAGE: https://github.com/lewis6991/spellsitter.nvim
-- TODO: Improve this plugin. Currently, it causes too many red-underlines for my tastes
-- local spellsitter = require("spellsitter")
--
-- -- Turn on spelling check globally for spellsitter
-- -- TODO: Add more details to spell checking, specifically URL/email ignores
-- vim.opt.spell = true
-- -- Disable caps check since I don't like to press shift
-- vim.opt.spellcapcheck = ""
--
-- spellsitter.setup({
--     enable = true
-- })
