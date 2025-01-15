fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Brodino"
description ""
version "0.0"

shared_scripts { "@ox_lib/init.lua", "config.lua", }
server_scripts { "server/*", }
client_scripts { "client/*", }

ui_page "web/dist/index.html"

files { "web/dist/*", "web/dist/assets/*" }