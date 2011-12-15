local objects = {}
setmetatable(objects, {__index={["subset"]=function(object, proxies)
    for _,o in ipairs(proxies) do
        if object == o then return true end
    end
end}})

local function _pickle(object, seen, indent, keys, name, defer)
    if not seen then seen = {} end
    if not defer then defer = {} end
    if not keys then keys = {} end
    if not indent then indent = "" end

    local serialize_key = function(key)
        if type(key) == "string" then
            keys[key] = "[=["..key.."]=]"
        else
            keys[tostring(key)] = "".._pickle(key, seen, "", keys, "k[ [=["..tostring(key).."]=] ]", defer):gsub("\n"," ")..""
        end
        return keys[key]
    end

    local escape = function(o)
        return o:gsub("\\","\\\\"):gsub("'","\\'"):gsub('"','\\"')
    end

    --Switch Object type:

    if type(object) == "table" then
        if seen[object] == true then
          if not defer[object] then
            defer[object] = {name}
          else
            table.insert(defer[object], name)
          end
          return "nil", seen, defer, keys
        elseif seen[object] then
          return seen[object][1], seen, defer, keys
        end

        if not seen[object] then
          seen[object] = true
        end

        local serialize = "{\n"
        for key, value in pairs(object) do
            serialize_key(key)
            serialize = serialize .. indent.."\t" ..
                    "[ k[ [=[" .. tostring(key) .. "]=] ] ]" .. " = " ..
                    tostring(_pickle(
                      value,
                      seen,
                      indent.."\t",
                      keys,
                      name .. "[ k[ [=[" .. tostring(key) .. "]=] ] ]",
                      defer)) .. ",\n"
        end
        serialize = serialize .. indent .. "}"

        seen[object] = {serialize, name}
        return serialize, seen, defer, keys
    elseif type(object) == "string" then
        seen[object] = {'[=[' .. escape(object) .. ']=]', serialize, name}
        return seen[object][1], seen, defer
    elseif type(object) == "function" then
        local nonnative, fundump = pcall(string.dump, object)

        seen[object] =  {(nonnative and "loadstring([=[".. fundump .."]=])" or "nil"), name}
        return seen[object][1], seen, defer, keys
    elseif type(object) == "number" then
        local serialize = tostring(object)
        if object == 1/0 then
          serialize = "1/0"
        elseif object == 0/0 then
          serialize = "0/0"
        end

        seen[object] = {serialize, name }
        return serialize
    elseif objects.subset(type(object), {"userdata", "file"}) then
        seen[object] = {"nil", name}
        return "nil", seen, defer, keys
    end
    return tostring(object), seen, defer, keys
end

pickle = {}

function pickle.dumps(object)
    local dump, seen, defer, keys = _pickle(object, {}, "", {}, "_L", {})

    local str = "local _L\nlocal k = {\n"

    for k,v in pairs(keys) do
      str = str .. "\t[ [=[" .. k ..  "]=] ]" .. " = " .. v .. ",\n"
    end

    str = str .. "}\n"

    str = str .. [[
setmetatable(k, {
  __index = function(self, k)
    -- no item
    return "---reserved---"..k
  end,
  __newindex = function(self, k, v)
    -- update _L
    --print(k,v)
    _L[v] = _L["---reserved---"..k]
    _L["---reserved---"..k] = nil
  end
})
]]

    str = str .. "_L = " .. dump .. "\n"

    for k,names in pairs(defer) do
      for _=#names, 1,-1 do
        str = str .. names[_] .. " = " .. seen[k][2] .. "\n"
      end
    end

    str = str .. "setmetatable(k, {})\n"

    local dump, seen, defer, keys = _pickle(debug.getmetatable(object), seen, "", {}, "_L", {})

    if dump ~= "nil" then
      str = str .. "local _Lm\n"
      for k,v in pairs(keys) do
        str = str .. "\tk[ [=[" .. k ..  "]=] ]" .. " = " .. v .. "\n"
      end

      str = str .. [[
setmetatable(k, {
  __index = function(self, k)
    -- no item
    return "---reserved---"..k
  end,
  __newindex = function(self, k, v)
    -- update _mL
    --print(k,v)
    _mL[v] = _mL["---reserved---"..k]
    _mL["---reserved---"..k] = nil
  end
})
]]

      str = str .. "_mL = " .. dump .. "\n"

      for k,names in pairs(defer) do
        for _=#names, 1,-1 do
          str = str .. names[_] .. " = " .. seen[k][2] .. "\n"
        end
      end

      str = str .. "setmetatable(_L, _mL)\n"
      str = str .. "setmetatable(k, {})\n"
    end

    str = str .. "return _L\n"
    return str
end

function pickle.dump(object, filename)
    local dump = pickle.dumps(object)
    local _file = io.open(filename, "wb")
    _file:write(dump)
    _file:close()
    return dump
end

function pickle.loads(object)
    local fn, err = loadstring(object)
    if fn ~= nil then
        return fn()
    end
	print("pickle.loads error: ", err)
    error(err)
end

function pickle.load(filename)
    local _file = io.open(filename, "rb")
    local dump = _file:read("*all")
    local object = pickle.loads(dump)
    _file:close()
    return object
end


--[[
local tab1 = {1,2,3}
print(pickle.dumps(tab1))

--]]
