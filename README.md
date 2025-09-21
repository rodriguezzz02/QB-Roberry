
---

🚨 QB-ROBBERY

Script de robos avanzado para servidores QBCore (FiveM) con soporte para ox_lib y qb-target.

Este recurso permite a los jugadores realizar diferentes tipos de robos:

🔑 Spots de tiendas (cajones, estantes, etc.) con lockpick.

🔧 Cajas fuertes con minijuego de taladro.

📦 Cajas físicas (props) que se rompen con palanca.


Todo es 100% configurable desde config.lua.


---

## 📌 Características principales

✅ Integración con qb-target (no requiere configuración manual).
✅ Soporte de ox_lib para notificaciones y progressbars.
✅ Tres métodos de robo diferentes:

1. Spots de tiendas → requieren lockpick.


2. Cajas fuertes → requieren drill + minijuego externo.


3. Cajas físicas (props) → requieren crowbar y se pueden configurar para dar 1 item o varios.



✅ Cooldowns personalizables por cada tipo de robo.

✅ Loot configurable con chance (%), cantidad mínima y máxima.

✅ Recompensas en dinero (cash) o blackmoney (item personalizado).

✅ Props visibles en el mundo para las cajas físicas, que desaparecen al ser robadas y reaparecen automáticamente tras el cooldown.

✅ Animaciones y props realistas (destornillador, taladro, palanca).

✅ Soporte de sonidos (InteractSound) para feedback al romper cajas.


---

## 📂 Archivos principales

fxmanifest.lua → Metadata del recurso.

config.lua → Todas las configuraciones de spots, safes y crates.

client.lua → Lógica de interacción, animaciones, progressbars y spawn de props.

server.lua → Lógica de loot, cooldowns y recompensas.



---

## ⚙️ Configuración

Items requeridos

Asegúrate de tener en tu qb-core/shared/items.lua los siguientes ítems (o los que configures):
```
lockpick

drill

crowbar

goldiron, diamond, bate, weed, coke, weapon_pistol, ammo_pistol, etc.

Item de blackmoney si lo usas (ejemplo: markedbills).

```
## ⚙️ Ejemplo de configuración

```
Spots (tiendas)

["store1"] = {
    spots = {
        {
            coords = vector3(25.5, -1346.2, 29.5),
            size = vector3(1.0, 1.0, 1.0),
            heading = 0,
            label = "Cajón de la caja",
            loot = {
                {item = "goldiron", chance = 50, min = 1, max = 2},
                {item = "diamond", chance = 30, min = 1, max = 1},
            }
        }
    }
}

Safes (cajas fuertes)

["safe1"] = {
    coords = vector3(28.1, -1339.4, 29.5),
    size = vector3(1.2, 1.2, 1.2),
    heading = 0,
    requiredItem = "drill", -- item necesario
}

En config.lua defines si la recompensa es:

Config.SafeRewardType = "cash" ---- cash/blackmoney

Crates (cajas físicas)

["crate1"] = {
    coords = vector3(100.2, -1300.5, 29.2),
    heading = 180.0,
    prop = "prop_boxpile_06b",
    label = "Caja de armas",
    multipleItems = true,
    loot = {
        {item = "weapon_pistol", chance = 50, min = 1, max = 1},
        {item = "ammo_pistol", chance = 70, min = 10, max = 30},
        {item = "weed", chance = 40, min = 1, max = 5},
    }
}

```
---

🔄 Cooldowns

Spots → Config.Cooldown (ejemplo: 15 min).

Safes → Config.SafeCooldown (ejemplo: 20 min).

Crates → Config.CrateCooldown (ejemplo: 15 min, y reaparecen automáticamente tras este tiempo).



---
## 🔗 Dependencias
- [qb-core](https://github.com/qbcore-framework/qb-core)  
- [qb-target](https://github.com/qbcore-framework/qb-target)  
- [ox_lib](https://github.com/overextended/ox_lib)

drilling (minijuego de taladro)

InteractSound (opcional, para sonidos al romper cajas).



---

## 🚀 Instalación

1. Descarga y coloca el recurso en tu carpeta resources/.


2. Asegúrate de tener todas las dependencias instaladas.


3. Añade los ítems necesarios en qb-core/shared/items.lua.


4. Configura tus spots, safes y crates en config.lua.


5. Añade el recurso a tu server.cfg:
```
ensure qb-core
ensure ox_lib
ensure drillingminigame
ensure qb-robbery
```


---

📝 Notas

Si añades nuevas tiendas, cajas fuertes o crates → solo edita el config.lua.

Los qb-target se crean automáticamente al iniciar el recurso.

Las cajas (props) desaparecen al romperse y reaparecen solas cuando termina el cooldown.



---


