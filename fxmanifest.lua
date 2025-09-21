fx_version 'cerulean'
game 'gta5'

description 'QB Robbery System (2025) - Spots, Safes & Crates'
author 'Rodriguez22/FaxKex'

shared_script '@ox_lib/init.lua'

client_scripts {
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
}

shared_script 'config.lua'