dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction(0xffffeedd, "init")

function init(x, y, w, h)
	SetRandomSeed(x + w, y + h)
	if y < -600 then
		local counter = 1
		while counter <= 8 do
			local random_offset_x = Random(0, 20)
			local random_offset_y = Random(0, 512)
			local random_chance = Random(0, 1)
			local AHHHHH = Random(1, 100)
			local offset_x = (512 / 8) * counter
			if AHHHHH >= 99 then
				EntityLoad("mods/extol_space_journey/files/entities/pickup/corruption.xml", x + offset_x + random_offset_x, y + random_offset_y)
			elseif random_chance == 1 then
				EntityLoad("mods/extol_space_journey/files/entities/pickup/jerrycan.xml", x + offset_x + random_offset_x, y + random_offset_y)
			else
				EntityLoad("mods/extol_space_journey/files/entities/pickup/boost.xml", x + offset_x + random_offset_x, y + random_offset_y)
			end
			counter = counter + 1
		end
	end
end
