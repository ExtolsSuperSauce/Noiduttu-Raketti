dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction(0xffffeedd, "init")

function init(x, y, w, h)
	print("HERE!!!!!!!!!!!!!!!!!!!")
	print(x .. "  " .. y)
	LoadPixelScene("mods/extol_space_journey/files/pixel_scenes/launch_pad_mats.png", "mods/extol_space_journey/files/pixel_scenes/launch_pad_visual.png", x, y, "", true)
end
