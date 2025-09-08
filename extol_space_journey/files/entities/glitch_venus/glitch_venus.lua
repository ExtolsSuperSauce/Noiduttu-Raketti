function collision_trigger(collider)
	if not GameHasFlagRun("extol_the_mirror") then
		GameHasFlagRun("extol_the_mirror")
		local wallet = EntityGetFirstComponent(collider, "WalletComponent")
		local money = ComponentGetValue2(wallet, "money")
		ComponentSetValue2(wallet, "money", money + 300) -- This is pretty arbitrary. Just check the gui.lua for the costs, and aim somewhere lower (Glitch/End Game secret stuff should afford most things. Keep in mind Height also pays out)
		local x,y = EntityGetTransform(collider)
		GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/goldnugget/create", x, y)
		GamePrint("Success! Return when you are ready!")
		GameAddFlagRun("extol_rocket_success")
	end
end