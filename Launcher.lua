-- =====================================
-- = ScreenLock Launcher - (c) BlauDev =
-- =====================================

local _LauncherVersion = "1.0"
local _SLockDir = "/.ScreenLock/"

os.loadAPI(_SLockDir .. "SLockAPI")

local UsersDAT = SLockAPI.loadTable(_SLockDir .. "Users.dat")
shell.setAlias("slock-config", _SLockDir .. "Slock-Config.lua")

if UsersDAT["Config"]["EnableProtection"] then
	shell.run(_SLockDir .. "SLock.lua")
	term.setBackgroundColor(colors.black) term.clear()
	term.setCursorPos(1, 1) term.setTextColor(colors.yellow)
	print(os.version()) term.setTextColor(colors.white)
	if fs.exists("/.autorun") then
		shell.run("/.autorun")
	end
else
	if fs.exists("/.autorun") then
		shell.run("/.autorun")
	end
end

if fs.exists("/.startup") then shell.run("/startup") end