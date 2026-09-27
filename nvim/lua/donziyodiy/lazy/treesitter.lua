local Plugin = { 'nvim-treesitter/nvim-treesitter' }

Plugin.dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects' }
}

-- See :help nvim-treesitter-modules
Plugin.opts = {
    highlight = {
        enable = true,
    },
    -- :help nvim-treesitter-textobjects-modules
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            }
        },
    },
    ensure_installed = {
        'javascript',
        'typescript',
        'tsx',
        'lua',
        'vim',
        'vimdoc',
        'css',
        'json',
        'c',
        'rust',
        'python',
        'cpp',
        'go',
        'markdown',
        'markdown_inline'
    },
}

return Plugin
