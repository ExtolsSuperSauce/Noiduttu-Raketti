function collision_trigger(collider)
	if not GameHasFlagRun("extol_the_cheese") then
		GameAddFlagRun("extol_the_cheese")
		local wallet = EntityGetFirstComponent(collider, "WalletComponent")
		local money = ComponentGetValue2(wallet, "money")
		if ModSettingGet("extol_space_journey.extol_space_difficulty") == "hard"
			ComponentSetValue2(wallet, "money", money + Random(800,1200))
		else
			ComponentSetValue2(wallet, "money", money + 1500)
		end
		local x,y = EntityGetTransform(collider)
		GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/goldnugget/create", x, y)
		GamePrintImportant("I See You.", "01000001 01110011 00100000 01000001 01100010 01101111 01110110 01100101 00100000 01010011 01101111 00100000 01000010 01100101 01101100 01101111 01110111")
		GameAddFlagRun("extol_rocket_success")
	end
end