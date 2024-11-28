local QBCore = exports['qb-core']:GetCoreObject()
local items = {}
for _, item in pairs(Config.Items) do
    table.insert(items, item)
end




for _, pedCoords in ipairs(Config.Peds.pedSpawner) do
    RequestModel(GetHashKey(pedCoords['hash']))
    while not HasModelLoaded(GetHashKey(pedCoords['hash'])) do
        Wait(0)
    end

    local spawnedPed = CreatePed(2, GetHashKey(pedCoords['hash']), pedCoords.x, pedCoords.y, pedCoords.z - 1.0, pedCoords.h, false, true)
    FreezeEntityPosition(spawnedPed, true)
    SetEntityInvincible(spawnedPed, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)

    exports['qb-target']:AddTargetEntity(spawnedPed, { 
        options = { 
            { 
                type = "client", 
                -- event = "s-blackshop:client:openMenu", uncomment this if u want to use qbmenu
                event = "s-blackshop:client:openUI", 
                label = 'Blackshop', 
            }
        },
        distance = 2.5, 
    })
end


-- qb menu uncomment if u want to use qbmenu
-- RegisterNetEvent('s-blackshop:client:openMenu', function()
--         local menuItems = {
--             {
--                 header = "Blackshop",
--                 txt = "What would you like to buy?", 
--                 isMenuHeader = true
--             }
--         }
--         for _, item in pairs(Config.Items) do
--             table.insert(menuItems, {
--                 header = item.name,
--                 txt = "Price $" .. item.price,
--                 icon = 'fas fa-code-merge',
--                 params = {
--                     event = "s-blackshop:client:subMenu", 
--                     args = {
--                         itemKey = item.itemKey,
--                         price = item.price,
--                         name = item.name
--                     }
--                 }
--             })
--         end
--     exports['qb-menu']:openMenu(menuItems)

RegisterNetEvent('s-blackshop:client:openMenu', function()
    local items = {}
    for _, item in pairs(Config.Items) do
        table.insert(items, {
            itemKey = item.itemKey,
            name = item.name,
            price = item.price
        })
    end

    print(json.encode(items))

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        items = items
    })
end)





RegisterNetEvent('s-blackshop:client:subMenu', function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = "Amount",
        submitText = "Buy!",
        inputs = {
            {
                text = "Insert amount", 
                name = "amount",
                type = "number", 
                isRequired = true,
            },
        }
    })
    if dialog then
        local amount = tonumber(dialog.amount)
        if amount > 0 then
            print('Enteret amount' ..amount)
            TriggerServerEvent('s-blackshop:server:processPurchase', {itemKey = data.itemKey, price = data.price, amount = amount, name = data.name})
        else
            TriggerEvent('QBCore:Notify', "Invalid amount!", "error")

        end
    end   
end)


RegisterNetEvent('s-blackshop:client:buyItem', function(data)
    TriggerServerEvent('s-blackshop:server:processPurchase', data)
end)

RegisterNetEvent('s-blackshop:client:openUI', function()
    local items = {}
    for _, item in pairs(Config.Items) do
        table.insert(items, {
            itemKey = item.itemKey,
            name = item.name,
            price = item.price,
            imageUrl = item.imageUrl
        })
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        items = items
    })
end)



RegisterNUICallback('closeShop', function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end)

RegisterNUICallback('buyItem', function(data, cb)
    local dialog = exports['qb-input']:ShowInput({
        header = "Item amount",
        submitText = "Buy!",
        inputs = {
            {
                text = "Amount",
                name = "amount",
                type = "number",
                isRequired = true
            },
        }
    })

    if dialog and tonumber(dialog.amount) > 0 then
        TriggerServerEvent('s-blackshop:server:processPurchase', {
            itemKey = data.itemKey,
            price = data.price,
            amount = tonumber(dialog.amount),
            name = data.name
        })
    else
        TriggerEvent('QBCore:Notify', "Incorrect amount!", "error")
    end
end)
