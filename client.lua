local QBCore = exports['qb-core']:GetCoreObject()
local activeProps = {}

-- ==========================
-- Crear zonas de qb-target
-- ==========================
CreateThread(function()
    Wait(1000)
    if GetResourceState("qb-target") ~= "started" then return end

    -- Spots de tiendas
    for localKey, localData in pairs(Config.Locations) do
        if localData.spots then
            for spotIndex, spot in ipairs(localData.spots) do
                local name = ("qb-robbery:%s:%s"):format(localKey, spotIndex)
                exports['qb-target']:AddBoxZone(name, spot.coords, spot.size.x, spot.size.y, {
                    name = name,
                    heading = spot.heading,
                    minZ = (spot.coords.z - 1.0),
                    maxZ = (spot.coords.z + 1.5),
                }, {
                    options = {
                        {
                            event = "qb-robbery:client:attemptRob",
                            icon = "fas fa-hand-rock",
                            label = spot.label or "Robar",
                            location = ("%s:%s"):format(localKey, spotIndex)
                        }
                    },
                    distance = Config.TargetDistance
                })
            end
        end
    end

    -- Cajas fuertes
    for key, data in pairs(Config.Safes) do
        local name = "qb-robbery-safe:" .. key
        exports['qb-target']:AddBoxZone(name, data.coords, data.size.x, data.size.y, {
            name = name,
            heading = data.heading,
            minZ = (data.coords.z - 1.0),
            maxZ = (data.coords.z + 1.5),
        }, {
            options = {
                {
                    event = "qb-robbery:client:attemptSafe",
                    icon = "fas fa-vault",
                    label = "Forzar Caja Fuerte",
                    location = key
                }
            },
            distance = Config.TargetDistance
        })
    end
end)

-- ==========================
-- Robar spots normales
-- ==========================
RegisterNetEvent("qb-robbery:client:attemptRob", function(data)
    local ped = PlayerPedId()
    if not QBCore.Functions.HasItem(Config.RequiredItem) then
        QBCore.Functions.Notify("Te hace falta un " .. Config.RequiredItem, "error")
        return
    end

    TaskPlayAnim(ped, "anim@amb@business@weed@weed_inspecting_lo_med_hi@", "weed_crouch_checkingleaves_idle_01_inspector", 3.0, -1, -1, 49, 0, 0, 0, 0)
    local prop = CreateObject(`prop_tool_screwdriver`, GetEntityCoords(ped), true, true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 57005), 0.1, 0.0, 0.0, 90.0, 0.0, 0.0, true, true, false, true, 1, true)

    QBCore.Functions.Progressbar("rob_spot", "Robando...", Config.RobDuration, false, true, {}, {}, {}, {}, function()
        ClearPedTasks(ped)
        DeleteObject(prop)
        TriggerServerEvent("qb-robbery:server:giveLoot", data.location)
    end, function()
        ClearPedTasks(ped)
        DeleteObject(prop)
        QBCore.Functions.Notify("Cancelado", "error")
    end)
end)

-- ==========================
-- Cajas fuertes
-- ==========================
RegisterNetEvent("qb-robbery:client:attemptSafe", function(data)
    TriggerServerEvent("qb-robbery:server:trySafe", data.location)
end)

RegisterNetEvent("qb-robbery:client:startSafe", function(locationKey)
    local ped = PlayerPedId()
    local safe = Config.Safes[locationKey]
    if not safe then return end

    local drill = CreateObject(`hei_prop_heist_drill`, GetEntityCoords(ped), true, true, true)
    AttachEntityToEntity(drill, ped, GetPedBoneIndex(ped, 57005), 0.1, 0.0, 0.0, 90.0, 0.0, 0.0, true, true, false, true, 1, true)
    TaskPlayAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_start", 3.0, -1, -1, 49, 0, 0, 0, 0)

    exports['drilling']:StartDrilling(function(success)
        ClearPedTasks(ped)
        DeleteObject(drill)
        if success then
            TriggerServerEvent("qb-robbery:server:safeReward", locationKey)
        else
            QBCore.Functions.Notify("Fallaste al abrir la caja fuerte", "error")
        end
    end)
end)

-- ==========================
-- Cajas físicas (props)
-- ==========================
local function spawnCrate(crateKey, crateData)
    if activeProps[crateKey] then return end
    local prop = CreateObject(GetHashKey(crateData.prop), crateData.coords.x, crateData.coords.y, crateData.coords.z - 1.0, false, true, true)
    SetEntityHeading(prop, crateData.heading)
    FreezeEntityPosition(prop, true)
    activeProps[crateKey] = prop

    exports['qb-target']:AddTargetEntity(prop, {
        options = {
            {
                event = "qb-robbery:client:breakCrate",
                icon = "fas fa-box-open",
                label = "Romper " .. (crateData.label or "Caja"),
                crateKey = crateKey
            }
        },
        distance = 2.0
    })
end

RegisterNetEvent("qb-robbery:client:spawnCrate", function(crateKey, crateData)
    spawnCrate(crateKey, crateData)
end)

RegisterNetEvent("qb-robbery:client:removeCrate", function(crateKey)
    local prop = activeProps[crateKey]
    if prop and DoesEntityExist(prop) then
        DeleteObject(prop)
    end
    activeProps[crateKey] = nil
end)

-- Intentar romper caja
RegisterNetEvent("qb-robbery:client:breakCrate", function(data)
    local ped = PlayerPedId()
    local crate = Config.Crates[data.crateKey]
    if not crate then return end

    if not QBCore.Functions.HasItem(Config.CrateRequiredItem) then
        QBCore.Functions.Notify("Te hace falta un " .. Config.CrateRequiredItem .. " para abrir la caja", "error")
        return
    end

    TaskPlayAnim(ped, "melee@large_wpn@streamed_core", "ground_attack_on_spot", 3.0, -1, -1, 49, 0, 0, 0, 0)
    QBCore.Functions.Progressbar("break_crate", "Rompiendo caja...", Config.CrateBreakTime, false, true, {}, {}, {}, {}, function()
        ClearPedTasks(ped)
        TriggerServerEvent("qb-robbery:server:crateLoot", data.crateKey)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "wood_break", 0.5)
    end, function()
        ClearPedTasks(ped)
        QBCore.Functions.Notify("Cancelado", "error")
    end)
end)

-- spawn inicial de crates
CreateThread(function()
    Wait(2000)
    for crateKey, crateData in pairs(Config.Crates) do
        TriggerEvent("qb-robbery:client:spawnCrate", crateKey, crateData)
    end
end)