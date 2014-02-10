#!/usr/local/bin/lua

local lom = require "lxp.lom"

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

print"OK"
