local QBCore = exports['qb-core']:GetCoreObject()

local spotcooldowns = {}
local safecooldowns = {}
local cratecooldowns = {}

-- ==========================
-- Loot de spots
-- ==========================
RegisterNetEvent("qb-robbery:server:giveLoot", function(locationKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local localKey, spotIndex = locationKey:match("([^:]+):([^:]+)")
    local location = Config.Locations[localKey]
    if not location or not location.spots then return end

    local spot = location.spots[tonumber(spotIndex)]
    if not spot then return end

    local now = os.time()
    if spotcooldowns[locationKey] and spotcooldowns[locationKey] > now then
        local remaining = spotcooldowns[locationKey] - now
        TriggerClientEvent('QBCore:Notify', src, "Ya fue saqueado, espera " .. math.ceil(remaining/60) .. " min.", "error")
        return
    end

    spotcooldowns[locationKey] = now + Config.Cooldown

    local chosen
    for _, entry in ipairs(spot.loot) do
        if math.random(1,100) <= entry.chance then
            chosen = entry
            break
        end
    end

    if chosen then
        local qty = math.random(chosen.min or 1, chosen.max or 1)
        Player.Functions.AddItem(chosen.item, qty)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[chosen.item], "add")
        TriggerClientEvent('QBCore:Notify', src, "Has conseguido: " .. qty .. "x " .. chosen.item, "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "No encontraste nada...", "error")
    end
end)

-- ==========================
-- Cajas fuertes
-- ==========================
RegisterNetEvent("qb-robbery:server:trySafe", function(locationKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local safe = Config.Safes[locationKey]
    if not safe then return end

    local item = Player.Functions.GetItemByName(safe.requiredItem)
    if not item then
        TriggerClientEvent('QBCore:Notify', src, "Te hace falta un " .. safe.requiredItem .. " para robar esto", "error")
        return
    end

    local now = os.time()
    if safecooldowns[locationKey] and safecooldowns[locationKey] > now then
        local remaining = safecooldowns[locationKey] - now
        TriggerClientEvent('QBCore:Notify', src, "Esa caja fuerte ya fue forzada, espera " .. math.ceil(remaining/60) .. " min.", "error")
        return
    end

    safecooldowns[locationKey] = now + Config.SafeCooldown
    TriggerClientEvent("qb-robbery:client:startSafe", src, locationKey)
end)

RegisterNetEvent("qb-robbery:server:safeReward", function(locationKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if Config.SafeRewardType == "cash" then
        local amount = math.random(Config.SafeReward.min, Config.SafeReward.max)
        Player.Functions.AddMoney("cash", amount)
        TriggerClientEvent('QBCore:Notify', src, "Robaste $" .. amount, "success")
    elseif Config.SafeRewardType == "blackmoney" then
        local qty = math.random(Config.SafeBlackMoney.min, Config.SafeBlackMoney.max)
        Player.Functions.AddItem(Config.SafeBlackMoneyItem, qty)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.SafeBlackMoneyItem], "add")
        TriggerClientEvent('QBCore:Notify', src, "Robaste " .. qty .. "x " .. Config.SafeBlackMoneyItem, "success")
    end
end)

-- ==========================
-- Cajas físicas (props)
-- ==========================
RegisterNetEvent("qb-robbery:server:crateLoot", function(crateKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local crate = Config.Crates[crateKey]
    if not Player or not crate then return end

    local now = os.time()
    if cratecooldowns[crateKey] and cratecooldowns[crateKey] > now then
        local remaining = cratecooldowns[crateKey] - now
        TriggerClientEvent('QBCore:Notify', src, "Esta caja ya fue abierta, espera " .. math.ceil(remaining/60) .. " min.", "error")
        return
    end

    cratecooldowns[crateKey] = now + Config.CrateCooldown

    if crate.multipleItems then
        for _, entry in ipairs(crate.loot) do
            if math.random(1,100) <= entry.chance then
                local qty = math.random(entry.min, entry.max)
                Player.Functions.AddItem(entry.item, qty)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[entry.item], "add")
                TriggerClientEvent('QBCore:Notify', src, "Conseguiste " .. qty .. "x " .. entry.item, "success")
            end
        end
    else
        local chosen
        for _, entry in ipairs(crate.loot) do
            if math.random(1,100) <= entry.chance then chosen = entry break end
        end
        if chosen then
            local qty = math.random(chosen.min, chosen.max)
            Player.Functions.AddItem(chosen.item, qty)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[chosen.item], "add")
            TriggerClientEvent('QBCore:Notify', src, "Conseguiste " .. qty .. "x " .. chosen.item, "success")
        else
            TriggerClientEvent('QBCore:Notify', src, "La caja estaba vacía", "error")
        end
    end

    TriggerClientEvent('qb-robbery:client:removeCrate', -1, crateKey)

    SetTimeout(Config.CrateCooldown * 1000, function()
        cratecooldowns[crateKey] = nil
        TriggerClientEvent("qb-robbery:client:spawnCrate", -1, crateKey, crate)
    end)
end)