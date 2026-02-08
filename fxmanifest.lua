fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Panda'
description 'CS-Blackmarket'

shared_scripts {
    'shared/config.lua',
    'shared/bridge/init.lua',
    'shared/bridge/notify.lua',
    'shared/bridge/callback.lua',
    'shared/bridge/inventory/init.lua',
    'shared/bridge/inventory/ox.lua',
    'shared/bridge/inventory/qb.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/init.lua',
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
}

files {
    "web/build/**",
    "web/build/*",
}

ui_page "web/build/index.html"