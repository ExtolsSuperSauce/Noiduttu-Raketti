function collision_trigger(collider)
	if GameHasFlagRun("extol_the_leviathan") and not GameHasFlagRun("?????extol?????") then
		GameAddFlagRun("?????extol?????")
		GamePrint("You have been spared.")
		GameAddFlagRun("extol_rocket_success")
	elseif not GameHasFlagRun("extol_the_leviathan") then
		EntityKill(collider)
		local eid = GetUpdatedEntityID()
		local x,y = EntityGetTransform(eid)
		EntityLoad("data/entities/items/pickup/sun/newsun.xml",x,y)
	end
end