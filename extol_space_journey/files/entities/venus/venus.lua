function collision_trigger(collider)
	if not GameHasFlagRun("extol_visit_venus") then
		GameAddFlagRun("extol_visit_venus")
		local wallet = EntityGetFirstComponent(collider,"WalletComponent")
		local money = ComponentGetValue2(wallet,"money")
		ComponentSetValue2(wallet,"money",money+500)
		GameRemoveFlagRun("extol_rocket_return")
	end
end