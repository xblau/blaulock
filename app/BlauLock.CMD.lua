--[[

    This file is part of BlauLock, a ComputerCraft program
    that adds password protection on startup.
    
    Author: Daniel 'Blaudev' Mosquera <daniel@blaudev.es>
    Repository: https://github.com/blaudev/BlauLock
    
    THIS FILE IS DISTRIBUTED UNDER THE TERMS OF THE MIT LICENSE

]]

local tArgs = {...}

dofile( '/.BlauLock/functions.lua' )

local Config = ploadtable( '/.BlauLock/config.dat' )
local BlauLock = dofile( '/.BlauLock/BlauLock.API.lua' )

local function printUsage()
    print( 'Usages:' )
    print( 'blaulock-cmd passwd [--pim <n>]' )
    print( 'blaulock-cmd inject [--file <path>]' )
    print( 'blaulock-cmd status [--enable/--disable]' )
    print( 'blaulock-cmd remove [--silent]' )
end

if #tArgs == 0 then
    printUsage()
    return nil
end

if tArgs[1] == 'passwd' then
    local PIM = 15
    if tArgs[2] == '--pim' and tArgs[3] ~= nil then
        PIM = tonumber( tArgs[3] )
    end
    
    if PIM < 5 then
        print( 'ERROR: PIM can\'t be lower than 5! (Current: ' .. tostring( PIM ) .. ')' )
        return nil
    end
    
    write( 'New password: ' ) 
    local newpass = read( '*' )
    
    write( 'Confirm it: ' )
    local confpass = read( '*' )
    
    print( '' )
    
    if newpass ~= confpass then
        print( 'ERROR: passwords do not match!' )
        return nil
    end
    
    print( 'Generating hash, please wait...' )
    confpass, newpass = nil, BlauLock.GenerateHash( 'SHA256', newpass, PIM )
    
    Config['Hash'] = newpass
    psavetable( Config, '/.BlauLock/config.dat' )
    
    print( 'New password saved successfully!' )
    return true
end

if tArgs[1] == 'status' then
    local status = Config['Enabled'] and 'enabled' or 'disabled'
    
    if tArgs[2] ~= nil and tArgs[2] == '--enable' then
        if Config['Enabled'] then
            print( 'BlauLock is already enabled!' )
            return nil
        end
        
        Config['Enabled'] = true
        psavetable( Config, '/.BlauLock/config.dat' )
        
        print( 'BlauLock has been enabled.' )
        return true
    end
    
    if tArgs[2] ~= nil and tArgs[2] == '--disable' then
        if not Config['Enabled'] then
            print( 'BlauLock is already disabled!' )
            return nil
        end
        
        Config['Enabled'] = false
        psavetable( Config, '/.BlauLock/config.dat' )
        
        print( 'WARNING: BlauLock has been disabled!' )
        return true
    end
    
    print( 'BlauLock is currently ' .. status .. ' on this computer.' )
    return true
end

if tArgs[1] == 'inject' then
    local path = '/startup'
    
    if tArgs[2] == '--file' and tArgs[3] ~= nil then
        path = tArgs[3]
    end
    
    if not fs.exists( path ) then
        print( 'ERROR: target file not found!' )
        return nil
    end
    
    if fs.exists( path ) and fs.isDir( path ) then
        print( 'ERROR: target must be a file, not a directory!' )
        return nil
    end
    
    if fs.exists( path ) and fs.isReadOnly( path ) then
        print( 'ERROR: target is read-only!' )
        return nil
    end
    
    BlauLock.inject( path, '/.BlauLock/BlauLock.Main.lua' )
    print( 'Successfully injected: ' .. path )
    return true
end

if tArgs[1] == 'remove' then
    if tArgs[2] ~= '--silent' then
        print( 'WARNING: This option will remove BlauLock!' .. "\n" )
        print( 'If you want to disable BlauLock without removing it, type "disable". If you want to uninstall, type "remove".' .. "\n" )
        write( 'Action: ' )
        local choice = read()
        
        if choice == 'disable' then
            shell.run( 'blaulock-cmd status --disable' )
            return true
        elseif choice == 'remove' then
            --
        else
            print( 'Unknown action "' .. choice .. '", aborting.' )
            return nil
        end
    end
    
    term.setTextColor( colors.white )
    term.setBackgroundColor( colors.black )
    
    term.clear() term.setCursorPos( 1, 1 )
    
    write( 'Uninstalling BlauLock, please wait... ' )
    
    fs.delete( '/.BlauLock' )
    
    local file = fs.open( '/startup', 'r' )
    local oldstup = file.readAll()
    file.close()
    
    local newstup = oldstup:gsub( "shell.run%('/%.BlauLock/BlauLock.Main.lua'%)", "" )
    
    local file = fs.open( '/startup', 'w' )
    file.write( newstup )
    file.close()
    
    print( 'Done!' )
end
