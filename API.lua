-----------------------------------------
-- ScreenLock Shared API - (c) BlauDev --
-----------------------------------------

function printTxt(text, X, Y, textColor, backColor)
	if X == "centrated" then
		local w, h = term.getSize()
		X = math.ceil(math.ceil((w / 2) - (#text / 2)), 0)+1
	end
	term.setCursorPos(X, Y)
	term.setTextColor(textColor)
	term.setBackgroundColor(backColor)
	write(text)
end

function readInput(sX, sY, eX, textColor, backColor, showChar)
	local showChar = showChar or nil
	local sBar = "" local iDif = eX - sX
	for i = 1, iDif do sBar = sBar .. "-" end
	term.setCursorPos(sX, sY) term.setTextColor(backColor)
	term.setBackgroundColor(backColor) write(sBar)
	term.setCursorPos(sX, sY) term.setTextColor(textColor) 
	local _input = read(showChar) return _input
end

function saveTable(table, path)
	local file = fs.open(path,"w")
	file.write(textutils.serialize(table))
	file.close()
end

function loadTable(path)
	local file = fs.open(path,"r")
	local data = file.readAll()
	file.close()
	return textutils.unserialize(data)
end

function listAll(_path, _files)
	local path = _path or ""
	local files = _files or {}
	if #path > 1 then table.insert(files, path) end
	for _, file in ipairs(fs.list(path)) do
		local path = fs.combine(path, file)
		if fs.isDir(path) then listAll(path, files)
		else table.insert(files, path) end
	end return files
end

function randomString(l)
    if l < 1 then return nil end
    local s = ""
    for i = 1, l do
        n = math.random(32, 126)
        if n == 96 then n = math.random(32, 95) end
        s = s .. string.char(n)
    end return s
end

function findStr(str, pat)
	local result = string.find(str, pat)
	if result == nil then return false
	else return true end
end