 -- TODO: get dynamically using env.PATH
local lldb_vscode_exe = "/opt/rocm/lib/llvm/bin/lldb-dap"

return {
  type = 'executable',
  command = lldb_vscode_exe,
  name = 'lldb'
}
