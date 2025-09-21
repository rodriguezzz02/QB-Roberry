Config = {}

-- ==========================
-- General
-- ==========================
Config.RequiredItem = "lockpick"
Config.ConsumeLockpick = true
Config.RobDuration = 10000 -- ms
Config.TargetDistance = 2.5
Config.Cooldown = 900 -- 15 min

-- ==========================
-- Robos normales con spots
-- ==========================
Config.LootTable = {
    { item = "goldiron", chance = 50, min = 1, max = 3 },
    { item = "bate", chance = 30, min = 1, max = 1 },
    { item = "diamond", chance = 20, min = 1, max = 2 }
}

Config.Locations = {
    ["store_1"] = {
        label = "Tienda Vespucci",
        spots = {
            {
                label = "Cajón 1",
                coords = vector3(24.5, -1347.3, 29.5),
                size = vector2(1.0, 1.0),
                heading = 0.0,
                loot = Config.LootTable
            },
            {
                label = "Cajón 2",
                coords = vector3(25.0, -1347.0, 29.5),
                size = vector2(1.0, 1.0),
                heading = 0.0,
                loot = Config.LootTable
            }
        }
    },
    ["store_2"] = {
        label = "Tienda Paleto",
        spots = {
            {
                label = "Estante 1",
                coords = vector3(-706.1, -913.5, 19.2),
                size = vector2(1.0, 1.0),
                heading = 90.0,
                loot = Config.LootTable
            },
            {
                label = "Estante 2",
                coords = vector3(-707.0, -914.0, 19.2),
                size = vector2(1.0, 1.0),
                heading = 90.0,
                loot = Config.LootTable
            }
        }
    }
}

-- Para añadir otra tienda:
-- ["store_X"] = {
--   label = "Nombre Tienda",
--   spots = {
--     { label="Cajón 1", coords=vector3(x,y,z), size=vector2(1,1), heading=0.0, loot=Config.LootTable }
--   }
-- }

-- ==========================
-- Cajas fuertes
-- ==========================
Config.SafeCooldown = 1800 -- 30 min
Config.SafeReward = { min = 5000, max = 15000 }
Config.SafeBlackMoneyItem = "markedbills"
Config.SafeBlackMoney = { min = 1, max = 3 }
Config.SafeRewardType = "cash" -- cash/blackmoney

Config.Safes = {
    ["store_safe1"] = {
        label = "Caja Fuerte Vespucci",
        coords = vector3(28.0, -1339.0, 29.5),
        size = vector2(1.2, 1.2),
        heading = 0.0,
        requiredItem = "drill"
    },
    ["store_safe2"] = {
        label = "Caja Fuerte Paleto",
        coords = vector3(-709.2, -904.5, 19.2),
        size = vector2(1.2, 1.2),
        heading = 0.0,
        requiredItem = "drill"
    },
    ["store_safe3"] = {
        label = "Caja Fuerte Sandy Shores",
        coords = vector3(1960.1, 3740.3, 32.3),
        size = vector2(1.2, 1.2),
        heading = 0.0,
        requiredItem = "drill"
    }
}

-- Para añadir otra:
-- ["store_safeX"] = {
--   label="Caja Fuerte Nombre",
--   coords=vector3(x,y,z),
--   size=vector2(1.2,1.2),
--   heading=0.0,
--   requiredItem="drill"
-- }

-- ==========================
-- Cajas físicas (props en mapa)
-- ==========================
Config.CrateCooldown = 900 -- 15 min
Config.CrateBreakTime = 10000 -- ms
Config.CrateRequiredItem = "crowbar"

Config.Crates = {
    ["crate_1"] = {
        label = "Caja de suministros 1",
        coords = vector3(450.5, -980.2, 30.6),
        heading = 0.0,
        prop = "prop_box_wood02a_pu",
        multipleItems = true,
        loot = {
            { item = "weapon_pistol", chance = 30, min = 1, max = 1 },
            { item = "ammo_pistol", chance = 50, min = 5, max = 15 },
            { item = "weed", chance = 40, min = 1, max = 5 }
        }
    },
    ["crate_2"] = {
        label = "Caja de armas",
        coords = vector3(250.1, -50.5, 69.9),
        heading = 90.0,
        prop = "prop_box_wood02a_pu",
        multipleItems = false,
        loot = {
            { item = "weapon_pistol", chance = 50, min = 1, max = 1 },
            { item = "ammo_pistol", chance = 30, min = 10, max = 20 },
            { item = "weed", chance = 20, min = 1, max = 3 }
        }
    },
    ["crate_3"] = {
        label = "Caja de drogas",
        coords = vector3(100.3, -200.7, 54.9),
        heading = 180.0,
        prop = "prop_box_wood02a_pu",
        multipleItems = true,
        loot = {
            { item = "weed", chance = 70, min = 5, max = 10 },
            { item = "coke", chance = 30, min = 1, max = 3 }
        }
    }
}

-- Para añadir otra caja:
-- ["crate_X"] = {
--   label="Caja personalizada",
--   coords=vector3(x,y,z),
--   heading=0.0,
--   prop="prop_box_wood02a_pu",
--   multipleItems=true/false,
--   loot={
--      {item="ejemplo", chance=50, min=1, max=3}
--   }
-- }