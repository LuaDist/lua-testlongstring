--
-- lua-TestLongString : <http://testlongstring.luaforge.net/>
--

local _G = _G
local pairs = pairs
local require = require
local tostring = tostring
local type = type

module 'Test.LongString'

local tb = require 'Test.Builder'

function is_string(got, expected, desc)
    if type(got) ~= 'string' then
        tb.ok(false, desc)
        tb.diag("got value isn't a string : " .. tostring(got))
    elseif type(expected) ~= 'string' then
        tb.ok(false, desc)
        tb.diag("expected value isn't a string : " .. tostring(expected))
    else
        local pass = got == expected
        tb.ok(pass, desc)
        if not pass then
            tb.diag("         got: " .. got
               .. "\n      length: " .. got:len()
               .. "\n    expected: " .. expected
               .. "\n      length: " .. expected:len()
               .. "\n    strings begin to differ at char XXX")
        end
    end
end

function like_string(got, pattern, desc)
    if type(got) ~= 'string' then
        tb.ok(false, desc)
        tb.diag("got value isn't a string : " .. tostring(got))
    elseif type(pattern) ~= 'string' then
        tb.ok(false, desc)
        tb.diag("pattern isn't a string : " .. tostring(pattern))
    else
        local pass = got:match(pattern)
        tb.ok(pass, desc)
        if not pass then
            tb.diag("         got: " .. got
               .. "\n      length: " .. got:len()
               .. "\n    doesn't match '" .. pattern .. "'")
        end
    end
end

function unlike_string(got, pattern, desc)
    if type(got) ~= 'string' then
        tb.ok(false, desc)
        tb.diag("got value isn't a string : " .. tostring(got))
    elseif type(pattern) ~= 'string' then
        tb.ok(false, desc)
        tb.diag("pattern isn't a string : " .. tostring(pattern))
    else
        local pass = not got:match(pattern)
        tb.ok(pass, desc)
        if not pass then
            tb.diag("         got: " .. got
               .. "\n      length: " .. got:len()
               .. "\n    matches '" .. pattern .. "'")
        end
    end
end

function contains_string(str, substring, desc)
    if type(str) ~= 'string' then
        tb.ok(false, desc)
        tb.diag("String to look in isn't a string")
    elseif type(substring) ~= 'string' then
        tb.ok(false, desc)
        tb.diag("String to look for isn't a string")
    else
        local pass = str:find(substring, 1, true)
        tb.ok(pass, desc)
        if not pass then
            tb.diag("    searched: " .. str
               .. "\n  can't find: " .. substring)
        end
    end
end

function lacks_string(str, substring, desc)
    if type(str) ~= 'string' then
        tb.ok(false, desc)
        tb.diag("String to look in isn't a string")
    elseif type(substring) ~= 'string' then
        tb.ok(false, desc)
        tb.diag("String to look for isn't a string")
    else
        local idx = str:find(substring, 1, true)
        local pass = not idx
        tb.ok(pass, desc)
        if not pass then
            tb.diag("    searched: " .. str
               .. "\n   and found: " .. substring
               .. "\n at position: " .. tostring(idx))
        end
    end
end

for k, v in pairs(_G.Test.LongString) do
    if k:sub(1, 1) ~= '_' then
        -- injection
        _G[k] = v
    end
end

_VERSION = "0.0.0"
_DESCRIPTION = "lua-TestLongString : an extension for testing long string"
_COPYRIGHT = "Copyright (c) 2009 Francois Perrad"
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
