IncludeCS("cl_init.lua")
IncludeCS("shared.lua")
include("config.lua")
include("shared.lua")

local svFiles, svFolders = file.Find("climb/gamemode/server/*.lua", "LUA")
local shFiles, shFolders = file.Find("climb/gamemode/shared/*.lua", "LUA")
local clFiles, clFolders = file.Find("climb/gamemode/client/*.lua", "LUA")

for k, v in pairs(svFiles) do
	include("server/" .. v)
end

for k, v in pairs(shFiles) do
	include("shared/" .. v)
	IncludeCS("shared/" .. v)
end

for k, v in pairs(clFiles) do
	IncludeCS("client/" .. v)
end