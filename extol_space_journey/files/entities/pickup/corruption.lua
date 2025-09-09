function collision_trigger(collider)
	local eid = GetUpdatedEntityID()
	local vsc = EntityGetFirstComponent(eid, "VariableStorageComponent")
	local x, y = EntityGetTransform(eid)
	if ComponentGetValue2(vsc, "value_bool") then
		GameAddFlagRun("i_extol_your_curiosity")
		GameAddFlagRun("extol_corrupt_me")
		GamePlaySound("mods/extol_space_journey/files/audio/extol_space.bank", "sounds/corruption", x, y)
		ComponentSetValue2(vsc, "value_bool", false)
		local random_event = Random(1, 10)
		if random_event <= 3 then
			local rand_bool = Random(0, 1)
			if rand_bool == 1 then
				PhysicsApplyForce(collider, Random(-50, 50) * Randomf(0.5, 2), 20) -- small push downwards and random sideways
			else
				local collider_storages = EntityGetComponent(collider, "VariableStorageComponent")
				for _, component in ipairs(collider_storages) do
					if ComponentGetValue2(component, "name") == "fuel" then
						local current_fuel = ComponentGetValue2(component, "value_float")
						ComponentSetValue2(component, "value_float", math.max(current_fuel - 1, 0)) -- small loss in fuel
						ComponentSetValue2(vsc, "value_bool", false)
						break
					end
				end
			end
		elseif random_event <= 6 then
			local collider_storages = EntityGetComponent(collider, "VariableStorageComponent")
			for _, component in ipairs(collider_storages) do
				if ComponentGetValue2(component, "name") == "fuel" then
					local fuel_max = ComponentGetValue2(component, "value_int")
					local current_fuel = ComponentGetValue2(component, "value_float")
					local fuel_fill = fuel_max * 0.2
					ComponentSetValue2(component, "value_float", math.min(current_fuel + fuel_fill, fuel_max)) -- 20% more fuel
					ComponentSetValue2(vsc, "value_bool", false)
					break
				end
			end
		elseif random_event <= 9 then
			PhysicsApplyForce(collider, 0, Random(-3000, -1000))
			ComponentSetValue2(vsc, "value_bool", false)
		else
			PhysicsApplyTorque(collider, Randomf(-20, 20) * Randomf(0.5, 2))
		end
	end
end
