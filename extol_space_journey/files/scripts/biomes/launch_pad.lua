dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction(0xffffeedd, "init")
RegisterSpawnFunction(0xffdedede, "particle_emitters")
RegisterSpawnFunction(0xff004206, "spawn_the_eye")

function init(x, y, w, h)
	LoadPixelScene("mods/extol_space_journey/files/pixel_scenes/launch_pad_mats.png", "mods/extol_space_journey/files/pixel_scenes/launch_pad_visual.png", x, y, "", true)
	LoadBackgroundSprite("mods/extol_space_journey/files/pixel_scenes/rocket_controls_visual.png", x + 250, y + 7)
end

function particle_emitters(x, y, w, h)
	EntityLoad("mods/extol_space_journey/files/entities/particle_emitters/launch_pad_emitters.xml",x,y)
end

function spawn_the_eye(x,y,w,h)
	EntityLoad("mods/extol_space_journey/files/entities/eye_eht/the_eye.xml",x,y)
end