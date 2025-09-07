ModRegisterMusicBank("mods/extol_space_journey/files/audio/extol_space.bank")
ModRegisterAudioEventMappings( "mods/extol_space_journey/files/audio/GUIDs.txt" )

dofile_once("data/scripts/lib/utilities.lua")

function OnWorldPreUpdate()
	local world_state_entity = GameGetWorldStateEntity()
	edit_component( world_state_entity, "WorldStateComponent", function(comp,vars)
		vars.fog_target_extra = 0
		vars.fog_target = 0
		vars.fog = 0
		vars.time_dt = false
		vars.rain_target_extra = 0
		vars.rain_target = 0
		vars.rain = 0
	end)
end