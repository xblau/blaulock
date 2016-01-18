-- ==================================
-- = ScreenLock -> (c) BlauDev 2015 =
-- ==================================
-- =                                =
-- =  This program only runs under  =
-- =         ComputerCraft          =
-- =                                =
-- ==================================

local _Version = "1.0"
local _SLockDir = "/.ScreenLock/"
local Current, _Input, _Locked = {}, {}, true
local OldPullEvent = os.pullEvent
os.pullEvent = os.pullEventRaw

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

local function checkClick(cX, cY, sX, sY, eX, eY, lock)
	local lock = lock or false
	if not lock then
		cX = cX or 0 cY = cY or 0 -- [[ Fix CRTL+T protection fail ]]
		if cX >= sX and cX <= eX then fir = true else fir = false end
		if cY >= sY and cY <= eY then sec = true else sec = false end
		if fir and sec then return true else return false end
	else return false end
end

local UsersTable = SLockAPI.loadTable(_SLockDir .. "/Users.dat")
local _Attempts = UsersTable["Config"]["Remaining"] or 2

local function Verify(_Password, _User)
	local _User = UsersTable[_User]
	local TempHash = GenHash(_User["Salt"] .. _Password)
	for i = 1, _User["IM"] do
		TempHash = GenHash(_User["Salt"] .. TempHash) sleep(0)
	end
	if TempHash == _User["Hash"] then return true 
	else return false end
end

if UsersTable["Config"]["EnableLock"] then
	if UsersTable["Config"]["Locked"] then
		if fs.exists(_SLockDir .. "lock.lua") then
			shell.run("lock.lua")
		end
		Current["ButtonColor"] = colors.gray
	else Current["ButtonColor"] = colors.green end
else Current["ButtonColor"] = colors.green end

paintutils.drawFilledBox(1, 1, 51, 3, colors.blue)
paintutils.drawFilledBox(1, 4, 10, 19, colors.lightBlue)
paintutils.drawFilledBox(10, 4, 42, 19, colors.white)
paintutils.drawFilledBox(43, 4, 51, 19, colors.lightBlue)
SLockAPI.printTxt("[ ScreenLock v" .. _Version .. " ]", "centrated", 2, colors.white, colors.blue)
SLockAPI.printTxt("Username:", 18, 7, colors.gray, colors.white)
paintutils.drawLine(18, 8, 35, 8, colors.lightBlue)
SLockAPI.printTxt("Password:", 18, 10, colors.gray, colors.white)
paintutils.drawLine(18, 11, 35, 11, colors.lightBlue)
paintutils.drawFilledBox(18, 13, 35, 15, Current["ButtonColor"])
SLockAPI.printTxt("Unlock", "centrated", 14, colors.white, Current["ButtonColor"])

while _Locked do
	if UsersTable["Config"]["EnableLock"] then
		if UsersTable["Config"]["Locked"] then
			SLockAPI.printTxt("This computer is locked", 11, 19, colors.red, colors.white)
			paintutils.drawFilledBox(18, 13, 35, 15, colors.gray)
			SLockAPI.printTxt("Unlock", "centrated", 14, colors.white, colors.gray)
		else	
			paintutils.drawLine(10, 18, 42, 19, colors.white)
			if _Attempts == 5 then
				Current["AttColor"] = colors.green
			elseif _Attempts > 3 then
				Current["AttColor"] = colors.orange
			else Current["AttColor"] = colors.red end
			SLockAPI.printTxt("Remaining: " .. _Attempts, 11, 19, Current["AttColor"], colors.white)
		end
	end
	local event, button, cX, cY = os.pullEvent("mouse_click")
	if checkClick(cX, cY, 18, 8, 35, 8, UsersTable["Config"]["Locked"]) then
		_Input["User"] = SLockAPI.readInput(18, 8, 35, colors.cyan, colors.lightBlue)
		if UsersTable[_Input["User"]] == nil then
			paintutils.drawPixel(35, 8, colors.red)
		else
			paintutils.drawPixel(35, 8, colors.green)
		end
	elseif checkClick(cX, cY, 18, 11, 35, 11, UsersTable["Config"]["Locked"]) then
		_Input["Pass"] = SLockAPI.readInput(18, 11, 35, colors.cyan, colors.lightBlue, "*")
	elseif checkClick(cX, cY, 18, 13, 35, 15, UsersTable["Config"]["Locked"]) then
		if _Input["User"] == nil or UsersTable[_Input["User"]] == nil then
			SLockAPI.printTxt("Username:", 18, 7, colors.red, colors.white) sleep(1)
			SLockAPI.printTxt("Username:", 18, 7, colors.gray, colors.white)
			paintutils.drawLine(18, 11, 35, 11, colors.lightBlue)
			_Input["Pass"] = nil
		elseif _Input["Pass"] == nil then
			SLockAPI.printTxt("Password:", 18, 10, colors.red, colors.white) sleep(1)
			SLockAPI.printTxt("Password:", 18, 10, colors.gray, colors.white)
		else
			if Verify(_Input["Pass"], _Input["User"]) then
				os.pullEvent = OldPullEvent
				if UsersTable["Config"]["EnableLock"] then
					UsersTable["Config"]["Remaining"] = UsersTable["Config"]["DefaultAttempts"]
					SLockAPI.saveTable(UsersTable, _SLockDir .. "/Users.dat")
				end
				SLockAPI.printTxt("Access granted", 20, 17, colors.green, colors.white) sleep(1)
				_Locked = false
			else
				_Input["User"], _Input["Pass"] = nil, nil
				SLockAPI.printTxt("Access denied", 21, 17, colors.red, colors.white)
				if UsersTable["Config"]["EnableLock"] then
					if _Attempts > 1 then
						_Attempts = _Attempts - 1
						UsersTable["Config"]["Remaining"] = _Attempts SLockAPI.saveTable(UsersTable, _SLockDir .. "/Users.dat")
					else UsersTable["Config"]["Locked"] = true SLockAPI.saveTable(UsersTable, _SLockDir .. "/Users.dat") end
				end sleep(2)
				paintutils.drawLine(10, 17, 42, 17, colors.white)
				paintutils.drawLine(18, 8, 35, 8, colors.lightBlue)
				paintutils.drawLine(18, 11, 35, 11, colors.lightBlue)
			end
		end
	end
end

if UsersTable["Config"]["Locked"] then os.shutdown() end