function collision_trigger(collider)
	if not GameHasFlagRun("extol_jupiter_moon") then
		GameAddFlagRun("extol_jupiter_moon")
		local wallet = EntityGetFirstComponent(collider, "WalletComponent")
		local money = ComponentGetValue2(wallet, "money")
		ComponentSetValue2(wallet, "money", money + 225) -- jupiter can return a little more since its a big planet?
		local x,y = EntityGetTransform(collider)
		GamePlaySound("data/audio/Desktop/event_cues.bank","event_cues/goldnugget",x,y)
		GamePrint("Success! Return when you are ready!")
		GameAddFlagRun("extol_rocket_success")
	end
end