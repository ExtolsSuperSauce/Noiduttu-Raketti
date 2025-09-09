local eid = GetUpdatedEntityID()
local vsc = EntityGetFirstComponent(eid, "VariableStorageComponent")
if ComponentGetValue2(vsc, "value_int") ~= GameGetFrameNum() - 60 and not ComponentGetValue2(vsc, "value_bool") then
	local sprite_comp = EntityGetFirstComponent(eid, "SpriteComponent")
	ComponentSetValue2(sprite_comp, "alpha", 1)
	ComponentSetValue2(vsc, "value_bool", true)
end
ComponentSetValue2(vsc, "value_int", GameGetFrameNum())
