local M = {
  'kevinhwang91/nvim-ufo', -- Folding
  event = 'BufRead',
  dependencies = { { 'kevinhwang91/promise-async' } },
    -- stylua: ignore
    keys = {
        { "zR", function() require("ufo").openAllFolds() end },
        -- closeAllFolds == closeFoldsWith(0)
        { "zM", function() require("ufo").closeAllFolds() end },
        { "zr", function() require("ufo").openFoldsExceptKinds() end },
        { "zm", function(...) require("ufo").closeFoldsWith(...) end },
        { "K", function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end,
        },
    },
}
local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' 󰁂 %d '):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, 'MoreMsg' })
  return newVirtText
end

function M.config() --code folding
  vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true
  vim.o.foldclose = 'all'
  require('ufo').setup {
    provider_selector = function()
      return { 'treesitter', 'indent' }
    end,
    fold_virt_text_handler = handler,
  }
  vim.o.foldcolumn = '0' -- '0' is not bad
end

M.config()
