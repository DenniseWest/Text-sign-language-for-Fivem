local Config = Config or {}

local Labels = {
    cs = { prefix = "IC-Překlad", overhead = "*ukazuje znakovou řeč*", voice = "Microsoft Iveta" },
    en = { prefix = "IC-Translation", overhead = "*uses sign language*", voice = "Microsoft Zira Desktop" },
    es = { prefix = "IC-Traducción", overhead = "*usa el lenguaje de señas*", voice = "Microsoft Helena Desktop" },
    de = { prefix = "IC-Übersetzung", overhead = "*benutzt Gebärdensprache*", voice = "Microsoft Hedda Desktop" },
    fr = { prefix = "IC-Traduction", overhead = "*utilise la langue des signes*", voice = "Microsoft Hortense Desktop" },
    ru = { prefix = "IC-Перевод", overhead = "*использует язык жестов*", voice = "Microsoft Irina Desktop" },
    zh = { prefix = "IC-翻译", overhead = "*使用手语*", voice = "Microsoft Huihui Desktop" },
    ar = { prefix = "IC-ترجمة", overhead = "*يستخدم لغة الإشارة*", voice = "Microsoft Hoda" },
    pt = { prefix = "IC-Tradução", overhead = "*usa linguagem gestual*", voice = "Microsoft Maria Desktop" }
}

RegisterCommand(';', function(source, args)
    local msg = table.concat(args, " ")
    if msg == "" then return end

    TriggerServerEvent('znakova:validateAndBroadcast', msg)
end)

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

RegisterNetEvent('znakova:showMe')
AddEventHandler('znakova:showMe', function(id)
    local lang = Labels[Config.Language] or Labels["en"]
    local player = GetPlayerFromServerId(id)
    if player == -1 then return end

    CreateThread(function()
        local timer = GetGameTimer() + 7000
        while GetGameTimer() < timer do
            Wait(0)
            local ped = GetPlayerPed(player)
            if ped ~= 0 then
                local coords = GetEntityCoords(ped)
                DrawText3D(coords.x, coords.y, coords.z, lang.overhead)
            end
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

    local playerPed = PlayerPedId()
    local dict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
    local anim = "base"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, 2000, 49, 0, false, false, false)
end)

RegisterNetEvent('znakova:playTTS')
AddEventHandler('znakova:playTTS', function(msg)
    if Config.TTS_Enabled then
        local lang = Labels[Config.Language] or Labels["en"]
        SendNUIMessage({
            action = "tts",
            text = msg,
            voice = lang.voice
        })
    end
end)
