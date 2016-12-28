--[[

    This file is part of BlauLock, a ComputerCraft program
    that adds password protection on startup.

    Author: Daniel 'Blaudev' Mosquera <daniel@blaudev.es>
    Repository: https://github.com/blaudev/BlauLock

    THIS FILE IS DISTRIBUTED UNDER THE TERMS OF THE MIT LICENSE

]]

local tArgs = {...}

local sInstallerLink = nil
local sInstallerPath = '/.BlauLockInstaller'

local function download( link, path )
    local handler = http.get( link )
    if handler then
        local data = handler.readAll()
        f = fs.open( path, "w" )
        f.write( data )
        f.close()
        return true
    else return false end
end

if not tArgs[1] then
    print( 'Running without args, assuming install...' )
    tArgs[1] = 'install'
end

if tArgs[1] == 'install' then
    if not http then error( 'HTTP API not found!' ) end

    if term.isColor() then
        --sInstallerLink = 'https://raw.githubusercontent.com/blaudev/BlauLock/master/installer/BlauLock.AdvancedInstaller.lua'
        sInstallerLink = 'https://raw.githubusercontent.com/blaudev/BlauLock/master/installer/BlauLock.BasicInstaller.lua'
    else
        sInstallerLink = 'https://raw.githubusercontent.com/blaudev/BlauLock/master/installer/BlauLock.BasicInstaller.lua'
    end

    if fs.exists( sInstallerPath ) then
        fs.delete( sInstallerPath )
    end

    write( 'Downloading installer...      ' )
    local ok = download( sInstallerLink, sInstallerPath )

    if not ok then
        print( 'Failed.' )
        return false
    end

    print( 'Success.' )

    shell.run( sInstallerPath )
    fs.delete( sInstallerPath )
end

if tArgs[1] == 'remove' then
    if fs.exists( '/.BlauLock/BlauLock.CMD.lua' ) then
        -- Use the built-in uninstaller
        shell.run( '/.BlauLock/BlauLock.CMD.lua remove --silent' )
    else
        -- If the cmd tool doesn't exist, remove the files manually

        if fs.exists( '/.BlauLock' ) then
            -- Remove the app directory
            fs.delete( '/.BlauLock' )
        end

        if fs.exists( '/startup' ) then
            -- Restore the startup file

            local file = fs.open( '/startup', 'r' )
            local oldstup = file.readAll()
            file.close()

            local newstup = oldstup:gsub( "shell.run%('/%.BlauLock/BlauLock.Main.lua'%)", "" )

            local file = fs.open( '/startup', 'w' )
            file.write( newstup )
            file.close()
        end
    end
end
