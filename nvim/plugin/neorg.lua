return ({
  'nvim-neorg/neorg',
  dependencies = {
    'nvim-neorg/lua-utils.nvim',
    'pysan3/pathlib.nvim',
    'nvim-neotest/nvim-nio',
  },
  config = function()
    vim.keymap.set('n', '<leader>no', ':e ~/notes/index.norg<cr>', { silent = true })

    vim.api.nvim_create_autocmd('Filetype', {
      pattern = 'norg',
      callback = function()
        vim.keymap.set('n', '<localleader>ju', ':Neorg journal toc update<cr>', { buffer = true })
      end,
    })
    require('neorg').setup {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {
          config = {
            icon_preset = 'diamond',
          },
        },
        ['core.journal'] = {
          config = {
            workspace = 'notes',
          },
        },
        ['core.export'] = {},
        ['core.tangle'] = {
          config = {
            tangle_on_write = true,
          },
        },
        ['core.dirman'] = {
          config = {
            workspaces = {
              notes = '~/notes',
            },
          },
        },
        ['core.keybinds'] = {
          config = {
            hook = function(keybinds)
              keybinds.map_event('norg', 'n', keybinds.leader .. 'o', 'core.looking-glass.magnify-code-block')
              keybinds.map_event('norg', 'i', '<C-t>', 'core.itero.next-iteration')
            end,
          },
        },
        ['core.qol.todo_items'] = {
          config = {
            create_todo_parents = true,
          },
        },
      },
    }
  end,
}).config()
