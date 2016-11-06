--[[

    This file is part of BlauLock, a ComputerCraft program
    that adds password protection on startup.
    
    Author: Daniel 'Blaudev' Mosquera <daniel@blaudev.es>
    Repository: https://github.com/blaudev/BlauLock
    
    THIS FILE IS DISTRIBUTED UNDER THE TERMS OF THE MIT LICENSE

]]

local Current = {}

local function download(url, file)
	local _Reply = http.get(url)
	if _Reply then
		local data = _Reply.readAll()
		f = fs.open(file,"w")
		f.write(data)
		f.close()
		return true 
	else
		return false 
	end	
end

if fs.exists( '/.BlauLock' ) then
    if fs.isDir( '/.BlauLock' ) then
        print( 'ERROR: BlauLock is already installed!' )
        return nil
    end
    
    fs.delete( '/.BlauLock' )
end

if not http then
    print( 'ERROR: HTTP API disabled!' )
    return nil
end

print( 'Fetching list of required files...' )

local Reply = http.get( 'https://raw.githubusercontent.com/blaudev/BlauLock/master/installer/files.dat' )
if not Reply then
    print( 'ERROR: Failed to retrieve list of files!' )
    return nil
else
    local sFiles = Reply.readAll()
    Current['Files'] = textutils.unserialize( sFiles )
end

print( 'Starting download...' )
for i = 1, #Current['Files'] do
    download( Current['Files'][i]['URL'], Current['Files'][i]['Path'])
end

print( 'Loading BlauLock\'s API...' )
dofile( '/.BlauLock/functions.lua' )
local BlauLock = dofile( '/.BlauLock/BlauLock.API.lua' )

local PasswordDefined = false

while not PasswordDefined do
    print('')

    write( 'New password: ' )
    local newpass = read( '*' )

    write( 'Confirm it:' )
    local confpass = read( '*' )

    print('')
    
    if newpass == confpass then
        Current['Pass'] = newpass
        PasswordDefined = true
    else
        print( 'ERROR: passwords do not match!' )
    end    
end

local NewConfig = { Enabled = false, }

print( 'Generating hash, please wait...' )

NewConfig['Hash'] = BlauLock.GenerateHash( 'SHA256', Current['Pass'], 15 )

psavetable( NewConfig, '/.BlauLock/config.dat' )

shell.setAlias( 'blaulock-cmd', '/.BlauLock/BlauLock.CMD.lua' )

if fs.exists( '/startup' ) then
    BlauLock.inject( '/startup', '/.BlauLock/BlauLock.Main.lua' )
else
    local file = fs.open( '/startup', 'w' )
    file.write( "shell.run('/.BlauLock/BlauLock.Main.lua')" )
    file.close()
end

print( 'Done! Run "blaulock-cmd status --enable" to activate.' )
