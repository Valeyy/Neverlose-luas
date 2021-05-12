local ffi = require("ffi")

local FindElement = ffi.cast("unsigned long(__thiscall*)(void*, const char*)", utils.PatternScan("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))
local CHudChat = FindElement(ffi.cast("unsigned long**", ffi.cast("uintptr_t", utils.PatternScan("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 8B 5D 08")) + 1)[0], "CHudChat")
local FFI_ChatPrint = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", CHudChat)[0][27])

local function PrintInChat(text)
    FFI_ChatPrint(CHudChat, 0, 0, string.format("%s ", text))
end

local hitgroups = {
	[0] = "Generic",
	[1] = "Head",
	[2] = "Chest",
	[3] = "Stomach",
	[4] = "Left Arm",
	[5] = "Right Arm", 
	[6] = "Left leg",
	[7] = "Right leg", 
	[10] = "Gear"
}

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local printHitInfo = function(shot)

	local entity = g_EntityList:GetClientEntity(shot.target_index)
	local player = entity:GetPlayer()
	local reason = ""

	if(shot.reason == 0) then
		printShotInfo(shot)
		return

	elseif(shot.reason == 1) then
		print("resolver miss")
		reason = "Resolver"
		
		if(g_Config:FindVar("Aimbot", "Ragebot", "Main", "Override Resolver"):GetBool()) then
			reason = "Resolver override"
		end
	
	elseif(shot.reason == 2) then
		reason = "Spread \x01[\x07Angle\x01: \x07" .. tostring(round(shot.spread_degree, 3)) .. "\x01] \x02Occlusion \x01[\x070\x01]"
	
	elseif(shot.reason == 3) then
		reason = "Spread \x01[\x07Angle\x01: \x07" .. tostring(round(shot.spread_degree, 3)) .. "\x01] \x02Occlusion \x01[\x071\x01]"
	
	elseif(shot.reason == 4) then
		reason = "Prediction error"

	end

	PrintInChat("\x01 \x01[\x0CNEVERLOSE\x01] \x02Missed \x0C"..player:GetName().." \x10Reason\x01: \x02"..reason.." ")
end

local function printShotInfo(shot)

	if shot.reason > 0 and shot.reason < 5  then
		printHitInfo(shot)
		return
	end

	local entity = g_EntityList:GetClientEntity(shot.target_index)
	local player = entity:GetPlayer()
	local hitbox = ""

	if((shot.hitgroup > -1 and shot.hitgroup < 8) or shot.hitgroup == 10) then
		hitbox = hitgroups[shot.hitgroup]
	else
		hitbox = "unknown"
	end

	PrintInChat("\x01 \x01[\x0CNEVERLOSE\x01] \x05Hit \x0C".. player:GetName() .." \x05".. shot.hitchance .."\x01%% \x07 ".. hitbox .." \x01(\x02".. shot.damage .."\x01) \x05".. entity:GetProp('m_iHealth') .."\x01HP")
end

cheat.RegisterCallback("registered_shot", printShotInfo)