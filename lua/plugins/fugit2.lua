return  {
  {
    'SuperBo/fugit2.nvim',
    opts = {
      width = 150,
      external_diffview = true, -- use diffview.nvim until fugit2's is more stable
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      {
        'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
        dependencies = { 'stevearc/dressing.nvim' }
      },
      'sindrets/diffview.nvim'
    },
    cmd = { 'Fugit2', 'Fugit2Blame', 'Fugit2Diff', 'Fugit2Graph' },
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- lazy, only load diffview by these commands
    cmd = {
      'DiffviewFileHistory', 'DiffviewOpen', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh'
    }
  }
}
