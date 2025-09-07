function collision_trigger(collider)
	if not GameHasFlagRun("extol_the_eye") then
		GameAddFlagRun("extol_the_eye")
		local wallet = EntityGetFirstComponent(collider, "WalletComponent")
		local money = ComponentGetValue2(wallet, "money")
		ComponentSetValue2(wallet, "money", money + 250)
		GameRemoveFlagRun("extol_rocket_return")
	end
end