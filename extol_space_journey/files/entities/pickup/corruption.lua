function collision_trigger(collider)
	local eid = GetUpdatedEntityID()
	local vsc = EntityGetFirstComponent(eid,"VariableStorageComponent")
	if ComponentGetValue2(vsc,"value_bool") then
		GameAddFlagRun("i_extol_your_curiosity")
		GameAddFlagRun("extol_corrupt_me")
		GamePlaySound("mods/extol_space_journey/files/audio/extol_space.bank","sounds/corruption")
	end
end