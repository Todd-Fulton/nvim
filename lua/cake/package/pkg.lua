---@meta cake.package.pkg
---@module "cake.config.cfg"

--- A package is a bundle of functionality provided by zero or more plugins
--- along with a set of user configurable options
---@class cake.Package
---@field name string
---@field version string
---@field desc string
---@field category cake.Category
---@field subcategory? string
---@field conflicts? cake.Conflict[]
---@field dependencies? cake.Dependency[]
---@field opt_deps? cake.Dependency[]
---@field replaces? string[]
---@field functionality? cake.Functionality[]
---@field config? cake.Config
---@field sha256 string
---@field packager string
---@field url string
---@field plugins? cake.Plugin[]
---@field install fun(self: cake.Package)
---@field configure fun(self: cake.Package)

---@class cake.Conflict
---@field package_name string
---@field version string
---@field functionality? string
---@field option? string

---@class cake.Dependency
---@field package_name? string
---@field version? string
---@field functionality? string[]
---@field options? string[]

---@class cake.Plugin
---@field name string
---@field url string
---@field lazy_opts? table
---@field setup fun(self: cake.Plugin, opts: table)

--- A callback to be executed on keybind or autocmd
---@class cake.Functionality
---@field name string The name of this functionality (displayed to user)
---@field desc string A description of this functionality (displayed to user)
---@field options? cake.Option[] An optional list of options that this functionality needs
---                             can be configured by the user
---@operator call(...) : nil The code to exectute

--- A category of package, used to organize packages during search or display to the user
---@alias cake.Category
---| '"ui"' # Package provides UI components (e.g. tablines, directory view, git view, etc)
---| '"lsp"' # Package provides LSP components (e.g. C++ LSP integration)
---| '"process"' # Package provides process management (e.g. run commands, build tools, linters, formaters, etc)
---| '"colorscheme"' # Package provides one or more colorschemes
---| '"lib"' # Package provides library utilities (mostly used as Dependencies for other packages)
---| '"addon"' # Addon to another package

