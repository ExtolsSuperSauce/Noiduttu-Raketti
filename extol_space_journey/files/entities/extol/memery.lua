if GameHasFlagRun("petri_the_purho_banned_extol") then
	local eid = GetUpdatedEntityID()
	local sprite_comp = EntityGetFirstComponent(eid, "SpriteComponent")
	ComponentSetValue2(sprite_comp,"image_file","mods/extol_space_journey/files/extol/banned.png")
	EntityRefreshSprite(eid,sprite_comp)
end