
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction(0xffffeedd, "init")
RegisterSpawnFunction(0xff41b8ba, "spawn_the_eye")

function init( x, y, w, h )
	LoadPixelScene("mods/extol_space_journey/files/pixel_scenes/the_eye.png", "", x, y, "mods/extol_space_journey/files/pixel_scenes/the_eye_background.png", true)
end

function spawn_the_eye(x,y)
	EntityLoad("mods/extol_space_journey/files/entities/the_eye/the_eye.xml", x, y)
end