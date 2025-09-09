function collision_trigger(collider)
	local eid = GetUpdatedEntityID()
	local vsc = EntityGetFirstComponent(eid, "VariableStorageComponent")
	local x, y = EntityGetTransform(eid)
	if ComponentGetValue2(vsc, "value_bool") then
		GameAddFlagRun("i_extol_your_curiosity")
		GameAddFlagRun("extol_corrupt_me")
		local spec = EntityGetFirstComponent(collider, "SpriteParticleEmitterComponent")
		ComponentSetValue2(spec, "is_emitting", true)
		GamePlaySound("mods/extol_space_journey/files/audio/extol_space.bank", "sounds/corruption", x, y)
		ComponentSetValue2(vsc, "value_bool", false)
		local random_event = Random(1, 10)
		if random_event <= 9 then
			local rand_bool = Random(0, 1)
			if rand_bool == 1 then
				PhysicsApplyForce(collider, Random(-600, 600) * Randomf(0.75, 2.5), Random(-1000, 750) * Randomf(1.5,3)) -- Random Boost
			else
				local collider_storages = EntityGetComponent(collider, "VariableStorageComponent")
				for _, component in ipairs(collider_storages) do
					if ComponentGetValue2(component, "name") == "fuel" then
						local current_fuel = ComponentGetValue2(component, "value_float")
						local max_fuel = ComponentGetValue2(component, "value_int")
						ComponentSetValue2(component, "value_float", math.min(math.max(current_fuel - Random(-20,20), 0),max_fuel)) -- Random fuel change
						ComponentSetValue2(vsc, "value_bool", false)
						break
					end
				end
			end
		else
			PhysicsApplyTorque(collider, Randomf(-25, 25) * Random(10, 20))
		end
	end
end
