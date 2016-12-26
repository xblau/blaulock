--[[

    This file is part of BlauLock, a ComputerCraft program
    that adds password protection on startup.

    Author: Daniel 'Blaudev' Mosquera <daniel@blaudev.es>
    Repository: https://github.com/blaudev/BlauLock

    THIS FILE IS DISTRIBUTED UNDER THE TERMS OF THE MIT LICENSE

]]

function pprint( text, sX, sY, textColor, backColor, func )
    local func = func or write

    if sX == 'centrated' then
        local w, h = term.getSize()
        sX = math.ceil( math.ceil( ( w / 2 ) - ( #text / 2 ) ), 0 ) + 1
    end

    term.setCursorPos( sX, sY )
    term.setTextColor( textColor )
    term.setBackgroundColor( backColor )
    func( text )
end

function pread( sX, sY, eX, textColor, backColor, char )
    local input = ''

    local function subinput()
        local subinput = ''

        if( #input < ( eX - sX ) ) then
            subinput = input
        else
            subinput = string.sub( input, #input - ( eX - sX ), #input )
        end

        if char ~= nil then
            local length = #subinput
            subinput = ''

            for i = 1, length do
                subinput = subinput .. char
            end
        end

        return subinput
    end

    paintutils.drawLine( sX, sY, eX, sY, backColor )

    term.setCursorPos( sX, sY )
    term.setTextColor( textColor )

    while true do
        local event, key = os.pullEvent()

        if event == 'char' then
            input = input .. key

            if( #input < ( eX - sX ) ) then
                write( char or key )
            else
                paintutils.drawLine( sX, sY, eX, sY, backColor )
                term.setCursorPos( sX, sY )
                write( subinput() )
            end
        elseif event == 'key' then
            if key == 28 then
                return input
            elseif key == 14 then
                input = string.sub( input, 1, #input - 1 )
                paintutils.drawLine( sX, sY, eX, sY, backColor )
                term.setCursorPos( sX, sY )
                write( subinput() )
            end
        end
    end
end

function prandomstr( length )
    if length < 1 then return nil end

    local str = ''

    for i = 1, length do
        rand = math.random( 32, 126 )
        str = str .. string.char( rand )
    end

    return str
end

function psplit( str, sep )
    if sep == nil then sep = "%s" end

    local t, i = {}, 1
    for str in string.gmatch( str, "([^" .. sep .. "]+)" ) do
        t[i] = str i = i + 1
    end

    return t
end

function ploadtable( path )
    local file = fs.open( path, 'r' )
    local tablestr = file.readAll()
    file.close()
    return textutils.unserialize( tablestr )
end

function psavetable( table, path )
    local file = fs.open( path, 'w')
    file.write( textutils.serialize( table ) )
    file.close()
end
