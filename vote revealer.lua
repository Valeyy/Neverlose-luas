local menuCombo = menu.Combo("Vote Revealer", "Vote revealer style", {"[YES], [NO]", "[1], [0]"}, 0)

local ffi = require("ffi")

local FindElement = ffi.cast("unsigned long(__thiscall*)(void*, const char*)", utils.PatternScan("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))
local CHudChat = FindElement(ffi.cast("unsigned long**", ffi.cast("uintptr_t", utils.PatternScan("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 8B 5D 08")) + 1)[0], "CHudChat")
local FFI_ChatPrint = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", CHudChat)[0][27])

local function PrintInChat(text)
    FFI_ChatPrint(CHudChat, 0, 0, string.format("%s ", text))
end

local function main(event)

    if event:GetName() == 'vote_cast' then

        vote = event:GetInt('vote_option')
        entityId = event:GetInt('entityid')

        local entity = g_EntityList:GetClientEntity(entityId)
        local player = entity:GetPlayer()
        local playerName = player:GetName()

        local selectedStyle = { "YES", "NO"}

        if menuCombo:GetInt() == 1 then
            selectedStyle = { "1", "0" }
        end
        
        if vote == 0 then
            PrintInChat('\x01[\x0CNEVERLOSE\x01] \x07'..player:GetName()..' \x01voted \x01[\x04'..selectedStyle[1]..'\x01]')

        elseif vote == 1 then
            PrintInChat('\x01[\x0CNEVERLOSE\x01] \x07'..player:GetName()..' \x01voted \x01[\x07'..selectedStyle[2]..'\x01]')

        else
            PrintInChat('\x01[\x0CNEVERLOSE\x01] \x07'..player:GetName()..' \x01voted \x01[\x0Aunknown\x01]')
        end

    end

end

cheat.RegisterCallback("events", main)