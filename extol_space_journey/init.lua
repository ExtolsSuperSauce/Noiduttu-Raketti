ModRegisterMusicBank("mods/extol_space_journey/files/audio/extol_space.bank")
ModRegisterAudioEventMappings( "mods/extol_space_journey/files/audio/GUIDs.txt" )

dofile_once("data/scripts/lib/utilities.lua")

function OnWorldInitialized()
	if not GameHasFlagRun("extol_space_journey_init") then
		local world_state_entity = GameGetWorldStateEntity()
		edit_component( world_state_entity, "WorldStateComponent", function(comp,vars)
			vars.fog_target_extra = 0.1
			vars.fog_target = 0.1
			vars.fog = 0.1
			vars.time_dt = false
			vars.time = 0
			vars.rain_target_extra = 0
			vars.rain_target = 0
			vars.rain = 0
		end)
		GameAddFlagRun("extol_space_journey_init")
	end
end

function OnPlayerDied( player_entity )
	GameTriggerGameOver()
end

function OnPlayerSpawned( player_entity )
	if HasFlagPersistent("extol_space_winner") and not GameHasFlagRun("extol_space_winner_init") then
		local pisc = EntityGetFirstComponent(player_entity, "PhysicsImageShapeComponent")
		ComponentSetValue2(pisc, "image_file", "mods/extol_space_journey/files/rocket/rocket_crown.png")
		GameAddFlagRun("extol_space_winner_init")
	end
end