local Mini = {
  -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  -- mini.ai requires this for something
  -- https://github.com/echasnovski/mini.nvim/blob/d330f2639462084d2ef6c699ccd6219b81c45bc7/doc/mini-ai.txt#L688
  dependencies = { { 'nvim-treesitter/nvim-treesitter-textobjects', enabled = true } },
  lazy = false,
  keys = {
    {
      '<leader>A',
      function()
        require('mini.starter').open()
      end,
      'Open Mini Start Page',
    },
  },
}

function Mini.config()
  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yinq - [Y]ank [I]nside [N]ext [']quote
  --  - ci'  - [C]hange [I]nside [']quote
  local spec_treesitter = require('mini.ai').gen_spec.treesitter
  require('mini.ai').setup {
    n_lines = 500,
    custom_textobjects = {
      f = spec_treesitter { a = '@function.outer', i = '@function.inner' },
      o = spec_treesitter {
        a = { '@conditional.outer', '@loop.outer' },
        i = { '@conditional.inner', '@loop.inner' },
      },
      a = spec_treesitter { a = '@attribute.outer', i = '@attribute.inner' },
    },
  }

  require('mini.surround').setup()

  local starter = require('mini.starter')

  starter.setup {
    query_updaters = 'EN0123456789',
    autoopen = true,
    evaluate_single = true,
    items = {
      starter.sections.recent_files(10, true),
      starter.sections.recent_files(10, false),
      {
        {
          action = 'enew',
          name = 'Edit New Buffer',
          section = 'Builtin actions',
        },
        {
          action = 'e ~/dotfiles/modules/nvim/init.lua',
          name = 'Neovim Config',
          section = 'Builtin actions',
        },
      },
    },
    content_hooks = {
      starter.gen_hook.aligning('center', 'center'),
      starter.gen_hook.adding_bullet(),
      starter.gen_hook.indexing('all', { 'Builtin actions' }),
      starter.gen_hook.padding(3, 2),
    },
  }
  vim.cmd([[
              augroup MiniStarterJK
              au!
              au User MiniStarterOpened nmap <buffer> j <Cmd>lua MiniStarter.update_current_item('next')<CR>
              au User MiniStarterOpened nmap <buffer> k <Cmd>lua MiniStarter.update_current_item('prev')<CR>
              augroup END
            ]])
end

local TrailSpace = {
  'echasnovski/mini.trailspace',
  event = 'BufRead',
  opts = {},
  config = function()
    local trailspace = require('mini.trailspace')
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function(ev)
        if vim.bo[ev.buf].modifiable and vim.bo[ev.buf].buftype == '' then
          trailspace.trim()
          trailspace.trim_last_lines()
        end
      end,
    })
    trailspace.setup()
  end,
}
Mini.config()
TrailSpace.config()
