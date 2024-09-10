return {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
        relative_pattern_support = true,
        snippetSupport = true
      },
    },
  },
  init_options = {
    format = {
      enable = true,   -- to use lsp format
    },
    lint = {
      enable = true
    },
    scan_cmake_in_package = true, -- it will deeply check the cmake file which found when search cmake packages.
    semantic_token = true,
    -- semantic_token heighlight. if you use treesitter highlight, it is suggested to set with false. it can be used to make better highlight for vscode which only has textmate highlight
  }
}
