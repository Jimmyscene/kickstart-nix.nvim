local Telescope = {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'debugloop/telescope-undo.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

    },
    {
      'nvim-telescope/telescope-ui-select.nvim',
    },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
}
vim.keymap.set("n",'<leader>U', function() require('telescope').extensions.undo.undo() end, { desc = 'Telescope undotree' })

function Telescope.config()
  local icons = require('extras.icons')
  local actions = require('telescope.actions')
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'TelescopeResults',
    callback = function(ctx)
      vim.api.nvim_buf_call(ctx.buf, function()
        vim.fn.matchadd('TelescopeParent', '\t\t.*$')
        vim.api.nvim_set_hl(0, 'TelescopeParent', { link = 'Comment' })
      end)
    end,
  })
  require('telescope').setup {
    pickers = {
      find_files = {
        hidden = true,
      },
      colorscheme = { enable_preview = true },
    },
    defaults = {
      color_devicons = true,
      entry_prefix = '   ',
      file_ignore_patterns = {
        'node_modules/',
        '%.git/',
        '%.terraform/',
        'vendor/',
        'snapshots/',
      },
      initial_mode = 'insert',
      -- path_display = filenameFirst,
      prompt_prefix = icons.ui.Telescope .. ' ',
      selection_caret = icons.ui.Forward .. ' ',
      selection_strategy = 'reset',
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--hidden',
      },
      previewer = false,
      mappings = {
        i = {
          ['<C-j>'] = actions.move_selection_next,
          ['<C-k>'] = actions.move_selection_previous,
          ['<esc>'] = actions.close,
        },
      },
    },
    extensions = {
      ['ui-select'] = {
        require('telescope.themes'),
      },
    },
  }

  require('telescope').load_extension('ui-select')
  require('telescope').load_extension('undo')
  require('telescope').load_extension('aerial')
  local function merge(table, table2)
    for k, v in pairs(table2) do
      table[k] = v
    end
    return table
  end
  local function withTheme(f, args)
    local themes = require('telescope.themes')
    local theme = themes.get_ivy
    local selected = theme(merge({ previewer = true, winblend = 10 }, args or {}))
    local function inner()
      return f(selected)
    end
    return inner
  end

  -- See `:help telescope.builtin`
  local builtin = require('telescope.builtin')
  local noPreview = { previewer = false }
  vim.keymap.set('n', '<leader>cc', withTheme(builtin.colorscheme, noPreview), { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sh', withTheme(builtin.help_tags, noPreview), { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', withTheme(builtin.keymaps, noPreview), { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>e', withTheme(builtin.find_files), { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', withTheme(builtin.builtin), { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set('n', '<leader>sw', withTheme(builtin.grep_string), { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>r', withTheme(builtin.live_grep), { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', withTheme(builtin.diagnostics), { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader><leader>', withTheme(builtin.resume), { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', withTheme(builtin.oldfiles), { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>b', withTheme(builtin.buffers), { desc = 'Find existing buffers' })
  vim.keymap.set(
    'n',
    '<leader>/',
    withTheme(builtin.current_buffer_fuzzy_find),
    { desc = 'Fuzzily search in current buffer' }
  )

  -- It's also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, { desc = '[S]earch [/] in Open Files' })
end
Telescope.config()

vim.keymap.set("n",'<leader>E', function() require('telescope').extensions.smart_open.smart_open() end)

local SmartOpen = {
  'danielfalk/smart-open.nvim',
  branch = '0.2.x',
  dependencies = {
    'kkharji/sqlite.lua',
    -- Only required if using match_algorithm fzf
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
    { 'nvim-telescope/telescope-fzy-native.nvim' },
  },
}

function SmartOpen.config()
  require('telescope').load_extension('smart_open')
end
SmartOpen.config()
