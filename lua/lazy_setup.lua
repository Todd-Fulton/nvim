require("lazy").setup(
{
    { import = "plugins" },
},
{
  ui = { backdrop = 100 },
  change_detection = {
    notify = false
  },
  install = {
    missing = true,
    colorscheme = { "tokyonight-night" },
  },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      -- disable some rtp plugins, add more to your liking
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
} --[[@as LazyConfig]]
)
