local M = {}

local Class = require('cake.types.class')

local _value = {}
local _refinement = {}

---@generic T : cake.Class
---@class ClassTemplate
---@overload fun(...) : `T` ClassTemplates are type constructors


local refm_vtable = {
  __newindex = function(t, k, v)
    if k == "value" then
      if not t[_refinement]:run_checks(v) then
        t[_refinement]:error(v)
      end
      rawset(t, _value, v)
    else
      t[_value][k] = v
      if not t[_refinement]:run_checks(t[_value]) then
        t[_refinement]:error(t[_value])
      end
    end
  end,
  __index = function(t, k)
    if k == "value" then
      return t[_value]
    elseif k == _value then
      return nil
    else
      return t[_value][k]
    end
  end
}

--- Refinement is a ClassTemplate.
---@generic R : cake.Class
---@generic T
---@class Refinement : ClassTemplate<`R`>
M.Refinement = {}
M.Refinement.__index = M.Refinement


local function get_refine_vtable(T)
  local proxy_mt = {
    __index = refm_vtable.__index,
    __newindex = refm_vtable.__newindex,
  }

  local tty = type(T)

  if tty == "table" then
    if T.vtable ~= nil then
      setmetatable(proxy_mt, T.vtable)
    else
      for k, v in pairs(getmetatable(T)) do
        if type(v) == "function" and not (k == "__index" or "__newindex") then
          proxy_mt[k] = v
        end
      end
    end
  elseif tty == "string" then
    proxy_mt.__eq = function(a, b)
      return a.value == (b[_refinement] ~= nil and b.value or b)
    end
    if T == "string" or T == "table" then
      proxy_mt.__len = function(t)
        return #t.value
      end
      if T == "string" then
        proxy_mt.__concat = function(a, b)
          return a.value .. (b[_refinement] ~= nil and b.value or b)
        end
      end
    elseif T == "number" then
      proxy_mt.__add = function(a, b)
        return a.value + (b[_refinement] ~= nil and b.value or b)
      end
      proxy_mt.__sub = function(a, b)
        return a.value - (b[_refinement] ~= nil and b.value or b)
      end
      proxy_mt.__mul = function(a, b)
        return a.value * (b[_refinement] ~= nil and b.value or b)
      end
      proxy_mt.__div = function(a, b)
        return a.value / (b[_refinement] ~= nil and b.value or b)
      end
      proxy_mt.__unm = function(a)
        return -a.value
      end
      proxy_mt.__mod = function(a, b)
        return a.value % (b[_refinement] ~= nil and b.value or b)
      end
      proxy_mt.__pow = function(a, b)
        return a.value ^ (b[_refinement] ~= nil and b.value or b)
      end
    elseif T == "function" then
      proxy_mt.__call = function(t, ...)
        return t.value(...)
      end
    end
    if T ~= "function" and T ~= "boolean" then
      proxy_mt.__lt = function(a, b)
        return a.value < (b[_refinement] ~= nil and b.value or b)
      end
      proxy_mt.__le = function(a, b)
        return a.value <= (b[_refinement] ~= nil and b.value or b)
      end
    end
    if T ~= "function" and T ~= "table" then
      proxy_mt.__tostring = function(t)
        return tostring(t.value)
      end
    end
  end

  return proxy_mt
end


-- TODO: Returm a RefinementType
-- A RefinementType should be a factory of values of checked T

---@generic T
---@class DefaultRefinement : cake.Class
---@field check fun(self, v : `T`) : boolean
local DefaultRefinement = Class:extend()
DefaultRefinement.__index = DefaultRefinement

---@param self DefaultRefinement
---@param v `T`
function DefaultRefinement:error(v)
  error(string.format("Invalid value for %s: %s", tostring(self), v), 3)
end

---@private
function DefaultRefinement:run_checks(v)
  if getmetatable(self) and getmetatable(self) ~= self then
    return getmetatable(self):run_checks(v) and self:check(v)
  else
    return self:check(v)
  end
end

function DefaultRefinement:check(_)
  return true
end

---@param v `T`
function DefaultRefinement:is_instance(v)
  return type(v) == "table" and
      v[_refinement] == self or self:check(v)
end

function DefaultRefinement:__call(o)
  local instance = {}
  instance[_refinement] = self
  setmetatable(instance, self.vtable)
  if o ~= nil then instance.value = o end
  return instance
end

function DefaultRefinement:__tostring()
  return "Refinement"
end

setmetatable(DefaultRefinement, DefaultRefinement)

---@param self Refinement<`R`, `T`>
---@param class `T`|string
---@param impl {check: (fun(self, v) : boolean), error? : fun(t, u, v), [any] : any}
---@return `R`
function M.Refinement:__call(class, impl)
  ---@class impl `R`
  impl = impl or {}
  impl.vtable = get_refine_vtable(class)

  return setmetatable(impl, DefaultRefinement)
end

setmetatable(M.Refinement, M.Refinement)

local OnUpdate = {}
OnUpdate.__index = OnUpdate

function OnUpdate:on_update(_, _, v)
  vim.notify(string.format("Updated value: %s", v))
end

---@param T Class
---@return Class
function OnUpdate:wrap(T)
  -- rt is the metatable for the proxy Class
  -- not the poxy instances
  local rt = vim.fn.copy(getmetatable(T))
  rt.__index = rt

  -- instance metatable is the metatable for proxy instances of type `rt`
  local og_mt = getmetatable(T).instance_metatable
  if type(og_mt.__newindex) == "function" then
    rt.instance_metatable.__newindex = function(t, u, v)
      og_mt.__newindex(t, u, v)
      self:on_update(t, u, v)
    end
  else
    rt.instance_metatable.__newindex = function(t, u, v)
      rawset(t, u, v)
      self:on_update(t, u, v)
    end
  end

  return setmetatable({}, rt)
end

---@class cls Class
---@return Class
function OnUpdate:extend(cls)
  cls = cls or {}
  cls.__index = cls
  return setmetatable(cls, self)
end

-- TESTS
local Number = M.Refinement("number",
  {
    check = function(_, v)
      return type(v) == "number"
    end,
    error = function(_, v)
      error(string.format("Invalid type for Refinement : %s", type(v)), 4)
    end
  }
)

local Boolean = M.Refinement("boolean",
  {
    check = function(_, v)
      return type(v) == "boolean"
    end,
    error = function(_, v)
      error(string.format("Invalid type for Refinement : %s", type(v)), 4)
    end
  }
)

local a = Number(1)
local b = Number(2)
local c = Number(a + b)
local t = Boolean(c > a)

vim.print(a.value)
vim.print(string.format("%s: %s", type(c), c))
vim.print(string.format("%s: %s", type(t), t))
c.value = 2

vim.print(string.format("a is a Number: %s", Number:is_instance(a)))
vim.print(string.format("c is a Number: %s", Number:is_instance(c)))
vim.print(string.format("3 is a Number: %s", Number:is_instance(3)))

c.value = "2"

return M
