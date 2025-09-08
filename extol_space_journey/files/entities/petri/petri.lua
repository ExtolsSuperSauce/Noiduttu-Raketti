function collision_trigger(collider)
	if GameHasFlagRun("extol_when_the_extol_extol") and not GameHasFlagRun("petri_the_purho_banned_extol") then
		GameAddFlagRun("petri_the_purho_banned_extol")
		GamePrintImportant("Petri Awoken","Extol was banned")
	end
	if not GameHasFlagRun("extol_petri_poke") then
		local eid = GetUpdatedEntityID()
		local x,y = EntityGetTransform(eid)
		if Random(0,1) == 1 then
			GamePlaySound("mods/extol_space_journey/files/audio/extol_space.bank","sounds/kicking_ragdolls",x,y)
		else
			GamePlaySound("mods/extol_space_journey/files/audio/extol_space.bank","sounds/herring_bone",x,y)
		end
		GameAddFlagRun("extol_petri_poke")
		GameAddFlagRun("extol_rocket_success")
	end
end