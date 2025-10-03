local eid = GetUpdatedEntityID()
local CTCid = EntityGetFirstComponent(eid, "CollisionTriggerComponent")
local difficuly = ModSettingGet("extol_space_journey.extol_space_difficulty")
if difficuly == "easy" then
	ComponentSetValue2(CTCid, "width", 25)
	ComponentSetValue2(CTCid, "height", 25)
elseif difficuly == "hard" then
	ComponentSetValue2(CTCid, "width", 15)
	ComponentSetValue2(CTCid, "height", 15)
end
