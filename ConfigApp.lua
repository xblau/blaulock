-- ==============================================
-- = ScreenLock Config Tool -> (c) BlauDev 2015 =
-- ==============================================

local tArgs = {...} local _Version = "1.0"
local _SLockDir = "/.ScreenLock/"

local _DefaultIM = 5

local function PrintUsage()
	print("Usages:")
	print("slock-config add <name> [-p <pwd>] [-m <im>]")
	print("slock-config del <name>")
	print("slock-config status <enable | disable>")
	print("slock-config list")
	print("slock-config uninstall")
end

local function GenHash(a)
	local b=2^32;local c=b-1;local function d(e)local mt={}local f=setmetatable({},mt)
	function mt:__index(g)local h=e(g)f[g]=h;return h end;return f end;local function 
	i(f,j)local function k(l,m)local o,p=0,1;while l~=0 and m~=0 do local q,r=l%j,m%j;
	o=o+f[q][r]*p;l=(l-q)/j;m=(m-r)/j;p=p*j end;o=o+(l+m)*p;return o end;return k end;
	local function s(f)local t=i(f,2^1)local u=d(function(l)return d(function(m)return 
	t(l,m)end)end)return i(u,2^f.n or 1)end;local v=s({[0]={[0]=0,[1]=1},[1]={[0]=1,
	[1]=0},n=4})local function w(l,m,x,...)local y=nil;if m then l=l%b;m=m%b;y=v(l,m)if 
	x then y=w(y,x,...)end;return y elseif l then return l%b else return 0 end end;local
	function z(l,m,x,...)local y;if m then l=l%b;m=m%b;y=(l+m-v(l,m))/2;if x then 
	y=bit32_band(y,x,...)end;return y elseif l then return l%b else return c end end;
	local function A(B)return(-1-B)%b end;local function C(l,D)if D<0 then return lshift(l,-D)
	end;return math.floor(l%2^32/2^D)end;local function E(B,D)if D>31 or D<-31 then return 
	0 end;return C(B%b,D)end;local function lshift(l,D)if D<0 then return E(l,-D)end;return 
	l*2^D%2^32 end;local function F(B,D)B=B%b;D=D%32;local G=z(B,2^D-1)return E(B,D)+
	lshift(G,32-D)end;local g={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,
	0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,
	0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,
	0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,
	0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,
	0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,
	0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,
	0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,
	0xa4506ceb,0xbef9a3f7,0xc67178f2}local function H(I)return string.gsub(I,".",function(x)
	return string.format("%02x",string.byte(x))end)end;local function J(K,n)local I=""for L=1,
	n do local M=K%256;I=string.char(M)..I;K=(K-M)/256 end;return I end;local function N(I,L)
	local n=0;for L=L,L+3 do n=n*256+string.byte(I,L)end;return n end;local function O(P,Q)
	local R=64-(Q+9)%64;Q=J(8*Q,8)P=P.."\128"..string.rep("\0",R)..Q;assert(#P%64==0)return P end
	;local function S(T)T[1]=0x6a09e667;T[2]=0xbb67ae85;T[3]=0x3c6ef372;T[4]=0xa54ff53a;
	T[5]=0x510e527f;T[6]=0x9b05688c;T[7]=0x1f83d9ab;T[8]=0x5be0cd19;return T end;local function 
	U(P,L,T)local V={}for W=1,16 do V[W]=N(P,L+(W-1)*4)end;for W=17,64 do local h=V[W-15]local 
	X=w(F(h,7),F(h,18),E(h,3))h=V[W-2]V[W]=V[W-16]+X+V[W-7]+w(F(h,17),F(h,19),E(h,10))end;
	local l,m,x,Y,Z,e,_,a0=T[1],T[2],T[3],T[4],T[5],T[6],T[7],T[8]for L=1,64 do local X=w(F(l,2),
	F(l,13),F(l,22))local a1=w(z(l,m),z(l,x),z(m,x))local a2=X+a1;local a3=w(F(Z,6),F(Z,11),F(Z,25))
	local a4=w(z(Z,e),z(A(Z),_))local a5=a0+a3+a4+g[L]+V[L]a0,_,e,Z,Y,x,m,l=_,e,Z,Y+a5,x,m,l,a5+a2 end;
	T[1]=z(T[1]+l)T[2]=z(T[2]+m)T[3]=z(T[3]+x)T[4]=z(T[4]+Y)T[5]=z(T[5]+Z)T[6]=z(T[6]+e)T[7]=z(T[7]+_)T[8]=z(T[8]+a0)
	end;local function a6(P)P=O(P,#P)local T=S({})for L=1,#P,64 do U(P,L,T)end;return H(J(T[1],4)..J(T[2],4)..J(T[3],4)..
	J(T[4],4)..J(T[5],4)..J(T[6],4)..J(T[7],4)..J(T[8],4))end;return a6(a)
end

local ExistingUsers = SLockAPI.loadTable(_SLockDir .. "/Users.dat")

if tArgs[1] == "add" and #tArgs >= 3 then
	if ExistingUsers[tArgs[2]] ~= nil then
		error("Specified user already exists")
	elseif #tArgs[2] < 1 or #tArgs[2] > 10 or tArgs[2] == "-p" or tArgs[2] == "-m" or tArgs[2] == "Config" then
		error("Invalid username")
	else
		local NewUser = {}
		for i = 1, #tArgs do
			if tArgs[i] == "-p" and tArgs[i + 1] ~= nil then
				NewUser["_Pass"] = tArgs[i + 1]
			elseif tArgs[i] == "-m" and tArgs[i + 1] ~= nil then
				NewUser["_IM"] = tonumber(tArgs[i + 1])
			end
		end
		if not NewUser["_Pass"] then
			print("Enter new password for " .. tArgs[2] .. ":") local Input1 = read("*")
			print("Confirm new password:") local Input2 = read("*")
			if Input1 == Input2 then NewUser["_Pass"] = Input1 else error("Passwords don't match") end
		end
		if not NewUser["_IM"] then NewUser["_IM"] = _DefaultIM end
		if not NewUser["_Salt"] then NewUser["_Salt"] = SLockAPI.randomString(25) end
		local TempHash = GenHash(NewUser["_Salt"] .. NewUser["_Pass"])
		for i = 1, NewUser["_IM"] do TempHash = GenHash(NewUser["_Salt"] .. TempHash) sleep(0) end
		FinalUser = {} FinalUser["IM"] = NewUser["_IM"] FinalUser["Salt"] = NewUser["_Salt"] FinalUser["Hash"] = TempHash
		ExistingUsers[tArgs[2]] = FinalUser SLockAPI.saveTable(ExistingUsers, _SLockDir .. "/Users.dat")
		print("New user " .. tArgs[2] .. " added successfully.")
	end
elseif tArgs[1] == "del" and tArgs[2] ~= nil then
	if ExistingUsers[tArgs[2]] ~= nil then
		ExistingUsers[tArgs[2]] = nil
		SLockAPI.saveTable(ExistingUsers, _SLockDir .. "/Users.dat")
		print("User " .. tArgs[2] .. " removed successfully.")
	else
		error("Specified user not exists")
	end
elseif tArgs[1] == "list" then
	local _ini = 1
	for k, _ in pairs(ExistingUsers) do
		if k ~= "Config" then print("[#" .. _ini .. "] " .. k) _ini = _ini + 1 end
	end
elseif tArgs[1] == "uninstall" then
	if tArgs[2] ~= "-s" then
		if term.isColor() then term.setTextColor(colors.red) end
		print("[CAUTION] Uninstall SLock?")
		term.setTextColor(colors.white)
		write("(S/N) > ") local _Sel = read()
		if _Sel ~= "S" then error("Aborted") end
	end
	print("Unloading APIs...") sleep(0.1)
	local tAPI = fs.list(_SLockDir .. "/APIs/")
	for i = 1, #tAPI do
		os.unloadAPI(_SLockDir .. "/APIs/" .. tAPI[i]) sleep(0.1)
	end
	print("Listing files...") sleep(0.1)
	local _tFiles = listAll(_SLockDir)
	for i = 1, #_tFiles do
		print("Deleting file: " .. _tFiles[i]) sleep(0.1)
		fs.delete(_tFiles[i])
	end
	print("Checking startup file...") sleep(0.1)
	if fs.exists("/startup") then
		local f = fs.open("/startup", "r")
		local _Content = f.readAll() f.close()
		local _Command = _SLockDir .. "SLock.lua"
		_Command = "shell.run('" .. _Command .. "')"
		if _Content == _Command then
			print("Startup file detected as link.") sleep(0.1)
			fs.delete("/startup")
			print("Startup file deleted. Rebooting now...") sleep(2)
			os.reboot()
		else
			print("Detected custom startup file. Repairing...")
			local _NewContent = string.gsub(_Content, _Command, "")
			local f = fs.open("/startup", "w") f.write(_NewContent) f.close()
			print("Startup file repaired. Rebooting now...") sleep(2)
			os.reboot()
		end
	else
		print("Startup file not found. Rebooting now...") sleep(2)
		os.reboot()
	end
elseif tArgs[1] == "status" and tArgs[2] ~= nil then
	if tArgs[2] == "enable" then
		if ExistingUsers["Config"]["EnableProtection"] then
			print("ScreenLock is already enabled")
		else
			ExistingUsers["Config"]["EnableProtection"] = true
			SLockAPI.saveTable(ExistingUsers, _SLockDir .. "Users.dat")
			print("ScreenLock has been enabled")
		end
	elseif tArgs[2] == "disable" then
		if ExistingUsers["Config"]["EnableProtection"] then
			ExistingUsers["Config"]["EnableProtection"] = false
			SLockAPI.saveTable(ExistingUsers, _SLockDir .. "Users.dat")
			print("ScreenLock has been disabled")
		else
			print("ScreenLock is already disabled")
		end
	else PrintUsage() end
else PrintUsage() end