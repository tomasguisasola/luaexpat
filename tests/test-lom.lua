#!/usr/local/bin/lua

local lom = require "lxp2.lom"

local tests = {
	{
		[[<abc a1="A1" a2="A2">inside tag `abc'</abc>]],
		{
			tag="abc",
			attr = { "a1", "a2", a1 = "A1", a2 = "A2", },
			"inside tag `abc'",
		},
	},
	{
		[[<qwerty q1="q1" q2="q2">
	<asdf>some text</asdf>
</qwerty>]],
		{
			tag = "qwerty",
			attr = { "q1", "q2", q1 = "q1", q2 = "q2", },
			"\n\t",
			{
				tag = "asdf",
				attr = {},
				"some text",
			},
			"\n",
		},
	},
}

function table.equal (t1, t2)
	for nome, val in pairs (t1) do
		local tv = type(val)
		if tv == "table" then
			if type(t2[nome]) ~= "table" then
				return false, "Different types at entry `"..nome.."': t1."..nome.." is "..tv.." while t2."..nome.." is "..type(t2[nome]).." ["..tostring(t2[nome]).."]"
			else
				local ok, msg = table.equal (val, t2[nome])
				if not ok then
					return false, "["..nome.."]\t"..tostring(val).." ~= "..tostring(t2[nome]).."; "..msg
				end
			end
		else
			if val ~= t2[nome] then
				return false, "["..nome.."]\t"..tostring(val).." ~= "..tostring(t2[nome])
			end
		end
	end
	return true
end


for i, s in ipairs(tests) do
	local ds = assert (lom.parse ([[<?xml version="1.0" encoding="ISO-8859-1"?>]]..s[1]))
	assert(table.equal (ds, s[2]))
end

local o = assert (lom.parse ([[
<?xml version="1.0"?>
<a1>
	<b1>
		<c1>t111</c1>
		<c2>t112</c2>
	</b1>
	<b2>
		<c1>t121</c1>
		<c2>t122</c2>
	</b2>
</a1>]]))
assert (o.tag == "a1")
assert (o[1] == "\n\t")
assert (o[2].tag == "b1")
assert (o[2][2].tag == "c1")
local c1 = lom.find_elem (o, "c1")
assert (type(c1) == "table")
assert (c1.tag == "c1")
assert (c1[1] == "t111")
local next_child = lom.list_children (o)
assert (next_child().tag == "b1")
assert (next_child().tag == "b2")
assert (next_child() == nil)

print"OK"
