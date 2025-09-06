function collision_trigger(collider)
	if not GameHasFlagRun("extol_jupiter_moon") then
		GameAddFlagRun("extol_jupiter_moon")
		local wallet = EntityGetFirstComponent(collider, "WalletComponent")
		local money = ComponentGetValue2(wallet, "money")
		ComponentSetValue2(wallet, "money", money + 225) -- jupiter can return a little more since its a big planet?
		GameRemoveFlagRun("extol_rocket_return")
	end
end