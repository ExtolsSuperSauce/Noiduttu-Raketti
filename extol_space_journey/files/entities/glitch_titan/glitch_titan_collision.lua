function collision_trigger(collider)
	if not GameHasFlagRun("extol_the_leviathan") then
		GameAddFlagRun("extol_the_leviathan")
		local wallet = EntityGetFirstComponent(collider, "WalletComponent")
		local money = ComponentGetValue2(wallet, "money")
		ComponentSetValue2(wallet, "money", money + 2000)
		local x, y = EntityGetTransform(collider)
		GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/goldnugget/create", x, y)
		GamePrint("Success! Return when you are ready!")
		GameAddFlagRun("extol_rocket_success")
	end
end
