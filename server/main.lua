local QBCore = exports['qb-core']:GetCoreObject()

-- Olta Kullanımı
QBCore.Functions.CreateUseableItem("fishingrod", function(source, item)
    local src = source
    print("Fishing rod used by source: " .. src) -- Debug
    TriggerClientEvent("thd_fishing:client:startFishing", src)
end)

-- Balık Ver
RegisterNetEvent('thd_fishing:server:giveFish', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Yem kontrolü ve tüketimi
    local bait = Player.Functions.GetItemByName("fishing_bait")
    if bait then
        if math.random(100) <= Config.BaitChance then
            Player.Functions.RemoveItem("fishing_bait", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["fishing_bait"], 'remove')
        end
        
        -- Şans faktörü
        if math.random(100) <= Config.SuccessChance then
            local fishTable = {}
            for k, v in pairs(Config.Fish) do
                table.insert(fishTable, k)
            end
            
            local randomFish = fishTable[math.random(#fishTable)]
            Player.Functions.AddItem(randomFish, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randomFish], 'add')
            TriggerClientEvent('QBCore:Notify', src, 'Bir balık yakaladın: ' .. QBCore.Shared.Items[randomFish].label, 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Balık yemi yedi ve kaçtı!', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Yemin yok!', 'error')
    end
end)

-- Balık Satışı
RegisterNetEvent('thd_fishing:server:sellFish', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local totalMoney = 0
    local fishSold = 0

    for fishName, info in pairs(Config.Fish) do
        local item = Player.Functions.GetItemByName(fishName)
        if item and item.amount > 0 then
            local price = info.price * item.amount
            totalMoney = totalMoney + price
            fishSold = fishSold + item.amount
            Player.Functions.RemoveItem(fishName, item.amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[fishName], 'remove')
        end
    end

    if totalMoney > 0 then
        Player.Functions.AddMoney('cash', totalMoney)
        TriggerClientEvent('QBCore:Notify', src, fishSold .. ' adet balık satıldı. Kazanç: $' .. totalMoney, 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Üzerinde satacak balık yok!', 'error')
    end
end)
