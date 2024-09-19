---@meta "cake.types.meta"

---
---@generic T : cake.Class
---@class cake.Instance<T>
---@field [table] `T` [_type] stores the Class this Instance belongs to

---Classes are constructors
---@class cake.Class
---@field is_instance fun(self: cake.Class, v: any) : boolean
---@field protected vtable table
---@overload fun(...) : cake.Instance<cake.Class> Constructor, returns an instance of Class T
-- TODO: Classes should be able to be extended or inhereted

