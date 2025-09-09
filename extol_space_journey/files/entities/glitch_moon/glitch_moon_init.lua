local eid = GetUpdatedEntityID()
local x,y = EntityGetTransform(eid)
LoadPixelScene("mods/extol_space_journey/files/entities/glitch_moon/glitch_moon_mat.png", "", x - 91, y - 91, "", true ) -- half of the image size used as an offset
