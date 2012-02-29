# lua-TestLongString : <http://fperrad.github.com/lua-TestLongString/>

project ( lua-testlongstring NONE )
cmake_minimum_required ( VERSION 2.6 )
include ( dist.cmake )

install_lua_module ( Test.LongString            src/Test/LongString.lua )

install_data ( CHANGES COPYRIGHT README.md )
install_test ( test/ )
