fx_version 'cerulean'
games { 'gta5' }
author 'Matti'
description 'Delta Check Player'
lua54 "yes"

client_scripts {
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

dependencies {
	'oxmysql',
}