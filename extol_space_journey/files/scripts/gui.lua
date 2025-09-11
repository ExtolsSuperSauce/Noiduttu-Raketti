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
	return px, py
end

local function vec_normalize(x, y)
	local m = get_magnitude(x, y)
	if m == 0 then return 0,0 end
	x = x / m
	y = y / m
	return x, y
end

local function random_text( length )
	local teststring = "abcdefghijklmnopqrstuvwxyz"
	local result = ""
	for i=1,length do
		local random_char = Random(1,#teststring)
		result = result .. string.sub(teststring,random_char,random_char)
	end
	return result
end

-- UPGRADES
local fly_list = {
	{ amount = -45, cost = 300 },
	{ amount = -51, cost = 650 },
	{ amount = -63, cost = 1200 },
	{ amount = -75, cost = 0 }
}
local rot_list = {
	{ amount = 6, cost = 150 },
	{ amount = 8, cost = 350 },
	{ amount = 10, cost = 800 },
	{ amount = 12, cost = 0 }
}

local fuel_list = {
	{ amount = 45, cost = 200 },
	{ amount = 70, cost = 550 },
	{ amount = 100, cost = 1300 },
	{ amount = 130, cost = 0 }
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
if y < -5000 then
	local time_interp = lerp(current_time, 0.56, 0.999)
	ComponentSetValue2(world_comp, "time", time_interp)
else
	local time_interp = lerp(current_time, 0.24, 0.995)
	ComponentSetValue2(world_comp, "time", time_interp)
end
local cloud_target = ComponentGetValue2(world_comp, "rain")
if y < -3000 then
	local cloud_interp = lerp(cloud_target, 0, 0.995)
	ComponentSetValue2(world_comp, "rain", cloud_interp)
else
	local cloud_interp = lerp(cloud_target, 0.8, 0.995)
	ComponentSetValue2(world_comp, "rain", cloud_interp)
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
	if GameHasFlagRun("extol_paradox_time") then
		EntityKill(player)
		return
	end
	PhysicsBody2InitFromComponents(player)
	local new_x, new_y = GamePosToPhysicsPos(250, 50)
	local pb2c = EntityGetFirstComponent(player, "PhysicsBody2Component")
	PhysicsComponentSetTransform(pb2c, new_x, new_y, 0, 0, 0, 0)
	GameAddFlagRun("extol_rocket_return")
	GameAddFlagRun("extol_space_selection_gui")
	GameRemoveFlagRun("extol_corrupt_me")
	GameRemoveFlagRun("extol_petri_poke")
	GameRemoveFlagRun("extol_rocket_success")
	planet_index = nil
	local wallet_comp = EntityGetFirstComponent(player, "WalletComponent")
	local cash = ComponentGetValue2(wallet_comp, "money")
	local previous_height = ComponentGetValue2(info_component, "value_float")
	ComponentSetValue2(wallet_comp, "money", math.floor(math.abs(previous_height) / 50) + cash)
	ComponentSetValue2(fuel_component, "value_float", fuel_tank)
	ComponentSetValue2(info_component, "value_float", 0)
	ComponentSetValue2(info_component, "value_int", 0)
	EntitySetComponentsWithTagEnabled(player, "alarm", false)
	EntitySetComponentsWithTagEnabled(player, "rocket_flame", false)
	local spec = EntityGetFirstComponent(player, "SpriteParticleEmitterComponent")
	ComponentSetValue2(spec, "is_emitting", false)
end


-- GUI
gui = gui or GuiCreate()
local res_x, res_y = GuiGetScreenDimensions(gui)

if GameHasFlagRun("extol_space_selection_gui") then
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
		GuiText(gui, res_x * 0.65, res_y * 0.28, "Upgrade Cost: $" .. fuel_list[fuel_level].cost)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.65, res_y * 0.3, "Fuel Tank Level: " .. fuel_level + 1)
		GuiOptionsAddForNextWidget(gui, 16)
		local upgrade_fuel = GuiImageButton(gui, 9, res_x * 0.51, res_y * 0.26, "", "mods/extol_space_journey/files/gui/fuel_upgrade.png")
		if upgrade_fuel then
			ComponentSetValue2(fuel_component, "value_string", tostring(fuel_level + 1))
			ComponentSetValue2(fuel_component, "value_int", fuel_list[fuel_level + 1].amount)
			ComponentSetValue2(fuel_component, "value_float", fuel_list[fuel_level + 1].amount)
			ComponentSetValue2(wallet_comp, "money", cash - fuel_list[fuel_level].cost)
		end
	else
		GuiOptionsAddForNextWidget(gui,16)
		GuiText(gui, res_x * 0.65, res_y * 0.28, "Upgrade Cost: $" .. fuel_list[fuel_level].cost)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.65, res_y * 0.3, "Fuel Tank Level: " .. fuel_level + 1)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiImage(gui, 9, res_x * 0.51, res_y * 0.26, "mods/extol_space_journey/files/gui/fuel_upgrade.png", 0.3, 1)
	end

	-- SPEED
	local flight_level = ComponentGetValue2(upgrade_component,"value_int")
	if fly_list[flight_level].cost <= cash and fly_list[flight_level].cost > 0 then
		GuiOptionsAddForNextWidget(gui,16)
		GuiText(gui, res_x * 0.65, res_y * 0.42,"Upgrade Cost: $"..fly_list[flight_level].cost)
		GuiOptionsAddForNextWidget(gui,16)
		GuiText(gui, res_x * 0.65, res_y * 0.44,"Speed Level: " .. flight_level + 1)
		GuiOptionsAddForNextWidget(gui, 16)
		local upgrade_flight = GuiImageButton (gui, 10, res_x * 0.51, res_y * 0.4, "", "mods/extol_space_journey/files/gui/speed_upgrade.png")
		if upgrade_flight then
			ComponentSetValue2(upgrade_component, "value_int", flight_level + 1)
			ComponentSetValue2(wallet_comp, "money", cash - fly_list[flight_level].cost)
		end
	else
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.65, res_y * 0.42, "Upgrade Cost: $" .. fly_list[flight_level].cost)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.65, res_y * 0.44, "Speed Level: " .. flight_level + 1)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiImage(gui, 10, res_x * 0.51, res_y * 0.4, "mods/extol_space_journey/files/gui/speed_upgrade.png", 0.3, 1)
	end

	-- ROTATION
	local rot_level = ComponentGetValue2(upgrade_component,"value_string")
	rot_level = tonumber(rot_level)
	if rot_list[rot_level].cost <= cash and rot_list[rot_level].cost > 0 then
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.65, res_y * 0.56, "Upgrade Cost: $" .. rot_list[rot_level].cost)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.65, res_y * 0.58, "Spin Level: " .. rot_level + 1)
		GuiOptionsAddForNextWidget(gui, 16)
		local upgrade_flight = GuiImageButton(gui, 11, res_x * 0.51, res_y * 0.54, "", "mods/extol_space_journey/files/gui/spin_upgrade.png")
		if upgrade_flight then
			ComponentSetValue2(upgrade_component, "value_string", tostring(rot_level + 1))
			ComponentSetValue2(wallet_comp, "money", cash - rot_list[rot_level].cost)
		end
	else
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.65, res_y * 0.56, "Upgrade Cost: $" .. rot_list[rot_level].cost)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.65, res_y * 0.58, "Spin Level: " .. rot_level + 1)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiImage(gui, 11, res_x * 0.51, res_y * 0.54, "mods/extol_space_journey/files/gui/spin_upgrade.png", 0.3, 1)
	end

  --PLANET SELECTION
	local planet_selection = ComponentGetValue2(info_component, "value_int")
	local planet_select_list = {
		{ name = "Moon",          related_tag = "extol_first_moon" },
		{ name = "Mars",          related_tag = "extol_first_mars" },
		{ name = "Jupiter",       related_tag = "extol_jupiter_moon",         required_tag = "extol_first_moon" },
		{ name = "Venus",         related_tag = "extol_visit_venus",          required_tag = "extol_first_mars" },
		{ name = "Titan",         related_tag = "extol_titan",				  required_tag = "extol_jupiter_moon" },
		{ name = "Distant Light", related_tag = "extol_milliways_found",      required_tag = "extol_visit_venus" },
		{ name = "CHAOS",         related_tag = "extol_when_the_extol_extol", required_tag = "extol_milliways_found" }
	}
	local corrupt_select_list = {
		{ name = "Moon?",         related_tag = "extol_glitch_moon" },
		{ name = "sraM",          related_tag = "extol_glitch_mars" },
		{ name = "The Eye",       related_tag = "extol_the_eye",			  required_tag = "extol_glitch_moon" },
		{ name = "The Mirror",    related_tag = "extol_the_mirror",			  required_tag = "extol_glitch_mars" },
		{ name = "The Leviathan", related_tag = "extol_the_leviathan",		  required_tag = "extol_the_eye" },
		{ name = "insanity",	  related_tag = "?????extol?????", 			  required_tag = "extol_the_mirror" },
		{ name = "NATURE",        related_tag = "extol_when_the_extol_extol", required_tag = "extol_milliways_found" }
	}

	GuiOptionsAddForNextWidget(gui,16)
	GuiText(gui, res_x*0.28, res_y*0.2, "DESTINATIONS")
	local corrupt_access = ComponentGetValue2(info_component,"value_bool")
	local sprite_file = "mods/extol_space_journey/files/gui/question.png"
	local gui_var_y = 0.24
	if corrupt_access then
		sprite_file = "mods/extol_space_journey/files/gui/bugged/bugged"..Random(0,9)..".png"
		for i, destination in ipairs(corrupt_select_list) do
			if GameHasFlagRun(destination.related_tag) then
				GuiOptionsAddForNextWidget(gui,16)
				GuiText(gui,res_x*0.28,res_y*(0.05*i+gui_var_y),destination.name)
				GuiOptionsAddForNextWidget(gui,16)
				GuiImage(gui,30+i,res_x*0.23,res_y*(0.05*i+gui_var_y),"mods/extol_space_journey/files/gui/star.png",1,1)
			elseif nil == destination.required_tag or GameHasFlagRun(destination.required_tag) then
				GuiOptionsAddForNextWidget(gui,16)
				if planet_selection == i then
					GuiColorSetForNextWidget(gui,1,1,0,1)
				end
				if destination.name == "insanity" then
					if GetValueInteger("extol_corruption_delay_"..i,0) <= GameGetFrameNum() then
						destination.name = random_text(7)
						ComponentSetValue2(info_component, "value_string", random_text(7))
						SetValueInteger("extol_corruption_delay_"..i, GameGetFrameNum() + Random(45,240))
					end
					destination.name = string.upper(ComponentGetValue2(info_component, "value_string"))
				end
				local index_button = GuiButton(gui, 30+i, res_x * 0.28, res_y * (0.05 * i + gui_var_y), destination.name )
				if index_button then
					ComponentSetValue2(info_component,"value_int",i)
				end
			else
				GuiOptionsAddForNextWidget(gui,16)
				GuiColorSetForNextWidget(gui,1,1,1,0.75)
				GuiText(gui,res_x*0.28,res_y*(0.05*i+gui_var_y), "[LOCKED]")
			end
		end
	else
		for i, destination in ipairs(planet_select_list) do
			if GameHasFlagRun(destination.related_tag) then
				GuiOptionsAddForNextWidget(gui, 16)
				GuiText(gui, res_x * 0.28, res_y * (0.05 * i + gui_var_y), destination.name)
				GuiOptionsAddForNextWidget(gui, 16)
				GuiImage(gui, 30 + i, res_x * 0.23, res_y * (0.05 * i + gui_var_y), "mods/extol_space_journey/files/gui/star.png", 1, 1)
			elseif nil == destination.required_tag or GameHasFlagRun(destination.required_tag) then
				GuiOptionsAddForNextWidget(gui, 16)
				if planet_selection == i then
					GuiColorSetForNextWidget(gui, 1, 1, 0, 1)
				end
				local index_button = GuiButton(gui, 30 + i, res_x * 0.28, res_y * (0.05 * i + gui_var_y), destination.name)
				if index_button then
					ComponentSetValue2(info_component, "value_int", i)
				end
			else
				GuiOptionsAddForNextWidget(gui, 16)
				GuiColorSetForNextWidget(gui, 1, 1, 1, 0.75)
				GuiText(gui, res_x * 0.28, res_y * (0.05 * i + gui_var_y), "[LOCKED]")
			end
		end
	end
	GuiOptionsAddForNextWidget(gui, 16)
	local question_mark = GuiImageButton(gui, 60, res_x * 0.28, res_y * 0.67, "", sprite_file)
	if question_mark and GameHasFlagRun("i_extol_your_curiosity") then
		ComponentSetValue2(info_component, "value_bool", not corrupt_access)
	end

	-- LAUNCH!
	if planet_selection == 0 then
		GuiOptionsAddForNextWidget(gui, 16)
		GuiImage(gui, 2, res_x * 0.56, res_y * 0.75, "mods/extol_space_journey/files/gui/launch.png", 0.4, 1)
		GuiOptionsAddForNextWidget(gui, 16)
		GuiText(gui, res_x * 0.56, res_y * 0.72, "SELECT DESTINATION!")
	else
		GuiOptionsAddForNextWidget(gui, 16)
		local launch = GuiImageButton(gui, 2, res_x * 0.56, res_y * 0.75, "", "mods/extol_space_journey/files/gui/launch.png")
		if launch then
			local pickup_entities = EntityGetWithTag("extol_space_pickup")
			for _, pickup in ipairs(pickup_entities) do
				local pickup_sprite_comp = EntityGetFirstComponent(pickup, "SpriteComponent")
				local pickup_vsc = EntityGetFirstComponent(pickup, "VariableStorageComponent")
				ComponentSetValue2(pickup_sprite_comp, "alpha", 1)
				ComponentSetValue2(pickup_vsc, "value_bool", true)
			end
			GameRemoveFlagRun("extol_space_selection_gui")
			if corrupt_access then
				GameAddFlagRun("extol_corrupt_me")
				local spec = EntityGetFirstComponent(player, "SpriteParticleEmitterComponent")
				ComponentSetValue2(spec, "is_emitting", true)
			end
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
rot_level = tonumber(rot_level)
if left then
	PhysicsApplyTorque(player, rot_list[rot_level].amount * -1)
elseif right then
	PhysicsApplyTorque(player, rot_list[rot_level].amount)
end

-- Rocket stabilization (please verify this is "stabilization")
-- Extol: Pretty good! Just adding a lerp function to it.
local brake = ComponentGetValue2(controls, "mButtonDownDown")
if brake and not left and not right then
	PhysicsApplyTorque(player, lerp( 0, rotation * -1, math.min(math.max(math.abs(rotation)/math.pi - 0.9,0.1),rot_list[rot_level].amount)))
end

-- Flight
local flying = ComponentGetValue2(controls, "mButtonDownFly")
local fly_level = ComponentGetValue2(upgrade_component,"value_int")
if flying and fuel > 0 then
	local fly_force_x, fly_force_y = vec_rotate(0, fly_list[fly_level].amount, rotation)
	PhysicsApplyForce(player, fly_force_x, fly_force_y)
	ComponentSetValue2(fuel_component, "value_float", fuel - 0.075)
	EntitySetComponentsWithTagEnabled(player, "rocket_flame", true)
else
	EntitySetComponentsWithTagEnabled(player, "rocket_flame", false)
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
local color = {1 - scale, scale}
GuiColorSetForNextWidget(gui, color[1], color[2], 0, 0)
GuiImage(gui, 3, res_x * 0.5, res_y - 20, "mods/extol_space_journey/files/gui/fuel_indicator.png", 0.75, scale, 1)

-- ALERT
local record_height = ComponentGetValue2(info_component, "value_float")
if record_height > y then
	ComponentSetValue2(info_component, "value_float", y)
	EntitySetComponentsWithTagEnabled(player, "alarm", false)
elseif record_height < y - 600 then
	GameRemoveFlagRun("extol_rocket_return")
elseif record_height < y - 475 or fuel <= 0 then
	EntitySetComponentsWithTagEnabled(player, "alarm", true)
	local return_me = GuiImageButton(gui, 2025, res_x * 0.24, res_y * 0.85, "[RETURN]", "mods/extol_space_journey/files/gui/alert.png")
	if return_me then
		GameRemoveFlagRun("extol_rocket_return")
	end
elseif y > 100 then
	GameRemoveFlagRun("extol_rocket_return")
else
	EntitySetComponentsWithTagEnabled(player, "alarm", false)
end

if GameHasFlagRun("extol_rocket_success") then
	local return_me = GuiImageButton(gui, 2026, res_x * 0.24, res_y * 0.9, "[RETURN]", "mods/extol_space_journey/files/gui/success.png")
	if return_me then
		GameRemoveFlagRun("extol_rocket_return")
	end
end

-- Planet Radar
local planet_list = {
	{ name = "moon",    pos_x = 0,     pos_y = -10000 },
	{ name = "mars",    pos_x = 4200,  pos_y = -15000 },
	{ name = "juptier", pos_x = -2000, pos_y = -20000 },
	{ name = "venus",   pos_x = -6000, pos_y = -14000 },
	{ name = "titan", 	pos_x = 10000, pos_y = -22000 },
	{ name = "???",     pos_x = 1000,  pos_y = -30000 },
	{ name = "???",     pos_x = -6666, pos_y = -25000 }
}

local corrupt_list = {
	{ name = "moon",         pos_x = 3000,   pos_y = -9900 },
	{ name = "mars",         pos_x = -4200,  pos_y = -16000 },
	{ name = "the_eye",      pos_x = -17185, pos_y = -6424 },
	{ name = "venus",        pos_x = 0,      pos_y = -20000 },
	{ name = "glitch_titan", pos_x = -10000, pos_y = -22000 },
	{ name = "???",          pos_x = -3500,  pos_y = -35000 },
	{ name = "???",          pos_x = 7777,   pos_y = -25000 }
}

local planet_index = ComponentGetValue2(info_component, "value_int")
if not GameHasFlagRun("extol_corrupt_me") then
	if planet_index ~= 0 then
		local indicator_distance = 32
		local dir_x = planet_list[planet_index].pos_x - x
		local dir_y = planet_list[planet_index].pos_y - y
		dir_x, dir_y = vec_normalize(dir_x, dir_y)
		local indicator_x = x + dir_x * indicator_distance
		local indicator_y = y + dir_y * indicator_distance
		GameCreateSpriteForXFrames( "data/particles/radar_moon.png", indicator_x, indicator_y )
	end
else
	if planet_index ~= 0 then
		local indicator_distance = Random(31,33)
		local dir_x = corrupt_list[planet_index].pos_x - x + Random(-20,20)
		local dir_y = corrupt_list[planet_index].pos_y - y + Random(-20,20)
		dir_x, dir_y = vec_normalize(dir_x, dir_y)
		local indicator_x = x + dir_x * indicator_distance
		local indicator_y = y + dir_y * indicator_distance
		GameCreateSpriteForXFrames( "mods/extol_space_journey/files/gui/glitch_radar/glitch_radar_moon" .. Random(0, 5) .. ".png", indicator_x, indicator_y )
	end
end

GuiStartFrame(gui)