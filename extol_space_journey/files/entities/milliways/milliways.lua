function collision_trigger(collider)
	if not GameHasFlagRun("extol_milliways_found") then
		GameAddFlagRun("extol_milliways_found")
		local wallet = EntityGetFirstComponent(collider,"WalletComponent")
		local money = ComponentGetValue2(wallet,"money")
		ComponentSetValue2(wallet,"money",money+1000)
		GameRemoveFlagRun("extol_rocket_return")
	end
end