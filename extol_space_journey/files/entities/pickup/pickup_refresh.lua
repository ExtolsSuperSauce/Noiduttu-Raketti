local eid = GetUpdatedEntityID()
local vsc = EntityGetFirstComponent(eid, "VariableStorageComponent")
if not (ComponentGetValue2(vsc, "value_int") >= GameGetFrameNum() - 150) and not ComponentGetValue2(vsc, "value_bool") then
	local sprite_comp = EntityGetFirstComponent(eid, "SpriteComponent")
	ComponentSetValue2(sprite_comp, "alpha", 1)
	ComponentSetValue2(vsc, "value_bool", true)
end
ComponentSetValue2(vsc, "value_int", GameGetFrameNum())
