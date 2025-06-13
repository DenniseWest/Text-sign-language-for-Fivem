
-- WHITELIST: seznam povolených licencí
local whitelistedLicenses = {
    "license:9daa0300ad39f2d4f8d9917ba48347f8babe2141",
    "license:1234567890abcdef1234567890abcdef",
    "license:abcdefabcdefabcdefabcdefabcdefabcd"
}

local function isWhitelisted(src)
    local identifiers = GetPlayerIdentifiers(src)
    for _, id in ipairs(identifiers) do
        if string.sub(id, 1, 7) == "license" then
            for _, allowed in ipairs(whitelistedLicenses) do
                if id == allowed then return true end
            end
        end
    end
    return false
end

RegisterServerEvent('znakova:validateAndBroadcast')
AddEventHandler('znakova:validateAndBroadcast', function(msg)
    local src = source
    if not isWhitelisted(src) then
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Systém", "Nemáš oprávnění používat znakování."}
        })
        return
    end

    -- Animace nad hlavou pro všechny
    TriggerClientEvent('znakova:showMe', -1, src)

    -- Výpočet vzdálenosti + TTS/Chat jen pro okolí
    local srcPed = GetPlayerPed(src)
    if not srcPed then return end
    local srcCoords = GetEntityCoords(srcPed)

    for _, targetId in ipairs(GetPlayers()) do
        local targetPed = GetPlayerPed(targetId)
        if targetPed and targetPed ~= -1 then
            local targetCoords = GetEntityCoords(targetPed)
            local dist = #(srcCoords - targetCoords)
            if dist <= 5.0 then
                TriggerClientEvent('znakova:displayChat', targetId, msg)
                TriggerClientEvent('znakova:playTTS', targetId, msg)
            end
        end
    end
end)
