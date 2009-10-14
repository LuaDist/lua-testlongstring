#! /usr/bin/lua

require 'Test.More'
plan(8)

if not require_ok 'Test.LongString' then
    BAIL_OUT "no lib"
end

local m = require 'Test.LongString'
type_ok( m, 'table' )
is( m, Test.LongString )
like( m._COPYRIGHT, 'Perrad', "_COPYRIGHT" )
like( m._DESCRIPTION, 'extension', "_DESCRIPTION" )
like( m._VERSION, '^%d%.%d%.%d$', "_VERSION" )

is( Test.LongString.max, 50, "max" )
is( Test.LongString.context, 10, "context" )
