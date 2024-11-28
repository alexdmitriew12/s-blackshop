fx_version 'cerulean'
game 'gta5'

author 'szefuncio'
description 'FiveM blackshop script'

client_scripts {
    'client/client.lua',
}

server_script {
   'server/server.lua'
}

shared_scripts {
    'config.lua'
}

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
    'ui/img/*.png',

}

ui_page 'ui/index.html'
