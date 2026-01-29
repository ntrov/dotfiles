return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      whitespace = {
        highlight = { 'Whitespace', 'NonText' }, -- Highlight groups for whitespace
      },
    },
  },
}
