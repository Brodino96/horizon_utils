Tp = {}

RegisterNetEvent("horizon:hackCompleted")
AddEventHandler("horizon:hackCompleted", function (place)
    Tp[#Tp+1] = place
    TriggerClientEvent("horizon:syncTps", -1, Tp)
end)