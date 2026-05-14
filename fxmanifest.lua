fx_version 'cerulean'
game 'gta5'

description 'AstraV Fishing Script'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'qb-core',
    'qb-menu',
    'qb-target'
}
