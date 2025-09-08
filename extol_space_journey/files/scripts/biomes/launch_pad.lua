dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction(0xffffeedd, "init")
RegisterSpawnFunction(0xffdedede, "particle_emitters")

function init(x, y, w, h)
	LoadPixelScene("mods/extol_space_journey/files/pixel_scenes/launch_pad_mats.png", "mods/extol_space_journey/files/pixel_scenes/launch_pad_visual.png", x, y, "", true)
end

function particle_emitters(x, y, w, h)
	EntityLoad("mods/extol_space_journey/files/entities/particle_emitters/launch_pad_emitters.xml",x,y)
end