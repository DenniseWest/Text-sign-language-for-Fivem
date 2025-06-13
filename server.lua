
-- WHITELIST: seznam povolených licencí
local whitelistedLicenses = {
    "license:9daa0300ad39f2d4f8d9917ba48347f8babe2141",
    "license:1234567890abcdef1234567890abcdef", -- nahraď svými licencemi
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

    -- Všem zobraz animaci i zprávu
    TriggerClientEvent('znakova:showMe', -1, src)
    TriggerClientEvent('znakova:displayChat', -1, msg)
end)
