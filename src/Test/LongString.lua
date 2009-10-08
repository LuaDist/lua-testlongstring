--
-- lua-TestLongString : <http://testlongstring.luaforge.net/>
--

local _G = _G
local string = string
local pairs = pairs
local tostring = tostring
local type = type

local tb = require 'Test.Builder':new()

module 'Test.LongString'

-- Maximum string length displayed in diagnostics
max = 50

-- Amount of context provided when starting displaying a string in the middle
context = 10

local function display (str, offset)
    local fmt = '%q'
    if str:len() > max then
        offset = offset or 1
        if context then
            offset = offset - context
            if offset < 1 then
                offset = 1
            end
        else
            offset = 1
        end
        if offset == 1 then
            fmt = '%q...'
        else
            fmt = '...%q...'
        end
        str = str:sub(offset, offset + max - 1)
    end
    local s = string.format( fmt, str )
    s = s:gsub( '.',
                function (ch)
                    local val = ch:byte()
                    if val < 32 or val > 127 then
                        return '\\' .. string.format( '%03d', val )
                    else
                        return ch
                    end
                end )
    return s
end

local function common_prefix_length (str1, str2)
    local i = 1
    while true do
        local c1 = str1:sub(i,i)
        local c2 = str2:sub(i,i)
        if not c1 or not c2 or c1 ~= c2 then
            return i
        end
        i = i + 1
    end
end

function is_string(got, expected, name)
    if type(got) ~= 'string' then
        tb:ok(false, name)
        tb:diag("got value isn't a string : " .. tostring(got))
    elseif type(expected) ~= 'string' then
        tb:ok(false, name)
        tb:diag("expected value isn't a string : " .. tostring(expected))
    else
        local pass = got == expected
        tb:ok(pass, name)
        if not pass then
            local common_prefix = common_prefix_length(got, expected)
            tb:diag("         got: " .. display(got, common_prefix)
               .. "\n      length: " .. got:len()
               .. "\n    expected: " .. display(expected, common_prefix)
               .. "\n      length: " .. expected:len()
               .. "\n    strings begin to differ at char " .. tostring(common_prefix))
        end
    end
end

function is_string_nows(got, expected, name)
    if type(got) ~= 'string' then
        tb:ok(false, name)
        tb:diag("got value isn't a string : " .. tostring(got))
    elseif type(expected) ~= 'string' then
        tb:ok(false, name)
        tb:diag("expected value isn't a string : " .. tostring(expected))
    else
        local got_nows = got:gsub( "%s+", '' )
        local expected_nows = expected:gsub( "%s+", '' )
        local pass = got_nows == expected_nows
        tb:ok(pass, name)
        if not pass then
            local common_prefix = common_prefix_length(got_nows, expected_nows)
            tb:diag("after whitespace removal:"
               .. "\n         got: " .. display(got_nows, common_prefix)
               .. "\n      length: " .. got_nows:len()
               .. "\n    expected: " .. display(expected_nows, common_prefix)
               .. "\n      length: " .. expected_nows:len()
               .. "\n    strings begin to differ at char " .. tostring(common_prefix))
        end
    end
end

function like_string(got, pattern, name)
    if type(got) ~= 'string' then
        tb:ok(false, name)
        tb:diag("got value isn't a string : " .. tostring(got))
    elseif type(pattern) ~= 'string' then
        tb:ok(false, name)
        tb:diag("pattern isn't a string : " .. tostring(pattern))
    else
        local pass = got:match(pattern)
        tb:ok(pass, name)
        if not pass then
            tb:diag("         got: " .. display(got)
               .. "\n      length: " .. got:len()
               .. "\n    doesn't match '" .. pattern .. "'")
        end
    end
end

function unlike_string(got, pattern, name)
    if type(got) ~= 'string' then
        tb:ok(false, name)
        tb:diag("got value isn't a string : " .. tostring(got))
    elseif type(pattern) ~= 'string' then
        tb:ok(false, name)
        tb:diag("pattern isn't a string : " .. tostring(pattern))
    else
        local pass = not got:match(pattern)
        tb:ok(pass, name)
        if not pass then
            tb:diag("         got: " .. display(got)
               .. "\n      length: " .. got:len()
               .. "\n          matches '" .. pattern .. "'")
        end
    end
end

function contains_string(str, substring, name)
    if type(str) ~= 'string' then
        tb:ok(false, name)
        tb:diag("String to look in isn't a string")
    elseif type(substring) ~= 'string' then
        tb:ok(false, name)
        tb:diag("String to look for isn't a string")
    else
        local pass = str:find(substring, 1, true)
        tb:ok(pass, name)
        if not pass then
            tb:diag("    searched: " .. display(str)
               .. "\n  can't find: " .. display(substring))
        end
    end
end

function lacks_string(str, substring, name)
    if type(str) ~= 'string' then
        tb:ok(false, name)
        tb:diag("String to look in isn't a string")
    elseif type(substring) ~= 'string' then
        tb:ok(false, name)
        tb:diag("String to look for isn't a string")
    else
        local idx = str:find(substring, 1, true)
        local pass = not idx
        tb:ok(pass, name)
        if not pass then
            tb:diag("    searched: " .. display(str)
               .. "\n   and found: " .. display(substring)
               .. "\n at position: " .. tostring(idx))
        end
    end
end

for k, v in pairs(_G.Test.LongString) do  -- injection
    _G[k] = v
end

_VERSION = "0.1.0"
_DESCRIPTION = "lua-TestLongString : an extension for testing long string"
_COPYRIGHT = "Copyright (c) 2009 Francois Perrad"
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--
