local M = {
  {
    'folke/ts-comments.nvim',
    opts = {
      lang = {
        kdl = { '//%s', '/*%s*/' },
      },
    },
    event = 'VeryLazy',
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- foo: bar
    -- JIMMYSCENE: bar
    -- JIMMYSCENE(things): bar
    -- TODO(things): bar
    -- NOTE(things): bar
    -- WARNING(things): bar
    opts = {
      signs = false,
      highlight = {
        keyword = 'fg',
        after = '',
        pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
      },
      keywords = {
        FIX = {
          icon = ' ', -- icon used for the sign, and in search results
          color = 'error', -- can be a hex color, or a named color (see below)
          alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = ' ', color = 'info' },
        HACK = { icon = ' ', color = 'warning' },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        jimmyscene = {
          icon = ' ',
          color = '#34f4f0',
          alt = {
            'JS',
            'JIMMYSCENE',
            'JimmyScene',
            'Jimmyscene',
            'JIMMYSCENE',
            'blakee',
            'Blakee',
            'BLAKEE',
            'blake',
            'Blake',
            'BLAKE',
            'beasley',
            'bpeasley',
            'BEASLEY',
            'BPEASLEY',
          },
        },
        NOTE = { icon = ' ', color = 'hint', alt = { 'INFO', 'NB' } },
        TEST = {
          icon = '⏲ ',
          color = 'test',
          alt = { 'TESTING', 'PASSED', 'FAILED' },
        },
      },
    },
  },
}
require('ts-comments').setup(M[1].opts)
require('todo-comments').setup(M[2].opts)
