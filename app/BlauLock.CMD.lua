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
    print( 'blaulock-cmd status [--enable/--disable]' )
    print( 'blaulock-cmd eraser [--enable/--disable]' )
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

    if tArgs[2] ~= '--silent' then write( 'Uninstalling BlauLock, please wait... ' ) end

    fs.delete( '/.BlauLock' )

    local file = fs.open( '/startup', 'r' )
    local oldstup = file.readAll()
    file.close()

    local newstup = oldstup:gsub( "shell.run%('/%.BlauLock/BlauLock.Main.lua'%)", "" )

    local file = fs.open( '/startup', 'w' )
    file.write( newstup )
    file.close()

    shell.clearAlias( 'blaulock-cmd' )

    if tArgs[2] ~= '--silent' then print( 'Done!' ) end
    return true
end

if tArgs[1] == 'eraser' then
    if Config.Eraser == nil then
        Config.Eraser = {}
        Config.Eraser.Enabled = false
    end

    if tArgs[2] == '--enable' then
        print( "This feature adds an 'emergency' password to BlauLock.\n" )
        print( 'When entered, BlauLock will delete EVERYTHING' )
        print( 'except itself, and replace the original password' )
        print( "with the emergency one.\n" )
        print( 'This can be useful if someone forces you to unlock' )
        print( "your computer under threat.\n" )

        write( 'Do you want to enable this feature? (y/N): ' )
        local input = read()

        if input == 'y' then
            write( 'Enter your emergency password: ' )
            local EraserPassword = read()

            if #EraserPassword > 6 then
                Config.Eraser.Enabled = true
                Config.Eraser.Hash = BlauLock.GenerateHash( 'SHA256', EraserPassword, 25 )

                psavetable( Config, '/.BlauLock/config.dat' )
                print( 'The eraser has been enabled successfully.' )
                return true
            else
                print( 'Error: your password is to short!' )
                return false
            end

        else
            print( 'Aborted.' )
            return true
        end
    end

    if tArgs[2] == '--disable' then
        write( 'WARNING: are you sure? (y/N): ' )
        local input = read()
        if input == 'y' then
            Config.Eraser.Hash = nil
            Config.Eraser.Enabled = false

            print( 'BlauLock\'s eraser has been disabled.' )
            return true
        else
            print( 'Aborted.' )
            return false
        end
    end

    if Config.Eraser.Enabled then
        print( 'BlauLock\'s eraser is ENABLED on this computer.' )
        print( 'Run "blaulock-cmd eraser --disable" to disable it.' )
    else
        print( 'BlauLock\'s eraser is DISABLED on this computer.' )
        print( 'Run "blaulock-cmd eraser --enable" to enable it.' )
    end

    return true
end

printUsage()
