------------------ # ------------------ # ------------------ # ------------------ # ------------------

Tp = {}
AddTextEntry("tp_interact", "Premi ~INPUT_CONTEXT~ per usare l'ascensore")

------------------ # ------------------ # ------------------ # ------------------ # ------------------

local function initHacking(place)
    if place.minigame == "keypad" then
        TriggerEvent("ultra-keypadhack", 6, 180, function (outcome)
            if outcome == 1 then
                TriggerServerEvent("horizon:hackCompleted", place)
            end
        end)
    end
    if place.minigame == "fingerprint" then
        TriggerEvent("utk_fingerprint:Start", 4, 5, 3, function (outcome)
            if outcome then
                TriggerServerEvent("horizon:hackCompleted", place)
            end
        end)
    end
end

local function itemUsed()
    local pCoords = GetEntityCoords(PlayerPedId())
    print(pCoords)

    for i = 1, #Config.tp["hacker"] do
        if #(Config.tp["hacker"][i].startingCoords - pCoords) < 5 then
            print("hacking")
            initHacking(Config.tp["hacker"][i])
        end
    end
end

RegisterNetEvent("horizon:hackingItemUsed")
AddEventHandler("horizon:hackingItemUsed", itemUsed)

------------------ # ------------------ # ------------------ # ------------------ # ------------------

local function teleportPlayer(coords, playerPed)
    DoScreenFadeOut(1000)
    Wait(1200)
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, true, false, false, false)
    Wait(300)
    DoScreenFadeIn(1000)
end

CreateThread(function ()
    while true do
        Wait(0)

        local playerPed = PlayerPedId()
        local pCoords = GetEntityCoords(playerPed)

        for i = 1, #Tp do
            local current = Tp[i]
            local dist = #(pCoords - current.startingCoords)
            if dist < 50 then
                DrawMarker(21, current.startingCoords.x, current.startingCoords.y, current.startingCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 255, true, true, 2, true, "", "", true)
                if dist < 5 then
                    DisplayHelpTextThisFrame("tp_interact", true)
                    if IsControlJustPressed(0, 38) then
                        teleportPlayer(Tp[i].arrivingCoords, playerPed)
                    end
                end
            end

        end
    end
end)

RegisterNetEvent("horizon:syncTps")
AddEventHandler("horizon:syncTps", function (new)
    Tp = new
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------

TriggerServerEvent("horizon:requestTpSync")

------------------ # ------------------ # ------------------ # ------------------ # ------------------