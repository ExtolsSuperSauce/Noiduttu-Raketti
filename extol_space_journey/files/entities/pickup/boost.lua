function collision_trigger(collider)
	local eid = GetUpdatedEntityID()
	local vsc = EntityGetFirstComponent(eid,"VariableStorageComponent")
	if ComponentGetValue2(vsc,"value_bool") then
		PhysicsApplyForce(collider,0,-3000)
		local sprite_comp = EntityGetFirstComponent(eid,"SpriteComponent")
		ComponentSetValue2(sprite_comp,"alpha",0.6)
		ComponentSetValue2(vsc,"value_bool",false)
	end
end