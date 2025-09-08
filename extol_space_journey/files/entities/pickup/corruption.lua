function collision_trigger(collider)
	local eid = GetUpdatedEntityID()
	local vsc = EntityGetFirstComponent(eid,"VariableStorageComponent")
	local x,y = EntityGetTransform(eid)
	if ComponentGetValue2(vsc, "value_bool") then
		GameAddFlagRun("i_extol_your_curiosity")
		GameAddFlagRun("extol_corrupt_me")
		GamePlaySound("mods/extol_space_journey/files/audio/extol_space.bank", "sounds/corruption", x, y)
		ComponentSetValue2(vsc, "value_bool", false) -- prevents sound spam from single corruption pickup
	end
end