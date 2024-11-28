local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('s-blackshop:server:processPurchase', function(data)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)

    if not data or not data.itemKey or not data.price then
        print("Error: Missing data in processPurchase")
        return
    end

    if xPlayer then
        local playerMoney = xPlayer.PlayerData.money['cash']
        if playerMoney >= data.price then
            xPlayer.Functions.RemoveMoney('cash', data.price)
            xPlayer.Functions.AddItem(data.itemKey, data.amount, false, false)
            if data.name then
                TriggerClientEvent('QBCore:Notify', src, "You purchased a " .. data.name, "success")
            else
                TriggerClientEvent('QBCore:Notify', src, "Purchase successful", "success")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "Not enough money", "error")
        end
    else
        print("Error: Player not found.")
    end
end)

