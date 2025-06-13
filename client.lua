
RegisterCommand(';', function(source, args)
    local msg = table.concat(args, " ")
    if msg == "" then return end

    -- Pošleme zprávu na server (včetně textu), ten zkontroluje whitelist
    TriggerServerEvent('znakova:validateAndBroadcast', msg)
end)

-- Funkce pro vykreslení textu
local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z + 1.0)
    SetTextScale(0.40, 0.40)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

-- Zobraz nad hlavou
RegisterNetEvent('znakova:showMe')
AddEventHandler('znakova:showMe', function(id)
    local player = GetPlayerFromServerId(id)
    if player == -1 then return end

    CreateThread(function()
        local timer = GetGameTimer() + 7000
        while GetGameTimer() < timer do
            Wait(0)
            local ped = GetPlayerPed(player)
            if ped ~= 0 then
                local coords = GetEntityCoords(ped)
                DrawText3D(coords.x, coords.y, coords.z, "*ukazuje znakovou reci*")
            end
        end
    end)
end)

-- Zobraz text v chatu
RegisterNetEvent('znakova:displayChat')
AddEventHandler('znakova:displayChat', function(msg)
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {"Překlad", msg}
    })

    -- Animace
    local playerPed = PlayerPedId()
    local dict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
    local anim = "base"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, 2000, 49, 0, false, false, false)
end)
