fx_version 'cerulean'
game 'gta5'

ui_page "nui/ui.html"

client_scripts {
	"lang/br.lua",
	"lang/en.lua",
	
	"config.lua",
	"utils.lua",
	"client.lua",
}

server_scripts {
	"lang/br.lua",
	"lang/en.lua",

	"config.lua",
	"server.lua",
	"server_utils.lua"
}

files {
	"nui/ui.html",
	"nui/panel.js",
	"nui/style.css",
}