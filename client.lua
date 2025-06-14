local Config = Config or {}

local Labels = {
    cs = { prefix = "IC-Překlad" },
    en = { prefix = "IC-Translation" }
}

RegisterCommand(';', function(source, args)
    local msg = table.concat(args, " ")
    if msg == "" then return end

    TriggerEvent('znakova:showOverheadAndAnim')
    TriggerServerEvent('znakova:validateAndBroadcast', msg)
end)

RegisterNetEvent('znakova:showOverheadAndAnim')
AddEventHandler('znakova:showOverheadAndAnim', function()
    local playerPed = PlayerPedId()
    local dict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
    local anim = "base"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, 2000, 49, 0, false, false, false)

    CreateThread(function()
        local timer = GetGameTimer() + 7000
        while GetGameTimer() < timer do
            Wait(0)
            local coords = GetEntityCoords(playerPed)
            DrawText3D(coords.x, coords.y, coords.z, "*ukazuje v znakove reci*")
        end
    end)
end)

RegisterNetEvent('znakova:showMe')
AddEventHandler('znakova:showMe', function(id)
    local player = GetPlayerFromServerId(id)
    if player == -1 then return end

    local ped = GetPlayerPed(player)

    local dict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
    local anim = "base"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, 2000, 49, 0, false, false, false)

    CreateThread(function()
        local timer = GetGameTimer() + 7000
        while GetGameTimer() < timer do
            Wait(0)
            local coords = GetEntityCoords(ped)
            DrawText3D(coords.x, coords.y, coords.z, "*ukazuje v znakove reci*")
        end
    end)
end)

RegisterNetEvent('znakova:displayChat')
AddEventHandler('znakova:displayChat', function(msg)
    local lang = Labels[Config.Language] or Labels["en"]
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {lang.prefix, msg}
    })
end)

function DrawText3D(x, y, z, text)
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
