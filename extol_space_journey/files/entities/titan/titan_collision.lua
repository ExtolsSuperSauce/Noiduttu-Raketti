function collision_trigger(collider)
	if not GameHasFlagRun("extol_titan") then
		GameAddFlagRun("extol_titan")
		local wallet = EntityGetFirstComponent(collider, "WalletComponent")
		local money = ComponentGetValue2(wallet, "money")
		ComponentSetValue2(wallet, "money", money + 175)
		GameRemoveFlagRun("extol_rocket_return")
	end
end