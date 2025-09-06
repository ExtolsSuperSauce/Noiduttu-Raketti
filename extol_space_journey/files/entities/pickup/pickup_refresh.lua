
local player_unit = EntityGetWithTag("player_unit")[1]
local _,py = EntityGetTransform(player_unit)

local eid = GetUpdatedEntityID()
local _,my_y = EntityGetTransform(eid)

if py - 450 > my_y then
	local sprite_comp = EntityGetFirstComponent(eid,"SpriteComponent")
	ComponentSetValue2(sprite_comp,"alpha",1)
	local vsc = EntityGetFirstComponent(eid,"VariableStorageComponent")
	ComponentSetValue2(vsc,"value_bool",true)
end