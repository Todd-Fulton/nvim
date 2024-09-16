---@meta cake.config.cfg

--- A configuration is a table of `cake.Option`s and `cake.Setting`s specific
--- to a particular package. A configuration does not describe 
--- how to configure a package. The package itself will
--- provide a method for configuring the plugins that it
--- uses internally.
--- @class cake.Config
--- @field pkg string Which package does this config belong to
--- @field options? cake.Option[]|cake.OptionSet[]
--- @field settings? cake.Setting[]|cake.SettingSet[]


--- A `cake.Setting` is an unit of configuration that is required for
--- a package to operate. It always provides a default, but can be modified
--- by the user. 
---@class cake.Setting
---@field name string A user facing name for this setting
---@field desc string
---@field value any The value of this setting
---@field default any The default value of this setting
---@field validate? fun(val : any) : boolean An optional validation function

--- A `cake.Option` is a unit of configuration that is optional. It is
--- not nessissary for a package to operate, that is, it can be nil or otherwise
--- unset.
---@class cake.Option
---@field name string A user facing name for this option
---@field desc? string
---@field text? string The string representation of this option
---@field value? any
---The method to reify the value of this option
---@field deserialize? fun(s: string) : any
---@field validate? fun(s : string) : boolean An optional validation function

---@class cake.OptionSet
---@field name string A user facing name for this set of options
---@field desc string
---@field options (cake.OptionSet|cake.Option)[]

---@class cake.SettingSet
---@field name string A user facing name for this set of options
---@field desc string
---@field options (cake.SettingSet|cake.Setting)[]

