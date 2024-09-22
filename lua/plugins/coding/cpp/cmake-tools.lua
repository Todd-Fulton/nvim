---TODO: Load when opening a workspace/project configured with cmake
return {
  "Civitasv/cmake-tools.nvim",
  ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "cmake" },
  dependencies = {
    'stevearc/overseer.nvim',
  },
  opts = {
    cmake_build_directory = function ()
      return "build"
    end
  }
}
