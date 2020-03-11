include("shared.lua")

local shFiles, shFolders = file.Find("climb/gamemode/shared/*.lua", "LUA")
local clFiles, clFolders = file.Find("climb/gamemode/client/*.lua", "LUA")

for k, v in pairs(shFiles) do
	include("shared/" .. v)
end

for k, v in pairs(clFiles) do
	include("client/" .. v)
end
