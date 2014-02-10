#!/usr/local/bin/lua

local totable = require "lxp.totable"

local tests = {
	{
		[[<abc a1="A1" a2="A2">inside tag `abc'</abc>]],
		{
			[0] = "abc",
			a1 = "A1",
			a2 = "A2",
			"inside tag `abc'",
		},
	},
	{
		[[<qwerty q1="q1" q2="q2">
	<asdf>some text</asdf>
</qwerty>]],
		{
			[0] = "qwerty",
			q1 = "q1",
			q2 = "q2",
			"\n\t",
			{
				[0] = "asdf",
				"some text",
			},
			"\n",
		},
	},
}

function table._tostring (tab, indent, spacing)
	local s = {}
	spacing = spacing or ""
	indent = indent or "\t"
    table.insert (s, "{\n")
    for nome, val in pairs (tab) do
        table.insert (s, spacing..indent)
        local t = type(nome)
		if t == "string" then
            table.insert (s, string.format ("[%q] = ", nome))
		elseif t == "number" or t == "boolean" then
            table.insert (s, string.format ("[%s] = ", tostring (nome)))
        else
            table.insert (s, t)
        end
        t = type(val)
        if t == "string" or t == "number" then
            table.insert (s, string.format ("%q", val))
        elseif t == "table" then
            table.insert (s, table._tostring (val, indent, spacing..indent))
        else
            table.insert (s, t)
        end
        table.insert (s, ",\n")
    end
    table.insert (s, spacing.."}")
	return table.concat (s)
end

function table.print (tab, indent, spacing)
	io.write (table._tostring (tab, indent, spacing))
end

function table.equal (t1, t2)
	for nome, val in pairs (t1) do
		local tv = type(val)
		if tv == "table" then
			if not table.equal (val, t2[nome]) then
				return false, "["..nome.."]\t"..tostring(val).." ~= "..tostring(t2[nome])
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
	--s = string.gsub (s, "[\n\r\t]", "")
	local ds = assert (totable.parse ([[<?xml version="1.0" encoding="ISO-8859-1"?>]]..s[1]))
	--print(table._tostring(ds))
	print(table.equal (ds, s[2]))
end
