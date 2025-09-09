function collision_trigger(collider)
	local eid = GetUpdatedEntityID()
	local x, y = EntityGetTransform(eid)
	local vsc = EntityGetFirstComponent(eid, "VariableStorageComponent")
	if ComponentGetValue2(vsc, "value_bool") then
		local collider_storages = EntityGetComponent(collider, "VariableStorageComponent")
		GamePlaySound("data/audio/Desktop/ui.bank", "ui/item_equipped", x, y)
		for _, component in ipairs(collider_storages) do
			if ComponentGetValue2(component, "name") == "fuel" then
				local fuel_max = ComponentGetValue2(component, "value_int")
				local current_fuel = ComponentGetValue2(component, "value_float")
				local fuel_fill = fuel_max * 0.3
				ComponentSetValue2(component, "value_float", math.min(current_fuel + fuel_fill, fuel_max))
				ComponentSetValue2(vsc, "value_bool", false)
				local sprite_comp = EntityGetFirstComponent(eid, "SpriteComponent")
				ComponentSetValue2(sprite_comp, "alpha", 0.6)
				break
			end
		end
		ComponentSetValue2(vsc, "value_bool", false)
	end
end
