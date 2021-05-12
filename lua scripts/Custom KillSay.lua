local menuSwitch = menu.Switch("Custom KillSay", "Enable", false)
local menuCombo = menu.Combo("Custom KillSay", "Include Name of victim", {"Disabled", "Before", "After"}, 0)
local textBox = menu.TextBox("Custom KillSay", "KillSay", 64, "clown down", "The text that you want to write when killing a enemy")

cheat.RegisterCallback("events", function(event)

    if event:GetName() == "player_death" then

        local victimId = g_EngineClient:GetPlayerForUserId(event:GetInt("userid"))
        local attackerId = g_EngineClient:GetPlayerForUserId(
                             event:GetInt("attacker"))

        local victimEntity = g_EntityList:GetClientEntity(victimId)
        local victimPlayer = victimEntity:GetPlayer()

        if victimId ~= attackerId and attackerId == g_EngineClient:GetLocalPlayer() and not victimPlayer:IsTeamMate() and menuSwitch:GetBool() == true then

            if menuCombo:GetInt() == 1 then
                g_EngineClient:ExecuteClientCmd('say '..victimPlayer:GetName()..' '..textBox:GetString())

            elseif menuCombo:GetInt() == 2 then
                g_EngineClient:ExecuteClientCmd('say '..textBox:GetString()..' '..victimPlayer:GetName())

            else
                g_EngineClient:ExecuteClientCmd('say '..textBox:GetString())
            end
        
        end

    end

end)