vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.sidescrolloff = 8
vim.opt.scrolloff = 8

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.completeopt = 'menuone,noselect'
vim.opt.smartindent = true
vim.opt.updatetime = 500
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.guicursor = ''
vim.opt.wrap = false

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P')
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n' }, '<leader>Y', '"+yg_')

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('TextYankPostGroup', { clear = true }),
    callback = function() vim.highlight.on_yank() end,
    pattern = '*',
})

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        config = function()
            require('rose-pine').setup {
                disable_float_background = true,
                disable_background = true,
                disable_italics = true,
            }

            vim.cmd.colorscheme('rose-pine')
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            require 'nvim-treesitter.configs'.setup {
                sync_install = false,
                auto_install = true,
                ignore_install = {},
                highlight = {
                    enable = true,
                    disable = {},
                    additional_vim_regex_highlighting = false,
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                            ['as'] = '@scope',
                        },
                        selection_modes = {
                            ['@parameter.outer'] = 'v',
                            ['@function.outer'] = 'V',
                            ['@class.outer'] = '<C-w>',
                        },
                        include_surrounding_whitespace = true,
                    },
                },
            }
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-ui-select.nvim' },
            {
                'nvim-tree/nvim-web-devicons',
                enabled = vim.g.have_nerd_font,
            },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
        config = function()
            require('telescope').setup {
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            }

            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            local builtin = require('telescope.builtin')

            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
        end,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'williamboman/mason.nvim', config = true },
            {
                'j-hui/fidget.nvim',
                opts = {
                    notification = {
                        window = {
                            winblend = 0,
                        },
                    },
                },
            },
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('LspAttachGroup', { clear = true }),
                callback = function(event)
                    local telescope = require('telescope.builtin')

                    vim.keymap.set('n', 'gd', telescope.lsp_definitions, { buffer = event.buf })
                    vim.keymap.set('n', 'gr', telescope.lsp_references, { buffer = event.buf })
                    vim.keymap.set('n', 'gi', telescope.lsp_implementations, { buffer = event.buf })
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = event.buf })
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = event.buf })
                    vim.keymap.set('n', '<leader>fr', vim.lsp.buf.format, { buffer = event.buf })
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = {
                                    'vim',
                                },
                            },
                        },
                    },
                },
            }

            require('mason').setup {}

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed,
                { 'bashls', 'clangd', 'dockerls', 'gopls', 'html', 'jsonls', 'lua_ls', 'rust_analyzer', 'shellcheck',
                    'tailwindcss', 'templ', 'tsserver' })

            require('mason-tool-installer').setup {
                ensure_installed = ensure_installed,
            }

            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}

                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            {
                'L3MON4D3/LuaSnip',
                build = (function()
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
                    {
                        'rafamadriz/friendly-snippets',
                        config = function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                        end,
                    },
                },
            },
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            luasnip.config.setup {}

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                },
                mapping = {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-y>'] = cmp.mapping.confirm { select = true },

                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),

                    ['<C-Space>'] = cmp.mapping.complete {},

                    ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { 'i', 's' }),
                    ['<C-h>'] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                },
            }
        end,
    },
    {
        'windwp/nvim-ts-autotag',
        opts = {},
    },
}
