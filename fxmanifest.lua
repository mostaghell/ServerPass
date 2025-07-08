fx_version 'cerulean'
game 'gta5'

author 'Mostaghell Team'
description 'Advanced FiveM Server Password Protection System with Modern UI, Security Features, and Comprehensive Logging - Developed by Mostaghell Team'
version '2.0.0'
url 'https://mostaghell.com'
contact 'https://t.me/MostaQeell'

-- Configuration and server scripts
server_scripts {
    'config.lua',
    'server/logger.lua',
    'server/security.lua',
    'server.lua'
}

-- Client scripts
client_scripts {
    'client.lua',
    'connection_client.lua'
}

-- UI files for connection password prompt
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

-- Dependencies
dependencies {
    'chat'
}