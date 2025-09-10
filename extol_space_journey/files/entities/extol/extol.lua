function collision_trigger(collider)
	if not GameHasFlagRun("extol_when_the_extol_extol") and GameHasFlagRun("?????extol?????") then
		GameAddFlagRun("extol_when_the_extol_extol")
		GamePrintImportant("@NollaPetri","yo for the homies ban me")
		GameAddFlagRun("extol_rocket_success")
	elseif GameHasFlagRun("petri_the_purho_banned_extol") and not GameHasFlagRun("extol_paradox_time") then
		GamePrintImportant("The End","and then this mod was never made")
		GameAddFlagRun("extol_rocket_success")
		GameAddFlagRun("extol_paradox_time")
		AddFlagPersistent("extol_space_winner")
	elseif not GameHasFlagRun("extol_rocket_success") then
		GamePrint("Unworthy")
		GameAddFlagRun("extol_rocket_success")
	end
end