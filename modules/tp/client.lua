------------------ # ------------------ # ------------------ # ------------------ # ------------------

Tp = {}

------------------ # ------------------ # ------------------ # ------------------ # ------------------

local function hackingMinigame(var)
    if var == "keypad" then
        TriggerEvent("ultra-keypadhack", 6, 300, function (outcome)
            if outcome == 1 then
                return true
            else
                return false
            end
        end)
    end
end

local function initHacking(place)
    if not hackingMinigame(place.minigame) then
        return lib.notify({ title = "Hacking fallito"})
    end

    return TriggerServerEvent("horizon:hackCompleted", place)
end

local function itemUsed()
    local pCoords = GetEntityCoords(PlayerPedId())

    for i = 1, #Config.tp["hacker"] do
        if #(Config.tp["hacker"][i].startingCoords - pCoords) < 5 then
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
            if #(pCoords - Tp[i].startingCoords) < 5 then
                
                if IsControlJustPressed(0, 38) then
                    teleportPlayer(Tp[i].endingCoords, playerPed)
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