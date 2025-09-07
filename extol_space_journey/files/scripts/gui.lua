-- HELPER FUNCTIONS

local function lerp(a, b, weight)
	return a * weight + b * (1 - weight)
end

local function get_magnitude( x, y )
	local result = math.sqrt( x ^ 2 + y ^ 2 )
	return result
end

local function vec_rotate(x, y, angle)
	local ca = math.cos(angle)
	local sa = math.sin(angle)
	local px = ca * x - sa * y
	local py = sa * x + ca * y
	return px,py
end

local function vec_normalize(x, y)
	local m = get_magnitude(x, y)
	if m == 0 then return 0,0 end
	x = x / m
	y = y / m
	return x,y
end

-- UPGRADES
local fly_list = {
	{ amount = -50, cost = 300 },
	{ amount = -65, cost = 650 },
	{ amount = -85, cost = 1200 },
	{ amount = -100, cost = 0 }
}
local rot_list = {
	{ amount = 6, cost = 150 },
	{ amount = 8, cost = 350 },
	{ amount = 10, cost = 800 },
	{ amount = 12, cost = 0 }
}

local fuel_list = {
	{ amount = 50, cost = 200 },
	{ amount = 80, cost = 550 },
	{ amount = 120, cost = 1300 },
	{ amount = 150, cost = 0 }
}

local player = GetUpdatedEntityID()
local x, y, rotation = EntityGetTransform(player)
local storage_comps = EntityGetComponent(player, "VariableStorageComponent")
local fuel_component = 0
local upgrade_component = 0
local info_component = 0
for _, comp in ipairs(storage_comps) do
	if ComponentGetValue2(comp, "name") == "fuel" then
		fuel_component = comp
	elseif ComponentGetValue2(comp, "name") == "upgrade" then
		upgrade_component = comp
	elseif ComponentGetValue2(comp, "name") == "info" then
		info_component = comp
	end
end

-- CLOUDS/SKY SHIFT
local world_state = GameGetWorldStateEntity()
local world_comp = EntityGetFirstComponent(world_state, "WorldStateComponent")
local current_time = ComponentGetValue2(world_comp, "time")
if y < -7000 then
	local time_interp = lerp(current_time,0.55,0.995)
	ComponentSetValue2(world_comp,"time", time_interp)

else
	local time_interp = lerp(current_time,0.24,0.995)
	ComponentSetValue2(world_comp,"time", time_interp)
end

local setting_music_volume = ModSettingGet("extol_space_journey.extol_music_volume")
if setting_music_volume == nil then
	setting_music_volume = 1
end
local dynamic_volume = math.max(math.min(y/-7000,1)*setting_music_volume,0.01)
local music_comp = EntityGetFirstComponent(player, "AudioLoopComponent", "extol_music_player")
ComponentSetValue2(music_comp,"m_volume",dynamic_volume)

-- Money increment + "back to start"
local fuel = ComponentGetValue2(fuel_component, "value_float")
local fuel_tank = ComponentGetValue2(fuel_component, "value_int")
if not GameHasFlagRun("extol_rocket_return") then
	PhysicsBody2InitFromComponents(player)
	local new_x, new_y = GamePosToPhysicsPos(250, 50)
	local pb2c = EntityGetFirstComponent(player, "PhysicsBody2Component")
	PhysicsComponentSetTransform(pb2c, new_x, new_y, 0, 0, 0, 0)
	GameAddFlagRun("extol_rocket_return")
	GameAddFlagRun("extol_space_selection_gui")
	GameRemoveFlagRun("extol_corrupt_me")
	planet_index = nil
	local wallet_comp = EntityGetFirstComponent(player, "WalletComponent")
	local cash = ComponentGetValue2(wallet_comp, "money")
	local previous_height = ComponentGetValue2(info_component, "value_float")
	-- math.abs() used because previous_height was in the negative (+y is down, -y is up), turning our money into -money
	ComponentSetValue2(wallet_comp, "money", math.floor(math.abs(previous_height) / 50) + cash)
	ComponentSetValue2(fuel_component, "value_float", fuel_tank)
	ComponentSetValue2(info_component, "value_float", 60)
	ComponentSetValue2(info_component, "value_int", 0)
	EntitySetComponentsWithTagEnabled(player, "alarm", false)
	EntitySetComponentsWithTagEnabled(player, "rocket_flame", false)
end

gui = gui or GuiCreate()
local res_x, res_y = GuiGetScreenDimensions(gui)

	--screen space testing tech
	TEMPY = TEMPY or false
	local testing_bool = GuiButton(gui, 12000, 10, 10, "+")
	if testing_bool then
		TEMPY = not TEMPY
	end
	if TEMPY then
		local cc_id = EntityGetFirstComponentIncludingDisabled( player, "ControlsComponent" )
		local mouse_x, mouse_y = ComponentGetValue2( cc_id, "mMousePositionRaw" )
		mouse_x = mouse_x * 0.5
		mouse_y = mouse_y * 0.5
		print( mouse_x/res_x .. "  " .. mouse_y/res_y)
	end

if GameHasFlagRun("extol_space_selection_gui") then
	--TODO GUI
	local _, bg_offset_y = GuiGetImageDimensions(gui, "mods/extol_space_journey/files/gui/shop.png", 1)
	bg_offset_y = bg_offset_y * 0.5
	GuiOptionsAddForNextWidget(gui,16)
	GuiZSetForNextWidget(gui, 1)
	GuiImage(gui, 4, res_x*0.5, res_y*0.5 - bg_offset_y,"mods/extol_space_journey/files/gui/shop.png", 1, 1)

	local wallet_comp = EntityGetFirstComponent(player, "WalletComponent")
	local cash = ComponentGetValue2(wallet_comp, "money")

	-- FUEL
	local fuel_level = ComponentGetValue2(fuel_component,"value_string")
	fuel_level = tonumber(fuel_level)
	if fuel_list[fuel_level].cost <= cash and fuel_list[fuel_level].cost > 0 then
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.55, res_y * 0.32, "Upgrade Cost: $" .. fuel_list[fuel_level].cost)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.55, res_y * 0.34, "Fuel Tank Level: " .. fuel_level + 1)
		GuiOptionsAddForNextWidget(gui, 16)
		local upgrade_fuel = GuiImageButton(gui, 9, res_x * 0.47, res_y * 0.3, "", "mods/extol_space_journey/files/gui/fuel_upgrade.png")
		if upgrade_fuel then
			ComponentSetValue2(fuel_component, "value_string", tostring(fuel_level + 1))
			ComponentSetValue2(fuel_component, "value_int", fuel_list[fuel_level + 1].amount)
			ComponentSetValue2(fuel_component, "value_float", fuel_list[fuel_level + 1].amount)
			ComponentSetValue2(wallet_comp, "money", cash - fuel_list[fuel_level].cost)
		end
	else
		GuiOptionsAddForNextWidget(gui,16)
		GuiText(gui, res_x * 0.55, res_y * 0.32, "Upgrade Cost: $" .. fuel_list[fuel_level].cost)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.55, res_y * 0.34, "Fuel Tank Level: " .. fuel_level + 1)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiImage(gui, 9, res_x * 0.47, res_y * 0.3, "mods/extol_space_journey/files/gui/fuel_upgrade.png", 0.3, 1)
	end

	-- SPEED
	local flight_level = ComponentGetValue2(upgrade_component,"value_int")
	if fly_list[flight_level].cost <= cash and fly_list[flight_level].cost > 0 then
		GuiOptionsAddForNextWidget(gui,16)
		GuiText(gui, res_x * 0.55, res_y * 0.42,"Upgrade Cost: $"..fly_list[flight_level].cost)
		GuiOptionsAddForNextWidget(gui,16)
		GuiText(gui, res_x * 0.55 ,res_y * 0.44,"Speed Level: " .. flight_level + 1)
		GuiOptionsAddForNextWidget(gui, 16)
		local upgrade_flight = GuiImageButton (gui, 10, res_x * 0.47, res_y * 0.4, "", "mods/extol_space_journey/files/gui/speed_upgrade.png")
		if upgrade_flight then
			ComponentSetValue2(upgrade_component, "value_int", flight_level + 1)
			ComponentSetValue2(wallet_comp, "money", cash - fly_list[flight_level].cost)
		end
	else
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.55, res_y * 0.42, "Upgrade Cost: $" .. fly_list[flight_level].cost)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.55, res_y * 0.44, "Speed Level: " .. flight_level + 1)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiImage(gui, 10, res_x * 0.47, res_y * 0.4, "mods/extol_space_journey/files/gui/speed_upgrade.png", 0.3, 1)
	end

	-- ROTATION
	local rot_level = ComponentGetValue2(upgrade_component,"value_string")
	rot_level = tonumber(rot_level)
	if rot_list[rot_level].cost <= cash and rot_list[rot_level].cost > 0 then
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.55, res_y * 0.52, "Upgrade Cost: $" .. rot_list[rot_level].cost)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.55, res_y * 0.54, "Speed Level: " .. rot_level + 1)
		GuiOptionsAddForNextWidget(gui, 16)
		local upgrade_flight = GuiImageButton(gui, 11, res_x * 0.47, res_y * 0.5, "", "mods/extol_space_journey/files/gui/spin_upgrade.png")
		if upgrade_flight then
			ComponentSetValue2(upgrade_component, "value_string", tostring(rot_level + 1))
			ComponentSetValue2(wallet_comp, "money", cash - rot_list[rot_level].cost)
		end
	else
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.55, res_y * 0.52, "Upgrade Cost: $" .. rot_list[rot_level].cost)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.55, res_y * 0.54, "Speed Level: " .. rot_level + 1)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiImage(gui, 11, res_x * 0.47, res_y * 0.5, "mods/extol_space_journey/files/gui/spin_upgrade.png", 0.3, 1)
	end
  
  --PLANET SELECTION
	local planet_selection = ComponentGetValue2(info_component, "value_int")
	local planet_select_list = {
		{ name = "Moon",        	related_tag = "extol_first_moon" },
		{ name = "Mars",        	related_tag = "extol_first_mars" },
		{ name = "Jupiter",     	related_tag = "extol_jupiter_moon",       	required_tag = "extol_first_moon" },
		{ name = "Venus",       	related_tag = "extol_visit_venus",        	required_tag = "extol_first_mars" },
		{ name = "Distant Light", related_tag = "extol_milliways_found",  		required_tag = "extol_visit_venus" },
		{ name = "CHAOS",       	related_tag = "extol_when_the_extol_extol", required_tag = "extol_milliways_found" }
	}
	local corrupt_select_list = {
		{ name = "Moon?",    	 related_tag = "extol_glitch_moon" },
		{ name = "sraM",     	 related_tag = "extol_glitch_mars" },
		{ name = "The Eye",  	 related_tag = "extol_the_eye",            	 required_tag = "extol_glitch_moon" },
		{ name = "The Mirror", related_tag = "extol_the_mirror",       	 	 required_tag = "extol_glitch_mars" },
		{ name = "DEATH",      related_tag = "extol_cthulhu_awakwens",    	 required_tag = "extol_the_eye" },
		{ name = "NATURE",   	 related_tag = "extol_when_the_extol_extol", required_tag = "extol_milliways_found" }
	}
	local corrupt_access = ComponentGetValue2(info_component,"value_bool")
	local sprite_file = "mods/extol_space_journey/files/gui/question.png"
	local gui_var_y = 0.27
	if corrupt_access then
		sprite_file = "mods/extol_space_journey/files/gui/bugged/bugged"..Random(0,9)..".png"
		for i, destination in ipairs(corrupt_select_list) do
			if GameHasFlagRun(destination.related_tag) then
				GuiOptionsAddForNextWidget(gui,16)
				GuiText(gui,res_x*0.35,res_y*(0.05*i+gui_var_y),destination.name)
				GuiOptionsAddForNextWidget(gui,16)
				GuiImage(gui,30+i,res_x*0.31,res_y*(0.05*i+gui_var_y),"mods/extol_space_journey/files/gui/star.png",1,1)
			elseif nil == destination.required_tag or GameHasFlagRun(destination.required_tag) then
				GuiOptionsAddForNextWidget(gui,16)
				if planet_selection == i then
					GuiColorSetForNextWidget(gui,1,1,0,1)
				end
				local index_button = GuiButton(gui,30+i,res_x*0.35,res_y*(0.05*i+gui_var_y), destination.name )
				if index_button then
					ComponentSetValue2(info_component,"value_int",i)
				end
			else
				GuiOptionsAddForNextWidget(gui,16)
				GuiColorSetForNextWidget(gui,1,1,1,0.75)
				GuiText(gui,res_x*0.35,res_y*(0.05*i+gui_var_y),"[LOCKED]")
			end
		end
	else
		for i, destination in ipairs(planet_select_list) do
			if GameHasFlagRun(destination.related_tag) then
				GuiOptionsAddForNextWidget(gui, 16)
				GuiText(gui, res_x * 0.35, res_y * (0.05 * i + gui_var_y), destination.name)
				GuiOptionsAddForNextWidget(gui, 16)
				GuiImage(gui, 30 + i, res_x * 0.31, res_y * (0.05 * i + gui_var_y), "mods/extol_space_journey/files/gui/star.png", 1, 1)
			elseif nil == destination.required_tag or GameHasFlagRun(destination.required_tag) then
				GuiOptionsAddForNextWidget(gui, 16)
				if planet_selection == i then
					GuiColorSetForNextWidget(gui, 1, 1, 0, 1)
				end
				local index_button = GuiButton(gui, 30 + i, res_x * 0.35, res_y * (0.05 * i + gui_var_y), destination.name)
				if index_button then
					ComponentSetValue2(info_component, "value_int", i)
				end
			else
				GuiOptionsAddForNextWidget(gui, 16)
				GuiColorSetForNextWidget(gui, 1, 1, 1, 0.75)
				GuiText(gui, res_x * 0.35, res_y * (0.05 * i + gui_var_y), "[LOCKED]")
			end
		end
	end
	GuiOptionsAddForNextWidget(gui, 16)
	local question_mark = GuiImageButton(gui, 60, res_x * 0.35, res_y * 0.66, "", sprite_file)
	if question_mark and GameHasFlagRun("i_extol_your_curiosity") then
		ComponentSetValue2(info_component, "value_bool", not corrupt_access)
	end

	-- LAUNCH!
	GuiOptionsAddForNextWidget(gui, 16)
	local launch = GuiImageButton(gui, 2, res_x * 0.6, res_y * 0.67, "", "mods/extol_space_journey/files/gui/launch.png")
	if launch and planet_selection ~= 0 then
		GameRemoveFlagRun("extol_space_selection_gui")
		if corrupt_access then
			GameAddFlagRun("extol_corrupt_me")
		end
	end
	GuiStartFrame(gui)
	return
end


-- Flight Controls
local controls = EntityGetFirstComponent(player, "ControlsComponent")
local left = ComponentGetValue2(controls, "mButtonDownLeft")
local right = ComponentGetValue2(controls, "mButtonDownRight")
local rot_level = ComponentGetValue2(upgrade_component, "value_string")
local rocket_flame_comp = EntityGetFirstComponent(player, "ParticleEmitterComponent", "rocket_flame")
rot_level = tonumber(rot_level)
if left then
	PhysicsApplyTorque(player, rot_list[rot_level].amount * -1)
elseif right then
	PhysicsApplyTorque(player, rot_list[rot_level].amount)
end

--[[local brake = ComponentGetValue2(controls, "mButtonDownDown")
--if brake then
	--TODO
end]]

local flying = ComponentGetValue2(controls, "mButtonDownFly")
local fly_level = ComponentGetValue2(upgrade_component,"value_int")
if flying and fuel > 0 then
	local fly_force_x, fly_force_y = vec_rotate(0, fly_list[fly_level].amount, rotation)
	PhysicsApplyForce(player, fly_force_x, fly_force_y)
	ComponentSetValue2(fuel_component, "value_float", fuel - 0.075)
	EntitySetComponentsWithTagEnabled(player,"rocket_flame",true)
else
	EntitySetComponentsWithTagEnabled(player,"rocket_flame",false)
end

-- Prevent player from opening the inventory
local igc = EntityGetFirstComponent(player, "InventoryGuiComponent")
if igc and ComponentGetValue2(igc, "mActive") then
	ComponentSetValue2(igc, "mActive", false)
end


-- Fuel Indicator
local scale = fuel/fuel_tank
GuiZSetForNextWidget(gui, 1)
GuiOptionsAddForNextWidget(gui, 16)
GuiImage(gui, 2, res_x * 0.5, res_y - 20, "mods/extol_space_journey/files/gui/fuel_tank.png", 1, 1)
GuiOptionsAddForNextWidget(gui, 16)
--TODO BETTER COLOR SHIFTING
local color = {0,1}
if scale < 0.5 then
	color[1] = 1
end
if scale < 0.25 then
	color[2] = 0
end
GuiColorSetForNextWidget(gui, color[1], color[2], 0, 0)
GuiImage(gui, 3, res_x * 0.5, res_y - 20, "mods/extol_space_journey/files/gui/fuel_indicator.png", 0.75, scale, 1)

local record_height = ComponentGetValue2(info_component, "value_float")
if record_height > y then
	ComponentSetValue2(info_component, "value_float", y)
	EntitySetComponentsWithTagEnabled(player, "alarm", false)
elseif record_height < y - 500 then
	GameRemoveFlagRun("extol_rocket_return")
elseif record_height < y - 350 or fuel <= 0 then
	EntitySetComponentsWithTagEnabled(player, "alarm", true)
	local return_me = GuiImageButton(gui, 50, res_x * 0.24, res_y * 0.85,"[RETURN]", "mods/extol_space_journey/files/gui/alert.png")
	if return_me then
		GameRemoveFlagRun("extol_rocket_return")
	end
elseif y > 100 then
	GameRemoveFlagRun("extol_rocket_return")
else
	EntitySetComponentsWithTagEnabled(player, "alarm", false)
end


-- Planet Radar
local planet_list = {
	{ name = "moon",  pos_x = 0,   pos_y = -10000 },
	{ name = "mars",  pos_x = 4200, pos_y = -15000 },
	{ name = "juptier", pos_x = -2000, pos_y = -20000 },
	{ name = "venus", pos_x = -6000, pos_y = -14000 },
	{ name = "???",   pos_x = 1000, pos_y = -30000 },
	{ name = "???",   pos_x = -6666, pos_y = -25000 }
}

local corrupt_list = {
	{ name = "moon",  pos_x = 3000, pos_y = -9900 },
	{ name = "mars",  pos_x = -4200, pos_y = -16000 },
	{ name = "the_eye", pos_x = -17185, pos_y = -6424 },
	{ name = "venus", pos_x = 0,    pos_y = -20000 },
	{ name = "???",   pos_x = -3500, pos_y = -35000 },
	{ name = "???",   pos_x = 7777, pos_y = -25000 }
}

local planet_index = ComponentGetValue2(info_component, "value_int")
if not GameHasFlagRun("extol_corrupt_me") then
	if planet_index ~= 0 then
		local indicator_distance = 32
		local dir_x = planet_list[planet_index].pos_x - x
		local dir_y = planet_list[planet_index].pos_y - y
		dir_x,dir_y = vec_normalize(dir_x,dir_y)
		local indicator_x = x + dir_x * indicator_distance
		local indicator_y = y + dir_y * indicator_distance
		GameCreateSpriteForXFrames( "data/particles/radar_moon.png", indicator_x, indicator_y )
	end
else
	if planet_index ~= 0 then
		local indicator_distance = 32
		local dir_x = corrupt_list[planet_index].pos_x - x
		local dir_y = corrupt_list[planet_index].pos_y - y
		dir_x,dir_y = vec_normalize(dir_x,dir_y)
		local indicator_x = x + dir_x * indicator_distance
		local indicator_y = y + dir_y * indicator_distance
		GameCreateSpriteForXFrames( "data/particles/radar_moon.png", indicator_x, indicator_y )
	end
end


GuiStartFrame(gui)