dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction(0xffffeedd, "init")
RegisterSpawnFunction(0xff4749c2, "spawn_fuel_can")

function init(x, y, w, h)
	SetRandomSeed(x + w, y + h)
	if y < -600 then
		local counter = 1
		while counter <= 8 do
			local random_offset_x = Random(0, 20)
			local random_offset_y = Random(0, 512)
			local random_chance = Random(0, 1)
			local AHHHHH = Random(1, 90)
			AHHHHH = math.min(math.ceil(y/-1024),60) + AHHHHH -- As you go higher in chunks the corruption becomes more likely
			local offset_x = (512 / 8) * counter -- 64 pixel offset for each pickup. 8 per chunk thus it's divided by 8. Might change later. (5-7?)
			if AHHHHH >= 101 then -- Still trying to find the right balance for this. 100-105 feels about right, but I don't want things to be too hard
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

function spawn_fuel_can(x, y, w, h) -- Forced Jerrycan spawn
	EntityLoad("mods/extol_space_journey/files/entities/pickup/jerrycan.xml", x, y)
end
