-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
return {
  {
    "kkoomen/vim-doge",
    config = function() vim.cmd ":call doge#install()" end,
    event = "User AstroGitFile",
  },
}
