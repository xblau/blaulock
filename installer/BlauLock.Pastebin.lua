--[[

    This file is part of BlauLock, a ComputerCraft program
    that adds password protection on startup.

    Author: Daniel 'Blaudev' Mosquera <daniel@blaudev.es>
    Repository: https://github.com/blaudev/BlauLock

    THIS FILE IS DISTRIBUTED UNDER THE TERMS OF THE MIT LICENSE

]]

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

if not http then
    error( 'HTTP API not found!' )
end

local InstallerLink, InstallerPath = nil, '/.BlauLockInstaller'

InstallerLink = 'https://raw.githubusercontent.com/blaudev/BlauLock/master/installer/BlauLock.BasicInstaller.lua'

print( 'Downloading installer...' )
local result = download(InstallerLink, InstallerPath)

if not result then
    error('Something went wrong! :(')
end

shell.run(InstallerPath)
fs.delete(InstallerPath)
