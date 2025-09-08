function collision_trigger(collider)
	if not GameHasFlagRun("extol_glitch_moon") then
		GameAddFlagRun("extol_glitch_moon")
		local wallet = EntityGetFirstComponent(collider, "WalletComponent")
		local money = ComponentGetValue2(wallet, "money")
		ComponentSetValue2(wallet, "money", money + 300)
		local x,y = EntityGetTransform(collider)
		GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/goldnugget/create", x, y)
		GamePrint("Success! Return when you are ready!")
		GameAddFlagRun("extol_rocket_success")
	end
end