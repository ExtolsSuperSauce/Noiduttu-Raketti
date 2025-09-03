
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )

function init( x, y, w, h )
	local counter = 0
	while counter < 10 do
		if y > 250 then
			local random_offset_x = Random(0,20)
			local random_offset_y = Random(0,512)
			--EntityLoad TODO
		end
		counter = counter + 1
	end
end
