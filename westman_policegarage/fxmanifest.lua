fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author "Westman Resourcez"

ui_page 'nui/index.html'

client_script 'client/main.lua'

shared_scripts {
  'configuration/config.lua',
  'configuration/strings.lua',
  '@es_extended/imports.lua'
}

files {
  'nui/index.html',
  'nui/style.css',
  'nui/main.js',
  'nui/polis.png'
}

escrow_ignore {
  'nui/index.html',
  'nui/style.css',
  'nui/polis.png',
  'configuration/config.lua',
  'configuration/strings.lua'
}