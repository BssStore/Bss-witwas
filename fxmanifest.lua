shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version  'cerulean'
game        'gta5'
lua54       'yes'


author      'Besettos'
description 'Frp Witwas Script ESX | OX'




client_scripts { 
    'client/client.lua',
    'config.lua'
}

server_scripts {  
    'server/server.lua',
    'config.lua'
}

shared_scripts { 
    '@es_extended/imports.lua', 
    '@ox_lib/init.lua' 
}

