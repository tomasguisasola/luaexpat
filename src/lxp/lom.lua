-- See Copyright Notice in license.html

local lxp = require "lxp"

local table = require"table"
local tinsert, tremove = table.insert, table.remove
local assert, pairs, type = assert, pairs, type


local function starttag (p, tag, attr)
  local stack = p:getcallbacks().stack
  local newelement = {tag = tag, attr = attr}
  tinsert(stack, newelement)
end

local function endtag (p, tag)
  local stack = p:getcallbacks().stack
  local element = tremove(stack)
  assert(element.tag == tag)
  local level = #stack
  tinsert(stack[level], element)
end

local function text (p, txt)
  local stack = p:getcallbacks().stack
  local element = stack[#stack]
  local n = #element
  if type(element[n]) == "string" then
    element[n] = element[n] .. txt
  else
    tinsert(element, txt)
  end
end

local function parse (o)
  local c = { StartElement = starttag,
              EndElement = endtag,
              CharacterData = text,
              _nonstrict = true,
              stack = {{}}
            }
  local p = lxp.new(c)
  if type(o) == "string" then
    local status, err, line, col, pos = p:parse(o)
    if not status then return nil, err, line, col, pos end
  else
    for l in pairs(o) do
      local status, err, line, col, pos = p:parse(l)
      if not status then return nil, err, line, col, pos end
    end
  end
  local status, err, line, col, pos = p:parse() -- close document
  if not status then return nil, err, line, col, pos end
  p:close()
  return c.stack[1][1]
end

return { parse = parse }
