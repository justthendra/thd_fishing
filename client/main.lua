local QBCore = exports['qb-core']:GetCoreObject()
local isFishing = false
local fishingNPC = nil
local rodHandle = nil

-- NPC ve Blip Oluşturma
CreateThread(function()
    -- Blip
    local blip = AddBlipForCoord(Config.SellNPC.coords.x, Config.SellNPC.coords.y, Config.SellNPC.coords.z)
    SetBlipSprite(blip, 68)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 69) -- AstraV Green
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Balık Pazarı")
    EndTextCommandSetBlipName(blip)

    -- NPC
    RequestModel(Config.SellNPC.model)
    while not HasModelLoaded(Config.SellNPC.model) do Wait(10) end

    fishingNPC = CreatePed(4, Config.SellNPC.model, Config.SellNPC.coords.x, Config.SellNPC.coords.y, Config.SellNPC.coords.z - 1.0, Config.SellNPC.coords.w, false, true)
    SetEntityHeading(fishingNPC, Config.SellNPC.coords.w)
    FreezeEntityPosition(fishingNPC, true)
    SetEntityInvincible(fishingNPC, true)
    SetBlockingOfNonTemporaryEvents(fishingNPC, true)

    -- Target
    exports['qb-target']:AddTargetEntity(fishingNPC, {
        options = {
            {
                type = "server",
                event = "thd_fishing:server:sellFish",
                icon = "fas fa-fish",
                label = "Balıkları Sat",
            },
        },
        distance = 2.5,
    })
end)

-- Önyükleme Döngüsü (Animasyon ve Modelleri Hazır Tutar)
CreateThread(function()
    local animDict = "amb@world_human_fishing@idle_a"
    local rodModel = `prop_fishing_rod_01`
    while true do
        local sleep = 2000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - Config.FishingZone.coords)

        if dist < (Config.FishingZone.radius + 20.0) then
            sleep = 1000
            if not HasAnimDictLoaded(animDict) then
                RequestAnimDict(animDict)
            end
            if not HasModelLoaded(rodModel) then
                RequestModel(rodModel)
            end
        end
        Wait(sleep)
    end
end)

-- Balık Tutma Başlatma
RegisterNetEvent('thd_fishing:client:startFishing', function()
    if isFishing then return end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    -- Bölge Kontrolü
    local dist = #(coords - Config.FishingZone.coords)
    if dist > Config.FishingZone.radius then
        QBCore.Functions.Notify('Bu bölgede balık tutamazsın! (Mesafe: '..math.floor(dist)..'m)', 'error')
        return
    end

    -- Su Kontrolü
    local forward = GetEntityForwardVector(ped)
    local checkCoords = coords + (forward * 2.0)
    local foundWater, waterHeight = GetWaterHeight(checkCoords.x, checkCoords.y, checkCoords.z)
    
    if not foundWater then
        foundWater, waterHeight = GetWaterHeight(coords.x, coords.y, coords.z)
    end

    if foundWater then
        local heightDiff = coords.z - waterHeight
        if heightDiff > 15.0 then
            QBCore.Functions.Notify('Çok yüksekten balık tutamazsın!', 'error')
            return
        elseif heightDiff < -1.2 then
            QBCore.Functions.Notify('Suyun içindeyken balık tutamazsın!', 'error')
            return
        end
    else
        QBCore.Functions.Notify('Önünde veya altında su bulunamadı!', 'error')
        return
    end

    -- Yem Kontrolü
    local hasBait = false
    if exports.ox_inventory then
        hasBait = exports.ox_inventory:Search('count', 'fishing_bait') > 0
    else
        hasBait = QBCore.Functions.HasItem('fishing_bait')
    end

    if not hasBait then
        QBCore.Functions.Notify('Yemin yok!', 'error')
        return
    end

    isFishing = true
    
    -- Animasyon ve Olta Hazırlığı
    local animDict = "amb@world_human_fishing@idle_a"
    local rodModel = `prop_fishing_rod_01`
    
    RequestAnimDict(animDict)
    RequestModel(rodModel)
    
    local timeout = 0
    while (not HasAnimDictLoaded(animDict) or not HasModelLoaded(rodModel)) and timeout < 50 do
        Wait(100)
        timeout = timeout + 1
    end

    if rodHandle and DoesEntityExist(rodHandle) then DeleteEntity(rodHandle) end
    if HasModelLoaded(rodModel) then
        rodHandle = CreateObject(rodModel, coords.x, coords.y, coords.z, true, true, false)
        AttachEntityToEntity(rodHandle, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    end

    if HasAnimDictLoaded(animDict) then
        TaskPlayAnim(ped, animDict, "idle_c", 8.0, 1.0, -1, 49, 0, false, false, false)
    else
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, true)
    end
    
    QBCore.Functions.Progressbar("fishing_wait", "Balık bekleniyor...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        -- Animasyonu tazele (Progressbar bitince durmasın diye)
        if HasAnimDictLoaded(animDict) then
            TaskPlayAnim(ped, animDict, "idle_c", 8.0, 1.0, -1, 49, 0, false, false, false)
        end

        -- Minigame (qb-minigames/skillbar)
        local success = exports['qb-minigames']:Skillbar('easy')
        
        if success then
            TriggerServerEvent('thd_fishing:server:giveFish')
        else
            QBCore.Functions.Notify('Balık kaçtı!', 'error')
        end
        
        -- Temizlik
        isFishing = false
        ClearPedTasks(ped)
        if rodHandle and DoesEntityExist(rodHandle) then
            DetachEntity(rodHandle, true, true)
            DeleteEntity(rodHandle)
            rodHandle = nil
        end
        
    end, function() -- Cancel
        isFishing = false
        ClearPedTasks(ped)
        if rodHandle and DoesEntityExist(rodHandle) then
            DetachEntity(rodHandle, true, true)
            DeleteEntity(rodHandle)
            rodHandle = nil
        end
    end)
end)

-- Temizlik
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if fishingNPC then DeletePed(fishingNPC) end
        if rodHandle and DoesEntityExist(rodHandle) then
            DeleteEntity(rodHandle)
        end
    end
end)
