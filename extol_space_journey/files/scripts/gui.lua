
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

local fly_list = {
	{amount=-50,cost=1000},
	{amount=-75,cost=2000},
	{amount=-90,cost=5000},
	{amount=-100,cost=10000}
}
local rot_list = {
	{amount=4,cost=500},
	{amount=6,cost=1000},
	{amount=8,cost=2500},
	{amount=10,cost=5000}
}

local fuel_list = {
	{amount=4,cost=50},
	{amount=6,cost=120},
	{amount=8,cost=250},
	{amount=10,cost=600}
}

local player = GetUpdatedEntityID()
if not GameHasFlagRun("extol_rocket_return") then
	local new_x, new_y = GamePosToPhysicsPos(230, 120)
	local pb2c = EntityGetFirstComponent(player, "PhysicsBody2Component")
	PhysicsComponentSetTransform(pb2c, new_x, new_y, 0, 0, 0, 0)
	GameAddFlagRun("extol_rocket_return")
end

local storage_comps = EntityGetComponent(player, "VariableStorageComponent")
local fuel_component = 0
local upgrade_component = 0
for _, comp in ipairs(storage_comps) do
	if ComponentGetValue2(comp,"name") == "fuel" then
		fuel_component = comp
	elseif ComponentGetValue2(comp,"name") == "upgrade" then
		upgrade_component = comp
	end
end

local controls = EntityGetFirstComponent(player, "ControlsComponent")
local flying = ComponentGetValue2(controls, "mButtonDownFly")
local x,y,rotation = EntityGetTransform(player)
local fly_level = ComponentGetValue2(upgrade_component,"value_int")
if flying then
	local fly_force_x, fly_force_y = vec_rotate( 0, fly_list[fly_level].amount, rotation)
	PhysicsApplyForce(player,fly_force_x,fly_force_y)
end

local left = ComponentGetValue2(controls, "mButtonDownLeft")
local right = ComponentGetValue2(controls, "mButtonDownRight")
local rot_level = ComponentGetValue2(upgrade_component, "value_string")
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

local moon_x = 0
local moon_y = -10000

local indicator_distance = 32

local dir_x = moon_x - x
local dir_y = moon_y - y

-- sprite positions around character
dir_x,dir_y = vec_normalize(dir_x,dir_y)
local indicator_x = x + dir_x * indicator_distance
local indicator_y = y + dir_y * indicator_distance

GameCreateSpriteForXFrames( "data/particles/radar_moon.png", indicator_x, indicator_y )