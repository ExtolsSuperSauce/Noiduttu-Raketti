function collision_trigger(collider)
	if not GameHasFlagRun("extol_first_mars") then
		GameAddFlagRun("extol_first_mars")
		local wallet = EntityGetFirstComponent(collider, "WalletComponent")
		local money = ComponentGetValue2(wallet, "money")
		ComponentSetValue2(wallet, "money", money + 175)
		GameRemoveFlagRun("extol_rocket_return")
	end
end