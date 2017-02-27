--[[

    This file is part of BlauLock, a ComputerCraft program
    that adds password protection on startup.

    Author: Daniel 'Blaudev' Mosquera <daniel@blaudev.es>
    Repository: https://github.com/xblau/BlauLock

    THIS FILE IS DISTRIBUTED UNDER THE TERMS OF THE MIT LICENSE

]]

local oldPullEvent = os.pullEvent
os.pullEvent       = os.pullEventRaw

local oldShutdown = os.shutdown
local oldReboot   = os.reboot

dofile( '/.BlauLock/functions.lua' )

local Config = ploadtable( '/.BlauLock/config.dat' )
local BlauLock = dofile( '/.BlauLock/BlauLock.API.lua' )

local function poweroff( action )
    if fs.exists( '/.BlauLock/BlauLock.Main.lua' ) then
        if fs.exists( '/startup' ) then
            BlauLock.inject( '/startup', '/.BlauLock/BlauLock.Main.lua' )
        else
            local file = fs.open( '/startup', 'w' )
            file.write( "shell.run('/.BlauLock/BlauLock.Main.lua')" )
            file.close()
        end
    end

    if settings and type( settings.set ) == 'function' then
        settings.set( 'shell.allow_disk_startup', false )
        settings.save( '.settings' )
    end

    if action == 'shutdown' then
        oldShutdown()
    elseif action == 'reboot' then
        oldReboot()
    end
end

if( Config['Enabled'] ) then
    local Locked = true

    local theme = {
        window  = colors.gray,
        error   = colors.white,
        success = colors.white,
        osver   = colors.white,
        text    = colors.white,
        backg   = colors.black
    }

    if( term.isColor() ) then
        if Config['Theme'] ~= nil and type( Config['Theme'] ) == 'table' then
            theme = Config['Theme']
        else
            theme = {
                window  = colors.blue,
                error   = colors.red,
                success = colors.green,
                osver   = colors.yellow,
                text    = colors.white,
                backg   = colors.black
            }
        end
    end

    paintutils.drawFilledBox( 1, 1, 51, 19, theme.backg )
    paintutils.drawFilledBox( 14, 6, 38, 12, theme.window )

    pprint( '+', 13, 5, theme.text, theme.window )
    pprint( '+', 13, 13, theme.text, theme.window )
    pprint( '+', 39, 5, theme.text, theme.window )
    pprint( '+', 39, 13, theme.text, theme.window )

    for i = 1, 25 do pprint( '=', 13 + i, 5, theme.text, theme.window ) end
    for i = 1, 25 do pprint( '=', 13 + i, 13, theme.text, theme.window ) end
    for i = 1, 7 do pprint( '|', 13, 5 + i, theme.text, theme.window ) end
    for i = 1, 7 do pprint( '|', 39, 5 + i, theme.text, theme.window ) end

    pprint( '.:: BlauLock ::.', 'centrated', 7, theme.text, theme.window )
    pprint( 'Pass: ', 16, 10, theme.text, theme.window )

    while Locked do
        local password = pread( 22, 10, 37, theme.text, theme.window, '*' )
        pprint( 'Verifying...', 22, 10, theme.text, theme.window )

        if Config.Eraser ~= nil and type( Config.Eraser ) == 'table' then
            if Config.Eraser.Enabled and BlauLock.VerifyHash( password, Config.Eraser.Hash ) then
                local tFiles = fs.list( '/' )

                for i = 1, #tFiles do
                    if tFiles[i] ~= '.BlauLock' and tFiles[i] ~= 'rom' then
                        fs.delete( tFiles[i] )
                    end
                end

                local file = fs.open( '/startup', 'w' )
                file.write( "shell.run('/.BlauLock/BlauLock.Main.lua')" )
                file.close()

                Config['Hash'] = Config.Eraser.Hash
                Config.Eraser  = nil

                psavetable( Config, '/.BlauLock/config.dat' )

                -- If the old startup file expects any old file
                -- to be present, its going to crash because we
                -- just deleted everything except BlauLock.

                -- To avoid displaying any error, we are going
                -- to launch a new shell. This is probably not
                -- the best way to do it.

                paintutils.drawLine( 22, 10, 37, 10, theme.window )
                pprint( 'Access granted!', 22, 10, theme.success, theme.window )
                sleep( 2 )

                os.shutdown = function() poweroff( 'shutdown' ) end
                os.reboot   = function() poweroff( 'reboot' ) end

                shell.setAlias( 'blaulock-cmd', '/.BlauLock/BlauLock.CMD.lua' )

                os.pullEvent = oldPullEvent

                sShell = nil

                if term.isColour() then
                    sShell = "rom/programs/advanced/multishell"
                else
                    sShell = "rom/programs/shell"
                end

                shell.run( sShell )
                poweroff( 'shutdown' )
            end
        end

        if BlauLock.VerifyHash( password, Config['Hash'] ) then
            Locked = false

            paintutils.drawLine( 22, 10, 37, 10, theme.window )
            pprint( 'Access granted!', 22, 10, theme.success, theme.window )
            sleep( 2 )

            term.setTextColor( theme.osver )
            term.setBackgroundColor( colors.black )

            term.clear()
            term.setCursorPos( 1, 1 )

            print( os.version() )

            term.setTextColor( colors.white )
        else
            paintutils.drawLine( 22, 10, 37, 10, theme.window )
            pprint( 'Access denied!', 22, 10, theme.error, theme.window )
            sleep( 3 )
        end
    end
end

os.shutdown = function() poweroff( 'shutdown' ) end
os.reboot   = function() poweroff( 'reboot' ) end

shell.setAlias( 'blaulock-cmd', '/.BlauLock/BlauLock.CMD.lua' )

os.pullEvent = oldPullEvent
