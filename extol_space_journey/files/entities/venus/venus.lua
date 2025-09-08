function collision_trigger(collider)
	if not GameHasFlagRun("extol_visit_venus") then
		GameAddFlagRun("extol_visit_venus")
		local wallet = EntityGetFirstComponent(collider,"WalletComponent")
		local money = ComponentGetValue2(wallet,"money")
		ComponentSetValue2(wallet,"money",money+500)
		local x,y = EntityGetTransform(collider)
		GamePlaySound("data/audio/Desktop/event_cues.bank","event_cues/goldnugget",x,y)
		GamePrint("Success! Return when you are ready!")
		GameAddFlagRun("extol_rocket_success")
	end
end