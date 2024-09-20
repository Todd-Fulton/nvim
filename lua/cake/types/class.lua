---@module "cake.types.meta"

local _type = {}

---@class cake.Class
local Class = {}
Class.__index = Class
setmetatable(Class, Class)

Class.vtable = {}
Class.vtable.__index = Class.vtable
setmetatable(Class.vtable, Class.vtable)

function Class:is_instance(v)
  local t = Class.typeof(v)
  if t == nil then return false end
  while self ~= t do
    local s = Class.superof(t)
    if s == t then return false end
    t = s
  end
  -- v is either the same type as self or a subclass
  return true
end

function Class:extend(c)
  local cls = c or {}
  cls.vtable = {}
  cls.vtable.__index = cls.vtable
  setmetatable(cls.vtable, self.vtable)
  return setmetatable(cls, self)
end

function Class:__call(o)
  o = o or {}
  o[_type] = self
  return setmetatable(o, self.vtable)
end

---@generic T
---@param v cake.Instance<T>
---@return `T`|nil
function Class.typeof(v)
  return type(v) == "table" and v[_type] or nil
end

function Class.superof(t)
  return getmetatable(t)
end

return Class
