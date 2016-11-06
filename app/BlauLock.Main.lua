--[[

    This file is part of BlauLock, a ComputerCraft program
    that adds password protection on startup.
    
    Author: Daniel 'Blaudev' Mosquera <daniel@blaudev.es>
    Repository: https://github.com/blaudev/BlauLock
    
    THIS FILE IS DISTRIBUTED UNDER THE TERMS OF THE MIT LICENSE

]]

local oldPullEvent = os.pullEvent
os.pullEvent = os.pullEventRaw

dofile( '/.BlauLock/functions.lua' )

local Config = ploadtable( '/.BlauLock/config.dat' )
local BlauLock = dofile( '/.BlauLock/BlauLock.API.lua' )

if( Config['Enabled'] ) then
    local Locked = true
    
    if( term.isColor() ) then
        windowColor  = colors.blue
        errorColor   = colors.red
        successColor = colors.green
        osverColor   = colors.yellow
    else
        windowColor  = colors.gray
        errorColor   = colors.white
        successColor = colors.white
        osverColor   = colors.white
    end

    paintutils.drawFilledBox( 1, 1, 51, 19, colors.black )
    paintutils.drawFilledBox( 14, 6, 38, 12, windowColor )
    
    pprint( '+', 13, 5, colors.white, windowColor )
    pprint( '+', 13, 13, colors.white, windowColor )
    pprint( '+', 39, 5, colors.white, windowColor )
    pprint( '+', 39, 13, colors.white, windowColor )
    
    for i = 1, 25 do pprint( '=', 13 + i, 5, colors.white, windowColor ) end
    for i = 1, 25 do pprint( '=', 13 + i, 13, colors.white, windowColor ) end
    for i = 1, 7 do pprint( '|', 13, 5 + i, colors.white, windowColor ) end
    for i = 1, 7 do pprint( '|', 39, 5 + i, colors.white, windowColor ) end
    
    pprint( '.:: BlauLock ::.', 'centrated', 7, colors.white, windowColor )
    pprint( 'Pass: ', 16, 10, colors.white, windowColor )
    
    while Locked do
        local password = pread( 22, 10, 37, colors.white, windowColor, '*' )
        
        if BlauLock.VerifyHash( password, Config['Hash'] ) then
            Locked = false
        
            paintutils.drawLine( 22, 10, 37, 10, windowColor )
            pprint( 'Access granted!', 22, 10, successColor, windowColor )
            sleep( 2 )
            
            term.setTextColor( osverColor )
            term.setBackgroundColor( colors.black )
            
            term.clear()
            term.setCursorPos( 1, 1 )

            print( os.version() )

            term.setTextColor( colors.white )
        else
            paintutils.drawLine( 22, 10, 37, 10, windowColor )
            pprint( 'Access denied!', 22, 10, errorColor, windowColor )
            sleep( 3 )
        end
    end
end

os.pullEvent = oldPullEvent

shell.setAlias( 'blaulock-cmd', '/.BlauLock/BlauLock.CMD.lua' )

if settings and type( settings ) == 'table' then
    settings.set( 'shell.allow_disk_startup', false )
    settings.save( '.settings' )
end
