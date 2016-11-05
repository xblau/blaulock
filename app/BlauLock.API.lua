--[[

    This file is part of BlauLock, a ComputerCraft program
    that adds password protection on startup.
    
    Author: Daniel 'Blaudev' Mosquera <daniel@blaudev.es>
    Repository: https://github.com/blaudev/BlauLock
    
    THIS FILE IS DISTRIBUTED UNDER THE TERMS OF THE MIT LICENSE

]]

local BlauLock = {}

function BlauLock.inject( target, exe )
	local f = fs.open( target, 'r' )
	local content = f.readAll()
	f.close()
	
	local launcher = "shell.run('" .. exe .. "')\n"
	
	local f = fs.open( target, 'w' )
	f.write( launcher .. content )
	f.close()	
end

function BlauLock.GenerateHash( algo, password, pim, salt )
    local hash = ''
    
    local pim = pim or 5
    local salt = salt or prandomstr( 20 )
    salt = salt:gsub( '%$', '&' )
    
    if algo == 'SHA256' then
        hash = '$SHA2$'
        GenHash = BlauLock.SHA256
    end
    
    hash = hash .. tostring( pim ) .. '$' .. salt .. '$'
    
    local temphash = GenHash( salt .. password )
    for i = 1, pim do
        temphash = GenHash( salt .. temphash )
    end
    
    return hash .. temphash
end

function BlauLock.VerifyHash( password, hash )
    local hash = psplit( hash, '$' )
    
    if hash[1] == 'SHA2' then
        GenHash = BlauLock.SHA256
        
        if #hash ~= 4 then return false end
        
        local temphash = GenHash( hash[3] .. password )
        for i = 1, tonumber( hash[2] ) do
            temphash = GenHash( hash[3] .. temphash )
        end
        
        return ( temphash == hash[4] )
    else
        return false
    end
end

function BlauLock.SHA256( str )
    -- GravityScore's SHA256 implementation
    -- Minified from original: http://pastebin.com/raw/gsFrNjbt
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
    J(T[4],4)..J(T[5],4)..J(T[6],4)..J(T[7],4)..J(T[8],4))end;return a6(str)
end

return BlauLock
