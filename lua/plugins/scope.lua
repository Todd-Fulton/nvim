return {
  "tiagovla/scope.nvim",
  dependencies = {
    "nanozuki/tabby.nvim"
  },
  --TODO: also when we open a new tab
  cmd = {"ScopeLoadState", "ScopeSaveState"},
  keys = {{"<Leader>ta", nil}},
  opts = {},
}
