#!/usr/bin/env lua

-- Set to true for debug build
debugbuild = false

local common = require "build_tools.lua.common"

local message, abort = common.build_rom("sonic", "s1built", "", "-p=0 -z=0," .. "kosinskiplus" .. ",Size_of_DAC_driver_guess,after", false, "https://github.com/sonicretro/s1disasm")

if message then
	exit_code = false
end

if abort then
	os.exit(exit_code, true)
end

if debugbuild then
-- Build DEBUG ROM
message, abort = common.build_rom("sonic", "s1built.debug", "-D __DEBUG__ -OLIST sonic.debug.lst", "-p=0 -z=0," .. "kosinskiplus" .. ",Size_of_DAC_driver_guess,after", false, "https://github.com/sonicretro/s1disasm")

if message then
    exit_code = false
end

if abort then
    os.exit(exit_code, true)
end

-- Append symbol table to the ROM.
local extra_tools = common.find_tools("debug symbol generator", "https://github.com/vladikcomper/md-modules", "https://github.com/sonicretro/s1disasm", "convsym")
if not extra_tools then
    os.exit(false)
end
os.execute(extra_tools.convsym .. " sonic.debug.lst s1built.debug.bin -input as_lst -range 0 FFFFFF -exclude -filter \"z[A-Z].+\" -a")
end

-- Correct the ROM's header with a proper checksum and end-of-ROM value.
common.fix_header("s1built.bin")
if debugbuild then
common.fix_header("s1built.debug.bin")
end

os.exit(exit_code, false)
