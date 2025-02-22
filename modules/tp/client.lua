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
        TriggerEvent("utk_fingerprint:Start", 3, 5, 3, function (outcome)
            if outcome then
                TriggerServerEvent("horizon:hackCompleted", place)
            end
        end)
    end
    if place.minigame == "voltage" then
        TriggerEvent("ultra-voltlab", 60, function (outcome)
            if outcome == 1 then
                TriggerServerEvent("horizon:hackCompleted", place)
            end
        end)
    end
end

local function itemUsed()
    local pCoords = GetEntityCoords(PlayerPedId())

    for i = 1, #Config.tp["hacker"] do
        if #(Config.tp["hacker"][i].hackingCoords - pCoords) < 5 then
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
                DrawMarker(21, current.startingCoords.x, current.startingCoords.y, current.startingCoords.z - 0.4, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 52, 177, 235, 200, 3, 1, 0, 0, nil, nil, false)
                --DrawMarker(21, current.startingCoords.x, current.startingCoords.y, current.startingCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 255, true, true, 2, false, nil, nil, false)
                
                if dist < 3 then
                    DisplayHelpTextThisFrame("tp_interact", true)
                    if IsControlJustPressed(0, 38) then
                        teleportPlayer(current.arrivingCoords, playerPed)
                    end
                end
            end

            local reverseDist = #(pCoords - current.arrivingCoords)
            if reverseDist < 50 then
                DrawMarker(21, current.arrivingCoords.x, current.arrivingCoords.y, current.arrivingCoords.z - 0.4, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 52, 177, 235, 200, 3, 1, 0, 0, nil, nil, false)
                --DrawMarker(21, current.startingCoords.x, current.startingCoords.y, current.startingCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 255, true, true, 2, false, nil, nil, false)
                
                if reverseDist < 3 then
                    DisplayHelpTextThisFrame("tp_interact", true)
                    if IsControlJustPressed(0, 38) then
                        teleportPlayer(current.startingCoords, playerPed)
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