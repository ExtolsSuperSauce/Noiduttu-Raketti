function collision_trigger(collider)
	EntityKill(collider)
	local eid = GetUpdatedEntityID()
	local x,y = GetEntityTransform(eid)
	EntityLoad("data/entities/items/pickup/sun/new_sun.xml",x,y)
end