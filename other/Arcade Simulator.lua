local a = 2 ^ 32
local b = a - 1
local function c(d, e)
	local f, g = 0, 1
	while d ~= 0 or e ~= 0 do
		local h, i = d % 2, e % 2
		local j = (h + i) % 2
		f = f + j * g
		d = math.floor(d / 2)
		e = math.floor(e / 2)
		g = g * 2
	end
	return f % a
end

local function k(d, e, l, ...)
	local m
	if e then
		d = d % a
		e = e % a
		m = c(d, e)
		if l then
			m = k(m, l, ...)
		end
		return m
	elseif d then
		return d % a
	else
		return 0
	end
end
local function n(d, e, l, ...)
	local m
	if e then
		d = d % a
		e = e % a
		m = (d + e - c(d, e)) / 2
		if l then
			m = n(m, l, ...)
		end
		return m
	elseif d then
		return d % a
	else
		return b
	end
end
local function o(p)
	return b - p
end
local function q(d, r)
	if r < 0 then
		return lshift(d, -r)
	end
	return math.floor(d % 2 ^ 32 / 2 ^ r)
end
local function s(p, r)
	if r > 31 or r < -31 then
		return 0
	end
	return q(p % a, r)
end
local function lshift(d, r)
	if r < 0 then
		return s(d, -r)
	end
	return d * 2 ^ r % 2 ^ 32
end
local function t(p, r)
	p = p % a
	r = r % 32
	local u = n(p, 2 ^ r - 1)
	return s(p, r) + lshift(u, 32 - r)
end
local v = {
	0x428a2f98,
	0x71374491,
	0xb5c0fbcf,
	0xe9b5dba5,
	0x3956c25b,
	0x59f111f1,
	0x923f82a4,
	0xab1c5ed5,
	0xd807aa98,
	0x12835b01,
	0x243185be,
	0x550c7dc3,
	0x72be5d74,
	0x80deb1fe,
	0x9bdc06a7,
	0xc19bf174,
	0xe49b69c1,
	0xefbe4786,
	0x0fc19dc6,
	0x240ca1cc,
	0x2de92c6f,
	0x4a7484aa,
	0x5cb0a9dc,
	0x76f988da,
	0x983e5152,
	0xa831c66d,
	0xb00327c8,
	0xbf597fc7,
	0xc6e00bf3,
	0xd5a79147,
	0x06ca6351,
	0x14292967,
	0x27b70a85,
	0x2e1b2138,
	0x4d2c6dfc,
	0x53380d13,
	0x650a7354,
	0x766a0abb,
	0x81c2c92e,
	0x92722c85,
	0xa2bfe8a1,
	0xa81a664b,
	0xc24b8b70,
	0xc76c51a3,
	0xd192e819,
	0xd6990624,
	0xf40e3585,
	0x106aa070,
	0x19a4c116,
	0x1e376c08,
	0x2748774c,
	0x34b0bcb5,
	0x391c0cb3,
	0x4ed8aa4a,
	0x5b9cca4f,
	0x682e6ff3,
	0x748f82ee,
	0x78a5636f,
	0x84c87814,
	0x8cc70208,
	0x90befffa,
	0xa4506ceb,
	0xbef9a3f7,
	0xc67178f2,
}
local function w(x)
	return string.gsub(x, ".", function(l)
		return string.format("%02x", string.byte(l))
	end)
end
local function y(z, A)
	local x = ""
	for B = 1, A do
		local C = z % 256
		x = string.char(C) .. x
		z = (z - C) / 256
	end
	return x
end
local function D(x, B)
	local A = 0
	for B = B, B + 3 do
		A = A * 256 + string.byte(x, B)
	end
	return A
end
local function E(F, G)
	local H = 64 - (G + 9) % 64
	G = y(8 * G, 8)
	F = F .. "\128" .. string.rep("\0", H) .. G
	assert(#F % 64 == 0)
	return F
end
local function I(J)
	J[1] = 0x6a09e667
	J[2] = 0xbb67ae85
	J[3] = 0x3c6ef372
	J[4] = 0xa54ff53a
	J[5] = 0x510e527f
	J[6] = 0x9b05688c
	J[7] = 0x1f83d9ab
	J[8] = 0x5be0cd19
	return J
end
local function K(F, B, J)
	local L = {}
	for M = 1, 16 do
		L[M] = D(F, B + (M - 1) * 4)
	end
	for M = 17, 64 do
		local N = L[M - 15]
		local O = k(t(N, 7), t(N, 18), s(N, 3))
		N = L[M - 2]
		L[M] = (L[M - 16] + O + L[M - 7] + k(t(N, 17), t(N, 19), s(N, 10))) % a
	end
	local d, e, l, P, Q, R, S, T = J[1], J[2], J[3], J[4], J[5], J[6], J[7], J[8]
	for B = 1, 64 do
		local O = k(t(d, 2), t(d, 13), t(d, 22))
		local U = k(n(d, e), n(d, l), n(e, l))
		local V = (O + U) % a
		local W = k(t(Q, 6), t(Q, 11), t(Q, 25))
		local X = k(n(Q, R), n(o(Q), S))
		local Y = (T + W + X + v[B] + L[B]) % a
		T = S
		S = R
		R = Q
		Q = (P + Y) % a
		P = l
		l = e
		e = d
		d = (Y + V) % a
	end
	J[1] = (J[1] + d) % a
	J[2] = (J[2] + e) % a
	J[3] = (J[3] + l) % a
	J[4] = (J[4] + P) % a
	J[5] = (J[5] + Q) % a
	J[6] = (J[6] + R) % a
	J[7] = (J[7] + S) % a
	J[8] = (J[8] + T) % a
end
local function Z(F)
	F = E(F, #F)
	local J = I({})
	for B = 1, #F, 64 do
		K(F, B, J)
	end
	return w(
		y(J[1], 4) .. y(J[2], 4) .. y(J[3], 4) .. y(J[4], 4) .. y(J[5], 4) .. y(J[6], 4) .. y(J[7], 4) .. y(J[8], 4)
	)
end
local e
local l = { ["\\"] = "\\", ['"'] = '"', ["\b"] = "b", ["\f"] = "f", ["\n"] = "n", ["\r"] = "r", ["\t"] = "t" }
local P = { ["/"] = "/" }
for Q, R in pairs(l) do
	P[R] = Q
end
local S = function(T)
	return "\\" .. (l[T] or string.format("u%04x", T:byte()))
end
local B = function(M)
	return "null"
end
local v = function(M, z)
	local _ = {}
	z = z or {}
	if z[M] then
		error("circular reference")
	end
	z[M] = true
	if rawget(M, 1) ~= nil or next(M) == nil then
		local A = 0
		for Q in pairs(M) do
			if type(Q) ~= "number" then
				error("invalid table: mixed or invalid key types")
			end
			A = A + 1
		end
		if A ~= #M then
			error("invalid table: sparse array")
		end
		for a0, R in ipairs(M) do
			table.insert(_, e(R, z))
		end
		z[M] = nil
		return "[" .. table.concat(_, ",") .. "]"
	else
		for Q, R in pairs(M) do
			if type(Q) ~= "string" then
				error("invalid table: mixed or invalid key types")
			end
			table.insert(_, e(Q, z) .. ":" .. e(R, z))
		end
		z[M] = nil
		return "{" .. table.concat(_, ",") .. "}"
	end
end
local g = function(M)
	return '"' .. M:gsub('[%z\1-\31\\"]', S) .. '"'
end
local a1 = function(M)
	if M ~= M or M <= -math.huge or M >= math.huge then
		error("unexpected number value '" .. tostring(M) .. "'")
	end
	return string.format("%.14g", M)
end
local j = { ["nil"] = B, ["table"] = v, ["string"] = g, ["number"] = a1, ["boolean"] = tostring }
e = function(M, z)
	local x = type(M)
	local a2 = j[x]
	if a2 then
		return a2(M, z)
	end
	error("unexpected type '" .. x .. "'")
end
local a3 = function(M)
	return e(M)
end
local a4
local N = function(...)
	local _ = {}
	for a0 = 1, select("#", ...) do
		_[select(a0, ...)] = true
	end
	return _
end
local L = N(" ", "\t", "\r", "\n")
local p = N(" ", "\t", "\r", "\n", "]", "}", ",")
local a5 = N("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local m = N("true", "false", "null")
local a6 = { ["true"] = true, ["false"] = false, ["null"] = nil }
local a7 = function(a8, a9, aa, ab)
	for a0 = a9, #a8 do
		if aa[a8:sub(a0, a0)] ~= ab then
			return a0
		end
	end
	return #a8 + 1
end
local ac = function(a8, a9, J)
	local ad = 1
	local ae = 1
	for a0 = 1, a9 - 1 do
		ae = ae + 1
		if a8:sub(a0, a0) == "\n" then
			ad = ad + 1
			ae = 1
		end
	end
	error(string.format("%s at line %d col %d", J, ad, ae))
end
local af = function(A)
	local a2 = math.floor
	if A <= 0x7f then
		return string.char(A)
	elseif A <= 0x7ff then
		return string.char(a2(A / 64) + 192, A % 64 + 128)
	elseif A <= 0xffff then
		return string.char(a2(A / 4096) + 224, a2(A % 4096 / 64) + 128, A % 64 + 128)
	elseif A <= 0x10ffff then
		return string.char(a2(A / 262144) + 240, a2(A % 262144 / 4096) + 128, a2(A % 4096 / 64) + 128, A % 64 + 128)
	end
	error(string.format("invalid unicode codepoint '%x'", A))
end
local ag = function(ah)
	local ai = tonumber(ah:sub(1, 4), 16)
	local aj = tonumber(ah:sub(7, 10), 16)
	if aj then
		return af((ai - 0xd800) * 0x400 + aj - 0xdc00 + 0x10000)
	else
		return af(ai)
	end
end
local ak = function(a8, a0)
	local _ = ""
	local al = a0 + 1
	local Q = al
	while al <= #a8 do
		local am = a8:byte(al)
		if am < 32 then
			ac(a8, al, "control character in string")
		elseif am == 92 then
			_ = _ .. a8:sub(Q, al - 1)
			al = al + 1
			local T = a8:sub(al, al)
			if T == "u" then
				local an = a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", al + 1)
					or a8:match("^%x%x%x%x", al + 1)
					or ac(a8, al - 1, "invalid unicode escape in string")
				_ = _ .. ag(an)
				al = al + #an
			else
				if not a5[T] then
					ac(a8, al - 1, "invalid escape char '" .. T .. "' in string")
				end
				_ = _ .. P[T]
			end
			Q = al + 1
		elseif am == 34 then
			_ = _ .. a8:sub(Q, al - 1)
			return _, al + 1
		end
		al = al + 1
	end
	ac(a8, a0, "expected closing quote for string")
end
local ao = function(a8, a0)
	local am = a7(a8, a0, p)
	local ah = a8:sub(a0, am - 1)
	local A = tonumber(ah)
	if not A then
		ac(a8, a0, "invalid number '" .. ah .. "'")
	end
	return A, am
end
local ap = function(a8, a0)
	local am = a7(a8, a0, p)
	local aq = a8:sub(a0, am - 1)
	if not m[aq] then
		ac(a8, a0, "invalid literal '" .. aq .. "'")
	end
	return a6[aq], am
end
local ar = function(a8, a0)
	local _ = {}
	local A = 1
	a0 = a0 + 1
	while 1 do
		local am
		a0 = a7(a8, a0, L, true)
		if a8:sub(a0, a0) == "]" then
			a0 = a0 + 1
			break
		end
		am, a0 = a4(a8, a0)
		_[A] = am
		A = A + 1
		a0 = a7(a8, a0, L, true)
		local as = a8:sub(a0, a0)
		a0 = a0 + 1
		if as == "]" then
			break
		end
		if as ~= "," then
			ac(a8, a0, "expected ']' or ','")
		end
	end
	return _, a0
end
local at = function(a8, a0)
	local _ = {}
	a0 = a0 + 1
	while 1 do
		local au, M
		a0 = a7(a8, a0, L, true)
		if a8:sub(a0, a0) == "}" then
			a0 = a0 + 1
			break
		end
		if a8:sub(a0, a0) ~= '"' then
			ac(a8, a0, "expected string for key")
		end
		au, a0 = a4(a8, a0)
		a0 = a7(a8, a0, L, true)
		if a8:sub(a0, a0) ~= ":" then
			ac(a8, a0, "expected ':' after key")
		end
		a0 = a7(a8, a0 + 1, L, true)
		M, a0 = a4(a8, a0)
		_[au] = M
		a0 = a7(a8, a0, L, true)
		local as = a8:sub(a0, a0)
		a0 = a0 + 1
		if as == "}" then
			break
		end
		if as ~= "," then
			ac(a8, a0, "expected '}' or ','")
		end
	end
	return _, a0
end

local av = {
	['"'] = ak,
	["0"] = ao,
	["1"] = ao,
	["2"] = ao,
	["3"] = ao,
	["4"] = ao,
	["5"] = ao,
	["6"] = ao,
	["7"] = ao,
	["8"] = ao,
	["9"] = ao,
	["-"] = ao,
	["t"] = ap,
	["f"] = ap,
	["n"] = ap,
	["["] = ar,
	["{"] = at,
}
a4 = function(a8, a9)
	local as = a8:sub(a9, a9)
	local a2 = av[as]
	if a2 then
		return a2(a8, a9)
	end
	ac(a8, a9, "unexpected character '" .. as .. "'")
end
local aw = function(a8)
	if type(a8) ~= "string" then
		error("expected argument of type string, got " .. type(a8))
	end
	local _, a9 = a4(a8, a7(a8, 1, L, true))
	a9 = a7(a8, a9, L, true)
	if a9 <= #a8 then
		ac(a8, a9, "trailing garbage")
	end
	return _
end
local lEncode, lDecode, lDigest = a3, aw, Z

local function ds(a)
	if type(a) ~= "table" then
		return ""
	end

	local r = ""
	for i = 1, #a do
		local v = a[i]
		if type(v) == "table" then
			r = r .. ds(v)
		elseif type(v) == "number" then
			r = r .. string.char(v)
		else
		end
	end
	return r
end

local function giohohgiouasd()
	local p1 = { 0x36, 0x61, 0x34, 0x34, 0x33, 0x31, 0x67, 0x36 }
	local p2 = { 0x78, 0x31, 0x62, 0x30, 0x64, 0x78 }
	local p3 = { 0x61, 0x61, 0x60, 0x63, 0x78, 0x6C, 0x6C, 0x62, 0x6C }
	local p4 = { 0x78, 0x37, 0x30, 0x65, 0x61, 0x36, 0x65, 0x65, 0x67, 0x30, 0x61, 0x33, 0x31 }

	local ncghjg = { p1, p2, p3, p4 }

	local parts = {}
	for i = 1, #ncghjg do
		local part = {}
		for j = 1, #ncghjg[i] do
			table.insert(part, bit32.bxor(ncghjg[i][j], 0x55))
		end
		table.insert(parts, part)
	end

	local result = ""
	for i = 1, #parts do
		result = result .. ds(parts[i])
	end

	return result
end

local service = 2931
local secret = giohohgiouasd()
local useNonce = true

local onMessage = function(message) end

repeat
	task.wait(1)
until game:IsLoaded()

local requestSending = false
local fSetClipboard, fRequest, fStringChar, fToString, fStringSub, fOsTime, fMathRandom, fMathFloor, fGetHwid =
	setclipboard or toclipboard,
	request or http_request or syn_request,
	string.char,
	tostring,
	string.sub,
	os.time,
	math.random,
	math.floor,
	gethwid or function()
		return game:GetService("Players").LocalPlayer.UserId
	end
local cachedLink, cachedTime = "", 0

local host = "https://api.platoboost.com"
local hostResponse = fRequest({
	Url = host .. "/public/connectivity",
	Method = "GET",
})
if hostResponse.StatusCode ~= 200 or hostResponse.StatusCode ~= 429 then
	host = "https://api.platoboost.net"
end

function cacheLink()
	if cachedTime + (10 * 60) < fOsTime() then
		local hwid = tostring(fGetHwid())
		local response = fRequest({
			Url = host .. "/public/start",
			Method = "POST",
			Body = lEncode({
				service = service,
				identifier = lDigest(tostring(hwid)),
			}),
			Headers = {
				["Content-Type"] = "application/json",
			},
		})

		if response.StatusCode == 200 then
			local decoded = lDecode(response.Body)

			if decoded.success == true then
				cachedLink = decoded.data.url
				cachedTime = fOsTime()
				return true, cachedLink
			else
				onMessage(decoded.message)
				return false, decoded.message
			end
		elseif response.StatusCode == 429 then
			local msg = "you are being rate limited, please wait 20 seconds and try again."
			onMessage(msg)
			return false, msg
		end

		local msg = "Failed to cache link."
		onMessage(msg)
		return false, msg
	else
		return true, cachedLink
	end
end

cacheLink()

local generateNonce = function()
	local str = ""
	for _ = 1, 16 do
		str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97)
	end
	return str
end

for _ = 1, 5 do
	local oNonce = generateNonce()
	task.wait(0.2)
	if generateNonce() == oNonce then
		local msg = "platoboost nonce error."
		onMessage(msg)
		error(msg)
	end
end

local copyLink = function()
	local success, link = cacheLink()

	if success then
		fSetClipboard(link)
	end
end

local redeemKey = function(key)
	local nonce = generateNonce()
	local endpoint = host .. "/public/redeem/" .. fToString(service)

	local body = {
		identifier = lDigest(tostring(fGetHwid())),
		key = key,
	}

	if useNonce then
		body.nonce = nonce
	end

	local response = fRequest({
		Url = endpoint,
		Method = "POST",
		Body = lEncode(body),
		Headers = {
			["Content-Type"] = "application/json",
		},
	})

	if response.StatusCode == 200 then
		local decoded = lDecode(response.Body)

		if decoded.success == true then
			if decoded.data.valid == true then
				if useNonce then
					if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
						return true
					else
						onMessage("failed to verify integrity.")
						return false
					end
				else
					return true
				end
			else
				onMessage("key is invalid.")
				return false
			end
		else
			if fStringSub(decoded.message, 1, 27) == "unique constraint violation" then
				onMessage("you already have an active key, please wait for it to expire before redeeming it.")
				return false
			else
				onMessage(decoded.message)
				return false
			end
		end
	elseif response.StatusCode == 429 then
		onMessage("you are being rate limited, please wait 20 seconds and try again.")
		return false
	else
		onMessage("server returned an invalid status code, please try again later.")
		return false
	end
end

local verifyKey = function(key)
	if requestSending == true then
		onMessage("a request is already being sent, please slow down.")
		return false
	else
		requestSending = true
	end

	local nonce = generateNonce()
	local endpoint = host
		.. "/public/whitelist/"
		.. fToString(service)
		.. "?identifier="
		.. lDigest(tostring(fGetHwid()))
		.. "&key="
		.. key

	if useNonce then
		endpoint = endpoint .. "&nonce=" .. nonce
	end

	local response = fRequest({
		Url = endpoint,
		Method = "GET",
	})

	requestSending = false

	if response.StatusCode == 200 then
		local decoded = lDecode(response.Body)

		if decoded.success == true then
			if decoded.data.valid == true then
				if useNonce then
					if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
						return true
					else
						onMessage("failed to verify integrity.")
						return false
					end
				else
					return true
				end
			else
				if fStringSub(key, 1, 4) == "KEY_" then
					return redeemKey(key)
				else
					onMessage("key is invalid.")
					return false
				end
			end
		else
			onMessage(decoded.message)
			return false
		end
	elseif response.StatusCode == 429 then
		onMessage("you are being rate limited, please wait 20 seconds and try again.")
		return false
	else
		onMessage("server returned an invalid status code, please try again later.")
		return false
	end
end

local getFlag = function(name)
	local nonce = generateNonce()
	local endpoint = host .. "/public/flag/" .. fToString(service) .. "?name=" .. name

	if useNonce then
		endpoint = endpoint .. "&nonce=" .. nonce
	end

	local response = fRequest({
		Url = endpoint,
		Method = "GET",
	})

	if response.StatusCode == 200 then
		local decoded = lDecode(response.Body)

		if decoded.success == true then
			if useNonce then
				if decoded.data.hash == lDigest(fToString(decoded.data.value) .. "-" .. nonce .. "-" .. secret) then
					return decoded.data.value
				else
					onMessage("failed to verify integrity.")
					return nil
				end
			else
				return decoded.data.value
			end
		else
			onMessage(decoded.message)
			return nil
		end
	else
		return nil
	end
end

local Theme = "Black"
local Speed_Library =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/triquqd717/main/refs/heads/main/test/newLib.lua"))()

local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local Themes = {}
Themes["Red"] = {
	Primary = Color3.fromRGB(60, 20, 20),
	Secondary = Color3.fromRGB(90, 40, 40),
	Accent = Color3.fromRGB(220, 60, 60),
	ThemeHighlight = Color3.fromRGB(250, 100, 100),
	Text = Color3.fromRGB(250, 230, 230),
	Background = Color3.fromRGB(20, 5, 5),
	Stroke = Color3.fromRGB(120, 40, 40),
	GradientStart = Color3.fromRGB(45, 25, 25),
	GradientEnd = Color3.fromRGB(50, 25, 25),
}
Themes["Green"] = {
	Primary = Color3.fromRGB(20, 40, 20),
	Secondary = Color3.fromRGB(40, 70, 40),
	Accent = Color3.fromRGB(80, 160, 80),
	ThemeHighlight = Color3.fromRGB(160, 250, 160),
	Text = Color3.fromRGB(230, 250, 230),
	Background = Color3.fromRGB(5, 15, 5),
	Stroke = Color3.fromRGB(40, 80, 40),
	GradientStart = Color3.fromRGB(25, 45, 25),
	GradientEnd = Color3.fromRGB(10, 30, 10),
}
Themes["Blue"] = {
	Primary = Color3.fromRGB(20, 30, 60),
	Secondary = Color3.fromRGB(40, 50, 90),
	Accent = Color3.fromRGB(60, 120, 220),
	ThemeHighlight = Color3.fromRGB(100, 170, 250),
	Text = Color3.fromRGB(230, 240, 250),
	Background = Color3.fromRGB(5, 10, 20),
	Stroke = Color3.fromRGB(40, 60, 120),
	GradientStart = Color3.fromRGB(25, 30, 45),
	GradientEnd = Color3.fromRGB(10, 25, 50),
}
Themes["Purple"] = {
	Primary = Color3.fromRGB(40, 20, 60),
	Secondary = Color3.fromRGB(70, 40, 90),
	Accent = Color3.fromRGB(160, 80, 220),
	ThemeHighlight = Color3.fromRGB(200, 160, 250),
	Text = Color3.fromRGB(240, 230, 250),
	Background = Color3.fromRGB(15, 5, 20),
	Stroke = Color3.fromRGB(80, 40, 120),
	GradientStart = Color3.fromRGB(30, 20, 45),
	GradientEnd = Color3.fromRGB(25, 10, 50),
}
Themes["Pink"] = {
	Primary = Color3.fromRGB(50, 15, 30),
	Secondary = Color3.fromRGB(90, 30, 60),
	Accent = Color3.fromRGB(220, 60, 150),
	ThemeHighlight = Color3.fromRGB(250, 100, 180),
	Text = Color3.fromRGB(250, 230, 240),
	Background = Color3.fromRGB(10, 5, 8),
	Stroke = Color3.fromRGB(120, 40, 80),
	GradientStart = Color3.fromRGB(45, 20, 35),
	GradientEnd = Color3.fromRGB(30, 10, 25),
}
Themes[Theme] = {
	Primary = Color3.fromRGB(15, 15, 15),
	Secondary = Color3.fromRGB(30, 30, 30),
	Accent = Color3.fromRGB(80, 80, 80),
	ThemeHighlight = Color3.fromRGB(160, 160, 160),
	Text = Color3.fromRGB(230, 230, 230),
	Background = Color3.fromRGB(0, 0, 0),
	Stroke = Color3.fromRGB(50, 50, 50),
	GradientStart = Color3.fromRGB(20, 20, 20),
	GradientEnd = Color3.fromRGB(5, 5, 5),
}
local Colors = Themes[Theme]

local keyfold = "AdminGui"
local keyfile = keyfold .. "/key.txt"
if not isfolder(keyfold) then
	makefolder(keyfold)
end
if not isfile(keyfile) then
	writefile(keyfile, "null")
end

local function bkijshadbki9y83219y8dasd()
	local verified = verifyKey(readfile(keyfile))
	if not verified then
		local att = 0
		repeat
			verified = verifyKey(readfile(keyfile))
			att = att + 1
			task.wait(1)
		until verified or att >= 3
	end
	if not verified then
		return
	end
	local players = game:GetService("Players")
	local player = players.LocalPlayer
	local game_gui = player.PlayerGui:WaitForChild("GameGui")
	local whitelist = {}
	local toggles = {}
	local initialized = false
	local user_input = game:GetService("UserInputService")
	local vim = Instance.new("VirtualInputManager")
	local hooks = (type(hookmetamethod) == "function") and true or false
	local lib, tab, section, infmoney, paragraph

	task.spawn(function()
		while true do
			task.wait()
			if user_input.MouseEnabled then
				game_gui.Enabled = true
				game_gui.CursorGame.Visible = true
				user_input.MouseIconEnabled = true
				game_gui.FreeMouse.Visible = false
				player.CameraMode = Enum.CameraMode.Classic
				player.CameraMaxZoomDistance = math.huge
			end
		end
	end)

	task.spawn(function()
		if user_input.MouseEnabled then
			player.CameraMinZoomDistance = 10
			player.Character.Humanoid.JumpPower = 50
			task.wait(0.5)
			player.CameraMinZoomDistance = 0.5
		end
	end)
	task.defer(function()
		getgenv().Theme = "Black"
		lib = loadstring(
			game:HttpGet("https://raw.githubusercontent.com/triquqd717/main/refs/heads/main/test/newLib.lua")
		)()
		local window = lib:CreateWindow({
			Title = "ADMIN PANEL",
			TabWidth = 300,
			SizeUi = UDim2.fromOffset(550, 315),
		})
		tab = window:CreateTab({
			Name = "Main",
		})
		section = tab:AddSection("Main", true)
		repeat
			task.wait()
		until section

		section:AddButton({
			Title = "Open Admin Panel",
			Content = "Or press Left L. Control to open",
			Callback = function()
				if not initialized then
					return
				end
				vim:SendKeyEvent(true, "LeftControl", false, game)
			end,
		})

		paragraph = section:AddParagraph({
			Title = "",
			Content = "",
		})

		paragraph:Set({ Title = "Whitelist", Content = "Whitelist is empty" })

		section:AddInput({
			Title = "Whitelist",
			Content = "Player Name",
			Callback = function(text)
				if not initialized then
					return
				end
				local pname = tostring(text)
				local tplr = players:FindFirstChild(pname)
				if tplr and tplr ~= "" then
					table.insert(whitelist, tplr.Name)
					lib:SetNotification({
						Title = "Whitelist",
						Content = "Added " .. tplr.Name .. " to whitelist",
						Delay = 3.5,
					})
					paragraph:Set({ Title = "Whitelist", Content = table.concat(whitelist, ", ") })
				else
					lib:SetNotification({
						Title = "Error",
						Content = "Player '" .. pname .. "' not found",
						Delay = 3,
					})
				end
			end,
		})

		section:AddButton({
			Title = "Kick All",
			Content = "Kicks all players except whitelisted",
			Callback = function()
				if not initialized then
					return
				end
				local output = nil
				for _, plr2 in pairs(players:GetPlayers()) do
					if plr2 ~= player and not table.find(whitelist, plr2.Name) then
						if plr2 then
							output = true
						else
							output = false
						end
						lib:SetNotification({
							Title = "Kicking",
							Content = "Kicking " .. plr2.Name or "Error",
							Delay = 3,
						})
						pcall(function()
							game:GetService("ReplicatedStorage").ToServer_EVENT:FireServer("Kick", plr2)
						end)
						output = nil
					end
				end
				if output then
					lib:SetNotification({
						Title = "Kick All",
						Content = "Kicked all players",
						Delay = 3,
					})
				else
					lib:SetNotification({
						Title = "Error",
						Content = "No players to kick",
						Delay = 3,
					})
				end
			end,
		})

		section:AddToggle({
			Title = "Auto Kick All",
			Callback = function(state)
				if not initialized then
					return
				end
				if state then
					toggles["KickAll"] = true
					for _, plr in pairs(players:GetPlayers()) do
						if plr ~= player and not table.find(whitelist, plr.Name) then
							pcall(function()
								game:GetService("ReplicatedStorage").ToServer_EVENT:FireServer("Kick", plr)
							end)
						end
					end
					lib:SetNotification({
						Title = "Kick All",
						Content = "Enabled",
						Delay = 3,
					})
				elseif state == false then
					toggles["KickAll"] = false
					lib:SetNotification({
						Title = "Kick All",
						Content = "Disabled",
						Delay = 3,
					})
				end
			end,
		})

		local function L_Hook(func, val)
			pcall(function()
				local old
				old = hooks
					and hookmetamethod(game, "__index", function(self, arg)
						if self == func and arg == "Value" then
							return val
						end
						return old(self, arg)
					end)
			end)
		end
		infmoney = tab:AddSection("Inf Money", true)
		local warning = infmoney:AddParagraph({
			Title = "",
			Content = "",
		})
		warning:Set({
			Title = "WARNING",
			Content = "Setting colossal numbers can lead to you never\nbeing able to join the game again on your account",
		})
		if not hooks then
			local recommend = infmoney:AddParagraph({
				Title = "",
				Content = "",
			})
			if user_input.MouseEnabled then
				recommend:Set({
					Title = "Error",
					Content = "Your Executor "
							.. (type(identifyexecutor) == "function" and identifyexecutor())
							.. " doesn't support hookmetamethod\nTry downloading velocity executor (it's free)"
						or "Unknown doesn't support hookmetamethod\nTry downloading velocity executor (it's free)",
				})
				infmoney:AddButton({
					Title = "Open Velocity Discord Invite",
					Content = "Click to open",
					Callback = function()
						if not initialized then
							return
						end
						lib:SetNotification({
							Title = "Copied",
							Content = "Copied the link",
							Delay = 3,
						})
						if type(setclipboard) == "function" then
							setclipboard("https://discord.com/invite/getvelocity")
						end
						local suc, err = pcall(function()
							local HttpService = game:GetService("HttpService")
							http_request({
								Url = "http://127.0.0.1:6463/rpc?v=1",
								Method = "POST",
								Headers = {
									["Content-Type"] = "application/json",
									Origin = "https://discord.com",
								},
								Body = HttpService:JSONEncode({
									cmd = "INVITE_BROWSER",
									nonce = HttpService:GenerateGUID(false),
									args = {
										code = "getvelocity",
									},
								}),
							})
						end)
						if not suc then
							print(err)
							lib:SetNotification({
								Title = "Redirect Failed",
								Content = "Copied the link instead",
								Delay = 3,
							})
							setclipboard("https://discord.com/invite/getvelocity")
						end
					end,
				})
			else
				recommend:Set({
					Title = "Error",
					Content = "Your Executor "
							.. (type(identifyexecutor) == "function" and identifyexecutor())
							.. " doesn't support hookmetamethod"
						or "Unknown doesn't support hookmetamethod",
				})
				infmoney:AddButton({
					Title = "Copy Delta Discord Invite",
					Content = "Click to copy",
					Callback = function()
						if not initialized then
							return
						end
						setclipboard("https://discord.com/invite/deltaex")
					end,
				})
			end
		end
		local maxnumber = 1.6e308
		local FinalMoney = maxnumber
		infmoney:AddInput({
			Title = "Money",
			Content = "Amount, Default: inf",
			Callback = function(text)
				if not initialized then
					return
				end
				local amount = tonumber(text)
				if amount then
					if amount > maxnumber then
						amount = maxnumber
					end
					FinalMoney = amount
					lib:SetNotification({
						Title = "Success",
						Content = "Set money to " .. amount,
						Delay = 3,
					})
				elseif text == "math.huge" then
					FinalMoney = maxnumber
					lib:SetNotification({
						Title = "Success",
						Content = "Set money to math.huge",
						Delay = 3,
					})
				else
					FinalMoney = maxnumber
					lib:SetNotification({
						Title = "Success",
						Content = "Set money to math.huge",
						Delay = 3,
					})
				end
			end,
		})

		infmoney:AddButton({
			Title = "Dupe Money",
			Content = "Click to dupe money",
			Callback = function()
				if not initialized then
					return
				end
				if hooks then
					L_Hook(game:GetService("Players").LocalPlayer.Stats.MoneyCilent, FinalMoney or maxnumber)
					lib:SetNotification({
						Title = "Success",
						Content = "Money Dupe Successfully Enabled",
						Delay = 3,
					})
				else
					if identifyexecutor then
						lib:SetNotification({
							Title = "Error",
							Content = tostring(identifyexecutor()) .. " executor cannot hookmetamethod",
							Delay = 3,
						})
					else
						lib:SetNotification({
							Title = "Error",
							Content = "Your Executor doesn't support hookmetamethod",
							Delay = 3,
						})
					end
				end
			end,
		})

		local FinalLevel = maxnumber
		infmoney:AddInput({
			Title = "Level",
			Content = "Amount, Default: inf",
			Callback = function(text)
				if not initialized then
					return
				end
				local amount = tonumber(text)
				if amount then
					if amount > maxnumber then
						amount = maxnumber
					end
					FinalLevel = amount
					lib:SetNotification({
						Title = "Success",
						Content = "Set level to " .. amount,
						Delay = 3,
					})
				elseif text == "math.huge" then
					FinalLevel = maxnumber
					lib:SetNotification({
						Title = "Success",
						Content = "Set level to math.huge",
						Delay = 3,
					})
				else
					FinalLevel = maxnumber
					lib:SetNotification({
						Title = "Success",
						Content = "Set level to math.huge",
						Delay = 3,
					})
				end
			end,
		})

		infmoney:AddButton({
			Title = "Dupe Level",
			Content = "Click to enable infinite level",
			Callback = function()
				if not initialized then
					return
				end
				if hooks then
					L_Hook(game:GetService("Players").LocalPlayer.Stats.Lv, FinalLevel or maxnumber)
					lib:SetNotification({
						Title = "Success",
						Content = "Infinite Level Successfully Enabled",
						Delay = 3,
					})
				else
					if identifyexecutor then
						lib:SetNotification({
							Title = "Error",
							Content = tostring(identifyexecutor()) .. " executor cannot hookmetamethod",
							Delay = 3,
						})
					else
						lib:SetNotification({
							Title = "Error",
							Content = "Your Executor doesn't support hookmetamethod",
							Delay = 3,
						})
					end
				end
			end,
		})

		local FinalDays = maxnumber
		infmoney:AddInput({
			Title = "Days",
			Content = "Amount, Default: inf",
			Callback = function(text)
				if not initialized then
					return
				end
				local amount = tonumber(text)
				if amount then
					if amount > maxnumber then
						amount = maxnumber
					end
					FinalDays = amount
					lib:SetNotification({
						Title = "Success",
						Content = "Set days to " .. amount,
						Delay = 3,
					})
				elseif text == "math.huge" then
					FinalDays = maxnumber
					lib:SetNotification({
						Title = "Success",
						Content = "Set days to math.huge",
						Delay = 3,
					})
				else
					FinalDays = maxnumber
					lib:SetNotification({
						Title = "Success",
						Content = "Set days to math.huge",
						Delay = 3,
					})
				end
			end,
		})

		infmoney:AddButton({
			Title = "Dupe Days",
			Content = "Click to enable infinite days",
			Callback = function()
				if not initialized then
					return
				end
				if hooks then
					L_Hook(game:GetService("Players").LocalPlayer.Stats.Day, FinalDays or maxnumber)
					lib:SetNotification({
						Title = "Success",
						Content = "Infinite Days Successfully Enabled",
						Delay = 3,
					})
				else
					if identifyexecutor then
						lib:SetNotification({
							Title = "Error",
							Content = tostring(identifyexecutor()) .. " executor cannot hookmetamethod",
							Delay = 3,
						})
					else
						lib:SetNotification({
							Title = "Error",
							Content = "Your Executor doesn't support hookmetamethod",
							Delay = 3,
						})
					end
				end
			end,
		})

		initialized = true
	end)

	function OnLeave(plr)
		if not initialized then
			return
		end
		if table.find(whitelist, plr.Name) then
			table.remove(whitelist, table.find(whitelist, plr.Name))
			paragraph:Set({ Title = "Whitelist", Content = table.concat(whitelist, ", ") })
		end
	end

	function OnAdd(plr)
		if not initialized then
			return
		end
		if toggles["KickAll"] == true then
			if not table.find(whitelist, plr.Name) then
				pcall(function()
					game:GetService("ReplicatedStorage").ToServer_EVENT:FireServer("Kick", plr)
				end)
				lib:SetNotification({
					Title = "Kick All",
					Content = "Kicked " .. plr.Name .. " from joining",
					Delay = 3,
				})
			end
		end
	end

	function OnCharacterAdded()
		if not initialized then
			return
		end
		task.spawn(function()
			if user_input.MouseEnabled then
				player.CameraMinZoomDistance = 10
				player.Character.Humanoid.JumpPower = 50
				task.wait(0.5)
				player.CameraMinZoomDistance = 0.5
			end
		end)
	end

	task.spawn(function()
		players.PlayerRemoving:Connect(OnLeave)
		players.PlayerAdded:Connect(OnAdd)
		player.CharacterAdded:Connect(OnCharacterAdded)
	end)
end

if verifyKey(readfile(keyfile)) == true then
	bkijshadbki9y83219y8dasd()
	return
end

local C = {}
function C:Create(n, p, pr)
	local i = Instance.new(n)
	local dt = p.BackgroundTransparency or 0
	for k, v in pairs(p) do
		i[k] = v
	end
	if pr then
		i.Parent = pr
	end
	if n == "TextButton" then
		i.MouseEnter:Connect(function()
			ts:Create(i, TweenInfo.new(0.1), { BackgroundTransparency = 0.7 }):Play()
			local s = i:FindFirstChild("UIStroke")
			if s then
				ts:Create(s, TweenInfo.new(0.1), { Transparency = 0 }):Play()
			end
		end)
		i.MouseLeave:Connect(function()
			ts:Create(i, TweenInfo.new(0.1), { BackgroundTransparency = dt }):Play()
			local s = i:FindFirstChild("UIStroke")
			if s then
				ts:Create(s, TweenInfo.new(0.1), { Transparency = 0.9 }):Play()
			end
		end)
	end
	return i
end

local function md(tb, o)
	local d, ds, sp
	tb.InputBegan:Connect(function(ip)
		if ip.UserInputType == Enum.UserInputType.MouseButton1 then
			d, ds, sp = true, ip.Position, o.Position
			ip.Changed:Connect(function()
				if ip.UserInputState == Enum.UserInputState.End then
					d = false
				end
			end)
		end
	end)
	uis.InputChanged:Connect(function(ip)
		if d and ip.UserInputType == Enum.UserInputType.MouseMovement then
			local dl = ip.Position - ds
			o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y)
		end
	end)
end

onMessage = function(m)
	Speed_Library:SetNotification({
		Title = "Key System",
		Description = "Status",
		Content = m,
		Time = 0.5,
		Delay = 5,
	})
end

local kg = C:Create("ScreenGui", { ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, game:GetService("CoreGui"))
local mf = C:Create("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Colors.Background,
	BackgroundTransparency = 0.1,
	BorderSizePixel = 0,
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.fromOffset(300, 180),
	Name = "KeySystem",
}, kg)
C:Create("UICorner", {}, mf)
C:Create("UIStroke", { Color = Colors.Stroke, Thickness = 1.6 }, mf)

local dsh = C:Create("Frame", {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 1, 0),
	ZIndex = 0,
}, mf)
C:Create("ImageLabel", {
	Image = "",
	ImageColor3 = Colors.Background,
	ImageTransparency = 0.5,
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(49, 49, 450, 450),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(1, 47, 1, 47),
	ZIndex = 0,
}, dsh)

local tb = C:Create("Frame", {
	BackgroundColor3 = Colors.Primary,
	BackgroundTransparency = 0.999,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 30),
}, mf)
local tl = C:Create("TextLabel", {
	Font = Enum.Font.GothamBold,
	Text = "Key System",
	TextColor3 = Colors.Text,
	TextSize = 16,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 10, 0, 5),
	Size = UDim2.new(1, -50, 1, 0),
}, tb)
local cb = C:Create("TextButton", {
	Font = Enum.Font.SourceSans,
	Text = "X",
	TextColor3 = Colors.Text,
	TextSize = 18,
	AnchorPoint = Vector2.new(1, 0.5),
	BackgroundTransparency = 1,
	Position = UDim2.new(1, -5, 0.5, 0),
	Size = UDim2.new(0, 25, 0, 25),
}, tb)
cb.Activated:Connect(function()
	kg:Destroy()
end)
md(tb, mf)

local cf = C:Create("Frame", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 30),
	Size = UDim2.new(1, 0, 1, -30),
}, mf)
C:Create("TextLabel", {
	Font = Enum.Font.Gotham,
	Text = "Enter your key below:",
	TextColor3 = Colors.Text,
	TextSize = 14,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 10, 0, 10),
	Size = UDim2.new(1, -20, 0, 20),
}, cf)

local ifr = C:Create("Frame", {
	BackgroundColor3 = Colors.Accent,
	BackgroundTransparency = 0.95,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 10, 0, 35),
	Size = UDim2.new(1, -20, 0, 30),
}, cf)
C:Create("UICorner", { CornerRadius = UDim.new(0, 4) }, ifr)
local ki = C:Create("TextBox", {
	Font = Enum.Font.GothamBold,
	PlaceholderText = "Enter your key here",
	Text = "",
	TextColor3 = Colors.Text,
	TextSize = 14,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 5, 0, 0),
	Size = UDim2.new(1, -10, 1, 0),
}, ifr)

local vb = C:Create("TextButton", {
	BackgroundColor3 = Colors.Accent,
	BackgroundTransparency = 0.8,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 10, 0, 75),
	Size = UDim2.new(1, -20, 0, 30),
	Text = "Verify Key",
	Font = Enum.Font.GothamBold,
	TextColor3 = Colors.Text,
	TextSize = 14,
}, cf)
C:Create("UICorner", { CornerRadius = UDim.new(0, 4) }, vb)
C:Create("UIStroke", { Color = Colors.Stroke, Thickness = 1.2, Transparency = 0.9 }, vb)

local clb = C:Create("TextButton", {
	BackgroundColor3 = Colors.Accent,
	BackgroundTransparency = 0.8,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 10, 0, 115),
	Size = UDim2.new(1, -20, 0, 30),
	Text = "Copy Link",
	Font = Enum.Font.GothamBold,
	TextColor3 = Colors.Text,
	TextSize = 14,
}, cf)
C:Create("UICorner", { CornerRadius = UDim.new(0, 4) }, clb)
C:Create("UIStroke", { Color = Colors.Stroke, Thickness = 1.2, Transparency = 0.9 }, clb)

clb.Activated:Connect(function()
	copyLink()
	Speed_Library:SetNotification({
		Title = "Key System",
		Description = "Link Copied",
		Content = "The link has been copied to your clipboard.",
		Time = 0.5,
		Delay = 3,
	})
end)

vb.Activated
	:Connect(function()
		local eeaads = ki.Text
		if verifyKey(eeaads) then
			Speed_Library:SetNotification({
				Title = "Key System",
				Description = "Success",
				Content = "Key is valid. Access granted.",
				Time = 0.5,
				Delay = 3,
			})
			writefile(keyfile, eeaads)
			task.spawn(function()
				bkijshadbki9y83219y8dasd()
			end)
			kg:Destroy()
		end
	end)([[This file was protected with MoonSec V3]])
	:gsub(".+", function(a)
		_JYsuqvDDOfgV = a
	end)
return (function(y, ...)
	local _
	local o
	local d
	local h
	local a
	local z
	local e = 24915
	local n = 0
	local r = {}
	while n < 769 do
		n = n + 1
		while n < 0x307 and e % 0x49c4 < 0x24e2 do
			n = n + 1
			e = (e - 493) % 37734
			local t = n + e
			if (e % 0x1cd6) > 0xe6b then
				e = (e - 0x164) % 0xb490
				while n < 0x15d and e % 0x1c46 < 0xe23 do
					n = n + 1
					e = (e + 335) % 26289
					local _ = n + e
					if (e % 0x1434) < 0xa1a then
						e = (e - 0xd0) % 0x6b45
						local e = 36057
						if not r[e] then
							r[e] = 0x1
							a = (not a) and _ENV or a
						end
					elseif e % 2 ~= 0 then
						e = (e * 0x32) % 0x59e0
						local e = 80577
						if not r[e] then
							r[e] = 0x1
							a = getfenv and getfenv()
						end
					else
						e = (e * 0x2f7) % 0x38e0
						n = n + 1
						local e = 99953
						if not r[e] then
							r[e] = 0x1
							z = string
						end
					end
				end
			elseif e % 2 ~= 0 then
				e = (e - 0x1a6) % 0x5d2f
				while n < 0x285 and e % 0xa02 < 0x501 do
					n = n + 1
					e = (e - 545) % 48268
					local t = n + e
					if (e % 0x1046) < 0x823 then
						e = (e * 0x147) % 0x514d
						local e = 17466
						if not r[e] then
							r[e] = 0x1
							_ = function(_)
								local e = 0x01
								local function r(n)
									e = e + n
									return _:sub(e - n, e - 0x01)
								end
								while true do
									local n = r(0x01)
									if n == "\5" then
										break
									end
									local e = z.byte(r(0x01))
									local e = r(e)
									if n == "\2" then
										e = o.rpuLxHJP(e)
									elseif n == "\3" then
										e = e ~= "\0"
									elseif n == "\6" then
										a[e] = function(n, e)
											return y(8, nil, y, e, n)
										end
									elseif n == "\4" then
										e = a[e]
									elseif n == "\0" then
										e = a[e][r(z.byte(r(0x01)))]
									end
									local n = r(0x08)
									o[n] = e
								end
							end
						end
					elseif e % 2 ~= 0 then
						e = (e - 0x388) % 0x31a0
						local e = 85075
						if not r[e] then
							r[e] = 0x1
						end
					else
						e = (e + 0x18e) % 0x6ea
						n = n + 1
						local e = 42119
						if not r[e] then
							r[e] = 0x1
							d =
								"\4\8\116\111\110\117\109\98\101\114\114\112\117\76\120\72\74\80\0\6\115\116\114\105\110\103\4\99\104\97\114\72\100\120\90\99\86\70\116\0\6\115\116\114\105\110\103\3\115\117\98\90\121\119\85\104\118\75\99\0\6\115\116\114\105\110\103\4\98\121\116\101\72\89\104\109\114\99\106\85\0\5\116\97\98\108\101\6\99\111\110\99\97\116\98\120\85\117\66\68\81\79\0\5\116\97\98\108\101\6\105\110\115\101\114\116\75\116\106\82\95\75\99\106\5"
						end
					end
				end
			else
				e = (e + 0x2fa) % 0x57ab
				n = n + 1
				while n < 0x3d5 and e % 0x1ab2 < 0xd59 do
					n = n + 1
					e = (e * 804) % 6227
					local a = n + e
					if (e % 0x3760) > 0x1bb0 then
						e = (e * 0x35d) % 0xb85c
						local e = 62087
						if not r[e] then
							r[e] = 0x1
						end
					elseif e % 2 ~= 0 then
						e = (e + 0xc8) % 0x5498
						local e = 70897
						if not r[e] then
							r[e] = 0x1
							o = {}
						end
					else
						e = (e * 0x23a) % 0x3cea
						n = n + 1
						local e = 28718
						if not r[e] then
							r[e] = 0x1
							h = tonumber
						end
					end
				end
			end
		end
		e = (e * 704) % 46419
	end
	_(d)
	local n = {}
	for e = 0x0, 0xff do
		local r = o.HdxZcVFt(e)
		n[e] = r
		n[r] = e
	end
	local function t(e)
		return n[e]
	end
	local z = function(d, _)
		local y, r = 0x01, 0x10
		local n = { {}, {}, {} }
		local a = -0x01
		local e = 0x01
		local z = d
		while true do
			n[0x03][o.ZywUhvKc(
				_,
				e,
				(function()
					e = y + e
					return e - 0x01
				end)()
			)] = (
				function()
					a = a + 0x01
					return a
				end
			)()
			if a == 0x0f then
				a = ""
				r = 0x000
				break
			end
		end
		local a = #_
		while e < a + 0x01 do
			n[0x02][r] = o.ZywUhvKc(
				_,
				e,
				(function()
					e = y + e
					return e - 0x01
				end)()
			)
			r = r + 0x01
			if r % 0x02 == 0x00 then
				r = 0x00
				o.KtjR_Kcj(
					n[0x01],
					(t((((n[0x03][n[0x02][0x00]] or 0x00) * 0x10) + (n[0x03][n[0x02][0x01]] or 0x00) + z) % 0x100))
				)
				z = d + z
			end
		end
		return o.bxUuBDQO(n[0x01])
	end
	_(z(154, "bN6_Swj:D1EpV9!Cjp"))
	_(
		z(
			234,
			"^GZP .UKiwqBjJ>?GUPZB.jj>{>J(iGKjq DUKK.i>K>BZjU>BJ?G.ziPJ>i??i_iwwJB>J ?GJiGJZ>Zj U.UUPZ? wjq>Z>?2qZUGP.P.PUjK.qPwZBGKiw GKZ> Z ?UqKwZJqBB.J>>P?>Z ZJ.GPPKJiBKZiq.jKU?.??ZiPZ>.UZKeiKB+B>JijK>GG GZGj QKGGiPUBPBB>f>??JZZZ. >.GUiiiwKwJjjjij>G.Z Gw B?jG.Kqw?BPJq>Bd JBZj UUZKwU?wJiUj?KZiiGGGGZ?._.U wUJwqBUJKJ>0Gq BwsKP P?.KKJwZjjJ4j?wiBZP  ..?KUiqwKBZjGj jJ>GgiP.Pi.U.KZ%PBjNjPJq?qMwjD .. UjKPiBqwqKJw>ZC 9JmP.GUi<iZyq.B jjJP>B+w?jZ  PUj >KjqPjfUiK?vQGiZ. R.jU?UiK?wqq>Bw?q?wBZjq J..KZiGw.BjBK>GVP>U2w ZPwU !>ZiqKBGJq> wKS>Zq P.wKZiJU>iBj?BJ?KHjcPjB"
		)
	)
	local e = (
		-1134
		+ (function()
			local _, n = 0, 1;
			(function(n, e, r)
				r(e(e, e, n), e(r, n and e, r), e(n and n, r, n))
			end)(function(a, e, r)
				if _ > 366 then
					return r
				end
				_ = _ + 1
				n = (n + 87) % 38697
				if (n % 1896) > 948 then
					n = (n * 149) % 39992
					return e
				else
					return a(a(e, e, r), r(a and e, e, r), a(r, e, r))
				end
				return e(e(r, e, r), e(a and a, e, a), e(r, r, a))
			end, function(a, e, r)
				if _ > 360 then
					return e
				end
				_ = _ + 1
				n = (n - 528) % 47365
				if (n % 1722) > 861 then
					return e
				else
					return r(e(e and r, e, r), r(r, e, a), a(a, r, e))
				end
				return a(a(e, e, e), e(a, a, e), e(r, r, e))
			end, function(r, a, e)
				if _ > 372 then
					return e
				end
				_ = _ + 1
				n = (n * 13) % 2511
				if (n % 980) >= 490 then
					n = (n - 285) % 12993
					return a
				else
					return e(e(a, r, a and a), r(e, e, e) and r(e, a, r), r(e, a, e))
				end
				return e(r(a, r, r and a), r(a, e and e, e), a(r, e, e))
			end)
			return n
		end)()
	)
	local t = o.HZcvBZkr or o.SobnaAyz
	local ae = getfenv or function()
		return _ENV
	end
	local a = 2
	local j = 1
	local d = 4
	local _ = 3
	local function re(k, ...)
		local f = z(
			e,
			".38!^7yPeCZz_Xar7^7YreZh^Zr=Ce^&aeCL!er^^e!pa^e,8eX6a#C^!_aoPP!8_Xe38X_7Pz8^7Z bZe7LreZ}_e!PXe^8aeC !eavee!o33_L8ZXbPe8W_ePS3ez9ZP38zeyfvezW7eL+zeC4reZP^erVCeZP^XS^Z&7Pr3C^Xeez8eXlPeyP!ZX3P_8C_XPa8_Z7Py3^7eOyZe74re38ZC7ar_Zr77Ck^7ajee!{!P_Ze3^!aXC3!az^7_hr_aPPSayt33zL7e*oaCz!y_*Cza732_Z7^_Cx^8aRee!m3rarC_!eXCeXwZXre^8^yZ3AzeyLiez{7eaBaP7BrrZn^er:aaZ7^zT^ZP78zZ!8Xeev8eX PeRyyaz{3Z_Qye3hzeyQ^e37Ce&=_37UreZSC77r%PZa!zr7Cz!rXzZ^^ZaCCy!Pazye!3X^P_87Xy738_X^PZzT7r<{Ze7k^z{CZZ7_&3Za^rC#^^aWee!x8_rPeX!7ayP!8Xa8ea8C_zP7zZy99ezv7e>0ZeP9!eZF^zrsCe^=!Zr7C_avC8!=Xeefea^8aPeX3PXyPa!!_Xe^zeyaQez#7e7^3Az7y7V7CS7CrrZe7^rCCr^er_!8XeeR8eX>Pe^E^^zh3e_!ye3UzeZP^X:^7Zyy+azy7abyZaXaXP^paCCF!eagaA!(XXe>8eXY_Xy^!3XX^Z_Ly_3uzeyg^a3r_yP^Ze7^reZ#^e^q:3Za7!Cm^Paiee!/3ZarCZ!^XXC83zXCC887zePC!R_7P^z887__P^3__^y_!^8rCe^^aeC !e^!rtC3^Ze)8_XTPe85!7X3e_8eye37zey2jerP_Zy7KXzarZZh^erxCe^;ae_area8ee!;Xee58eXGX3yt_ePP3e_Gyey^3XXeP_r8_PPeZZ7KreZ)^erT3eee8eCv^Aa2ee!E3Ca^C7!CayyP!XXC3e_^ye3vzeXPyC3C__+hrC7SreZ+zJy^V_z57z_ZyP%rrZC3^rZaer!Ca_ee!XX8eX!!_Xe83z_rPy8^zXya3_Pa7zArz73r(_z873U3ZX73a_yP)CzP7P!XXCeC!yCreZ87_ae!aP_eyX33z_P!XPzX7C<Czy3r{_Z77zt^yP^aaXZP8^aCeZraa^C78CP8z87CH3ZC73rCr3ar7e3PZe71re3qz^73L_Zr^ZrrZP7!r_7G^yarCy!!XX^U8Xa8eZ8rXZ!azeyZKez97e7yAX_8y3&y_33Ua!Z7y3CQ!_aJee!B^_a3Cz!zPe8C_ePE3e!PXZPC8__7ya3C_^y7ZZ7(reZ,^erB7eZ88eC8!eaTee!?Xe^(CZ3nPe87_ePU3e87XZe88PX8 ezC7eJhZez!7Cl!zx77a^ZC7yrz!Zagee!qXees8eV8ze88_ePV3e_ByeX}xZZLYezP7e--ZeZoyZuCz773;ZzCaeCP!ea;eePe^_r^Ce3PXXC^_eP^3e_5ye788^X7yXzh7rY6Ze7k7a38zP7XaZeP8ZC8!ea ee!LXeewyy3TPZ8u_ePx3e_p8eP_reyOwXz:7ecdaa_87CkXZXr=ZK^RaeC=ee^rrzCC^_aCCP!aPZ8+_eP{3e_(8ey_reyq3hzT7e-FrXCC^z3^zZ7rK!Z7aeCC!eaSeePz!XrCPz^CazC^8XXX3e_Zye3QzeZ8yC3!_!yP3ZzryXIaZ_r>Z8^xaeC&Pr^7r_e!!Xr8Ca!CXze7_ePZ3e_tyey^3XXeP_r!_Py_3P_88zZq7PrgCe^K!er_CC^!aXCe^Pa_e_!7aZP^8Xaee__oya3lzeyI7e87_ZPv3^z7rZZV^er(Ce^WaeXCreaIC!!IXeeKyC!aXzee!Pa8ye8rX3Pa8_y,xrzW7eOkazzryZI7ery7H3^gr8Cq!ea?r^Cr!Ca^Cz^^aZeC!yXP3Z_6ye3fzey-Gea^CeV/z^70reZpez7rSZZa^XJ8eZ^3a_CC^Xr!8eX^Pe8u_ezaPC8X_X3wzryK ezg_Zy73C_77X3!z_rDCr^kaeCOPz^rryCa!Xa!C_X8Z!ZPXa^CayzP7P^rzeyztezd7e7!3^zC7z=7ez77,yz^^Xx8!Za5ee!GXeexZe83ze8;_zP 3e_BXze73Zy(88zo7e} 3O_^y_3Yzz8Z_Pyr^C#vZ3>areC_!Cr^CP!8aPer!za^^y8a_Xe^zey^Vez{7eya3Xz_y^Z(7kr*Ce^,3PrzCX7CzyZ^7Qr^8eX^Pe8=_e_77_8CX738zey%Wezh7eeGaaCfreZ7^er5CeZy7^rrZP78ee!^Xeew8e88XXe!!_P)83_#ye3w,__7e&8^Z^y3 Zz7y^Zv^zr(Ce^07yr7Zra8ee!UXee-8eXnZyyg_ee^3e_wye!r8eX7yZ3__3y!XPz!yP2azy77rzz^73IyZ37^b3!gazes8eX-zXea!_X7eZaha3Pr8XX88e3zzXPC_eze7X38ZXrUCX^GaeC6ez^_r3C!!Xen!aXAPe8&JZX3Pz8z_re88PX7Py3^Z_P8LCzayz3+ZCy8rXZa^z9C!ZaIee!wXee%8eoDze88_ePv3e_,ye3Ja^Z>xezz7e6/ZeCCy7?3Zr77XzZr7^rrZZ3!eZy!1zz!7zK!Zz3!tPPN3X_?ye3>rZ__yC3!_!{xz^7;reZlC_y8rCZa7z}sCC78aXCa!zrC8eX8Pe8s_eXrez_2Pe3Jzeyw^Z33zzyzkr_8yP37zy7^XzZr7^rrZZ3!ee^7Xee/8e37ayC^8Xa8!e!CXPe78ZehP!37X38gQZz7y^xrzr8ZCe^^aeCg!e^PaCCX!XeI8_X,Pe8m3_X7Ci!^ye37zeyQBer!_Py_3P_8reZe^ernCez^7PO!Z_78r3Ca!rei8aXMPe8*!za^eZ8CXyPPzeyz5ez)7eP^3Pz!y^ICze785PZ37Zr^!ZPZ83_CP33C_3eCzP88_eP=3e_DyeC-3aZ%LezC7e>}ZeZ^y}xCZz7zsyZ77zn!!eayee!RXeaCCz!ya3e_8XP83e_Nye3Lzea)P!rI7ZxBZe7dreZD^e!^Xe^%rxC%!eaYXXPC3zarCZ!aXXC8_ZPD3e_Hye3Vre_r^ezMy7HEZe7;!r38ZC7^+3Z77yG^ez7^aCZ8^_eu8aX,Pe8D37X7e_8eXPP^zeyWSez/7ev8Ze7DreZ5^e_638e-aeCC!ea1eee!!Xa!CP!aX_e3!ZaC3e_yye3jzeZ!PP3__PP8Xz7BraZ;^ervXzz8^Xr3Z_^7eZ!lXeeL8eXnPe^^eePO3__{ye3s8__CP7377e33Ze7UreaCz773rrZ7!_}8CC^arzZb!Cr8eX!aXzCC_ZPw3e_,ye3jzeyifez{7_xSZe7-^zKC_877Ce^ZaeCH!e!!r_C3^_r7Cz3!aPe^8XPp89_Bye3{83X!ya3r_^y^,X_8rZZ ^erBCe^hae_^rea#C8!RXeenPz!raXC88zX7yz83Xye!zeye#ezN7eP8vXz37_nyz37_rX^{r3CH!ealXzC!^Za7eX!azrC7!3PM88_-ye3E+!_7e3X4ZzPC3z_^7XIX^ereCe^-aeXCZz8_rPC3!_a7e_X838zCy3wCz37Cy3^rzeyyTez/7e7Zr3za7_o7_Irbzr^maeCte_^er3Z!reayC3!_XX^m!rX3ezaiXee88PX^yX3!__y7q_P*yrUCz_7ezeeX7PrrZy!!aXC!reXy7zXHPa8{_ePFyz!^XZPr8!_7hezZ7e;#ZezX7C?zZX7y2PZ_^_r7ZZaLC^!(Xee{Cz!7a_e!!^XCee88XPP38Z_^0Zz+7eWwZe7NreaCeer8Ce^taeCE!ey2_CPiXeez8eX2PeC!^3XaPP!8_Xe38X_7Pz8^7z=3ZZaZC3!Ca3eC!3IC8PC8!ea{ee!5Xen6Pa3 PZ8&_ePd3e_pyePareyf38z17e9Dr3zX7C=PZX!_rCZ8^Xr_!Zakee!pXee&8ea^ze8uXyP&3e_(_87C8y_^yX8eCZy73Jz3yaVCzPy8Ce^CaeC#!e8!rPZo73Z&P^!Cayez_ZP,3e_fye3Wze_C^ezhyM6NZe7R^_%7_by^azZCy8r7!ea!ee!MXeX7CZ!_PZ8o_ePG3e_)yeyarey+gazj7eGFarzry_;eZC7XCZ^SaeC(!eafeee^3eeY!eX,Pe8V3Xa!PX!8z3Pa8eX7P_{!zXP83azC7zm7^er^Ce^jaeX7Zy77r7!hXXe-8eX _3eX8CXPPX_}e83GzeytPN8^__Pv3zeZ8P_rZCy4Y3ya7er_CC7^rPC8^ParCz^^Zye!!PXX3Z_lye3xzeyS*eX^CeRUZa70reZoeC7!rzZ77yx^!Za1ee!LXeec8e3aze88_eP53e_dye3l3_ZttezC7e <ZeZ!7zd3z^77a_zC7er7!eaZee!4XeX^eX^ea_y8!Xa^e_8rXy3oX!y^sezk7ea^Ze7IreZ3^erOCe78a_C?!easCC! XeeV!ZaXPe84_ePZ3e_>ye!yzryowezm7aS ZC7,eyZ=^_PCCe^;aeCy!ea3ee!^y3e,8eXUPr8K_CPb3e_ryC3Nzey3#ez&7eNyr!7VreZR78r0CC^MaCCQ!ez7ee!%XeeW8eX1Pe8y3!P13C_WPe3vzCy<&CzN7eX7Ze7oreZS^er;Ce78CyCF!ZauCP!,Xee{8e^ZPe8!_eP33e_Kye3ua7yoizz:7CcKZZ7DreZ_^er^Ce^3aeC<!ea8ea!OXXeG!PX+Pe82XZ!_3e_yye!azeyDLeXA^!xIZa7WraZBP3rnZZ^_aeCP!ea7ee!FXeeJ8XXGPa8{_ZPp3C_hPZ8!zeyyse3Z7e#nZeP6rCZ%^ar=Ca^(P!Cq!er^ee!yXee88eX8Pe8ya7Ps3a_=e83LzCyEQCz}7_eCZe7mrezZ^er3Ce^^P3C6!ea#Ce!+XCep8eX_Pe8y_eP+3e_5ye88XzyS rzSaCqMZe7hraZ7^erPCe7raeC3!eaIee!^y3e,8eXHCP8H_CPg3_^Cye3%zee9jez37e38P^7MrrZKzPrECe^-rZ7_!eaeeePXXee#8eXyXZ8kXOPk!__=yC3&zey51_!C7e(;ZeP^reZ3^er^83^LaeCAy3a-eC!BaZ^_8eXePe88_ePR3e_y_Z3p_Vy>!?z;7C2JZe7dr_8C^eriCeyeaeC3!ea^33!?Xeej73XgPC8BXZ!_3e_eyeZ^zeyxSe_88^BOz37TyyZ#^erdze7zaeCC!eaCee73XeC8!_XIe88O!7PQ3e_uPZ8ezeyz}e3a7e2NZePRO3Zm7!r>Z!^+!ZCH^Zaaee!_XeaP8eXdPe^#_rPK8^_/P^3)!eyR3Zz77e(XZeP8reZx^e3<eb^Ur7CG^7aIC3!naZC_8eXaPe^8_ePN3eauP_3d_yy03yzpz<m<zZ7^reZr^erPCe^AaeCy^yagCP!&3*e,8CXxPC8w__rC3e_%ye^ezey3%ez87a)UzP7Bn!ZW^er9ZZaaaeZ{!e7Zee!NXeC8C^X0eC89^ZP:3e_HPZ3rzeP8ie7y7e>LZe7bA!Z07zrdZj^maeCM!ereee^^Xee(8eX8Pe8o__Pb8X_jPZ3fzey13Z_P7e3yZeZXreZ:^erICr^YrXCp^XaoCa!GaeeX8ea^Pezr_ee73erB8^3q__y)e3z P3g5ZeyXrez!^er8Ce^8aezQ^8asC_!paze=Z_XWCa8C_ee^3evPye33zerXYez^a3vkZe7U!rZf^CrsC__CaeC=!e8zee!3XeZI3bX9e_8BXzPUC__1eayrzeP^oerz7e(3Ze_zreZ^X3r}Ce^?!!CY!CaFe_zCXee&8e3_Pe83_ee8_y_QPZ3KkzyELezA7a^zZey^reZy^er3Ce^eaeC?kXa=ee!6aCeO8eX:Per7_eP%3e__ye30zey%XXz<7e/TzP7kreZi^e_7Ce^baeCe!eaAee!jZXeH8eXWeZ8s_eP:3eC7ye39zey8gezL7eJNPX7kreZA7er,Ce^>aey7!eawee!7Xee/8ea8Z88,X_PD^z_Hye3G_Z8_Be_^7e!!Ze7freZKXZrMZ_^+aCC0!CaWeaPzXeC^8eXXPe83_eP!3e_*!X36zeyg33zg7eRmZe87reZ+^eraCe^xaeCD0Xajee!Ba7eS8eX:eZ_a_ee73e_7ye3dzeP8zyzIya)+^87qreZ57ZCaCe7PaeC7!ea=ee!^3^e)!XX az8I_CPG3e!Zye8CzeP^Hez&7e::Z^7133ZN^CrJCZ^:rZZ7!erZee7aXeeV8erme78Ra8Pd!8_EC33&_ZP7he_z7eCyZe7preZG7rrYz8^/aZCM!Ca<ee!PXeCZ8ea^Pe8,_ePD8r_me83%zCy+;ZzD7a3zZeyZre,z^er3Ce7CaeC^_3aHee!4^!e98CX%P_ZC_ePA3e!8ye33zeP8zyz}P8F/X^7vreZF^edeCC7zaeC7!eaAee!?r:eK^^X=C88k_ePn3eX:ye8zzey8-ez37e38zZ7}3!ZkPZrxCe^laeCz!er_ee^ZXee(8eXVPr8Da!Pu3Z_KyC3pz_eCfe_77ey?Ze73reZyC!r<ZX^1ryC9!CaveC!bXe778eXLPe8P_eP&3e_yz!3#_ayS33zm7Cj}z87YreP7^er4Ce7^aeCp!ea;7X!5XeeK!ZXLPe8v_e^73e_0ye3Zzey/5ezv8XM}Ze7:rZZ ^erjCe37aeCT!earee!kXeeirXXxPe8J__PM3e_Myea7zey}leze7eTVZe7F_XZ5^erlCz^TaeC;!ez7ee!RXee78eX?Pe8+CXPT3e_AP!36zey0Sarz7e3PZe7ereZ3^er_Ce^<zXC?!eauea!,Xee?8eZ7Pe8D_eP73e_Yye3HeXy&Aezoy_o6Ze7KreP7^er>Ce78aeCc!eaT7X!qXee-!8X9Pe8}_e^73e_+ye38zey<HezG8XngZe7ukPZO^erJCe37aeCn!ea^ee!kXeeIrXXnPe8=XJP&3e_uyea7zeyH ez!7e9=Ze7m_XZ1^erdZ!^#aeC#!ez7ee!(XeCy8eXmPe8y3!P !K_ky_3>zCy&3oz(7eX7Ze7Jrez^^ervCe^vzXCb!eaxCZ!vXeeh8eZ7Pe86_ePZ3e_/ye3,eXyKiez67Z&NZe7,reP7^ergCe^^aeC9!ea&7X!#XeeO!KXdPe8T_e^73e_bye3!zeyc)ezO8X1uZe7srXZ+^erpZZ7aaCZC!e^7ee!2XeC8!yX C88W33P(3e_lPZ8CzePzAe3Z7e?HZePs33Zjy!rcz!^c3rC?^Za!ee^XXeZZ8eX?Pe8DX_Pd!!_Ge73:zey)0ezP7e3ZZe7freZ8^ergZy^148C}!Ca eZ!;aZe38eazPeeZ_ePL3eaMP53DX!yS8!z)CZ:4zZrarezX^e&!Ce^faeCu^Xa3Z!!4r7eW8ZX2eZ!__ee_3e8Zye3xzeel3rzsP^,t_^7D!ZZF7ZoyCe7aae!!!eajee!Wr7ep^^XYCy8+_ZP>3e_yyC8Xzey%;ezb7e<kzy7B3yZp^er*Z3^hrZCX!erreeZXXeeG8erNey8IaPP&!P_VZ33*_Zy30eXE7eZCZe7#rez87^rnzC^:!8C:!ea4CZ^^XeZ88e3ZPe8N_ePq88_3eP3?XZyvbZzvyeYZZeyareXy^eDrCe78r7CE7Pau67!2Xeef^eX_Pe!r_eer3erCye88zay/8ez>ark=Ze7+-ZZ_^e33Cez7aeCR!er8C3!:rZeMCXXjPe8D_ePZ3CXrye!8zey8*e_<yCxk_y7;P^ZfyPr9ZZ^zaeZr!e7Xee!&XeZ:8rXNCP8faPPh73_pPZ3^zee*xe8^7e=nZey8F^ZiyCrK^3^WaeC?^Za_ee78Xe8C8eXmPe85X8P3!P_9eZ3kzZy63ez37e3aZererezr^eS8Ze^wUPC9z7a ee!*ree38earPe!r_eZC3eX8PP3qXeyUPrzW7e2hzZ78re_3^e37Ce^AaeZ873auZZ!4rXes8eX6Pe8Z_Cer3ea8ye38zePHIazAPy1;zr7W3PZ07Zr^Ce7rae5X!eacee7La!eB^PXpCP8tL3Ph8ZXPye!wzeXP+ezl7e38_^7R3CZAe!rRCe^FrZZ_!ef8eeyzXeem8eX9e883aPPv!Z_{yZ3(_eyzwe_a7eyzZeyrrez8y3r:zP^0y7CU!eawZe!XXeCr8earPe7C_ee8!S_)ee3KE8ylqezkyZqrZeP3re!Z^erECe78aXC%7ZaE88!iXee#8eXZPC!r_eC83e_8ye8b__y{8yz&CCt#_P7,GZZ8^eArCezXaeCF!e:keC!grPe>^PXFz38OXZe33ealyez<zeynLe_87Co5_C7YyXZ?^erNZZ78aez8!e77ee!VXeeL!8X3CP8qaZPk3Z_LPe3XzePa0e!r7e3rZey8-3Z-yPrk37^oaeC 7earee^rXeCr8e0CPe!8a7P1!e_ zr34zey53Z_e7e83Ze7^reZ#^eT8Z^^2-ZCx!_aoee!fXeeZ8CarPe^8_eP83eXYe83BXyy{eIznPP# zZ7Xrezr^eyXCe^=aez}^PaiZP!5rPeRy3XbeZ8Z_eC=3e78ye3bzeP88qzGPCwnZ_72reZ+7ZF^Cey8aeC^!eaOee!oaZe,^PXxCZ8Y_ZPf8ee3ye8azeyeGe_r7e3Rz37}37Zn7XrUzy^haeC8!eraee!FXeeC8ea8e^8OaPPSC7_Uye3TXeya,e_r7e3rZeeCrez878rjze^c!8Cq!ea=CZ!aXeZ38e^7Pe8:_ee8e!_OeZ3Vk8yOvezW7e3MZeyrre_8^er8Ce7,rrCt7yaLza!}rPei!ZXCPe!r_eaX3e_Mye!KX!y48PzQPPNja37WfZZe^e3BCez7aeC,!er8Cz!qrCekPCX-Pe8TXZXz3ea8yee7zey9SezWyP(m_P7U3ZZB^ZrkZe^3aeZa!e7_ee^rXeC8^^XQCP8A^7Pg3e_+ee38zePrhe_r7e!CZey81uZWyerv!Z^MaeC+^ZaXee73Xe8Z8eXbPe!8!!P<!Z_,WZ3OzeyOqe_e7e3rZeP8reZ8^eBKz3^gHyCKa0aBZP!{aZCe8earPeCX_ePx3ea6y_3IXPyc8PzuC3bTzZyYre_u^eCZCe^maeZ8^rauZC!,^re;8eXQeZez_eC83eyZye3wzeyh3^zHPPmT_Z7TrZZO7eu_Ce7aaeZP!erree^8ayek^PX#r78f_ePf!eX^ye8rzePr)eaC7e38zy7t3eZ:e!r=Ce^9rZCe!eh3eeZPXee58ea8a!8vaZPN7!_6ye3>zePX1e_r7e88Ze78rezJ7Zrnzy^{7!CR7Pa/CZ!^XeCr8e^XPe82_eCb8__JeP3tXPyf^3zWyZ07ZeP re!Z^eriCe78rzCO7Cala^!bXeei!Z!zPe^8_e*Z3e_Gye34_Py*8PzLPZxIZZ7xdeZy^e{aCee3aeZr!er8eZ!{rPeDZ7XNPe84aeec3eXrye8rzeCCJe_8yr)6_e7HyXZ6^erbZZ^7aez3!ee8ee!oXeC8C!XOCZ8N!XPu3e_Lye3_zePrMeX87e,8Zey=>CZ?yyr*8P^ OPCk^ZaCee^rXerX8eXsPe^;XCPN!P_=eP3Jr3y<3ZzP7e8RZe7^reZ?^eT8Z!^BICCJeranee!VaZaz8er8Pe8^_ePQ3e_cyr3EXPyD8Zzd7Z(Vzey3reza^eyeCe7raeZ8^!a5ZP!c77eM8eX Ce!P_eer3eXrye^CzeP83_zFPeJY^r7nreZi7Z27Cey3ae_Z!eaDee^8eyei^ZX=3r81_ePG3eX8ye8rzee8wez87e3hyC703yZt7#rRzP^5reZC!erXee7!XeCa8eX1CS8;ayPx3e_gP33W_ZyeJe_r7ePXZe7fre_j7rrNzP^?LPCjP3aDCZ!zXeZ 8e3ZPe8-_ee8!!_,eC3vr8y;cezdyZyzZeP8re^C^erACe^}r^Cm7PaKZZ!SXZe)!eaePe!a_eZy3eXrye88_!yk8PzpX7FuZe7{3eZ^^elrCe7rae_C!er8Z0!xree6CXX1Pe8fXZeZ3ea3yeZ8zeyd5e_8_!({_Z7(erZ>^erECe7!aeZr!ef8ee!8XeC/!aX:Cy8w^^Pm!P_4PZ83zePr&e8X7e<qZeP%brZ%yPrJzP^&83CD^Zr!ee7GXe8C8eXcPe!8__P6!C_FKe3-zeyc3Z3z7e88Ze_^reZk^erdZ!^>)PCV7Za5eZ!#aeey8eaaPe_e_eer3eX8yz3LXPyme7z-7e,:_e7erezr^egrCePCaeZ87!a*Ze!-rXe98eX/eZ!z_eC33eXKye3bzeP8P!z,PZ9h3r7,reZs^er8Ce7raez8!ea8ee^EaaeU^yXVer8TaPPR8ZXzye8rzeXX)ezo7e8bzy7H3PZ,yPrKX3^VrZZ_!elHeeyzXeen8ea8er8MaCP2zJ_vye3I_Z_z(eX87ePPZe7FreZU7^r&zP^+hZCf!Za4Ce^eXeCa8e!zPe!r_ee88r_oeP3{!7yj;ezvPeG_Zeyrrezr^e8CCe78arCb7eai88!mXeeE!ZaCPe^3_e3P3e_6ye888!yH8ZzVZ8HbZe7xrezy^edrCey8aeC8!eroZ^!{ryelyCXoCP8AXZPa3eXryeeXzey>OeX{y7WI_P7)3PZ0e3r#ZZ^aaez?!e77ee!lXeC88XXLCC8wP3Pp3e_NPZPzzee8Ne7H7esFZe7l3lZxyPrGzZ^UaZC&^erPee^aXe-r8earPe!8_CPk!P_ha73izeyT8ez87e3rZeyrreXC^eK8ZC^v5eC}!_aOee!;aZe^8er3Pe7Z_ePM3eX8X!36XZy>7rz97eKiZey!rezr^e38Ce^8aeZY!XaNZy!*74eK^PXmeZ!V_eer3e!Xye3FzeeM3yz}PPg0_P7:!3Zx7ZxXCey1ae!P!eawee^8aaeH^CXdP_8J_eP=8Zyaye!8zer8Wezo7e-TzZ7j3PZVyZrMCZ^ re73!eraee!eXeCr8eaIPz8na7PI7A_4ey3=zeya{e_a7eDMZe7Crez87zrdzP^=y7CH!eaLZe^ZXeCr8earPe7C_ee83__%ee3V8Xy65ez>yZ3!ZeP3reaZ^erpCe787!CS7ZaB!3!,Xeec8ea_Pe!r_eC83e_8ye8(X;yx8yz5eaO0_P7JsZZz^eMrCezXaeC,!eDlC7!UrPe+^PXcz38>XZPe3eaUyey3zeyWne_8P7Qd_C7RyXZ ^erfZZZzaez8!ePPee!VXeeU!&XQCP8xaZPT3Z_5Pe88zePase8_7e3rZey833ZKyPr237^MaeCV7eaXee^rXeCr8eMCPe!8XrP&!e_v383Dzeyu3Zzy7e83Zer8reZ;^eq8D!^>KZCoZ_axee!MXeCX8earPe^8_eP83eX e83NXyylzdzLPP4czZ7_rezr^eyXCe^ aez4^!amZP!2rPejy3XieZ!!_eC;3e7Xye3hzeP8}azsPCSR7872reZV7Z7zCey8aepP!ea?ee!6aze%^PXgCZ8s_ZPv8e_Pye8azePPve_r7e38_^7v3PZq_7rsCe^EBeCP!erree^rXezC8ea8P_8xaeP&z-_0ye31_ZP! eX37e!zZe7nrez8z!rBzZ^V7rCb!eaxee!rXeCr8er8Pe88_een!;_0ey3-8!y+8PzFyZ3#Zeyrre3X^er?Ceydr!C47Pa(ZP!:33et!ZaLPe^f_e__3e_+ye88_8y;8CzDr8BfZe7M(ZYz^e38CeeZaeCS!eaTZ7!2rPes^ZXDPZ8RXee^3eXaye73zePrSe_8yz;O_P7vP7Z+^erbze^ZaeZr!erreeyCXeC88XXfCe8dyZPI3e_GPZ8Zzee3+e877elHZey8y!ZtyZrS!e^OaeC(!erNee^rXeZ88eX8Pe!TXXP+!y_hrP3QXPy43Zz37e3rZe_XreZ;^e39Cr^FHPCU7Pab_3!naZC38erMPe7Z_ePs3eX8yX3fXCyg78zS7e5gzZzzre_8^e^PCe^FaeCm^CaiZP! rZeE8ZXTee8e_eea3e!eye8rzeP83ez1PP,6877wreZAyeraCe7raeZr!e3Cee^8a7e-^eXqP_8A_ePx8Z_rye!3ze=P}ezl7e387y7j3ZZ<XZrKCe^gaeZ8!erree78Xee88eaw!C8/ayP/8<_weP3{_eP3Ee_X7e^7ZeyareZ>77rxzy^YaeCJ^3ahCZ!yXeCr8e^XPe8p_eCs3X_seP3+XPy(^3z,yZ1zZeP1re!8^er1Ce78U^C>7CaAa^!hXeeM!Z!zPe^8_eZZ3e_mye3TXmy48PzQPZwMZZ7cfeZC^ebaCePyaeZr!er8eZ!lrPeIZ7XcPe8taePe3eXrye8rzeCCUe_8P8u(_e7oerZg^er*ZZ^Zaez3!e3Zee!RXeC8C!X1CZ8OP3Pt3e_mye3PzePrdeX87e#8ZeyOhrZDyyr*3^^tVPCQ^Za3ee^rXerX8eXUPe^;XPPO!P_geP36r3yE3ZzZ7e8OZe_^reZ-^e28Z^^<LCCda3aGee!{aZaz8er8Pe7I_eP*3e_BPe3+XPyn8Zzm7Zhbzeyzreza^eCeCe7raeZ8!Ca<ZP!g77eA8eXwCe!3_eer3eXrye^CzeP83yzkPep93r7SreZI7Z63Cey3aez7!ea=ee^8^!e<^ZXDaC8O_ePD3eX3ye8rzee8Lez87e39ZC7)3yZx7rrGzP^ rZZz!erreeZXXeeG8erGPz8qaPPB!P_1Z330_ZPeneX<7ePPZe7wrez87Zr+zC^f8!Cu!eawCZCzXeZ88eyePe82_ePh3r_FeP3,XZykxZz%yenXZeyareQz^eRrCe78aaCR7PaVh7! Xeej^eaPPe!r_eer3erCye88X!yu8ezSrrK5Ze7SnZz8^e33CeXZaeCx!er8r!!ArZeL!_XWPe8p_eP_3eXrye!8zey8pe_MP^Nm_y7x!CZKyPr&ZZ7XaeZr!e7Xee!IXeZU!_XbCP8<aPPu73_GPZ8Czee -e7G7eotZey8rzZAyCr0%X^0aeCu^Z^zee78Xe888eX/Pe8TXyPo!P_leZ3UzZy?3ezr7e3aZeXrrezr^eN8z7^H5PCIz7a1ee!tree^8earPe!r_eZC3eX8y_34XeyB7rz17et{zZ7yre_3^e!ZCe^#aeZ8Z!a+ZZ!Uyze*8eXkPe8r_eer3ea8ye38zePU:az5Py(/8u7O3PZ{7ZW8Ce7raeWX!eaoee7Kr8e>^PX>CP8tv3Pf8Z_zye!&zeCZ/ez&7e38_37*3CZDarrJCe^*rZ!a!e(8ee!^Xee>8eXueZ80aPP%!Z_qyZ31_e83Ie_a7efeZeyrrezJ73r:z7^ktyCB7ya<ee!7XeCa8eXKPe8C_ee83a_5eP3o!7y9Hez,PeY8Zeyrrezr^e8CCe78rXC%7eaqa^! XeeL!Za8Pe^3_e__3e_Dye888!y:8ZzNz^6vZe7}reZZ^emrCey8aeC8!erlZ3!0rye}7aX CP8OXZe73eXryeeXzeytxeXQy^Vf_P7c3PZ,e3r>ZZ7Paezl!e3Zee!HXeC8!!X=CC8kM8PB3e_LPZPzzee8;eaZ7e>sZe7u3^Z4yPr0zZ^laZCT^ea8ee^aXer_8earPe!8a8P5!P_(a73pzeyl8e_!7e3rZeyrreXC^e98Zy^=<eCBXZa5ee!JaZC38er3Pe_8_ePO3eX8X!32XZy%ZZzo7egpZeyQrezr^e38Ce^8aeZu7!a6Zy!xe2ew^PXYeZ!__eer3e!Xye3bzeeV3XzcPPQf_P7B!3ZM7ZrXCey<ae!Z!eaOee^8a!e>^CX-888c_eP*8Z8zye!8ze6Ztez*7e6fz{7&3PZSyZroCZ^SreZ3!eraee^PXeCr8ea8C88&aPP(C7_Sye3wXeP3?e_r7e3rZeeCrez87ar#ze^>8!C{!eaECZ!rXeZ38e<zPe8x_ee8e!_=eZ3Lr!y%QezA7e3eZeyrre_8^er8Ce70rrCc7yaSr!!0rPew!Za!Pe!r_eaX3e_>ye!=zXyQ8PzqPPfda37 4ZZr^e3uCe_8aeCv!er8C!!-rCeoZZX1Pe8KXZXz3ea8yeC8zeyFDezKyz 1_P7G3ZZ2^ZrQZe^eaeZa!e83ee^rXeC8!XXQCP8L^7Ph3e_Hee3ZzePr9e_r7e!CZey83AZDyer}8Z^WaeC ^Zrzee73Xe388eXoPe!8!!PI!Z_-rZ3:zeyj0ez77e3rZeP8reZ8^eRFZa^>=yCf_PaHZP!YaZee8earPeCX_ePA3eaOe83pXPy(8Pz1C3EvzZ7Cre_F^e!ZCe^maeZ8!Xa9ZC!U88eW8eX}eZez_eC83e*Zye3BzeypxrzWPPg>_Z7-rZZ 7erPCe7aaeUe!erree^8a!eN^PXSr78m_ePK!e_eye8rzePrLeaC7e38Zr7Q3eZBa8rpCe^wrZCe!e)3ee_ZXee48ea8ZZ83aZPGz8_5ye3#zey8*e_r7e88Ze78rezG7ZrEzy^5rnC&7PaWee!_XeCX8eaCPe!a_ePv8X_Ley3vX7yu83z%yZ3QZeyrre_e^erHCe^Qr7C17eaAZP!DXeeA!ZazPe^3_e_73e_1ye3Y_eyi8ezFPe{)_C7lMZZz^e33Ce_7aeC#!eanF8!)rZeg^PXFPe8d_e^83ea3ye38zey8Tezy7z)3_C7=!8Z8^Cr-CC^Ta_3C!ealeeyZXZe38ea8^^85aCPvZe_qye32ze!!QeX87e3rZe7&reZ 79r&zC^qaZCu!CaQCZr_XeZ38e^!Pe8<_eP4C8_QeZ3BXey;Lezh7eX8ZeP3reZ8^er8Ce^yazC37Cai_z!8XCe58CXOP_ZC_eP:3e>!yZ33zeP8X^zOPC}tXP7wreZq^eyZCey8aezG!eaoee^8eye(^zXi__8E_eP,3eC3ye!3zee!wez37e5yr!7J3CZT^rr2CC^laZCD!ez7ee!wXeCP8eXgPe8RCXPm3e_xee3Jzey}/eZ=7e88ZeyPreZf^eG8z3^duzCL_maoee!IXee88er^Pe^O_ePD3e_}e83;Xzyo8_z<7echZe73re_8^erUCe^8aezy!Xa9ZZ!d8ee88CXDQX86__rC3e_kyey:zZy3WezQX8NT_Z7t3CZK^erJCeX8aez8!ea3ee!3Xeeh!PX3Pe8x_CP&3e_{yel^zee8}ezf7em?Ze7y^!Z}yzr5Z^^,aCCm!CaxeeS7Xee<8eazPe8c_eeway_ueZ3)!yyT8zzJ7a^zZeP!reZ!^er3Ce^3aeCuWXalee!nr^ec8eXMPayz_eP73e_7ye33zey3tezB8XMbZe7:38Z5^erDzerzaez^!eS8eeZaXeC8!rXQCa8273Pw3e_bye3CzeePlezB7eJ3Zey8+cZwP)rD!_^/aeCT7ea_ee7eXeZe8eyzPe^v_aPc^;_+Cq3V_Zyo3e_!7e8PZeazre_e^ec8CZ^V3=CLZ8aJee!gree88erePe^e_ez83eX8e^32a8yi7Bz;7ecNZeyPrC_e^e3ZCe^0aeCOzXadZ_! Xee&8ZXGCe!Z_eC73ea8yeeazeP83Pz&Pr0ma^76reZ6^eJXCeyeaeCN!eaPee^8r<eV73Xxey8b_ePm!e_Cye!CzeeCke:z7e38_87,88ZT77r5Ce^vrZZe!edzee!XXee=8eXSC38Wr3PO^!_HyZ3S_ePXueXe7e^PZePCre_TP^r3_3^>&yC<PCa5Ce!eXeZe8e!ePe^C_eZc8y_pCt3x3eyAPez&ee3XZePerezr^eP8Ce78arChy3aGZ^!gXee=^ea_Pe^C_eCC3e3zye88X8yD!8zGy7N/Ze7d%ZX7^e3zCe_8aeCn!er8C%!OR^e<!7XNPe8,XZPz3eaXyeC8zey:vezYyz)EX37<87Z9^Zr/Ze^aaeze!e3Xee7CXeC88aXuZ38?a^Pg3e_2ee3^zeeCpeXC7e3yZey88_Z6P8rD_C^faeCN^Zr!ee7zXer38eX(Pe8%X7P2^3_ C!31zZy)3e_77e8eZeX!re_C^e8)z!^/3vCme^a9_e!uXe8z8erCPe^^_ePh3e_YPZ3wXXyS!3zh7Zo:_ey7re_y^e38CezaaeZ8^7aoz,!)^aeA8eXiPe8Z_eCC3e_4ye3Tzey}3!zEe8%9_X7VreZ+^eY3CeyyaezZ!ea3ee7)PXeA^aXoCZ8A^yP,8Z7_ye!ezeCr,ezO7eA2z97L83Z0^erDCZ^#heZZ!euZee^aXemr8ea,e38#r3PVe^_9C83%aey!;eXC7eP8ZeX_reZq^Zr*_8^,LXC,!eanee!_XeZy8erZPe83_eC1zX_hea3MXZyceyzVyZ37ZePereX_^erWCe^),8C;y3adee!jX_eW7eXCPe^C_eXI3e_7ye^#X^y?!3zwPPiW8Z7JDZzZ^e3ZCe7_aeCf!ebtC^!%68en78X5X!8VXZez3eazye37zey6/e_8880mX^7JPZZf^er0ZZ^7aezX!ea7ee!=XeC8^3X)Zy8A^ZP,3e_Tye3!zeeZWeXa7ep8ZeyQA^ZVP3rj3z^H38C-yerPee7CXehX8e78Pe8;XCPN^8_IeX3:zeyx9ezC7e8yZePZreZ8^e3AZP^q,rCg7Zadby!uaZC88erCPezC_eP}3e_o7_3fa8y=*ezjy!{{XeXere_Z^eC7CezZaezd7!aUz!!YryeqyCXpee8P_eCZ3e8!ye!zzeC63zz,e8Y98C7=(7Zl7Zr8Ceyzae!^!eaQee79XXe97!XUZ!8WP!Ph!eXZye!zzeezoevr7e3?za7}88Znr!rS_!^9rZZr!egzeeeCXeex8erjCb8=r!Pn^!_c_!3:_ZPzbeX_7e8PZe7Brez8^zrp_7^2*rCw!ea0CZ!PXeZa8eaePe8M_ee8!8_FCP3*XEyUiez?7e33ZePzre_r^er8Ce7/PaC9y8a/Xe!mG!e4!ZX^Pe^z_ePa3e_Lye!i_zyW!!zqe!=0<!7%NZzw^e3_Ce^XaeCh!er8CZ!ER7eh!7X4Pe8m_ee33eazye!Xzey8{e_Ry7JwX87o!rZSP!rq_eC!aezZ!e^1ee!7Xez,8CXuZ88<aPPLCZ_LPZ8!zeezue__7eHEZeP&drZQP!rp_!^g^!C9^Za!ee7_XeeX8eXlPe!8a7P-^7_paZ3hzey03Zz_7e8aZe7XreZU^eG8 !^23PC>zZaVee!nXee78erzPe^r_eP83eXpPZ3xa8y=^7zYe!}#zZy4re_z^em_Ce^iaezV^za6z!!nl!eKe!XLeZ!8_eC_3e_7ye3)zeP83_zVe7i=Zz7-reZt7Z8^CeyaaeC7!ea(ee^8azeh7PXMPz8>_eP<3e_!ye!zzeerDez87e3GzC7Q88Z:_zrw_!^03eC!!e*ZeezXXei88eX,r88hr!PG!a_fye3Wze!3IeXP7e8zZe73re_t8er*zr^<OZC%zya(CZ^8XeZC8e2_Pe8E_eP:8X_&C83xzey*6_z)Pej^ZePzreza^e8yCe7m58Cqy8aJr<!gR!e 7eXrPe^Z_eXp3eKrye^5_Oy4!8zGPPfk8Z7n+Zzr^e3zCe7_aeCs!eMfeZ!*?!e,7!XqX!8{XZe^3ea_ye37zeyoSe_8yCSDX77hPZZ>^er2ZZ7Paeza!ey8ee!>XeC88rXLZP8oY8PM3e_Yye3zzeezheXr7eB8Zey}PPZ?P8r;3z^N3!Cf!erPee7zXeZ78eX;Pe8=X!PV!r_KC!3<zZyw8ez^7e8eZeP8re3a^e&8ZP^q38C:C8aOee!cXeCX8erzPe8i_ePP3eX8Pz3Ta^y4Z_z67e)c_e!ere__^e3_Ce7XaezKrXadz^!uU^et!^X5ee8e_eCz3eXXye!_zeCq3Pz?e!Vh3!75e8Z1yer3Cey_aeZa!e^zee^mXzet7!X+zz8hr^P=^eXXye!zzera#e337e!cZa7:8!Z6ZerNCX^wrZZr!eu_ee^_Xee>8er,eX80r^P=^^_x_!3j_Zy_EeXX7ee8Ze7irez87}rO_y^ierCV!eaLCZ^eXeZr8e78Pe8&_ee83r_-Ce3&78yJ=ezg7e*rZeP_reXM^er8Ce79zyCKy!am_7!H#^eS!ZarPe^__ee_3e_tye!?zry*!^zhe^*i !7JoZzX^e3XCe^7aeC4!er8C!!gmyeWyaX)Pe8{XZP_3earye37zeyu}e_8y3:6Xe7NPZZ4^er4Ce73aez_!e3Jee!8XeCnZPXhZ!8W^zPg^^_Eye8_zee_=eXP7enFZe7jraZWPGrs_^^EaZC17eaZee7CXeZ88e^aPe!8XrPg^!_s3^3UzeyKlez37e8_Ze7VreZe^e?8Z7^d37CWX_a-ee!4re)^8erXPe^X_eeX3ea<P!3Ba7yW!7zIXrpHzey3re__^e6XCeyXae_i^8aTz^!0^!eE^!X#Ce!7_eCX3eXayePzzePK+Zz/e^E2az7:87Z)PeIPCey_ae8a!e3^ee^8r7eR77Xtey8G_ePA!e^Xye!XzeeXJeuz7e38Zr7-8yZn^Xr=Ce^6rZCX!e)ree!XXeeH8eXlPX8Fr7P{^P_NyZ3o_eP8MeX_7e^PZePXreXk^Zr0_^^k^eCg!XaLCZ^7XeZX8ea_Pe8g_eC*CC_GC730a7yRy!z}yZdyZePareZ7^ergCe78a_CTyPa2eC!OXeeb!ZaPPe7(_ePX3e_9ye88_ey&!Cz,XZ4+Ze7BreZ!^e3XCeP3aeC8!erxC_!mo^e*y7XNZ78<XZer3eaXye8_zey*9eXhy3s+X77(87ZfZ!roZZ^Caeza!ey8ee!GXeC8^^XcZP8/__P;3e_uPZ8XzeCnUe!87eL(Zey838ZvPCrKC_^VaeCj!er8ee7XXez38eX8Pe!9aXPF^^_Qaz3%a7yogez77e8XZePPreZO^er,Z3^u33C6y7a0eZ!#reC38erZPe^C_ePz3ea5e73Ga8y/!8z2Zy:?ZaCzre__^erkCe^3aeC3!eah7X!pXeel^_X+Pe8;_e_X3eaZye!_zey3;ez#P^bpX87&3zZH^er=Ce^zaezz!edPee!1XeeB!_X%Z^8YaXP=3e_Lye37zeeZKeX_7eL3ZeP+krZEP8rhzZ^&yyC5^Zreee7_Xez_8eX6Pe8/X!PM^7_Iye3-zzyD!ea37e8XZezxreZ7^eW8Z^^43yC}7^a*ee!EreCy8eraPe^a_e_z3eX8yz3/aPyfeZz#7ecizZy^reXJ^eP8Ce^haeZ8!ZaMzC!}7Zen8eX=eZ8Z_eZ83erZye3dzeyp38z3eyQiXZ7BrZZU7erCCeyXae_X!e:aee^8a_e%7yXUC^8p_eP#!e_Zye!azeea)eJz7e38_^7T8PZg^Xr?Ce^prZZy!e3;eez8XeeH8ea8e!8SrCP{3X_Dye3m_Z%afea87e8^Ze7SreZQ7Cr3_y^53ZC}!Za0Ce^XXeZX8e7!Pe^a_eP53z_pCy3NXXy:Qezs7eEyZePZre_a^er8CeyRaaCSy!a<ZZ!67yew!ZaePe^X_e_Z3e_vye3jX8y}!yzR7ex}Zr7#=Zy_^e3rCea^aeC4!e?dP+!,VPe(7PXSC78{ae!73earye!rze239e_#P3{UXy7t37ZMPPrw_e73aeza!e^zeeCCXeZF^8X4ZP8:ayPde!_+Pe3Pzeeacer!7e8rZeeS3!ZKPyr%!y^g^ZCiyer8ee7aXea{8eX7Pe!8aPP=^P_se^3Ozeyu8e_Z7e8rZePrrerz^e28Z!^,3eCczZa{ee!:aZCP8e03Pe_P_eP+3eX8yX3UaZy/eZzJ7eG-zZyereX!^eCPCe^oaeCj^ra*zP!quzex8ZXNeeaa_eCa3erXye!rzeP88Pz)eP<L_^7sreZmyeS^Ceyraezr!e!zee^8XZeo7eXoPX8Q_ePD8ZXzye^3zeay%ez57e38_77?8ZZK_Zr+Ce^-rZC_!e3!eePZXeeL8eX(PC8=rPPi^z_GyZ3s_e8aReXa7ee!ZePrreZU_8ri_P^+38C/!eabeeO3XeZz8errPe83_eCmre_5C!3+XZyUeyzFyZMXZePXreX_^erkCe^UryCSyya<ee!jXXe&^ea3Pe^r_eea3eyeye8=_8yx!yz}_1I}XP7d8eZC^e3aCeZWaeZZ!e3mZ3!xdyes^PXirZ89XZer3earye8_zeyITeX47auAXP7-8PZ)Z!rSZZ7Pae_0!ey8ee!JXeC8^1XKZC8qyrP=3e_OPZ38zeC8ve!87e{*Zey8HXZnPzr&8z^;aeCH!er3ee7rXez!8eX8Pe!TCyPS^y_}Z73UaPy,3Z_r7e8rZey_reZt^e35Ca^%3PCWyPaxa!!IaZeP8el+Pe87_ePE3eX8Py3UaCyfeazn7e:ozZ77reX8^eP8Ce^saeZ8^Xaszz!038e,8eX%Pe!^_eCr3er!ye38zePRePz#ey2E8z7E8PZM^erZCeyraezZ!ea/ee!xaeeO7!X{ZP8J_ZPU!eXPye!_zee8&e8a7e38_!7v8yZ*zarICe^,aeZ8!e(ree!GXee38ea8ez8jrePGya_Dye3&XeXC#eam7e!JZeZzrez87_rl_C^WyZCG!eaACZ^8Xez88eXyPe8f_ePT83_BCe3qaZy22Zz9yeD7ZePrreaz^e8sCe^NrCCLyeapz!!VXee*8eXePe^__eZ}3e_3ye!0_zyU!^z2PZ9A8y7bUZzy^e3aCeyyaeCQ!eaMeX!u)Pet8eXte48}XZ!_3erIyez^zeybMeX*Feq(Xe7A8eZsy7r=ze7yae_Q!e3see!_XeCY!7X#ZP8Na7PQ^e_:Ce8yzeer>er^7e7aZee1neZ5PProx!^<y8Cd7e/_eCy5XeCa8e!zPe!;_ZP:^P_lZz3#aey,!ezC7e8rZeaareH8^e8ECa^o3PCiCeaTeX!)aZeX8ej&Pe!__ePp3ea=e83Maeyg!ezjz!50zZ77reX3^eP8Ce^UaeZ8yXa0zZ!+P8e*8eXleZ8^_eZ!3e^8ye3wzeP833zAe_(c8Z72reZ&^eJZCeP=ae_^!ea8ee^4aZe)7PXNz789reP>8ZXPye^TzeP_?ez47e8Mz!7O8eZ<Pertr!^VrZ!a!e33ee!7Xeeh8ea88y8prZPkCP_Rye35_ZNajea!7e&7Ze7Krez8ryr;__^lyZCv!eaBee^3XCz=8e<^Pe88_eeD8Z_-CP3t!zyN!ezj7e3XZeeQre_z^erMCe^bazCty^aFze!cXZe&^eX!Pe^X_eC83e!aye88zryx!Pz,/^Y)Ze7?reZC^e8LCe^*aeCC!eRHz^!3}Ce;^yX68c84XeeC3erUyePezeC3-eaYyy+kXe7D7eZ/P!rQ_e7eae_}!erreez8XeC8!_XnZC8ka^P#3e_hee3ZzeC3Lea37e7zZey8)yZ9PZr-3Z^MaeC>^Z37eey!Xe8P8eX#Pe!8a^P)^__&aZ3Yzeym3Z_e7e!7Zee7reZD^eruZ^^;3CCTyXa4eZ!:aeC78eiDPe7X_eZ33eX8ya3#aCyb8^zk7eOS_ey_reX3^e83CeCzaeZ8^ya}zZ!qXXeu8eXLeZ!Z_eZ!3e^yye3LzeP88^z#e_9H8Z7)reZf7Zr3CeP7ae_Z!eaxee!Sa^eY7CX2ZX8h_ZPi8eXzye^Ezea!kea37e!?3_7v8eZ9z!rw_7^5rZCr!e33eeX^XeeA8erxeZ8vrCP#^C_ke73GXeP! ea37e!3Ze7_rez{y3rs_e^dR7C;yCaFZe!XXez38eaaPeez_ee&3z_bCe3frzy*!Czmee33Zee(re!a^e78Ce^(!ZC}yCaSz8!)XeeK8eazPe^X_eZ33e_8ye!<_Cy>!yzRPZTu8y7UiZz3^e8LCezyaeC+!ea2Z!!YlCeo8eX0PC8*XZPC3er8yeyyzey;=eXnyX0vXZ728ZZ5Z!rDZZ^CaC_!!ey8ee!mXeC8!ZX5Z_8<_aP*3e_:ye8CzeC8fea^7ex8ZeyprZZ0PCrUa!^/3ZC:!erseey8XeZX8eXtPe8O_aP+^y_)CZ3tzCy#8eCk7e8aZeP8re3a^eJ8Ze^f3eCuPPa9ee!*XeC^8eL3Pe8)_eP!3ea;eY3SaZyT8yzOaP}fze7_reX3^e7_CeP8ae_5^!amzC!l^ZeDe_XlZe!C_eZ33e8yye!hzeyQe8z-eZYNX77mreZ2^e_3Ceyaae_8!ea3ee7Kzee-7yXdCZ8S^yPp8ZXeye^kzet_=ez57eq>z!7-8CZ0^erWZ3^RveZy!e38ee^aXe8e8eaNee8brCP2eg_9CZ31aeP^6ea37eywZePzreXO78ro_C^>SPC(zZa?CZ^rXez88ea_Pe8(_eCE8P_NCZ3=aZy;y!z;yZVaZee!re88^er-Ce78E!Chy_am8r!2Xeek!Za3Pe77_er83e_,ye88_^yY!azvCyD/Ze7(rez5^e88CePyaeC8!ert7y!qVCewy7X<ZZ8OXZer3er8ye8_zey%oeXqy!0dXZ7Y8ZZ1Z!rcZZ^aae_!!ea7ee!sXeC8!TXtZ_8o^aPE3e_TPZ8PzeC7Be!87e*>Zey8raZ&Par}X8^4aeC(!ea_eey8Xezy8eX8Pe!wCyPS^C_iaz3KaZyt!e8^7e!3Zezzre!_^e-8z!^+3ZCHX_aBee!&reee8eJ8Pe78_eeX3ea{Pa3EaZyk!ZzUy^?Wze78reX3^e:XCeP8aez#^aa0zZ!{ryeSC!X0ee8z_eZ33ek!ye^8zeCR3CzceCxn^y7f7ZZp^e^8CeP8aezZ!ea{ee!hX_e}7yX?ZZ8S_ZPO!eX3ye!rzee8<e8a7e38z37R8CZuzarSCe^faeZC!e38ee!+Xee38ea8P_8DrzPNya_Jye3fXeP_ ea!7e!!ZeZzrez873r3__^hyZCo!eatCZ!!Xez78eXyPe8Y_eP)!7_:Cz32aXy>YZzSye,rZee8reaz^e8!Ce^qr3C(yzaOzy!vXees8eayPe^r_eZ!3e_3ye!UCey}!PzxPZ0M8y7J:ZZP^e83CePraeC/!ea;Z!!(gZeM8eXtPz80aePC3er!ye8azearse_AyaivXZ75y^ZpPzru_e7Pae_8!e78eeC^XezN^8X5ZZ8f8aP=!e_(yeeZzeC!ieXa7e{;Ze7vyrZvPPrw_z^<aCCE7ea!ee7rXeZa8eXzPe^tXzP)^P_hCP3ggyyBkarz7e!3Ze78reZ3^er8Ce^czXCI!ea1CX!NXees8eZ7Pe8&_eeZ3e_Tye3x8ryd!Pz<eCRRZC7i3ezZ^e3rCeyXaeCz!eu/ea!(2Pei7PX#_y8Q_azz3er3ye33zey36ezy7e(DPX7RreZtP^r/Ce^Baey7!ea}ee^PXeeY8eXQ^X8{_eP6!8_bye3;ze!7(ezo7e84Ze7HreZI3Xr1Ce^BKCCB!eaQee#7XeeA8er^Pe8%_ePf8c_3CP30aCyl9Czb7efyZe7treZ3^erOCe73aeC}!ea3ee!KXeeK8rXOPe89G_X7ez!^XZPr!3y={_z27eb9Ze!XreZp^ercCe^Faez%XXaRee!SXee}8CXMPe7Z_ePO3e_8ye33zeyw3Pz37ekLZC7YreZ1^ermCe^OreCY!eapeZ!(XeeM8eX9Pe=fdPPY8P_1ye3 <z_7P_ra_PP^33zyy39!ZCy^M3Zr7yC/!rabee!O3zarCy^^XXea!_PJ3__Jye3,?__CP7377eh^Ze7%re3^ZCy!E!^YJ7CF!eamX!C773ZAC3^!CeCy8CX_e38^Cy!0rC_!yz37_zP!_ezPyZ63zyy^rXZ^3yCU!raBee!68zr7ez!!XXC!!zP83e_vye3Nzeyj3Ar 7evPZe75rea^ZXy!s_z87PgC!ea7ee!WXer!Ce!3area_ePz3e_Aye7^3XX!yz88_3P,3_zCyPFa^erZCe^(aeXzCX7CZee!73r!C_!7a78c_XP-3e_1Z_P78^_3e3z>7_RRZe7/^_k7_Ey^Ce^CaeCv!e7PrZCC^_a7ea!Ca^e7_eP73e_kyey^83X^P^377e3XZe7IreZkXyr{Ce^SaeCT!ea,Ze^XXeeU8eXjPe8a_eP18__byC39zCyw*ezJ7ek^Ze78reZ{^erWCe^ x7C/!CaOeZ!,XZe(8aaCPe83_ee_3e_3ye35zey^C3z)7e i_^72rCZj^eXXCe^3aeC8!eafee7waae38CXgPC8{_ZPW3eX_ye3!zeyTwez77e!iZa7VrzZ/7erYZ^^u3eCZ!ea!ee!zXeeP8eNGeX8W_zPh3z_Mya3uaeyzcez!7ek^Ze73reXJ^zrbCz^jr7Cq^KaNeezZXee38eX!Pe83_ee88!_JyC3Q_Py=)ezY7e3yZe78reZ!^er&Ce^RraC0!za+ee!hXee)8ea!Pe83_eP!3e_3ye88__yjWCz97XqMZe7%3ezX^er3Ce^3aeCZ!eayX!!pXZe=8eXSPC8=_CPc3ez!ye3nzey^(ez97e=)a87)rCZA^Zr#CC^}aePX!ea3ee!7Xeeu8erx3X8?_CP#3C_NP33czeCZ-ez37es8Ze73reZN7Pr3Ce^BaCCB!ea*eC!oXeeW8eXYPe8M_eP!3e_jye3qZ7y*Fez27eg>Ze7*re!8^erkCe^3aeC3!ea2CP!3Xee18CX?Pe8S_eP:3e_SP!3czey=bezZ7eV#ZeCz7X3Cye^!33z!7_r7Z7a8ee!NXeep8eXmeby>_ePz3e_{ye7_83_aP!XwCzyr3ezC7X,^^erzCe^taeX^CX7!azZ8^3rYC_!CaPea_ePr3e_pyey!3XX^7y3r__yCnazC7zG3z_7CqPZaaeC^!eaJeee^^3aXeXXNZ!8(_ePdy_8e_X!=8^_CPy3zPeye}C_!3eQ8ZX77}yyV^zrrZe^CaXC^rer^CPrVr3er!Xa8!e8!X^PC8e_8PP33_Zy^Xy7xrXZq^erAX_Z77^r3z3a+er!4Xeecyz!rayC^8XXae__8ye32zey)%ezJ!e!rZe77reZ1^e^^43z^7^r7!ea_ee!MXeeYaBXtPe8u_eP:3e_Mye8Zzey+=ez37eS3Ze7wrrZO^ermCC^<aeCL7erZee!OXeeO8eX7Pe8/XUP=3Z_Iye3?zXy2!ez37e(8Ze7zreZ3^e8jZ3^naZC#!_a/ez!RneC38eX8Pe8C_ePP3erFPC32zZy9Iaz y8sGXey3reZ8^ereCe^8aeCB^?a3ee!EXZeu8CX<Pe!z_eP=3e_3ye3Bzey wezv7eq!Ze7(reZU78rfCe^;!3raZe77r_P8!XaPeC!aPe8P_eP63ep!XPPa8y_7yz8^7eO_Ze7;reaCzyyE{Xz^8zreCC^aarC7!_e8!ZX#Pe8%ae7e3e_7ye34zey3>eXdrXR1ZX79rXZE^Zr}CaezaeCP!ea3ee!3Xee^8eX<^X8k_eP>3Z_=ye34ze!74ezB7eH!Ze7#reZv3Xr(Ce^qa_C2!ea/ee 7Xee,8eX3Pe8q_ePSaC_:yX3#zry 1Cz}7eaXZe77reZN^er/Cey:XmCk!XaDeX!nXzeA^eP7Pe87_eP73e_8ye3y#!yBTrzi7eHHZC7Rr_Z>^e_7Ce^1aeC8!eaUee!,ZXe58eX6Pz89_eP/3eC7ye3?zey3hez<7evcPX7nreZw^_rOCe^{aeCe!Ca7ee!PXee38eX>PX8c_ePl3C_4ye36zZyARez,y8ONZe7{reZy^erWCeer^aryZz^7r_!KaDem8eXv_eer!zXCe_8CXPPazey3AezM7e7eZe7^reZ,^e!7myz777C2!Xa,ee!/8za!eC!_XX8F_XP 3e_jzX7^83_X!Zzty7ffZe72^7grzXy!rXeX7P&yCX^XaXCa^_ei8zXHPe8h!yX7er_jP73bzeyQ7X8!zXP8r3zaye37z_^^33z-^XCv!Ca4ee! !3e3^zXLPe8n_e7X3e_3ye3pzeybiezy7zD3ZC7Lr_Z ^CrBCC^Va_3C!eaoee!^Xee38eX^w38-_eP:!Z_KyC3HXe^e4ez37e=OZe7Crez83^riCZ^Va_CY!eaWZe3eXee88eX8Pe8C_eCwh;_byZ3uzZy;jrz}7aCrZe73re_8^er3Ce^8aeC^_3aHee!vrZe48CXmCeQe_eP33e_Wye38zeyDZ7z67ZU+ZC7dreZc^erPCe^3aeC3!ea8ee!GazeG8ZX2PZ8?_ePf8ZXeye3!zeyyBez&7e8vza70rzZ=^zr}Zx^4aeZz!ea^ee!!Xee,8er6e88q__Po3__gyz3nXez_0ez^7eE^Ze77reZ/^arGCX^&azC/!eaJZe!8Xee78eX7Pe8!_eCu8__iyX3WzXy%1CzQPe3eZe7yreZ3^er!Ce^nu!C=!XaOeX!kXaej8eXrPe8y_eP!3e_9ye!T_Xyp{az*7a%Yz87?3eZa^eryCe^yaeC7!eacea!TXrec8zXIPe8{ae7e3e_Pye3PzeyZjeXb8!f{Zr7(rrZ ^Crgze7zaeCe!ea3ee!ZXee<!MXOPr8F_rP<8j_(ye3Xzey!RezP7e<8Zey#q^ZK^Zr{CZ^,azCi!eareC!#Xee38eX(Pe8K_eP>3e_yye3=zeyd5_zk7eB)aXzayX#X^erPCe^}aeX!ZP^aryC7!zr^8eXPPe8/_ez!e483XyPP3X_^9ez_7eh1ZeCXyP37zz77XZz77_O^ZP^azC!:aden8eX,_eer!zXCe_8CXPPazeyXHez,7e773zz7yZaCzyyF:Xz^!_1CZe^7eC^^Xee/8erEyP8v_CP/3e_Dya3,_ZyX5ez87eR3Ze7Tre_c77r}CZ^uaZC;!aa}Ze^XXee88eX8Pe8^_ePy!7_UyC3=_zy/1Czb7Z0QZ_XCreZ-^eA!Ce^3aeC9^^a1eC!>XCeS8eX/Ce7X_eP83e_:ye37zeyl3ezG7zs}Zz7greZgyer8Ce^!aeC!!ea7ee!&a3ec8zX2PZ8f_eP>3e_eye38zey3MezH7eD>Za7trCZb^er Ce^W{eZC!ea3ee!qXee!8er(C88<_CPh3C_,yZ3FzaZz,ez!7e&hZe73reZ8^er%yX^NaeCd!eafee!UXeP!8eXhPe8?_ePJ3e_f!C3NzCyGMzzU7C%?Ze7rrCZR^er3Ce^faeC3!ea)ee!!Xeel8eX?ey8,_ePAyX!!_Xe8<3_aPe87__7!3_z3y_k7^er!Ce^#aeX7Zy^^ee!^Xee*8e37ayC7!7PQ8!_Vye34zez^<ezA7ex0Ze76re_g7HrFCe^EaeC9!CabCZ!PXee38eX!Pe8p_eCK8e_9yC3fzCy)iCzGPe34Ze73reZ3^er8Ce^yrpC/!eaAC/!?XCe28CXsP_ZC_ePq3e_eye33zey^C3z&7e6bz87SrCZ-^er_Ce^4aeCI!eacee!4rCef8eXMPC8W_ePY3e_ryC3uzey3=ez-7e?-Ze7Lrez!^ernCe^JaaCS!eaQ_PCa!CaXeX?XPe83_ePh3eaXye3PzeybYe3_C_yCgrz7yz3^^er!Ce^gaea7ZZ^_ee!yXee*8e3XXXC^!GXrP__:yr3&zeyiP737_zP!(CzP7XZL^zr6Ce^E8rX7e_aOeX!tXee2Ca!3a^C78XP83e_+ye3jzeyLP3rR7eo^Ze7Kre2eZCy!:)^5r8C{!eaUXzZ^!Cr^CX^!zzer8_X73e_^ye3>ze_^yC8^zCO!ZC7wr_ZV^erDXZZr^_nC!eaPee!TXeZyCy!raye!8XZX3e_Pye3Kze__^_37zzyrh_z7rezz^er6CeZy^CrCZ^^7a_7o^_ar^e^yXXC8!3XyC3aBX3Pa8__7yr88_3P^83PareZP^er+Cez!7Xr!Cz^7rzZ!XeeX8eXAPe^r!ea7PZ8_X3P!aP_yP^33zr8rZCCZreZx^ervZe^daCC%!eafee!sXeC78eX3Pe83_eP83e_myZ3vzZy)mCz*7ef6zZ73reZ!^e(!Ce^RaeCd!_aEe_!/XZeM8eXTPe8C_eP73e_!ye3-zeyD8Vz*7_E5ZZ74rZZJ7Z!!Ce^7aeC3!ea/ee!Va^e48aX-Pe8N_ePO3e_Zye38zey8jezy7eBVze74rzZ&^_rJCe^9aaZX!ea!ee^3Xee38eXJPe8^73PM3e_?PC3(zCyvde8Z7eV!Ze78reZq^e:8^y^Da_Cm^Pa;ee!fXerZ8eX7Pe83_eP(3e_BZP3VzZyWxzzk7Xg)Ze!XreZ!^er7Ce^JaeCu7aace_!0XeeJ8ZXKee8y_eP^3e_^ye38zeCJ37z&7_DmZX71rrZt^ereCe^!aeC8!ea8ee7ba7ef8_X>Pz8,X!P5!a__ye3^zeZP6ez37e%CZe7^e3Zn^erTXr^)aCC2^ZZ_ee!^XeCA8eX}Pe^QzMPL3X_0yz3h_yy?Kee87es^Ze78reZ8^e3ge0^KaXCn!_a/CZ!/raya8eX7Pe^+_eP33e_Xye3^^3y9cezcPejbZC7=r_8C^er>Cee3aeC3!eaIP7!&XXeM8_XvPe8h_aX83e_7ye^Xzey3Rez}7ev^!37+reZqe7rVCC^wuePe!ea7ee!^Xee_8er=1^8%_XPb3X_VP83R_Zya=ezy7eq!Ze7freZv^XrKCr^gaZCd!ea0Ze!XXeee8eX^Pe8__eCd8C_wPY3(_fy43Uzl7e3!Ze7PreZ8^er8Ce78raC&^da{eZ!TXeeq8erCPC8C_eP33e_Wye88_7y#38zh7ZRNZe7Arez7^erzCe^yaeCD!ea>Ce!5XreH8rX:e!8J_eP73e_yye38zey8>ezyyC (ZX7k8zZW^CruCa^9a_3C!ea,eey!Xee38eX^E38H_ePk^r_hyC3dXe^emez77e6^Ze7_re_A!FrhCX^RaXCY^paveeQPXee78eX8Pe8l_eP^Z3_1ye3{*3yGACz97eaXZe77reZP^erkCe787XCL!aaOCC!jXeeb8ea8Pe87_eP83e_3ye35zayN;Xzv7Xt/Ze7Irez8^er7Ce^8aeCA!ea^Ce!-XeeVP3X PC8iae7e3e_7ye3^zey_seXH^;d)ZX7wrXZY7brJCe3PaeC7!ea8ee!HXee^z3XGPe8l33PO3C_dyerXzey7YezP7edcZePbC8ZB^ar?C_^5aaC1!eaeee!7Xee88eX3Pe80XXP:3X_SyX3#zeyxBe_87eV7Ze78reZB^er^ZK^OaeC1e3a?eC!LXey88eX^Pe8^_eP13e_B!r3(z_yQQZz47e*(Ze7rrCZY^er3Ce^9aeC&!ea)ee!ZXee-8eXsPa8k_ePsyz!^_Ce^8XX!Yez77e gZeZ^y33^z^77Ce^raeCq!e!!aXZ^8yarC_!CXaeC8zX3e_8CXPPazeyZdezH7e^z1X_C3er!_3y!S_Z777C8!ea#ee!(Xee/!_3NPe8z_eP}3e1^_Xe!3zX8P386__yC3PzareZ^^eroCeC^73rXCXa(eX!+XeeTy_!7a^e3^3PF3r_Lye3:rz_rPy8^zXya3_78reZf^erBCe^p_e_r!CaZee!kXeeOaPX*PC8*_eP93e_Yee3^zey3nez37eE!Ze7n33Z6^zrLCe^%aXCDyerCee!!Xee88eX^Pe7hXPPE3z_Aya3uzCyU3e_87eF!Ze7CreZh^e8uC_^<azCT!ra1C8!G1ee88eX!Pe8e_eP73e_9P=33zCyF&zzO7CNJZe7_reZ#^er3Ce^5aeC4!eauee^CXee/8eX)P_8x_ePQ7Z8r__eCzeyXhezY7e8r3e_77Z<_z37!_Pz!7_r3ZZ7^ee^OXeeQ8e!3aeCi!^XCPz83X_PC8P_a!P3Z_zyr3y7YrrZ2^er,nzZ77ZRyZ3^!aX!Va8eE8eX2a3e^8XXae_8C_aPC3XX8feze7e4-Ze_^yP3!z_y8g3Za^rC5PCanee!L73arCXr)XCC88XCFPZ87X3Pa3reKPZ33__y7_ez_y3=Xz3y^rXZ^3^zoZe^_aXC3^za7^e^PXCeC!_CM^Zroeee!3X_!PP3az_P!_ez3yyn^yey^IZzCber3Cr^3r3CaVyef8zX=Pe8{3Xa8e^_Eyr3OzeyYP737_zP!oCzP7XZ-^zrGCe^(7XV8Z^anea!5Xee2P7!7a_ee!PX^3e_^ye3tzez*7P/!Z_08Ze7sreZI^e_%38e,aZC}!eaEee!}XeaCyeX8Pe8n_ePN3eekaZ7Ezey_dezA7e^!3Pzay_E7zyy^_7C^y31&CXaner!GXeetC^3^XXe!!PX^PX_-PX3Izeyb^a33_3y_6Xz^3e3^zP3lrzZ3^zreCX&?r^CC^yaz7yXuPr8k_ePYy/87_CP^3XX8Pzz4y8*mZe7b^z3^ZCy^pXz!8zrrC_^7ee!^Xee-8e!^XCC^8CP>3r_cye3:8^Z^P33PzXP!3_7RrrZJ^eru&^e77yr!ZP^^aX!,XreQ8eXdazC78zX!PX!!Xz3!zCyu7Czj7ebfZePZrCZA^erOCe^?aez,^ZaYee!,XeeW!PXLPe8__eP33e_3ye3izeyt3_zf7CA{ZC7#rZZo^aH3Ce^#aeXX!ea3ee!3Xee^z3XfPe8j37Pi3C_-PZX_zey2Sezy7eVgZe7vzzZH^CrtCZ^(aeCT!ea!ee!3Xee38eXHPe8>_ZP*3e_lye3tzZyIwezy7eR3Ze7!reZ{^erhCZ^WaZCn!eaoe_!)XeC88eX!Pe8^_ePo3eX8PZ3#z_yg*Zz%7e)mZe38reZ!^er!Ce^^aeZ*^za0eZ!laWeF8zX{Ze8P_eP83e_zye3_zeP887z47zVwzr7breZd^e?7Ce^^aeCB!ea8ee!Lareb8XX/PX8B_eP&8eXeye3^zey^Vez77e38z^7RrXZR7arnCe^;rZZC!eayee!yXee+8eXTe!8*_rP)3e_Uye3vzeZa9ezy7eMPZe7breZ 6rrMCX^>aeCA!Za&Ce^ZXee^8eX7Pe87_ePO8C_Dyz36zZy/%Zz{yewyZe78reZ3^er!Ce^SrZCY!zagee!)XCew7eX^Pe8!_eeH3e_!ye89zay9vZz,yzT1Zz7RreZ8^er3Ce^8aeC8!e:+C_!5XZeK8CXse_82aae83e_8ye^zzey3Seza7e<^!37+reZFe!r=CC^RrZ7_!ea8ee^3Xeet8er>yj82_zPn3C_VyC3Dze!89ez87eF8Ze78re_)!nrKCz^VaZCj7UaFZaerXee!8eg^Pe83_eeC3e_^r33Dzeyw!_zj7C{p_e!ereZ!^er8Ce77aez(7^a3ez!/XzeJ!8XIPe8y_eP!3e_yye3Tzey?8^zj7zp#ZC7*reZE^errCe^!aeC3!ea8ee!bXae;8zXVPe8-_eP53e_!ye3!zey3:ezf7e->Za7-r_Zt^arvCe^UaeCC!ea!ee!!Xee}8eX^ee85_ePL7X_1yC3Aze^Xwez!7eYPZe7Hre_Ky7r3C_^,aZCq^3aRee^7Xee!8eX8Pe83_ePT!!_}yz3pzey#-ezQPe3CZe7^reZ8^erCCe^>azCO!zawez!sXeeg8_XrPe8=_ez73e_3ye!%ZlyV-Zzm7C;cz_7A3arr^er8Cee7aeC3!eaXee!^y3eW8eX5zX8D_CPQ8Zyaye38zeyPoezl7eO/C77brzZ-^rr(Ce^1aey!!ea^ee!8XeeJ8eXme88H_zP93Z_6yC3,zey_6ez!7eWkZe7=reZn_8rKC_^/aZCM!eahee!8XCe!8eX!Pe8R_ee8_y_EyZ3S_ZypHezF7eaXZe7!reZP^erECe^2zzCm!_ajeZ!&XeeM8eXyPe8!_eP83e_3ye3D_^y}tzzi7egUZe7hre3Z^er^Ce^8aeCh!eabeZ!3XzeF8zXJPe8%__rC3e_Eyey{zey3#ezEy^GVZe76rCZF^erTCe8XaeC3!eayee!,Xee68ZX3Pe8c_zP?3e_Aye3rzCykQez37ewvZe7preZ-^esCCe^jaeCE!_aLee!9^_rCCe!7Pe8^_ePV3e!^_Ce!8!y8wez57eLRZe7{aeXr^erzCe^=aeX_ZP^!aCC_8ea_eC^CXXC8_eP!3e_}yePa3XXP}Zz+7eBNZe70reZW^erMZ^^iaeCuer^3r3Z^3aarCZ3!ajeC!^X^3e_eye3Vze_yPX3azzP^33zryyZ(^rr(Ce^W8rr3Z7^7_rZ7^3eF8XXfPe8=8_X7Pa87XZ3t_8y1WezMCry73_Z!7X38za7CrzZ7aeZ!!eaReeey^3r8C_^7XCe_33Xaee!7X_7X3C_ayC3PzXP8Ze7^reZl^eyPrCZC7_CR!_abee!c!ra3C7!7Pe8P_eP<3eKrXy7_3X_3Pa377e0PZe76rer1z^7333Z77Z5!!eaeee!jXe_CCy^!a_e3!yX!PX_RPe3*zey#7P3aCzyeLC_87CN!z_77qZe3^_r^CX^^ee!eXee>8e^8XXe38_Xye38__X3T_yyBuez _%yr3Pzzy7+7z_73d7Z77_reZP^^ee!7Xeej8e3rayy38_X^3e_7ye3UzeX!Pe33_ryaZZ7&reZN^ersCe^e8eC*^eaQee!u8Xr!eX^8_3ea!ea7e_3!_Xe88a_Cyz377eQCZe7Lrerkz^7333Z77ZXPZX^CeeZcXeeV8eXU878i_ePu3e_6ye3l_ZyaGez37e3!Ze7KreZc7PrJCZ^MaCC+!eawee!yXee38eX8Pe81_eP93z_,ye32zeyslZzN7a33Ze7Freze^er3Ce^3aeC^_3a4ee!Br4ek8CXbeZ_a_eP33e_yye3Mzeypr7z=7ZsEZe7vreZs7ZbZCC^!aeZ!!eaEee!WXZes8_XLPC85_eP/3eXuye3!zey^pez:7eA/ZC72rZZJ^erfCZ^&aeCP!eaRee!8Xeew8er9eC8x_CPO3C_Myz3F_ZPC(ez87eq8Ze7>re_M!UrmCZ^MaZC1^7atCZXaXee!8eX!Pe8v_ePW78_%yZ3HzZyASCzU7ah!ZC7Wreze^er3Ce^3aeC^_3aLee!Wr9e18CXgeyX7_eeP3eXeye33zey3pez^a3/WZe7W3bZp^CrcC__CaeC2!eaeee!3Xeey8zX3Pe8&a!PA3C_)yC3Fz_aClezF7e3zZe73reZv7Pr3Ce^faCC+!eaTCZr_Xee38eXaPe8<_eCOX8_EyC3FzCy)3!zNyZ3_Ze7!rezw^er)Ce^Dr!C-!Ca#ez! XZed^ea_Pe88_eP33e_^ye!O_8y&-zz?7Z>6_37;3ezZ^er!Ce^!aeCP!er8e_!vXXe=!3X/Pe8x_eP73e_!ye37zey8Aez9P^%4Z_7EreZ}^er{Ce77aeC7!eatee!/Xee,!^XuPa8U_eP)3e_JPZ8!zeyP:eza7eMsZePKr_ZJ^rrUCr^tr!C/^ZaCee!CXeCe8eXbPe8dXZP=3r_bP33{zZyW3Zza7eleZey3reZ%^e3w^^^qr+Cq^:a?eX!,aZC^8eXCPe8__eP53e_bPX3+_,y%pZzc7ZnfzZ73reZC^er3Ce^1aeZ8^_auC8!,a_ev8eXVPe!z_ePC3e_8ye38zeey3rz/y3hfXX7prCZ*7?rTC__CaeCk!e37ee!3Xee^z3X6Pe8 R3P<3C_1ye3_zeyC=ez37e2+Ze7y7ZZM73rFX3^jaCC&!eaje_zCXeeo8e)CPe83_eP^Z3_Lye3br8yH1Cz#7eL_Ze7CreZc^er?Ce^Y_ZC-^8a6Cy!xXee-!ZC_Pe8r_eP83e_Rye!>Z9y 3PzYyP-dza7%raaz^eU)Ce^iaeC3!ea!ee!UZXec8eXOPr8s_ePL3eC7ye3Nzey!HezE7eGEPX7+reZ)^ZrfCe^Nae_Z!earee!8Xee38ea8^^8KXPPV3Z_?ye3hXe^e;ezr7e6rZeyyreZyC!r,Ze^Ua_Co!CadeZ!/Xe778eXOPe8P_ePh3e_f!X3mzey{5Zz47eKQZeeZreZr^er8Ce^3aeZ8O^aKCP!0XZe28eXpCe&e_ePr3e_rye3Zzeyy7!zgyeS?Za7QrCZN77r9Ce37aeC)!eaZee!fXee>rXXiPe8KX!PU3e_Iyea7zey?kez_7e iZe7j_XZI^er0Ca^RaeCd!ez7ee!2Xeee8eXMPe8bCXPN3e_gPy3*zeyo ee77eABZe73reZ5^erlyX^)aeCd!_a&ee!%Xe778eXHPe88_ePB3e_M!X3:zeyvjXzx7eKOZe87reZ)^erCCe^paeCOmXa%ee!Oa7eo8eXsPer7_eP:3e_Pye3Gzey0^8z4yP0=ZZ7,rCZq^a!zCe^raeC8!ea3ee!!Xee<rXXUPe8}_aPE3e_syea7zey><ez^7ekmZe7A_XZ)^erdZy^UaeC<^Z(Zee!rXeer8eXmPe8y3!P(8P_iyX3EzCyAS_zH7eX7Ze7#reZy^eriCe^}zXC{!ea-eX!BXee&8eZ7Pe8M_eP^3e_Jye3*eXy%-ezWy8?RZe7wkZ_Z^errCe77aeC#!eayX!!gaPes8zX0PC8q_zPN3eC7ye3{zeyy)ez27e(FPX7jreZ-^rrnCe^faey7!eaRee!8Xeec8ea8Z88GXPPN8Z_Jye3Q_Z8_5ezr7ej8Ze7Ere_V!9r:ZP^LrPCS^aaIeaPzXeC68eX3Pe83_eP83e_<!X3Bzey<LCzm7ecHZe87reZ/^er8Ce^RaeC P8a6CP!)XZe{8CXuPe8r_CPY3e_3ye3MzeyPTezT7e3mZe76reZt^_r+Ce^K8XraZX^Xee!CXee(8e3yaZe78XzXeP!7XzP7zey^=ez17eyX*C_^yxZ17er+Ce^v!7rrZX7!aXPC!zarCy37aye38ZX_PX8^ye3ZzeyiIer!_XP83zzryZaPZC7XrX^?a_CV!eaKrrC3^3r^8zX3Pe8Z_eP#3e-!_CPX3XX8yCrX_Py^{X7!reZw^_r%Ce^(7hJ7Cr^7ee!PXeec8e8ya3C!!3X8e^87ye87zeyjver!zCyXdX_87CaXZCyer8Zr7PrXP_^CrzZ^!Caaez!7Pe8P_ePp3eb7XyP33Z__yX3^7eY_Ze75reaXzPy7hzZ78XraCC^8r^C7!_eW8rX,Pe8ptzX_PC!!XzPC3zytN_zn7eTh3_z3yz&z^eN_Ce^SaeZ8#^asee!iaeeY8eX<Ce8e_eP)3e_Dye3yzeyH3ezg7exxZC7UrCZ;^er^Ce^TaeCG!eaAee7Jaret8eXAPe8hXyPf3a__ye3>zey9/ez37eTQZe7^e3Z&^ertCe^UaCCS!e_Xee!UXee38eX2Pe7LyyP<3e_WP73<zryp)ezr7egLZe73reZ*^e3YZP^;aeC9!eaFeX!Nieea8eXAPe8z_ePP3e_qyr3Mzey#wezw7eEvXe77reZ ^er^Ce^PaeCl^_anee!0XCeI8eX2CeYe_eP63e_Fye38zeC=fZz,7e22z!7AT3Z%^e*CCe^qaeC8!eamee^8XXe/8CX<PC80_ePi!e_Pye33zey3&eze7e8hZZ7qrCZ2^Cr/ZP^+reCr!eabee!eXee38eX>C789_ePJ3Z_Eye3?_Z8_)ez37e(!Ze7%re_U!nrmCC^baCCh^8acCeraXee+8eX_Pe83_eP^Z3_wye3FzeyEhCzu7ehrZC70reZ3^er4Ce^JaeC4!eaPee!lXeel!yXkPe8h>zXePC!8_CP!8__7PZr3z_y^EXz^reZ7^erdCeer7yX3C_^^ee!zXee}8e8Ra^e3^3X7eZb3__P^3X_^*ezP7eRHZeCryya_ZX73<aZ7aeCP!eaAeeP!^PaaCy!7XzC^_ePa3e_,yeyq8^_3e337_Z78GXzXyP3yz37arr^0reCn!eaJXPCa3zaeeC^8XCe!!_X7eZ+3__P^3X_^=e_27ewUZe7HePZO^erGCe^waeC#7erPee!2Xee08eXyPe^ma7PO3e_Gye3HzXyU3Z_z7eJ8Ze7^reZ<^erqZ!^YaeC(!Za:eC!{XeeP8eXVPe82_ePU3eaGP!3lzeyuQez47zoT_er7reZR^ernCe^7aeZ8eeapeZ!wXZeW8eX*Pe!3_eP%3e_8ye33zeygczzR7e)EZC7preZQyer8Ce^5aeCv!ea3ee7FXCe18eX5Pe8f_XP68Z_Zye38zeyP<ez*7etRZr7TreZ6^Zr<CC^maeCr!Ca:ee!3XeeU8eX Pe8=_ePZ3e_<ye35zXylmezbZ_yC3_z_7XZt^Zr6Ce^c3^zk!ea^ee!TXe_aeC!XXX8I_zP63e_kzzP78_y=9XzL7e-L3_z37Zn_ZXr;Ca^{aeCnCz^rryC!!Cr^8eX^Pe8I_eXye38a__3O_3y4Aez:Zrye33_^7X&_z3y!=_^}arCb!ea:_zCr^yr^eX!aa_8)_aPG3e_gXZP787_rPa377C83Ze7vreZ-!7r:CC^jaeC}!ea ea!!XCe38eX^Pe83_eP33e_^r33<zey*T_zv7C5jZe7rrCZD^er3Ce^ aeZ8m^aLeC!WXXew8eX1Ceay_eP33e_3ye3Pzey<LXzL7ZVcZC7NreZoyerrCe^!aeCs!ea!ee!Ir^ec8CX9Pz8K_ZPh3a_7ye33zey_Fez37eJ3Ze7^e3Z+^erBZ^^}aCCd!_yCee!UXeZ;8eX3Pe!8C^P:3C_IyX34zeyo8eZz7e;3Ze73reZZ^erWZr^caZC&!CaEee!xaZCe8eX!Pe87_eP<3ea=yZ3/zzyAMzz(7riFZe7_reZ^^er3Ce^OaezN^aaBeX!WXeeO8zXbPe8!_eP!3e_7ye3(zey)3Fz47ChNZe7ArCZw^ez^Ce^3aeC8!eaFee74a_e;8CX2PC8U__PU3e_Zye3!zeybfez87e!=Zr7OrzZ6^Cr0Zi^MrZC!!ea^ee!7XeeR8er,C!8*__P<3__Iya3gzey7&ez77e(3Ze7drez8ryrOCa^ aZCV!eanee^8Xee^8eXyPe88_eeiay_(yz3f_3yO?_zV7eX3Ze73reZ!^er3Ce^(rPC3!eakeC!+XeeB8eXVPe8s_ZPV3e_hye37zeyj}e8!_ey33rzareZ^^eruCez^^Cv!Z!aIC!!lXee68ezXPe8v_ePA3e_pye3yzzy3xezo7_mvZC7)rCZ+^_PCCe^EaeC^!ea3ee!4aPe38eX)PC8w_ePl8Ze_ye3Tzey8Lez07e8cCc7vreZY^erMCC^gaaXz!ea3ee!oXee38eX8Pe8FzzP-3e_0yC3Ozey>ueZ!7eoTZe78reZR^erdX8^(aeCu!Za9eC!lXeer8CXLPe83_ePg3e_3ye3RzeyZQez07ej8Ze7DreZY^erKz_e2aZC&!eaxee!uXe_CyeX8Pe80_ePo3e_-^e^rzey^GezD7eP^mC_!y!Z073rNCe^c8zreCC78aCC!^_a7CZXme38)_eP{y8!7X7eGge_rPr37_ZJbzX7)reZmez73x7Z77Zr3e7^CryeZ^ParC73^a3C!!_X3ey8!_X3Ez_y/(ez6_ry333_^reZ_^er{CeeX7P67Zz^7_XCa!Ca8C^!7X_8MX2PK3e_tzde787_3Py3r_3y^Zey8reZ;^er%e7^GaeC !eaiee!freye8eXGPe8N_ePC3e_yyz33zeyi+Xz97CIlZC7}r_8C^erSCe^7aeC3!ea^33!IXeem!CX;PC84_e7X3e_wye33zey?DeaRy3{vZe7lrrZq^Cr:Ce78aeCI!ea3ee!>XeZb!zXRPe8J_eP23X_Qee3azey5dezF7e9ZZeed%ZZw^erjCa^JaZCc^Za7ee!fXee^8eXGPe^l_ZPh3e_Kye3s_4yU3Z7a7e03Ze7!reZJ^ercX8^saeCM!ZaDeC!:XeyX8eXoPe83_ePS3eroPC3hzeynSrz<7ziRZe7rrCZJ^er3Ce^kaeC/!ea}ee!ZXee%8eX8Pe8b_ePG3e_me_7}zZyL6ezF7e#NZe!:!PZ8^erGCe^saeC,e38Kee!CXeeT8e3!a6e3!ZX3Pz!^_Xe8zeP7%ezH7e^!;CzX7X38ZC!Xw3Za^8rrZP^X__CC^zr^eC!aXze7_ePC3e_wye7Z8X_XPeq<_PPP X_8reZe^eroCeee7XrXCC^arPCC!_eN8_XcPe8W!rX3e3!^ye3_zey+VerX_PP73zz7!XcaZC78O^Z7^_Ci!_a?ee!S^_a3Cz!zPe!3_eP:3e_<773WzeyiKezc7eg,_e!ereZk^erSCe^CaeCyCZa6ee!Baeen8CXBPe8b__rC3e_)ye8Szey3)ez%^7ShZe7ArCZQ^erN_e^CaeC-!ea7ee!3Xee?^3XoPe8u_CP13e_Dee3ezey6tezl7e>^ZePIt3Zc^erQCe^WarC/yeaZee!-Xeey8eX!Pe!8_rPi3e_MP83czeyq8e_87e0:Ze7+reZe^en8^y^*aCCB!ZaNee!QXezZ8eX9Pe88_eP33e_n773dzeyO?Czx7e)iXey3reZw^er7Ce^8aeC>^Pa3ee!GXCeK8eX<Pe8T_ePT8y_oye3kzey7Yezj7e^^mXz_7C3C^er7Ce^:aea^Z37^r^C7XZe(8eX9Pe8,_ePe7e_5PH3-zey%7!3Czzyz_eC3y^W_^er7Ce^&aei<Cz^3r^C_XeeP8eXbPeyz!3X!e!87__!MzeyPwezO7e^z33z!y!a3z^7_Ce^XaeCl!eFGaaZ8^PaX^e!ZaPeC!yXCey8Pyz33zey76ezG7eP^FCz8y^?7^errCe^haea!CX7^XyCr^_aCea!CXze3!_XCeP8aye3^zeyw/e3y_3yai_7Or_ZU^erJayZ377r7!eaPee!uXe_!CP!aa_e7!ya^3Cabye3Rzeysr7zE7CfdZe7vreZR^ar!CC^3aeC^!ea3ee!3Xee^z3XtPe8Y__P43C_?ye3rzCyc+ez37eAoZe7ka7Zv^Cr<CC^;aeCF7e_eee!3Xee38eXPPe^y8PP}3C_ueP3/zCyv33z57_eCZe7-rezr^er3Ce78z^C=!CafC8!WXees^eagPC83_eP33e__ye3*_PyD/ZzT7Z5gZe7=3eZz^er!Ce^jaeCX!ea-Z7!iXCeT8zXGPZ8L_aPa3e_3ye8{zey3nezU7eR^!37FreZ,7eroCC^Ka_3C!eaGee^rXee38ea8^^8L_CPY3X_sye3OzaZz9ez87elEZe73reZ3^erOyX^oaeCN!eaiee!/Xe!C8eX3Pe88_eP33e_*P83NzCy,ozzw7e,I_e77reZ3^er3Ce^zaeCN^3awez!EXeeQ8zXLZe!y_eP!3e_8ye3^zeP83Pzh7_RBZa7creZbyeAXCe^7aeCY!eaXee^8aCet8aXNeg89_ePs3eX7ye3^zey^iezy7e3Lza7orzZF7yr/C_^x3eZ3!ea!ee!3Xee!8eX ^C8%_CPW3z_+yC31zeyrBCzL7eg3Ze7YreZ3^er Ce^yaeCA!ea*CC!TXee9PZ!7aee_!3X!PC!^_XP^6zX^PP88zCyP%X7gr_ZD^erOrrZ377r7!eaZee!9Xe_PeX^^_ze7!Zaye38!_X3u_yyIkez2Z_yrrzz7yZ3yZXy8rPe7!aX7ey!^ee!ZXee68e3ya3C88X_!PX!8XaP78ZyGF_zS7e1Hr!zC7z%z^erZCe^{aeZ8_Ca#ee!(XZeR8eXSCe!Z_ePw3e_Uye3!zeP883zW7Z (ZC7qreZo^eYXCe^TaeC8!ea8ee7-Xze/8eX0Pe8k__Pm!eX7ye3gzeyL9ez77e38Zr7BrZZi^arTCe^LaePX!ea!ee!mXeeV8eXWe583_eP{3z_jyC3#zey_jez&7e,3Ze7VreZD^erWCee!aeCS!ea%er!lXeeOyz!rayC^8XXae__8ye3dzey2ceP+_Z^KZe7areZj^e^C(Pz77ZzFPX7eaXC!^Xr^CP^8Ce8WX7PF3e_sZCe78__r8erz_3y!3!Pk!C(_z^rkCz^DaeC ez^7r_!qXeeM8eX=Pe87_eP 3e3^X3e^8^_7<ezZ7e#*ZeC^yX3gZX3ha7Zr7yr7z3aNC{!wXeebyz!3a^e_8ZX3Pz8zyeP/zey%Uec!zXP^3_zCyyKPye7!nPZ_7Pw!Zz^3r^7t^yr7C7!8XXC8!zC(Pz83Xy!-8^_7yC3^PeP^3PPEP3DrzX3RTyZ77ar7ZZaZaZC7^3aaerrDXCe8!^X7!e!^XP!H88_rP33aPeP^30z73e;PZC7XrXy?^CrPCC^Cry72^Paa^e^CaPC7!ZCSPC8!_zPr8X_aP_zxy3><Ze7l!CG^Z_!8mXz^7_rrZyaoeX!5XeeYP_!eXXeX8XP-!__cye3Vj!_Cyz3z_z8D*Cz_y^_)ze7_rCzC^X{8Zzh=aXZe!za7Ce^^CeCP!IXCe_87X^PC8zX^yX3^7e-7Ze7srea_ZXyyrXZ_aeC7!ea}eePX^PaaeX^CPe8^_ePm3eb^_CeC8zyT33zW7ejVr3za7a_jC77r?yZ7y3Ci7aa9ee!?8XaaC!!aaPCP!yCTP_8r_Xe!8yePP_X=_zP73e_KyP38z_3t, Zr7PrzZ7^7r_C3^7a7C_!eaPe^_eea3e_,ye7!8^_Cyz3zPeP^3PP57XsaZC78 ^Z79erCZy^yr3Ca^3r^eXr:a^e7!aX7e^_lP73-zey&^z3__3y!3!P&y_wrye7!MPz#y3CO!aa/ee!08zaCZ8!7_XeC_ZP43e_Lye3-aea3^ezwye:<Ze7m^P3hZX7azee3^_rXZ3^aZeew!CaaeX!_PZ7!!_3_7^Xra!r_!Pyo3^zJ7eIuaz_87X13z_77arZC7yr^ZP7Pee!^Xeeh8e^^XCC!!!P+83_dye3=Kr_eP38^zXy_33_!y_Z/77r0Ce^}8zr_Z3^!r!7d^_ar^e!raee7!yPm83_gye3HrzX8yX33__y7r_z37ZZR78r#Ce^q8Cr^C_!!aXC!^_aCCP!aPe8^_eP03eha_CPX3XyJ3<zR7e&0fa_7yy)!z_7C2PZaaeCP!ea0eePe^_r^Ce3PXXC^_ezX3e_Vye!53__ryX8!_y8P3_P}yz37zey#nPz87_zNZB^rrPCz^7a7C_!3a7e7!_XeeP8^P8y^8ZXC8e3^_PPP3yz_yP+3Z_7CIyZPbeWyCX^_rPC!^3r^Z3r5XXCe8XX!eX!^XPe8XeeeP38^PrP!_ezyyZ:7ZX3CCe^^aeC0!e7^03Zo!Xeh!!XEPe8*bCz^y7YCzy!YteZ37yr7Z^w>zZ70reZHCr7eB3z^^Xr_Z37!r_7j^3r!^e!7a7Cj!_aC3e_Pye3TzezP^CT8Zy^CryCPrez^^er/Cee377rrZX^ar_7_re_^eX!yXCC7!^a^78aLX3Pa3ayq,_z07en0Krz3y7{7^eM_Ce^naeXrZe^7ry7+8aa7C^!rXzeC!_aC!eH^X3e!3z_rPZ3^Pe^C3y_yy33^ZXrpZF^<aeCRPC^^a_PC^yrGCX^^Pe8C_eP%3e-3__P^:__ryr3P_^y7Ze7^reZA^eyPrCZC7_COe_aoee!>8XaaC!!aaPCP!yC+P_8r_Xe!8yePP_X;_zP73e_nyP38z_3w UZr7PrzZ7^7r_C3^7a7C_!eaPe^X8_^eZ!CeeP^8PXPPy3__Py3f_zCyy#PyeyyrXZ_7Pr!Z37^,37g!XreeX!!aXC^!Pa8!eaeX3e^XrX!8e3y_Zy7QXPCrez{^er5CeZC^_r7Zy7^r3Cy73a7Zi!7XzC7!_XreZ_*yX3Wzeyd^X88_Zyr3Z7Y%^Zq^erna7Zr7XO!CX87ryC3!Za_eX!^Pe8__eP?3en3__P^Ae_3PZ33zrP8jC_SyYZF^rrICe^t^rr7Z_^PaXCa^ae1^7X<Pe81hzX_e38!X!!Q8__r8e37_yy3DZz_7X_Ez37araZC7yrCZ_^7ZeC^!CrCCzX#P_8l_ePqy783X3PazeP!=ezD7e^!3^zC7z>zyey^pPy2^_m7Ze^7ZeCX^PaaeX^CPZ8W_eP#3e_Q3ee!reyA8ezo7e%6rP_83e3OzZ77kzz!heX_CX^yr_7 8^Za^e3!aPea!_a8eP8_eee^8PeTPP8%zXyaZe7CreZ*^e!^(Xzd^XzWP_^3t3Z!XeCr8eXnPe^:8_XrPX!!Xy!P8_e2Pz87_eP>3P_8y__Rz(7r-PZz77r7Z_^3r7C7^_aeCP!^Pe8e_ePJ3e3^_CP8Kr_Cy_8^_0K#z87)reZpz^7rrCZ^7zF^ZZ^CryCPXeCC8eX-Pey!!PalC3aJZ_P78^X^yCXpC_yC3zz!yP38Z_3*a3Za7arCZ_^7ee!7Xee,8e38a^e38zXz3e_eye3hzeZzP33!_!8*aCz_y^ZY7!r2Ce^u!er_CC7CaXZ8re_aeC!XXX8D_XP;3e_uzX7^83_X!Zzvy8sLZe7l!_37ze77zee_^X&yCX^_ee!ZXee(8e!yaZer!7zrPa8yXzP78_y57Czv7eIR3F_^y_3(zz8Z_Pyr7Zr3ZrGaarCC^_aeCX!8aXC!8Xa8Pz8rXye^3X_aP_Xazzyr37Pry_38z3y3lXz3^__PyC3PzPCX!CaCCyrraZe78aa!^P8e_XP33_X!!P3XzCyC3yPry_57zzy^_PZa^X;Pe^^CaZ7a^^r7eCXsC!83_ePW8ZZ7ye3(zeC8-ez>7eSkZr79reZJ^CrpCZ^t3eZq!eaKee!_XezX8ea8PX8}_ePd7!_oye3}_ZP8Wez37e8eZe7lre_N7!r0CC^BaCC47CanCZ!7Xee!8e3!Pe8L_ePY3__NyC3wzzyH4ezc7e^^Ze74reZ/^er8Ce^UM3C?!ea)eC!tXZej8ea_Pe8N_eP63e_Rye3DzZyHVez:7e(DZe7i3ezy^erECe^<aeZC!eaoZ^! XZeb8eX;Pz8DrePe3e_8ye3Pzee^neaW8PdWZZ7,!8Zq^ZrUZZ7XaeC!!e8Oee!-XeZ6!zXsPz84_zPi7Z_KPZ3Pzey^ve_y7e+oZey8raZU^XrD_a^KaeC5!erzee!!Xee78eX8Pe!R_CPN3Z_HPX3Bzzy5:eze7euwZe78reZ8^e3iCC^5aCCW!eaOZ7!9XeC78eX!Pe8c_eP33ermPC3=zzy(8Pz%e_;,ZerqreZ3^er!Ce^8aeC+^PaGeC!SXCe+8eXTPe8z_eP33e_3ye3Gzee9pXz 7CY+ZC7W3yZK7Zr8Ce^!ae_^!ea>ee!?aZeM8_X+PC8{_ePu3e_Zye33zey^vez87eQVz871rCZ{^ZrOCe^5rZ7_!ea3ee^ZXeek8er:y#8n_CP+3C_SC^3Gzer8,ez37eM3Ze73reZq!7r<CC^<aZCH!eaveaC8Xee38er8Pe83_eP53e_^r33>zeyi8ZzJ7CBqZe!XreZ3^er8Ce^OaezWXXaAeC!wXCe4!!X*Pe3^_eP!3e_)ye3!zeCH3CzN7z5HZr7%krZQPen3Ce^!aeC3!e3Pee!y8!ew8_XfPz8F_CP?3Z_9ye)!zeyFpez!7eD&Ze7)azZs^er/C_^daeCY^eeeee!!XeeC8eX^Pe8Ia^PE3C_pyz3WzCyL/e_37ed3Ze78reZ&^e3xZ!^{aCC=!Ca0zC!hXeC78eX!Pe8A_eP83erOeo3Mzzyo;rz<7aSKXe77rCZ!^er3Ce^yaeC-^yaGeC!fXze>8ZXkPe!7_eP33e_7ye32zeyv37zj7CK2ZX7dreZkyerZCe^3aeC3!ea7ee!Ka7et8zXKPe8(_ZP*^eXzye3!zeyPHe_z7e!=z_7UrzZf^Cr-zX^haeCz!ea3ee!!Xee38eX)Pz8v_CPO3Z_qye3HXePyqez37et3ZePZreZ(7ZrbCz^=aeC,!zaGze!ZXee!8eXPPe!z_eZG!8_tyz3DzCyK^Pzh7a^zZe7^reZZ^er3Ce^7aeCW8za6ee!cXze(8eXMPe3!_eP13e_yye3qzeynrzzD7e#sZr7mreZ9^ea!Ce^taeCg!ea0ee!c_zeT8eXKPX8B_eP<8eyeye3!zeyC%ez^7etW_!7krCZ<^zrnCC^GaeC3!ea3ee!8XeeL8er,eC8A_CPj3C_1P!3Jzeya6ez!7elIZe7!reXR7zr9Cz^xarCWPyaMze^3Xee!8eX3Pe8X_ePyy!_,y_3pzay)QCzg7XNBZe^!reZG^er!Ce^haeCA8za5ee!*Xaes8eXAPe3!_eP,3e_eye3>zeyHrzz/7eSIZr7-reZV^ea!Ce^jaeC5!eabee^Ie5e58zXYe38{__Pb3eX7ye33zey!kez37egkzy7)rCZ<^ZrGCe^(AeZ_!ea3ee!3XeZz8eXVe88>_zP,3e_ByZ3 aeyPiez!7euPZe7^reZyC!rhC_^QarCg!CaGea!}XeP!8eXsPe8!_ePB3e_>7z3}zeyg33z,7e%4Ze^!reZ+^eryCe^SaeCF8zaqee!bade-8eXGPe3!_eP93e_Pye3-zey0rzzs7e&wZe7:reZG7ezaCe^!aeCC!ea^ee!#ZCe 8CXhPz8#_CPl3ahzye33zeyS(ez37e{3Ze70azZ4^erOZ8^vaeCc!eryee!8Xee38eXLPe^ XCP=3Z_%yZ3#Xyy23Z_P7ed^Zey3reZ=^ersZ8^NaXCx!CaKee!iXeC!8eX8Pe87_eP83e_KPC3hzZyf3!zq7eoMZe7_reZ8^erzCe^xaez;XaafeZ!NXZe*7CX=Pe!X_eP^3e_Uye38zeC 3Xz)7_lvZr7jraZsPej%Ce^^aeC3!eayee!sr7e18ZXTP_80_ZPk!eXzye3!zey8>ez77ed5zX7VrXZL^erJCZ^S3eZC!ea7ee!PXeZy8e99C^8L_XPF3C_#P83}zeP_(ez!7e27Ze73reZb!7rhCz^fr8C;!ea<eaC8Xee!8e^XPe83_ePQ3e_^r334zeyTe7zD7C:TZ_XCreZ0^ezyCe^3aeCx87amez!ha!ej8eX(CeC!_eP!3e_!ye^3zey93zz:7X/1Ze7>rZZFPeizCe^7aeCP!eayeeyfaoem8XX#PC8g_aPH3eX_ye3!zey7Rez87ebUzy7pr_Zn7^r4Ce^?UeCz!ea^ee!^Xez68eXye^8)__P}Z)_WyC3MzCy6J_!C7exBZeXereZ3^er^83^=aeCsa)a)eC!#re878eX^Pe8!_eP73e_0!a31zayRSezw7ZN+Xe7PreZy^erPCeyraeZ8^^a0er!tXzep8eX2eZ!e_ePe3ea!ye3IzeP888z9y3UwXy71reZp^eU3Ce^eaeC8!ea8ee7yr3es!0Xu>_8p_CPY!e_#y_CCzey9Ne^^7e*3Zey8_^ZN75r:_y^&aeCD!eRXee!eXee38eX8Pe8^73PU3e_ora3<zCyQFeZa7e/eZe7xreZ(^er?Z^^DrnCl!Ca;ee!6aZ8a8eXCPe^8_ePl3e_VZP3Szry(Irz(y3%9Za7!rCZP^eezCe^3aeC3!ea^33!)Xee:_!X+PC82XZ3a3e_Pye!Xzey0{e_d8y6jZa7grCZ}^rrSCe^zaeC^!eayee!3Xee0!XX<P_86X!P&3e_{ee8ezey^Iez^7eBzZe7co^ZJ^ar9Ce^NazCqyea!ee!yXeeP8erCPe7FX_PS3a_2yC3QX^yugarz7e=PZe77reZ3^er8Ce^NXzCm!eavez!:XeeV8e_!Pe8J_eP/3e_Eye8UeyyAnazwy3xxZr76reP3^er^Ce^yaeC3!ea^33!gXeeHaaX}PC8>ae373e_^ye3!zey7 ezw8aW>Za7hreZ}^Zr4_e^aaeCy!eaPee7rXeC8!zX>Pr8n_zPj3e_gPZ87zeyeAeX!7e6 Zey82CZ<73rG_y^JaeCq!eaeee!eXee88eX8Pe^yXyPq8s_?3_3jzCy=8ezI7_eCZe7ore7^^er3Ce78z^C:^ba&zy!LXeeb8erXPe8e_eP33e_8ye3^^3yELezjfaMfZC7YreCa^ereCe^qaeC9!eaDC^!Aamep8CXjPe80XZ3a3e_Cye^CzeyswezfCPmTZr7NrrZY73r%Ca^!aCCP!eCzee!3Xee38eX^G38h_eP}X!_HyC3m_Z5a#ezP7e38Ze7Vrezt3yr-Ca^}aCC=!raqee!zXee^8eXyPe83_eP-3r_My_3x_!yAwezRPe1PZe7^reZ^^erzCe^TAxC4!aaGee!IXze}7eaZPe8y_ePP3er_ye^-_Zy6naz57CV:z_7&raaz^erPCe^eaeC3!ea3ee!D_ze18eX=Pz8B_eP68eeaye3yzeyC2ezP7eo,PC7Ir_ZK^arxCC^QrZ!a!ea!ee^eXee{8eXTXX8m__P,3z_?ye3czeP8jez77eRzZe7dre_,^Xr>CX^)aXC y8a}ee!3XeeP8eXpPe8!_eZ5!3_Gyr3%zry&3Pzpee}XZe7PreZ3^e3PCe^y!!Cx^laNC!!UXCe:8_X4Pe3!_ePW3e_!ye3=zeyOXXzt7e%?Zz7oreZF^e_7Ce^QaeC^!eaEee!w_zeA8eX?Pe8E_ePU8eyeye3PzeyCYeze7eV9Za70rXZN^rrpCC^-aeZC!ea7ee!zXeew8erve_8%_XP/3X_wP!3Lzey7JezP7ehNZe7!reXR^zr%Cr^darC)^Da%ze^3XeeP8eX3Pe77_ePyy!_(Pu39_^y(hCz/7aFTZe^!reZ9^er!Ce^4aeC%8zabee!=a8eL8eXGPer7_ePY3e_3ye3gzey-XXzJ7eNoZ_7nreZ;^e_7Ce^GaeC!!eaSee!4_zeu8eX?Pe8A_eP{8e3Zye3PzeyCWeze7eF}ZC7?rXZ*^rr<CC^>aeZ!!ea7ee!!Xee{8eX,e384_aPU8!_}ye3AXePe+ezy7evyZePZreZiy8r?ZM^qaeC;!zaYze!8Xeee8eXPPe8a_eZR8C_jP>3HzCyW8rzo7a^zZe7CreZ3^er3Ce^^aeCY8zauee!lXzeD8eX{Per7_eP)3e_!ye3lzeyFXXzt7eUqZX7VreZA^ea!Ce^JaeCn!ea{ee^Oeles!MXke38hX3PY3eX^ye3yzeyesez37eEFzB7mraZ:7!rnCe^,ueCZ!eayee!yXeez8eXEC!8%XWP?3e_?yz3Waey!Feze7e5PZeC3reXR7CrwZl^AaCCD^za4eaPzXeeC8eX8Pe83_ePy3e_R7z3mzeyqKzzM7eMfZe^!reZN^erZCe^,aeCjVXa{ee!pXCeg8eXwPer7_eP(3e_7ye3Azey%XXzL7e:kZz7{reZu^ea!Ce^SaeCi!ea9ee^H!8ej!hXqe382X3P)3e_zye3yzeyeBez37emiZz7fraZf^zrQCe^AaeC3!eaPee!zXeej8er*Pr8?_rP(3r_oC835zePX-ezC7ekcZe7!reX<7ZrAZ3^TarCR^eawze^3XeeC8eX3Pe^P_ePyy!_VP83)z_yKhCzT7_mFZe^!reZw^er!Ce^2aeCR-Xalee!*Xzep8eX(Per7_ePq3e_yye3-zeyIrzzh7e9sZe79reZU7eCeCe^CaeCC!eaZee!9a3e:8rXHe38s_CP}3e_Pye3Pzeyzhezs7e8GzD7HrrZN^rr0Z!^JaeCy!eaCee!FXee!8e1)e_80X3P43r_wZ=3faeP3,ezC7e;3Zee!reZyC!rpZ8^Sr3CW!Cajea!9XeP!8eXtPe8!_ePk3e_v7z3)zeyH38zx7eRdZe87reZ{^er3Ce^9aeC+*Xa?ee!-Xael8eXFPer7_ePi3e_!ye3ozeykrzzU7e)NZe7jreZ47eoaCe^CaeCC!eaZee!gX_ek8rXte38;_CPn3e_^ye3Pzey3AezR7e1lz!7RrrZQ^zrkCe^}aeCy!eaWee!3Xeeh8eXXPe8u_eP33e_?ye3<zXy>sezh_ey!9Cz_y^Z8^rrWCe^?rZ7_!ea8ee!3Xeeb8eXy_!82_zPR3e_pyC3+zzygEeZ!7e;sZe7DreZx^erqyX^xaeCs!eaUee!WXe778eXdPe83_eP-3e_IZ83nzZy(nZzf7C%;Ze7rrCZc^er3Ce^9aeC3!ea&ee!!Xeex8eX?P_8<_ePiPr83X7P7zeyP/ezm7e7rFPzCyyc^ZXyeCe^aaeCp!e^erPCr^!aXeX^^XCeX8Xa^eh8r__3f_7y,1ezW7eaXZe73reZ>^erhCe^ya8Cq!eauC^!)XCeQ8CXWP_ZC_ePY3e__ye33zeP8X^z17CmHZz74reZ<7Zz_Ce^8aeC3!ea;ee^8eye%8zXNPZ8k_ePm3aizye3^zeyVAez37eJ!Ze7BazZu^ersCC^>aeCN!eX!ee!iXee88eXkPe82CXPJ3e_Jye3bzeynTe_87e13Ze7^reZ8^erS38^)aeCO!CaBee!cXeer8CX=Pe83_ePM3e_3ye3Lzey3Hez?7eTSZX7JreZUCa732^z7^XC8^ya}ee!&XeyX8eX8Pe8v_eP%3e_yvP3Jzey,3=z#7CNgZZ7gr_8C^er;Ce^eaeC3!e)yPy!0XCeV8aXLPC8U_CP+3_^Cye35zeyymez37e}^!37YreZx7=r-CC^taePX!ea8ee!3XeeJ8eXJ^r8E_ZP43Z_Hye3?ze^X ez87eB8Ze7(reZ17^r3Cz^FaeCw!eaRee!8Xee^8eX3Pe8B_eP 87_FyZ3;z_y6Kez?7e3XZe78reZM^erJCe^4r3C>!eateC!=XeeE8eXSPe80X8Pf3e_1ye3rzey>UeW!zXP^ryzry_nCZa7CrzZ37_rCZP^aee!PXeeh8e3!aPea!_X7ey!^ye3XzeyRSeV!zXP^_ez_7X3yZX7_zez^7PzL!eryee! XeX!eX^^Cee_8XayPX8_eee^8PewP733__yeXyzeyXpPZXrACr^>aeCnez77azC!!Xr!CzXde38b_ePQe783X_Peay_ePX3PzXhUzj7freZqz_7rQyz777r8CX78eZ! XeeI8eXIPe8e>eP%3X_dye3vB__CP_3_zXI ZX7NreZFe_771^Z3y3C3yZasee!?XeyX8eX3Pe8u_ePx3e_yyz33zCyQ1_z+7CGnZC7mr_8C^er Ce^^aeC3!ea%CP!3XeeL8CX5Pe8jXZ!_3e_3ye3Pzey%/ez&X8SnZZ70reZn^er?Ce38aeC3!ea8ee!8Xeey8zX3PC8<X8P?3C_#yC3jz_aCSezE7eBZZe73reZ^X3rVCe^k&!Cg!Ca5ee3XXee88eX3Pe8V_ePy!3_3yZ39_yyi=Czh7Cb)Z_XCreZF^eraCe^3aeC^_3awee!OaPei8CXkPekX_eP33e_3ye3qzey<8Cz?7Cl4ZZ7kreZ1^e8eCe^8aeC!!ea<ee7 Xrek8ZXGPZ8U_CP&3eXZye3^zeyquez!7e!B_77?r_Z&73r;CX^grZCz!ea7ee!!Xee08eXKe!8A_aPF3C_,ye3mzey31ez77eo7Ze7yrez%3yrGC_^QaZCJ!XaBze^3Xee^8eXZPe8e_eP1aC_OyZ3Iz_y,RCzi7_eCZe7LreX3^er3CeyyXyCj!eatZy!BXCe}8aXJP_ZC_ePc3eXaye33zey^C3zT7egVX>7mrCZ+^eXXCe^8aeC3!eaoee!,Z3ek8ZXKPZ8g_ePq3eXCye38zey!gezA7e8pzr7=rZZi^ZrnCC^(aeC!!ea^ee!2Xee!8e)%eZ8J__PS83_+yX3gaePCGez^7eW8Ze7^reX17zr}C_^}r8C&^4aFee>3Xee88eX^Pe83_eP^Z3_%ye3IaCy=lCzV7eaXZe78reZ3^ernCe^?z3C/!Za;eZ!jXee=8eaePe88_eP!3e_oye!IX7ycQZz:7Zd6ZC7Orezz^er^Ce^IaeC!!e3MZ8!BX_e2!3XoPX8treP!3e_^ye38zey^tea+7X<vZ_7VU8Z57Ar+Ce33aeC8!ea^ee!3XeeE!PX3Pe8x_CPx3e_oye3tzeyS3Zz67e;GZe7PreZm^e^#9^Z3y3r7ZZ7!ee^rXee98er9XXCe8XX!eX!^XPe8Xe_!yC3a_yyr3_PFy#HrzP7zB7Z77_r3Z7^7r_Ce^Pa^8eXrPe8I_e_!PX!^zyPr8__Cya3Czzy33_zCyP9a^er^Ce^laerPCC^XaX!6XXeT8eXAzXC8!ZXreZ_6yr3OzeyS7z87zzy!(X_!yzZW7erdCe^?73r^CX^ar_CC!arCeX^eXXe!!Xa^eP!8ye3ezey&Oe8^_PP!3__8y3%aZrr#CZ^6aeCSe^7yee!PXeeq8e3!aPea!_X7ey!^ye3Zzey,{erPzXP^rzz7yZ3yz37!rX^EaXC+!ea6XzZ^!Cr^CzXDPX8f_eP27_87X^P3!3y43!zA7esRr^zr7z93z^^(L^Z3y3r7ZZa8ee!JXeeL8eXbe-yV_eC!3e_qye7C8y_yP33a_3P^FXP0^^g7za77L^yd!zA7Cz^!aXZ!^zayCX!_a^CCaez7ey83_ZP_3X_^tez77eKxZeZ^y33^z^77Cey_aeCo!e!CrPZ7^ZZLyX^eXXe!!Xa^eP!8eeP^8P_7Pz3aPrP^_e_!yX3gze7rTZz^+ereZP^rr!CX!Xr^eC!XXXC^!DXrP__SCr3Rzey -eCX7en2Ze7TreZ;^eryrZ^UaeC;!_aleC!<Xeek8_7CPe8:_eP^3e_3ye3^^3ykLezk7X:0ZC7creZr^Cr}Ce^3aeCi!eapP7!&Xee;8CXtPe8Y_aX83e_Mye8azey3Yez%7ep^!37FreZ5yyr>CC^>aePX!ea6ee!8Xeeb8ea8a380_CPf3__6ye3tXePZ1ez37e&3Ze7zrez87zrKCz^9aCC?!ea#ee!_Xee38eX!Pe88_eCG3a_qyC3DzCys3yzdPe38Ze73reZ3^er_CeyTreCQ!Ca+eC!Ta3eg8ezXPe88_eP!3e_kye3y3Zy}jZzLy_+UZC7?reZ/^_PCCe^GaeZ^!ea3ee!^y3e*8eXdeX82_CPt3eZXye38zey^oezk7eB>PC7preZ-^ZrmCC^DaePX!eaBee!7Xeej8erjXa8}_ePF3e_-yz3Ezey_{ez87euSZe7!reXoy3rECZ^)rCCu!aatze^eXee88eXZPe!4_eZO!^_nyZ3O_7y23Pz&7eYaZe7*reZ8^er3Ce^^P3CG!eaKza!:XCeR!ZC_Pe89_ePP3e_Fye3y3ZyLlez{eP6DZC7OreZD^_PCCe^0aezr!ea3ee!V_7et8eXAPX8f_eP{!eP8ye3Rzeylwez!7eGxza71rZZ6^erDCz^m3eZ_!ea8ee^3Xee78ea8e)8x_zPv8*_pye3b_ZP_Dez^7esPZe7SreZny!rvC_^faCCG!eaEee!CXee!8eXfPe88_ee8_y_by_3pzZyFUez27ee!Ze7!reZ!^er^Ce7*r^Cj!Za*C8!%Xze{7eXCPe88_ePX3e_rye32_3yAYez:7ZDWZC71r_z^^er;CePyaeC3!eauP7!nXeeK8XXMPe8%aeXy3e_cye3gzey!nezvP!YgZZ7<reZG^zr*_e7yaeC8!er3ee!7Xez&8ZX-PZ8kX8Pt8Z_QCe3_zey8HezX7eHrZe7LJ3ZR^erGCZ^;aCCu!eareC!MXee38eXuPe8v_eP13e_!ye3,zeyx3^zs7eE4rzz7yyM^C!7733e77ar7Zy7^ee!^XeeS8e!PXCeX8XPW8!_fye3jA^_7ya8^Czyr3y_^yZUrz^r%Z7^GaeC)!e_Xee!fXeeo8eX}Pe8y8ZPD3e_?y_3UzCy1Eezn7_eCZe7FreZ^^er3Ce^^P3C(!eaqeX!wXCe/8eXrPC8o_eP33e_Lye3kZ7y0Tezx7CGdZe7Q3eeC^erMCe^waeC3!eaHZ3!MXZew8CXcPe8>XZPC3e_!ye3!zey2)ez*y&N:Z_7=reZI^erFZZ7^aeC7!ea8ee!OXee<!{X3Pe8>_XP)3C_hye8XzeyFIez37eSqZe7BreZW^erZCe^YaeC8!eafee!fXeel!;3&Pe8P_ePi3eU!XPPa8__7Py8^7eueZe7&re3^zP7a#XZX^Zr7ZZa9CX!RXeeJPz!7a_^ 8_X3C3!!eee^8PejP733__yeXyzeyXvPZXr6CX^laeCMe_^Cr_C_!XeM!3XnPe8,!7X3e_8eCyPe8X_PyXzn7rMnZe7H^z37Zz7!rXz!7zCT^^aIee!58za7C_r5X_e3^3a!!e!^XP!0zeyrAezU7e7!LX_^^yLrz_7CraZC^zr3Z_^CrPCaXee78eXHPey^8XX_PC!CyC^3zeyKMezp^7V0ZC7TreZ+^er1CaZ8aeC3!ea^ee!3Xee(8eX^R38h_ePh3__nyC3iz_aCKez#7e;7Ze73reZM7Pr3Ce^qaCCc!ea{CZr_Xee38eX!Pe8U_ePGC8_oyZ3Nzey 6ezN7eX8Ze73reZ8^er8Ce^y^ZC{!CaWZ!!:XCe18eXEP_ZC_ePS3eXzye33zey/r7zb7Z02ZC7NreZ>^alCCC^8aeCa!ea3ee!3Xee^z3XbPe8#XyP>3C_cy_CCzeyltezr7e#3Ze7Ia7Zq^CrBCC^&aeCE!el3ee!3Xee88eXNPe84q1P;3Z_1yz3mzey28e_Z7et8Ze78reZC^erbZa^Ua_Ck!ea)ez!?beea8eX^Pe87_ePP3eX8P83ozXy{3<z07eowZe7PreZy^er3Ce^OaeCG^CaBeX!-XXeY8aX*eeaa_eP^3e_8ye37zeCo3Czp7_&+z87orCZJ^e_3Ce^8aeC^!ea3ee!^y3ej8eX,Ze8+_CPh!a3rye3 zeeP5ez37eByZe7^e3ZI^erozr^kaCCO!e_Xee!8Xee38eXWPe8qC3Pm3Z_myZ3Ozeyxke_y7e%8Ze7!reZ%^e3gZy^6aZCo!ZaRC3!WXee_8eX^Pe8i_eP!3erYPy3uz_yk=Xzv7rDsXey_reZ^^er8Ce^^ae_S^3aJe_!&a8eD8CX>Per3_eP83e_^ye33zey^C3z{7e*xXe7ArCZ,^eXXCe^8aeC3!eadee!5Z3eg8ZX?PZ89_ePR3e_zye38zey!Sez*7e8Kz87;rZZQ^ZrsZ3^iaeC8!ea^ee!&Xee!8ef=C88)__PH3X_Oyr3daePycez^7e}8Ze7^reX#y^rwC_^Tr8C=!CaDee{3Xee88eX^Pe83_ePm8P_3ye3xzCy{EezG7ew{Ze7muPZE^ermCe^PaeCN!e8!rPCa^_a7Cy^^Pe8r_ePJ3e;!XPe(83_7y_XS__ye{XPcy^mCzy7zCe^7aeC0!e7vrZCC^yr^8eX^Pe89_ea^C3!6_X3fXay/vezF_QP^3__uyzXZPP3rr_ZC7zr!ZP78a_7a!zarC7rra3ea!aXCe_87CPPP3XX^Pa37_^yruzzCy_3C^er7Ce^gaeg=Cz^3r^C_Xeer8eX+PeP88XX^e3!8_XP!8_eR^a33_3y_kXz^rezP^er9Cee!7P;MZ3^7a_72^_aeeXr{a^eC!yXz!e8CXye!8__7yC3^7e{7Ze7Vrea^ZX7_rCzCaeCy!eaneeP!^ProC3!7X_88_eP)3e_?ye3v_6Zhkeze7ewWZezyyXFaZzy^L3Zr7yCs^Pahee!F8za7C_3aaPC^!3Xye38!_Ce^83_rPyzSy^jIZe7Tyzj7z_7!0^ZC7er8ZP^3rZC^Xee78eXoPeP^!3a^e^87ye!ezeyt}ez)^7IJZe7KreZ#^erFCaZ8aeCv!ea^ee!3Xeew8eX^R38Q_ePB3__9yC3;z_aCDezh7ec7Ze73reZ#7Pr3Ce^>aCCt!ea=ee3XXeel8eX3Pe8l_eCu3;_Tye3xzeyT37zO7e3CZe78reZQ^er!CePSr3CA!ZalCP!4a8e,7eaePe88_eP33e_8ye^#zZy-IZzNy3xUz!75rezy^erUCe^8aeC3!er8C8!6Xee{8_XKPe8OXZ!_3e_3ye3azeyVGezg8ZtcZe79rZZ2^Zrdza8aaeCA!er8ee!3Xee_8eX^F38b_ePH8Z_9yC3Jz_aCuez=7e37Ze73rez83^rNCe^)ryC+!eaYCZXaXee38eX7Pe82_eP178_Mye3mzZy=lCzHyZ__Ze7DreZy^er&Ce^8aaCM!Cawee!hXeeQ8e_rPe8,_eP83e_3ye3yzzy3Aez*PrhfZC7srCZJ^_PCCe^iaezP!ea3ee^8Z^e%8ZXfPz8d_ePT3eC!ye3!zey3>ezG7e+vzz7krZZ/^ZrgCC^uaePX!ea8ee!3Xee68erUPS8{_ZP*3Z_dP73tzey7Uez^7emOZe7!reX,7!rYC_^wrPCi!rauze!8Xee^8eX3Pe8e_eZ>3X_fy_3H_3yW3!zI7eo7Ze78reZ^^er3Ce78s!Cg!Za?Cy!QXee<!ZPaPe8!_eP73e_#ye3Gr8y-gZzL7Z<*ZC7qreZr^CrcCe^3aeCR!ea3ee!0XeCy8eX;Pe8n_aP;3e_izPe883_PP33a7e5!Ze7%rej!z77^Ce^ZaeCc!e8ZXzPr8y_7Cy!!aPe^8XP)3a_cye3+R7_7P_3e_Py^Ze7ZreZ=^e!PrXz^!zr7ZZ7yr3C!!Xe6!!XSPe8v3%a^e_!:zzP78ZXyP33!zX%kZ_7>reZTZCy8rrz!aeZX!ea>eeCe^_r^CemZZP^rrCZ8^raaCe!aaeea!CaZea!^Xae!8P38ze7!XPzy87_3!ea^ee!OXeXAPP8!__8wX^P;3e_0XDe^8_X1yP88zXP33Xz7yz3^^er!Ce^)aea7ZZ^_ee^!XeeB8e!ea_C^!ea!78arCPP^83X!yz3r_Zy^Xyz!yP#X^erPCe^daeXeCX^3a_C7^Zr!8eX_Pe8p_ez!eP8aX_P78yX^!7E^X3PcqX7Lr_Z1^ernXZZr^_GC!eaaee!HXe_CPy8y_3P^uX_r7Z38zPyPtzZ77Zz1y^p{Ze7J!rq7zy77tZZ37_r7Pr!7X3P^Xee^8eXHPee!!PX^PX_kP!39zeyIyr37__PyTXz_yPH!z3y^33^SreCQ!eaSaCZg^ea_C3!!XCC^!3XreyarX8e!8P_acez77eoxZezayP>aZz77Ce^^aeC%!e^PaCCX!Xe>^8X/Pe8RXZXP3e_#ye8yzeyQ-eXky8pOZe7*reZx^XrjZZ^_aeC8!eayee!mXeeS!^X<Pe86_ZPE3Z_IPZ8Zzey3}ezZ7ejTZe7)3!Z/^Zr?Ce^*a_CNyerzee!8Xeez8eXePe7NX_P#3Z_%y_34_3yQgezZ7ek!Ze7breZ8^e89Z8^QazCE^yaAC_!BfeC38eX!Pe83_eP_3eXbPz33zZy137zK7zSt_e7^reZ!^ercCe^!aeCj!Za&eX!NXeeo8zX{Ze83_eP73e_8ye8AzeeEBazd7aq Ze7?4CZM^euZCe^eaeCs!eaWee!Ta7eE8aX5e081_ZPL8e_^ye37zeP7Oezy7eS&Za7=raZH^er}CC^E3eZz!eayee^8XeC!8eah^y8t_XPG3r_Iya3RzeP8>ez!7el7Ze78rezH3yruCZ^+rPC=!zaLeeyZXee38eX8Pe83_eP68P_3ye3;zCyQMezF7e:tZe74GCZ6^erpCe^eaeC5!e8zr3C!^!ZcyC!_a^8kXZPk3e_izyPrXeXLP^33X3y73Z_!3e3^zP3w=!ZC^zrz!ea^ee!-Xe_aeC!XXX8(_XP*3e_-X_P33Z__yXz-7_tLZe7g7akCzy7^Ce^ZaeCq!e8PaXZ^8ea_eC^CXXC8!zP-3X_xye3Nr__7P^33X3kTZr7,reZJC!7CrzZz73raCraweX!>XeeiCe!3a3C8!zP*3X_Rye3=8e_!yC3__^-izP7,reZOCz77o_ea7Pj^Z3^yr3C!!Cr^C3!ray8N_XP23e_4ZXe88Z_rPZz2y>;+Ze7l^!wCZz7zK3Za^rzH!Za5ee!NXee#8eXeze8,_XP+3e_%z_PC8___yXzUyZ=*Ze7g^!SCZz7zrXZ^4er3Z^^_ZeZF^^a3Z3!7aZC!_ePP3e_:ye7!8P_aP_37_yP^ZeC7reZ:^erne7^;aeC0!eaBee!#Xaa88eXGPe8^_eP33e_vye3^^3y1Oez57_(fZC7&r_8C^erhCe^7aeC3!ea?CP!3Xee?8CXRPe8K_e783e_cye39zeyiKe_8Xr}9ZC7QE3ZB^ersCe^yaeC8!ea3ee!;XeZ4!zX PZ8E_ZP63a_,ye8^zey8Hez!7e%lZe7ESCZ;^CrMCe^VazCb!_ayee!{Xez,8eX3Pe8Yz7PM3a_HyZ3tzeyOpa^r7eY7ZeygreZ3^eryCe^^P3C*!ea(Ce!=XCe98_7CPe8#_eCr3e_3ye88e^ygRaz>7_44Ze7Y3ez6^CryCe^yaeC7!eabZ!!lXre=8zXAPe8:aee^3e_eye37zey!Oez0y^>bZa7nYoZ ^ZruCa7CaeCy!ereee!3Xee<8eX^M389_ePi!E_-yC3Uz_aCiezl7e8rZe73reZyZZrtCX^%V^Cd!Caiee!oX_4C8eXAPe!__eP33e_FP^3}zey(HCzg7e{>Z_XCreZo^e XCe^3aeCp^^aJee!#XeeY8eXxPeSX_ePy3e_^ye3qzee+Zzzc7a?=Za7}F!ZS^ereCe^eaeCJ!ea!eeypXze0!BX#eP8fXjP-8ZX_ye3CzeyX?ezs7e8MZZ7*s8Zo^XrJCz^AaeZe!eaCee!CXeeZ8eXyeC8=X3Pi!r_ yC3EzCyS<_!C7egMZePPreZ3^e)8^y^qr3CK^^aLee!)ae^a8eXePe!3_ePC3erEPC3l_/y0jrzjyynhZe83reZy^ereCe^3aeZ8l^a1ea!{a8e%8eXvPayz_ePP3e_=ye33zey3Hez&8XRcZe7>rXZo^erBCePZaeCy!ea8ee!3Xee#AZX{Pe8i_eP 3e_SyeaCzey^>ezd7e}/Ze7y?rZB^Cr1Z^^faCC9!Za>e_zCXee*8eX_Pe83_ePy3z_3ye35aXy,oCzm7CFuZ_XCreZ9^e87Ce^3aeC^_3aVee!d37e98CXBPe<X_eP33e_^ye3vzee&yazS7CbtZC7LK!Z#^e=eCe^!aeCj!ea!eeyHa^eT8zX:eP8c_CPk^e_^ye3!zeP3ie_67e!xZ_7LrzZY^rr*Zy^GaeZz!ea3ee!!Xee38eX^g38;_eP 7__fyC3fze^XIez37e/^Ze7Ure_BZarLCC^kaCCv^!aIee^_Xee!8eX1Pe8!_eZ63a_xyz3}_Py+3^zLee17Ze7!rez3^er8CeP1reC)!zaver!MayeE8eXXPe83_eP!3e_3ye3f_Py3>ez<7CG;Ze7LrCZl^er6Ca^+aeCU!eaaee!VXeX^CP8!XXC8!aX7eZ3rZXyyrXZa7_zny8*hZe72!rw7z_^!rXz87arCCz^7ee!ZXeec8e3ya3C88X_!PX!8XaP78ZyK4_zj7eG)r!zC7zpz^er^Ce^6aerPCC^XaX!+aCeE8eX(_Ze7!eX_e38!_Ce^3X_^7z8^_PP8<CzP7XZ=78rHCe^ErZ83!eaFee!7Xeeg8er=e880_ePG3e_*yZ3{_Zy^Mez87e yZe71reZf7&rOCe^QaZC<!Za1Ze^zXeeU8eXIPe83_eC#!B_gye3szeyY-zzRyZ3!Ze78reZ^^erMCe^-X7C-!zaOee!+Xeeg8eXePC8j_eP!3e_3ye3iX8y44ezq7C2jZe7EreZh^erEZC^=aeC4!eaPee!lXe_7Cy!3XZe_8XX^3e_^ye3szeZayC3XzX4!Ze7VV(ZW^erdX_ZC7zr3CZ^_aXC^Xeer8eXQPeP!8Xa^yy8rX_PC3a_Cyz33__yC3PzarZZ<^er#Ce^iaeCePeaser!/Xee P!!CXzezLCX_e^_}yX31zey2Pe3!zCy_3^7prrZh^er+XzZr7y4^CX^ar_!FaTeb8eX=_!eC8zXz!e;3X^P_zeyZhez67e^PSX_^^ej_ZCyCrXz87zCE!Xahee!g^ea3C3^8az8O_XPQ3e_4X_P33Z__yXzi7X49Ze7R^_-Cz_7_rX^!aCCd!_ahee!}!aaCCy!^Pe87_eP?3ex^_XP_3CXC2CaP7eNJZe7ja7Zm^CrSCe^(aeCR!a^8ee!3Xee^8eX3Pe8g_eP^Z3_Eye3pz_ys;CzR7_eCZe72reZ7^er3Ce^crPC3!eadeC!AXee?8aX!PC85_ePe3e_3ye33zey^C3zI7eTtz)7-rCZ ^_PCCe^qaezZ!ea3ee!/_7e#8CX+PC8v_ePH^eX3ye33zeyPDezr7e388r7UrCZ<7^rKCe^IaeC7!ea8ee!8Xeem8er=C78(_ZPE3Z_(P!3hzeP_:ez87e-!Ze7*reZ57rrSCC^QaeCI!za e_^ZXeeG8eruPe83_ePA(7_Jya3Jzzy+mezQ7aCrZe77rez^^er3Ce^yaeC^_3aOee!0a_eK8CXIP_ZC_eP93eXrye33zeP8X^zG7aVYz77IreZYyezyCe^yaeCy!er=ee!#are)8rX<P_8F_ePM!eXyye3ezey7lez87ei:z_7;raZ<7TrnCZ^naaZ^!eayee^rXee38eX3Pe8^73P+3e_+eP3EzCy:3ZP_7eByZe7ereZb^erya!^;arC%!ea eC!WXCeg8eZ7Pe8E_eP73e_jye3?r8y}hazp7ZHwZC7>rePC^er^Ce^VaeC9!eayCr!&XCel!eX4PC89_ZPb3_^Cye3QzeP&Wez37eT5C77DrCZi^Xr%Ce^ciery!ea3ee!3Xee78eXNC/8t_zPU3e_5yz3#aeyCmez!7eAaZe7ZreXo7PrTCz^Yr3Cf!CaMze!^Xee!8ea3Pe8y_eP&!!_vyC3czzyRMCzA7_eCZe7;reXy^er3CeyyXyCj!ea>z7!HXCe08zXJP_ZC_eP;3eaXye33zey^C3zJ7e,lXa7(rCZ5^eXXCe^3aeC3!ea:eeyLaCe68CXUPr8/_zP 3eZXye33zey7QezF7e8pna7LrCZ}^CrDCX^{aeZ3!ea!ee!wXee!8e5Sey8w_zPM8y_oP83RaeyXqez!7ebCZe7^reX<y7r/Cz^lrCCt!aa<ee!CXee38eX!Pe83_eP68P_3ye3xzCyERezb7CmIZe7+raZD^erfCe^aaeCJ!e!^rPe!!Xr8Ca!7aZPrvX_y7X2az_39_8yTGezBCayC3Zz7^z27zZyyrXz8aeZ3!ea,eee8!XrwC^!CXze3!_X7P_3!X_Pr8Z_3yr377eE^Ze7>re<PZC7XrX^)a_CY!eaDX!CC!zaz8eXZPe8F_ezPPX!^zzP78ZXyP33!zX*oz87ureZM7Ze3Ce^JaeC^!ea-ee7Ya_eO8eX*Pe8<_aP68Z_^ye38zey!Iezj7ebnza7WreZv^ZrKCZ^bteZz!eavee!SXee38er%ea8j_eP+3e_hyZ31_ZPeUez87ei7Ze7mreZD!7r;Cz^?aeC/!eaAee!eXCeK8eX!Pe83_ePT8a_Jye3 zCyILezJ7eGVZe7GrZZO^erMCe^_aeC+!e7!aXZ^!za_C3^4XZer8Ca8P__YeZ3JzeygPq8^__PY3zeZ8P_rZ_7ChzZ!7Pl8C_QaazCr^7ZrC3!aaaeC!_X7^P8^_XP_8__3yX8e7e>CZe7;reZs!7r=Ce^ aeCb!eaTeaC8Xees8eX^Pe83_ePq3e_^r33&zeyEM_z)7C:/Z_XCreZK^er7Ce^3aeC*^Pa3ee!HXCe/8eX4eZa__eP93e_3ye3SzeP8zyzl7COgZZ7EreZV^e8ZCe^)aeC8!ea3ee!vaPe38eX*PC8h_ePO3e_Eye3u_ZyKGezV7eVPZe7Krea!zP7al_Z77yt^!ea7ee!vXe_7CZ^8aPC8_eP73e_Yyey^83X^P^377e%7Ze7grea^ZX7_rCzCaeCP!ea2eeek^^a3Z3!7aZC!_ePr3e_Oyey!3XX^7y3r__yC/azC7zN3z_7ChPZaaeCe!ea{eeZ^^Pr!C_^8a3ea8rPR^^_iye3s33_rPX88Pe^78gz77z37z_7r%Zy/^_rrCX7!ry7P^_ZKCz^7aeCL!Pa8e_aBXSPr8P_zP737__y337z7y_,ezP7^Ce^ZaeCh!e8PaXZ^8za7CZ^ya3e!8XPI8e_>ye3g83_^yX3a__yCVa_C7X3eZX7!mXz^7Po8!e{8ee!oXe_CCy!ya3ea!3a^PXa2Z_P3!3X!8eH!_Xy!#zz7yz3!Zay7?^Z_y3zuPX^aaCC8^^a7e_XEPz8g_ePj7_83a33lXPyu2ezAPey78Gz77z37z_7rvZy6^zr3Zy^arPZ^reaeCP!ra!eX8Xa^PC8X_Xe^8f_ry_z-y!f=Ze7{^^wrZz731^CI7^r3z3^7rZ!YXXeQ8eXj_zC^8Ca^ez_8ye3jzeyv%ezKyt^GZe7PreZ)^e^!6XZ!^zr7Zz7!ee!^Xee*8e!PXCeX8XP}7h_Jye3wze^XxezI7esxZe7LreZyZZrFCe^fa_CS!Caiee!-X_ C8eX=Pe8^_eP33e_^r33qzeyv Xz47C05Ze7rrCZW^er3Ce^xaeC#87apee!#XCeT8eXAPa8!_CP03e_Cye33zey3Wez^a3-OZe7Up3Z1^CrgC__CaeCi!erree!3XeeI37XbPe8(_ZPN3e_;PZPCzey3*e_87ewGZeP63IZ&^Cr?CC^1r3Ch^ZrCee!!Xee78eX)Pe81X8P*3C_(yz3=zZyh8e_87el3Ze73reZa^e3wZ!^FaCC=!CaVCP!OreCy8eX3Pe83_eP_3e_p773EzZyqVzzS7e:KZaz8reZ8^e<7Ce^3aeC-!ea^33!FXeeh!XXsPC89__rC3e_Kye8yzey3pezs^7wnZZ7Nr_Z>^er Ce33aeCo!ea8ee!3Xee137XIPe8D_XPn3e_peePyzey0:ezn7e%yZe7:1_ZE^ZrVCe^BazCUyerPee!8Xee!8ea3Pe7Q_aP}3Z_(yC3i_!y9!e_X7eQ8Ze7^rezl^er%ZC^LaeCM!ZageC!5X_#C8eX0Pe7P_eP33eX8!^3kzeyt38z+7eL1Zaz8reZW^e8GCe^3aeC2!ea^33!hXee%7eXLPC8;_e7X3e_Rye37zey-feXfSZ{IZe7(reZN^arICe^8aeC8!ea{ee!!Xez+!aX{PZ8%_zP)3Z_+PZ8Zzey!9ezP7eV<Zey8,7Z4^_rnZ8^LaeC=!er7ee!^Xee38eXfPe8#X_PA3z_hye3{zZyn3Z7a7eF^Ze7XreZ4^erD3z^qazC,!zave_!Yaee78eX8Pe83_eP!3erhe53bzZyK9_zdyeNjZeyzreZ ^er8Ce^3aeC^7^aSee!hGre-8CX<PeHX_eP)3e_7ye3Gzee>yaz67esRZe70raZ+^ejXCe^8aeCh!ea!eey#XCex8ZX#Pz8-_ZPw^eX!ye38zey3/eze7e!)zZ7TrZZg^_r=Ze^GaeZ7!eaKee!8Xee38eXmeP83_eP:3C_6ye3-zeyHfezhyXmAZe74reZ7^erECez^^Cr8Z^^7eZ!1Xeek8eX1Pe8epeP}8!_2ye31XrehPy3r__8stazryXdaZ_roCr^;aeC/Pz^rryZ^!XaaC_Xme38*_eP*yr8eX3e^3X__P38!__EtZX7HreZqeXy8;ZZr7ZCg^Palee!:8za7C_3aaPC^!3Xye38!_Ce^83_rPyz0y7T*Ze7M3e3^zP3U=rZe73G^CX^_r3Z!^_e*!}X}Pe8F!_Xrez!^XZPC8y_Pqez87eH,ZeP_3eZW^_rjCe^J!yr3Z7^7ee!yXeed8e!!aPea8zX3e__WPy39zey&^a3C_yy^aazCyZ3!z_!!94ZC7^r^!eapee!QXeem8aX:Pe8I!3Xaez87XZe^zZyRxez27e:)Ze7_!eZj^Xr*Ce^J8_r7Z^^3u3!OXze)8eXd_ze7!_PN3X_sye39#__CP_3_zX&%zg7YreZMCe7_rCzC^Xc87eOPee!yXeeB8e33X_e^8XX^!e_3Z33=zeywoeCX7e#3Ze7QreZV^eryCz^3aCCd!_a9eC!}XCe68_7CPe8m_eP^3e_3ye3L_Py3-ezA7CdvZe76-Zy_^er3Ce^CaeC6!ea27_!TXZew8eXnPe8T_ePa3e_3ye38zey8 ezt7_QSZZ7wrCZT^er/ze7eaeC8!ea8ee!XXeeq!yX(P_8v_CPw3e_Bye88zey84ez^7e,8Ze7yu7ZY^ZrjZy^MaCCW!CaFe_zCXee#8eXaPe83_eP^Z3_Lye35a7yqTCz#Pa7rZe78rez3^er3Ce^aaeC^_3aQee!}aCeg8CXYP_ZC_ePk3eaXye33zeP8X^zM7z?MZC7>reZfyeZ^Ce^!aeC!!earee!hr7eS8_X;PZ8m_ePd!eX^ye37zey8dezz7e+UZr7OrzZG^XrdCC^waeCZ!ea!ee!!XeeB8erGeP8(_zP+3z_Nyr3%zePCKez77eR5Ze7!reXd^ZroCX^krzC5!Xa>CZ^-Xeey8ea7Pe8x_eCw8y_Qyr3,zZyc3!z2yZZaZe7ereZe^er}Ce^k8PCH!aa+ea!2axeF!eCaPe87_eP^3e_yye^(_CyJJXz}yCGdze7oreP3^er!Ce^7aeC3!eaA^_!VXzeT8_X0Pe8;aeeC3e_!ye3!zeP8iezT7_k,ZX7TreZ%^Zrc_e^XaeC7!er!ee!7XeC8!8XnPa8E_CPW3e_bee8Pzeyywezy7eS_Ze7:rZZ6^rr)CZ^baeCk^Ze3ee!eXeeZ8eX0Pe8V_CPE3a_<PS3YzZyM3e_P7ed7Ze7^reZy^erFZe^&azC?!XapeC!SX_eP8eXAPe7e_eP33e_m773;zzyoJzzA7egq_ee3rCZ!^er!Ce^PaeC !ZaNeX!,Xeeo8zXbZe8e_eP73eX!ye3yzeP8lrzR7akSz_7lreZv^efzCe^PaeC3!eaEee^8XzeR!cXLPz8k_eP)3e_8ye3yzeyy?eze7e3kPy7irXZt^_rKCa^S3eZ3!ea7ee^3Xee88eXj^C8/_zPN3X_MyC3Vzeyr&CzU7ei3Ze7qreZw^er0Ce^ZaeC:!eaYer!+XeefPz^7Xze!8Xa!ez_fPa3gzey57z37__8:37zryyK7_33b#_ZrperXCC7^rp7a^4r7er!7Pe8e_ePE3e!^XPPa8X_XyZ37_Z,%z37>reZ2z773<_Ze3yreZX^PaX!-a7et8eXd_ze7!_C<e78rXyP7!3eHP_3rPeU?ZX7KreZ}e_77N^Z3y3C8!eapee!oXeex!R3bPe8P_eP43eY!XPPa8__7Py8^7eL7Ze7Rrer^z3y^:^Z7aeCr!eaqeee!!Xr^Py!ra_eC8aXCPz83X_PC8P_aoCa37e0gZe7ca7ZH^CrICe^VaeCj!aa!eC!3Xee^8eX3Pe83_eP^Z3_)ye3+z_yj5Czo7eirZC7=reZ3^erpCe78z^C(!CaBez!&XeeO8e^ZPe88_ePU3e_6ye3*eZyo?Cz*7Z+VZZ7nraZ!^Cr3Ce^ZaeC3!ea3ee!^y3eT8eXke88T_CP63_^Cye3=zePZAez37ew1C77GrZZ ^Cr Ce^5aa_z!ea8ee!aXee38eX3Pe8^73Px3e_4Py3:zCy:weCX7et3Ze73reZf^erLzC^-aCCV!Za-ee!VXeze8eX8Pe8!_ePW3eaGP739zZyu9ZzFy8?%Zey reZ^^er-Ce^!ae_v!_aOe_!%a3e;8CXveZ!y_eP73e_7ye3UzeyN3_zi7alBZC7&reZT^eieCe^7aeC7!eayee^2Zye#8_XkeG8M_XPR^eX3ye3^zeyytezP7eO(PC7brZZ/^_rSCC^ja_3C!eaJeey;Xee38eryyy8<_eP;!7_gyC3jz_y6Y_!C7eNWZeyXreZ3^er^83^paeCt7ra/eC!/XeyX8eX8Pe83_eP=3e_B!33RzZyi#Zz:7eW5ZeyjreZ8^er!Ce^}aez0!ra0eZ!sXZe-!8XsPe87_eP^3e_Kye3!zeCi3rz:7_xqz37<rCZ?Pej!Ce^^aeCe!ea8eeykXreQ8_XLPa8m_rPB3eC3ye38zey^cez37eT^!371reZRPer<CC^AaePX!ea8ee!3Xees8eX-^38c_ZPp3Z_{ye3Bzey7)ez87eU!Ze7?re_47!r;CZ^gaZC>^8akee!7Xee^8eXiPe8!_eZt!7_gy_3k_3y)VCz*ee3_Ze7^reZe^er8CeP9aCCR!_akea!+Xreb8eZ3Pe88_eP^3e_3ye3J_Py3?ez?7C&-Ze7LreZ6^erSZZ^LaeCT!eaPee!lXe_!CP!aa_e7!ya^3e_7ye3:zeZ7PZ88_PP8Ze7PreZ6^e^!SXZ!^zr7Zz7!ee!zXeed8e3XaPea8XaC7z8CX^P78yX^Wez77e oZeZ!y_h3z_y!Ce^7aeCu!e8^aXC_!CrC8eaFPe8i_eXCP_87Xye^83_ye337XIy7pz_7y_lrzZr(zP^SaeCh7e^7(lC7!zr7C_!raZ^m8zX3ey8aXPe^Xe_ePP3r_!yXqX_^7CEXZXy^IwZr^_C6^&a:ee!l^_arCz^^aZeC!yXP3eXrye3WzeZXPP3azXPC_eC^yX3pZX3gazz7^zr!CX7!rzCy^Xa_C^^CCey7!yX3PZ8__XP^zeyPBezN7e7<3^z3P3d7zZy!Ce^^aeCt!e^PaCCX!Xeo7^XnPe8W83XreX!8ee77!q_7yz87__yr3ZPg7_:rZXy!GyyP7_z+Zz77reZm^Pr8C_rkaLer!PXze787X_P387_7P_3e_Py^Ze7zreZK^e!_4PZ!^Cr_ee^_aCZC!Xr88eXZPe8#_ezPPX!^zzP78ZXyP33!zX)-zP7xreZ6Cz779_ea7PI^Z3^yr3C!!Cr^C3!ray88_ePK3e_Iye3k_AZ1:ez77e=,ZeZ^y33^z^77CePeaeCc!eaYP7!)Xeeh8eX#Pe8A_aX83e_Tye3^zey3}ezb7e9^!37wreZu^_r-CC^%a_3C!ea?ee!7Xee38eX*eP83_ePk3C_mye3ize^XOezb7eW3Ze7vreZy^zr3Ce^Dr3C=!Ca&eC!JX_AC8eXuPe8C_eP33e_^r33&zey98Pzs7CtAZe!XreZQ^er8Ce^#aeZ8Z3ameC!fa^eA8eXnCe88_eP33e_3ye3rzeP8Waz,7zYkz!7:reZ,^er!Ce^3aeC!!ea8ee7VXze(8CX/PC8vXyPW!eXeye33zey3Fez77e8(ZC7srCZH^Cr>C_^waePX!ea8ee!!Xeep8eXyXZ8W_ZPt8X_6yC3)zeyMG_!C7e0)Zey7reZ3^er^83^0aeCo^aaveC!)XeyX8eX8Pe8^_ePR3e_,!C3+zey&9ZzQ7C,wZe!XreZA^er7Ce^{aezqCaa&ee!*Xee(!eXcPe!z_eP83e_Tye3!zeCU3!z=7Z6UzZ7&rzZlPerrCe^8aeC3!eaZeey*r^eO8ZXsPa8FXCPj3eXeye3{zey8kez37et^!37,reZYPrrECC^:rZ7_!ea#ee!PXeeY8eXyXZ8}_eP1^e_lyC3izey:0_!C7eOLZee1reZ3^erde7^,aeC>!Xahee!Ore!88eXsPe8o_eeq3e_-P834zZyh6ezk7zTYXe7CreZ8^eo8Ce^8aeZ8^3a5ez!#a3eO8eX<eZ!X_eP^3e_Pye3Fzeyx3#z{7_-GZC7TreZF^er8Ce^!aeC#!ea8ee^8eyeO8_X&eB8x_ePU3e^!ye3!zey!0ez^7e3Vz37xrZZD^CrNCz^=3eZC!ea8ee!yXeC38eX%eC8b_ePH3Z_>yC3Az_P3QezS7e!PZe73reZK!7r?Ce^ aXC#!ea9ZeCyXee08eXGPe!Q_eP:8^_4yZ31zeyQ>zz-eeJyZe78rez8^er8CePlaCCx!ZageC!Ja7e%7eaXPe88_ePy3eX3ye3?X8yT)ez-7ZElZC7BreZr^CroCe^3aeCj!ea+ee!;XeCa8eXjPe8EXPP:3e_>X!P7!3e}P38!PeyC3y_y7C>_z37^_y^Fa_CV!eaVr_Z8^Xa78zX3Pe7r_eP?3e!!_Xe88a_7PZX6_Zy73__7yZ2aZX7^zeZ37yzFZ3^araC3^^aCe_rdazC^8Ca^eX!!eeP!8P_^yXX_PePl3^z77C3!ZX3& _z8y3zpCC^PaCCC^yZiC^!3a_e7!ZCa3e_!ye3gzeZP^XA^7e9PZe7Sre_yzy7r>yZ!^X_X!ea!ee!6XeX7CZ!_Pe8^_eP>3e8^_Ce^3CytTrz{7esQ37z7yz3!ZC7PrX^oarCk!ea5r^P^!Xa!CP!^XX8&_XP:3e_:eaPz3XXC^7z>y^NfZe7N!PHCZ_77{yz^73ryZ3^7rZyXXeey8eX1PeyX8Xa^eS8r__3W_pyLkezW__yr3z_^yZNCzy7PCZ^;aeC5!eaTee8x3Pe88eXuPe8/_eP28e=,ye8zzey&ue3yzCyC3^z77__/z_7rzezy^Xb8Z3^ys37#^3aaC_!7XrC8!3a^C3aaye^8zey(Ke33PeP8OX_3yXh7zzy^zeZC7zz)CC^_rZC7!Ca^Z3r5XZe7!3XaPraUXzP78yX^!^X}_ey_KXz3yz57yey!p^Zr7rzDC_^rrrCagyeS8_X?Pe8HhZXrP_!Cye37zeyRGe8yzCy_33z^rez8^erECeyr7eq7CZ^_r3C!+PrPC?!Ca_e7!^XCez!^CP3Dzryo>ez9_^^^33zP7X3!z_r+CC^IaeCKy7a(e_!IXeeMP!37X3Pr_ePP3e_+yee!8X_!yz37_zP!Ze7^reZD^e7erCz!7DC8!ea1ee!:XeeFC33SPZ8Y_ePp3e_#!eeZreyg^Cz,7ei&83zryX_oZCy8rXyl^Zr7Z3^aar7o^Za3C_!7Cee_!3XXe3!^_XP^a^e{Pe3_zXy33zz73e3PZC7Cx_y%3Z_}7e7!aXC!^Paae_^!Cee3!yX^!e!^XZeCXe_3yr33_3yaXy7/48Z)^er{azz^^C5^ZX7!_zCr!_a78C^aPe8{_eP;+7_byC30zeygVez#PaaaZe73reZ^^er3Ce^!aeC^_3aIee!1X_eq8CXJP_ZC_ePf3e_Zye33zey-r7z:7C,>ZC7=reZT7Z7ZCe^8aeZ8!eaVee!0aPet8CX#PZ8L_CPx3e__ye33zeyATez%7e-:z77JrCZ)^ZrwCe^#a_Zz!eaMee!_Xee38eXAe^8+_CP)3C_#ye30zee3gez37ehgZe7ureZq!7rFCC^FaZCY!ea(ee3yXee38eX3Pe88_eP<8r_}yZ3lzzyclez4yZ+_Ze7!rez7^er5Ce^prZC4!_ave_!/Xee>8eX_Pe87_eP73e_5ye3K_RyfE_zn7ZwdZZ7p9ZZr^er7Ce^_aeC<!er87^!TXaeQ!aX%Pe8}XZaX3e_Pye3azey+WezN7z4;z,7>raZ6^ervCe7eaeCe!ea3ee!TXee#8aX-Pr8:_ePH3e_Lye8_zeyy%ezL7el8Zey8c^Zp^rrNZ!^BaeC)!eaCee!eXeeo8eXkPe8bUPP?3Z_&yZ3f_}y(deCX7e}!Ze7PreZx^eryCz^3azC&7CaveC!sXCe)8_7CPe8:_eC33e_3ye3^^3yuTezqPX)OZC7Lre3Z^er!Ce^8aeCu!er8!y!NX_eS8aXxPe8m_eaZ3e_7ye33zeyg5ezKCPo4ZZ7GrzZO^Xr)Ce8XaeC!!eaeee!FXeeRCZXoP_8d_eP63Z_GPe3_zey^qezP7eL8Zee9gPZ&^_rQZ7^jaXCn!ea3ee!!Xee88eX8Pe8nXrP43__kye3Hzey0Sez87eB^Ze7lreZ/^e39Cr^Ea_C}!zaGZy!+raea8eX^Peer_eP33eXzye3^^3y+Nezg_Pi=ZC7YpZy_^er^Ce^ZaeCI!e:oP2!kXXeW8zX ez84_e^83e_^ye38zey8WeX}^#u}ZX7Br_ZIy3r,za8aaeC7!e3yee!3Xee!8eX^T38G_eP}^a_wyC3mz_aCAez97eyCZe73re_-!pr CX^va_C(^ma0Ze3eXee78eX7Pe!^_eCyFy_HyX3+r!yp*Cz67z4KZ_XCreZ&^e8zCe^3aeC^_3akee!N8aeu8CXbPelX_eP73e_Pye3LzeyyyZz?7X?5rz7krCZ+^er/C__CaeCK!e!!ee!3XeZ,3vX(PX8*__P}8x_-eeZPzey7jez77e3ZZey8rZZ5^aroZa^AaeCQ^Zr8ee!PXee88eXgPe!8XZPx8m_BPr3)zeyW#ezr7e>CZe73reZ=^eS8ZW^jr8Cd^ra}ee!sXeeX8eXzPe8C_ePT3e_hP!3dzryJSrzky!4DZeyPreZy^er8Ce^8aeCy^8aneX!n87e08CXlPa8?__rC3e_Mye7Xzey3Lezuy^IUZX7,rCZ,^erlCe3PaeC7!ea8ee!xXee^z3X2Pe8h^7P(3C_-yerXzey7}ez37eMsZey8y8Z<^arKZC^KaeC !eryee!7Xee88eX3Pe80a^Pn3X_;ye3&zeyF1e_Z7ep7Ze78reZl^er^z8^BaeC0z7adeC!(Xee_8eX7Pe83_ePk3e_i!r3lzXydYZz>7e+vZ_XCreZ<^eyXCe^3aeCq87ateX!ka8e48eX&PeCz_ePy3e_/ye3czeP8xrzx7rR)zP7EreZl7ZrrCe^eaeZM!eacee!KaXen8XX#eY8+_ZP?!a_Cye37zezaOez37e3eZe7^e3Zs^er+ry^EaCCJ!_yCee!VXea!8eX3Pe8Vz7PW3X_)P!31zey)le8Z7e5yZe7#reZj^er%Ce^?aXC=!aakee!*Xee{8CX7Pe8v_ePK3e_^r33Tzeyve7z17CR}Ze!XreZ7^er3Ce^?aeZ8Z8aqea!1XCeg8eXGPe8X_eP73e_8ye33zeyp3Jz=7XTGZe7preZq^eV3Ce^7aeC8!ea#ee!^a8eI8eXEr780_CPj3eZXye37zey3tez)7e89C87(raZA^_r5Z3^haeC7!ea7ee!8Xee38eX}Pa8-_XPo3e_%ye3gzeP_6ez77eK8Ze7kreZ^7rr(Ce^By7CM!Ca Ze3eXee^8eX!Pe!a_eCyPP_Ky_3G!*yxQCzfP^wSZ_XCreZq^eyeCe^3aeCp87a e_!-XCeq8eXTeZeZ_eP73eXXye3wzey}3Dz&7_<EZZ7,rCZ0^erzCe^^aeC?!eavee!ma5el8_XOPZ8D_eP}3_X7ye3*zeXXlez37e/EC77Er_ZD^CrfCe^YrZ!a!ea7ee!^XeeB8eXIz88O__PQ3Z_tyC3Bzey_*ez^7exSZe7/reZ:3rrBC_^GaZC2!ea%ee!rXCeg8eX3Pe84_ePL3e_}ye!8zeyI<ezcZC6GZe70P3krzX3xrCZ_7Zr7CC^^&375^Aa3Ca!7Cee3!yC1PC8!X_PC8a_78e3zzXPCX^PYyeG_ZX73tzZ76eQPCC^Cr_7>!aarCZrOa3C^aea^ePa}_Xee8e_CPZ37Pey82XzyyP38ZX3U5ZZ7^_r7CX^Xr3Ca!rZWC3^^Zy88_ePQ3e_Jye3,ZeCrfZz=7eRIZe7mreXzeer#C_^+aeC%ee8rXze^XeeP8eXKPeC!!XX!Pz87Xze!zey^vezE7e^83Pz^P3Z<^arQCe^#!7r7Z_^erPC^XZeb8eX6Pe8gCeaZ7e_;yr3&zeyT7637zCy^RX_8yzZ,y!rcCe^v7XraZ373rXC7rea!CP!aazC^!ZX3e38aX_!I8a_CPP3_zCP^33zryyZV7Pr-Ce^17!r7z3*>r3Z!reaCCy^yXCe_!3X^^y_AP^32zey4^z3r_yP^,Xzay__XC_yCYeZ7aeCe!eaxeeZ^^Pr!C_^8a3ea8rPL7P_gye3w8z_7PZ8yzXP8_e_87X3^zXy8+yZ7^_z=CC^aZeCC^yryeC!_a3e^aea!e_83X_e78zeHyz3rz_y7X^P?ye;_ZX73;zZ7we:^ZZ7CZeC3!ra3C3!aCee_8Ca^PX!8Cy3VzryQ(ezE_^^^33zP7X3!z_rSXC^9aeC*z3^rrX7=!Cr8eXr{XZe7!3XaPraqXZP38__78e3__3yX33_^7Xi^P^3{keZ_^Xr3Zz^7ZeZP!CaCC_r#ZZ7+aea!PX8!XPPa3_X!8e33_yy^_e_^yZ3Cye73rrZ373rayya!eC!BXzeW8eX&_XC8!^P#3__vye3:8_X8PX377e}PZe7+re?_e_77rzZr^_r7!ea7ee!MXeaaCP!aXze7_ePZ3e_AyePC3__7Py8^_3yy33z7yZZ?^_rhCe^*^_r3Z_^3ee^zXeel8e!yXCeC!^X7P_avX_PrXeXyyX88_3yy83Pny3maz_77rrz873M^z3oaee^GXee58e!3aeCT!^XCPz83X_PC8P_a!P3Z_zyr3y71r_Z<^erpqGZ37zre!earee!lXeZrCe^7XZe_!3X!^P!8_XP^3X_7P7Xr7enPZe7nre{_eX7arzZr^_r7!ea3ee!=XeZX8eX!Pe89_eXzPX!Cye37zey#de8yzCy_33z^rZZp^er6Ce^%aerCPea C8!/XeeAPz^^XCC^!Xa!7z8r__P7zeyP6ez?7eyX;X_!yzb3Zr77CCz8aeCF!ea:Ce!BXCe%8eX/Pe8U_eez3e_3ye33zey8Iez?7ZtDZZ7:rCZ+^er;ZZ78aeC!!erzee!iXee-^7XfP_8O_ZPv3e_cye8^zey7%ez!7e{uZe7:rCZ#^_ruCZ^daZCD!ereee!8Xee88eX^Pe8?a8Pn3z_<ye3 zZy+3Z_87e2^Ze7rreZK^eJ8ZC^uaXC#^7aRee!GXeCz8eXyPe8^_eP}3e_be33qzay,gCzc7eEqZe7yreZ7^erGCe^taeCI^eawe_!?Xeen8ZXkee!z_eP!3eXyye3^zePY3zzR7z0&_y7GreZY^eXXCe^^aeC7!ea*ee!yXze38_X/eX8v_CPp3C_Sy_CCzeylMe_77eQ3Ze7^e3ZH^erNZa^baCC6^eZaee!!XeC78eX3Pe8+z7PR3__nya3/zeylBeeZ7eK7Ze7NreZ^^ep1CX^HaXC*^Za(eZ!hveey8eX7Pe8P_eP^3eX8PZ3)zay68^zw7etwZe7_reZP^er!Ce^-aeCq^7a0ea!HXZe+8ZX%ee!!_eP73e_yye3yzeyDr_zw7a?BZe70rCZWPer^Ce^yaeC_!erCee^ur4e;8XX<e38=_aPB3eX3ye3^zey8hez87e8s_^7krXZ{^_rfzC^=paZ3!ea7eeC!Xee38erYPe8^73Pm3e_n_z3*zCy{3ZP_7ec7Zey^reZT^e3Kej^kaaCS!_aEea!(Xe788eX7Pe88_eP83ea27R34zayE;XzI7X1i_aZrreZy^e^MCe^3aeZ3!ea^33!%XeefPeXWPC8;ae7e3e_yye37zePPmeX*^=#,Za7)raZiyPrnzaCraeCy!e8Zee!3XeC38eX^g38b_ePhy8_gyC3=ze^Xcezy7eL7Ze7*reZyZZr#Ca^)8rCx!CaYee!2X_SC8eX(PeyP_eP33eag7&3>zay&)Xz2yr&D_eaPreZy^eryCe7ZaeZ8^Xa9er!WaPe#8eX,eZ88_ePe3eX!ye3GzeP83zz?y3xg_77)reZg^eQZCe^ZaeC3!ea&ee^8aye9!!X(C78o_ePt3e_aye3_zeyPiezT7ed(zZ7<,,Z,7+r5Z^^JaeCz!eaPee!8Xee88eXye_8t_aP27C_4yC3vzryvU_!C7e?uZeC3reZ3^er=Z^^>aaCm!Ca,ee!tXe7P8eXyPe88_ePJ3e_^r33LzeyIPCzl7CF*Ze!XreZy^ereCe^MaeZ8Z8aTer!Gr/eG8eXvPe8P_ePy3e_8ye33zey+3^z:7aNtZe7YreZ:^er^Ce^yaeC8!eapee!^r7eO8eXiaC8p_CPj3e__ye3yzey3%ez>7e5fPr7vraZS^ZrcCe^la_3C!ea&eeZ3Xee38eXOy78i_aPk8n_Eye3?_Z_ZcezP7e}zZe7vreZ97rrOCa^jaZCE!Ca0ee^7Xeey8eXFPe8O_eP28z_1ya3vzZy:pezQ7_:zZe7nre33^er3Ce^dX7C%!aadC3!KXeeH^ey7Pe8P_eP73ea8ye88_7yv3=zg7ZJ=Ze7)JZz!^erCCe^!aeC?!easeX!NXae+!3XFPZ8xaaPy3e_yyeyXzey3oezZ7e5^!37AreZ0Z7rsCC^>aePX!eayee!eXeeE8ea8a88+_rPx3C_Fye3;zeyajezy7eJ8Ze73reZw7zrpCa^-aeC6!eaBee^EXeey8eX8Pe8&_eP^8e_dye3 8CyggCzA7eaXZe7yreZe^erFCeyoX8C2!ra(eX!?rZes8eX^Pe8y_eP83e_3ye3F_eyc}azk7e{MZe7drezX^eryCe^8aeCE!ea^Cz!bXeewCCX=PC82ae7e3e_7ye3^zee3leXyzPfxZX7gy^ZN^CrbZ}^ka_3C!ea1eeC_Xee38eXdy78-_XP18p_(ye3m_Z_Zcezy7e3NZe7?reZm^Cr,CX^GaZCs!Cabee!3Xee78eX#Pe8B_eP#87_syX3tzZy/jez57_AzZe7Rre33^er3Ce^,X7C5!Xa Cx!cXeeY!ZPaPe8y_ePa3e_Vye3>r8yUfXzs7ZU-ZC71reZ_^er7Ce^9aeCx!ea,7r!+XXeS8ZXMPe8{_ePr3C_Eye33zey{>ezW7eJ/Ze7PreZ5^er8Ce^?aeCE!ea/PeyrXee^8eXkPeC^^3apPX_Jya3jzey?Pz8^_ZyC3yzPreZ^^ermCeZ!70r3ZZavee!hXee?8eXyPe81_eXaeX8X_ZP78Zy92Xz47eQ=3_z37Z}_ZXr3_3^laeC)^ZZ_ee!3Xee88eX=Pe8U^8PW3Z_,ye3KzeyIoee87e53Ze78reZ8^e3yrP^#aCC%!aaBeC!GXrep8_7CPe85_ePy3e_3ye3^^3yU6ezdyf&bZC7>,Z^a^er3Ce^7aeCn!eam7r!;XCe}8ZXcPe8*XZ3a3e_3ye37zey}1e_8+y>-ZZ7>rCZG^erfCeyXaCC!!ea(ee!hXeC8XyX0P_8M_CPK3e_xy_^_zey8qeXP7eH3Ze7KXCZt^ar=Ce^1aXCO^ZZ_ee!PXee88eX:Pe8q^8PK89_-ya3#zey{qee87e2PZe78reZ8^e3yrP^:arCB73aieC!sXrep8_7CPe8}_eeC3e_3ye31!8y&+rzf7CTlZe7fre3a^ereCe^4aeCg!ea4Z^!)a3eH8aX=Pe8/_ee73e_eye38zey8=ez-P72xZC7xrrZ#7>rpC_^3aeC)!e0yee!3XeC8r^X0Pr8M_ZPi3e_%yeeZzeyefezy7esLZe7j_ZZw^rrjCZ^JaZC/7a_aee!PXeCr8eX3Pe8y_eP^Z3_nye3KXPyKsCzV7_eCZe74re_y^er3Ce^fy8C2!ra2eC!sXee4!ZP^Pe8e_eP!3e_xye!l_yyw3Sz-y d:Z_7=reZr^erCCe^yaeC,!ea+C8!ga+e48ZXIPZ8&_eez3e_3ye3Pzeye:ez^7CUJZe7R3aZH^CrkC_yCaeC8!eaXee!3Xee4rrXRPC8Y_ZP&3e_0ye3rzCyk}ez37e>&Ze7;reZN^er7Ce^AaeC-!aaKee!u8Xr!eX^8_3e^_ePZ3e_Vye7P3XX^7z37_ZPy33z!7XZN^rrhCe^=!er_CC7CaXZ8^zef!!X+Pe8=3^XrPz83X^yS8^_3e337_Zf(Z_7greZiZr73g7Z7aeCe!easee^88XeO8eXRPX8-_ePR!eX8ye39zeyuVez87e38zr7irZZ6^zr;Ce^5aeC^!ea9ee!8Xee88er#C!8o_eP&3e_Ky_36XePepez,7eDdZe73reZ(y3rxCe^DaZCs!eaYee!rXCek8eX3Pe8)_ePp3e_:ye3Zzey?5ezGy8GjZe7I^7-rzXy!rXe_^Xr3Za^7ee!yXeel8e8%XCC88XXae__Qyr3YzeyI^z3r_yyaFXz!y_Zg^Xr&Ce^p7er3Z378rz!=aaeS8eX*zZe38zXzPr!8XPe78y_^7_88zCya3z_?7C38ZX7arzzCaeCZ!ea?eee^!XreC_38aXC^!_Xrey_8ye36zeylSez17e?tZe7ZreZk^e!XuPz77zr7PX^ar_C7^ZeG8zX<Pe8-!yX7er_:Pw3jzey0733a_zP^YCza7zs7^_3^Ce^<aeZ87_a3e_!ha8eM8eX}Ce!e_eP^3e_^ye3CzeyWLrzu7X/oZC74reZ*^ewzCe^^aeC8!ea8ee7AXreJ8XX,PZ8T_XPk3a_8ye37zeyeAez37e*3Ze7^e3Z,^erJZI^naCCF^Zeaee!7XeeP8eX4Pe!8C^Pu3a_Ty_3DzeyLUe8Z7e2PZe78reZ%^erNCP^IaaCM!ZaFC0!-X_SC8eXAPe8X_eP33e_UZC3jz_yL33z6y8b1ZayPreZy^er_Ce^3aeC8!ea^33!,Xeev!^X#PC8Y_aP!3C_!ye88zey3{ez37eH^!37ureZL7Zr+CC^Wa_3C!ea}ee^!Xee38ea9^y8)__Pf3Z_6yz3IXazrjez37e88Ze73reZy^er^83^BaeC17Za9eC!Qreye8eXyPe8^_ePe3eat*X3czayTnaz07zpRZaCzreZe^er3Ce^3aeC8!eaxPz!:Xeed8eXhPe81_e^73e_lye3^zeywMez5_rFEZa7Fi&Zf^Cr?ze7_aeCy!ea^ee!3XeZ#^3X1Pa8b_aPH3z_;ya7zzeye0ez*7e53Ze7!reZf!zrFCe^(aeCU!eaJee17XeeI8eX^Pe8H_eP,aX_9ye3QzXyRJez-7eX3Ze7yreZe^er3Ce^/zrC5!_a,eZ!/Xeeo8eXrPC86_eP33e_Jye38zeyThezZ7evJZe7GKvZD^erFaXeC!zT^ZZ^rr!C7Xee!8eXsPeea8XaP3e_aye3qzeZyP33az_^y33_8yz3^ez7ej3Z_^_C;!_aQee!m8ea_eC^CPe8y_ePD3eu!XZP73CX^yXz2ya9*Ze7V!Z53Zz7zrrz87Pb7Zy^^X_Z8!CaaCz^=XCC88XXaPz!CyZZZ73rCZ3^Cr3zCaP7u5^Zk^erda_z8^CraZz7DaCZ8!Xaaez^CPZaXC^!_a^e_!^r_rPyo33z=7e/Yr__P7X(7zy!CvyZy7PCE7Ca>ee!:Xear8eXTPe8u_eP,3eaxyC3Fzey9cezc7X*nZey!reZ8^er3Ce^VaeZ8!_axez!Sa8et8eX;Ce8X_eP!3e_!ye38zeP8M_z/7_o Zr7+reZE^eYXCe^!aeC8!ea8ee!wa7e38_XcPe8;_CPf3e_rye37zey8Yezx7e3+_87ir_Z5^ar,CX^NaeCe!eaoee!^Xee88erJee8,_eP#3e_cy_3RzePegezY7e)8Ze73reZly8r-Ce^DaCCd!eaLZe^_XeeB8eX)Pe8!_ee88P_%yZ30zCyoRezo7e3CZe7OreZ8^er8Ce^yazC3!ea;C_!1XCeF8CXcP_ZC_ePc3eX^ye33zey^C3zF7e1H_e7BrCZx^eXXCe^3aeCM!eaFee7R8Je18CX(PC8R_XP?3e_rye3!zey?hezF7e38zP7fr_Zf78rNCe^B?eC^!ea^ee!^Xee88ea8e78(_XPI3r_ ye3izey3{ez^7eU8Ze78reZO7zrACX^HaeC>!Cadze^3Xee78eXePe8C_eP 8Z_qyC3AzXyRkZzIPeZ7Ze73reZ3^er^Ce^O88C#!CaVeZ!9XCew8eXrPC8/_eP33e_,ye3KzeyE?ezz7e>#Ze7NrzZ+^er#AyZ77rCG^ya)ee!I3aaCCy!^zaeC!Za!e_G!XOPC8^_^Wez_7ek9ZeZ^yZ/3zyy!;eZ37Zr7Zy^!q3!IaReD8eX6_XyC3za^eZ8rX!P7zeyy(ezm7e^!3Zz77C3^ZXr8!8XCe38CX3PC^3yrXeeC8eX&PeP^!rX7PX8az3Pa3a_r+Z3yzayy/azy7aeyePr8Ce^0aeCS!eaVee!MXeCy8eX2Pey88CX!e!8PXZPr8X_ay_G^_Zy33y_!yeE3zZ77&yZ!y3CF!_a%ee!{8ea_eC^CPe!r_ePo3e_mXP3xzeyU-ez<7eD;_ey^reZ9^erBCe^7aeCH73adeZ!tXCeB8eXEeZ!C_eP!3e_Pye39zee)3rzS7zwIZz7>rCZ07Zr!Ce^^aeCy!eaqee!AX_e:8zXtPZ8(_ZPK3e7<ye3^zey Rez37e!Tz279r_Z>78rqZw^waeZC!eajee!^Xee88er*ey8%_eP(3e_SP!3qzeyPQezc7eL8Ze73reZ27zrHCe^IaCCF!eawZe!^XeeY8eXjPe88_ee83__:yZ3oz_yfVezL7e38Ze7NreZ8^er8Ce^yt^C5!ea4Zy!qXCej8eXqP_ZC_ePg3eXaye33zey4r7z%7Cx;Ze7NreZQye!eCe^3aeC3!ea7ee!gaPe+8zXwPe8v_eP08ZXXye3^zeyPjezD7e8Hz!7%r_Z:^_rQCC^brZCX!ea7ee!yXeex8eX;PC8/__Pw3Z_+yZ3)zey7Rez77eJOZe73reXM7CrBCX^+azCL^3a*ee^8Xee38eX7Pe88_eCdzX_5yC3UzCyf3!zg7e!ZZe73reZ8^er3Ce^LrPC3!ea>eC!NXeek8eXUPe8=_XP)3e_fye3Wzey>wez87enqZe7DreZ?e8!#CZ^taeCT!ea>eey03ee88eXUPe8I_ezwP{L5yZ3bzey(tez,7erKaP79TZZN^er}ZZyzaeCE!ea3ee!DXeC8!%XdPC8d_XP>3e_LPZ3^zey81ez!7eAQZey8c_ZH^zrwCX^(aeC:!_aPee!3XeCi8eX3Pe8G^8PH3X_fye3%zey1(eC_7e(yZe7BreZW^erRz^^1arCu!CaYee!bXee!8eXePe88_eP13e_#e33m_+yffCzn7ZoF_eyPreZe^ereCe^8aeC6!_a:er!UXZeR8ZXYCe8z_ePP3e_Pye3^zeyl3CzT7ah ZZ7orZZ&^e,CCe^IaeC7!eayee!^p3e,8CX*PX8S_CP=3eCPye35zey8*ez=7e#nzP73reZL^CrdCe^naeCW!eaoeC!nXeeO8eXCPe8V_eX!PC8!X/P7Q^_CPy3z7e:CZe7prez83^r/Ce^IaCCc!easee_^XeeY8eX3Pe83_ePy3z_3ye3:zXyl1Cz;7CNQZ_XCreZI^er7Ce^3aeC^_3aMee!Ra}eS8CXRPesX_eP83e_sye3/zeyoXzzH7z,iZC7qreZ/^errCe^8aeC8!ea3ee!faPe38eX*PC8T_ePU3e_ ye3LzeyL0ezu7Cc3Ze7dreZI7Pr3Ce^HaCC#!eaFee!{XeeQ!aX-Pe8{_ZP*3e_Nye3?zeza^ez87eI}Ze7kreZYZq!iCZ^1aeCl!eaKoePe3ee88eXlPe8N_ezVyXvLyZ3YzeyN}ez:7e7zae78reZM^erdCe^OXe_r!ea^ee!cXea8Z,!raZ88_ePM3e_QyeCof!ZoqZzf7ej6Ze7L!erCeervCX^GaeCgCZ^Cr_y!IZe88eXWPe8b_e! P3,&yZ3wzeyd{ezk7e^zae78reZg^ervCe_>!3Xt!eayee!1XeaCCy^!XXC8!_P83e_#ye3 zeyW7;rL7Zf%Ze7NreZ ^e!ZXe^8aeC?!ea2eePR!{_;8ZXFPe8w_eP Xe3eZe38zey,lezp7eeEHMCvreZ+^erlCe^AaXC=!eaor_C3!Za_eXX8Pe8#_eP<3e_h_37;zezzgezx7e6wC_7breZ47 r%Ce^?rZzr!Ca3ee!_Xeen8ea8eC8h_ZP#8C_xye3k_ZP8sez!7e3gZe79rez8^XrgC_^QreCM!ea<CZ!XXee78eXXPe8J_ee888_sya3gzzy6jezxyZ3zZe7PreZz^erDCe78CyC>^Ia6C^!(Xee&8e^ePe8T_ePe3e_3ye3DZ_yALCz07aD{Ze7kEZ^a^er8Ce^3aeCN!er8ze!3Xzel8zXTPe8EXZeX3e_^ye8!zeyQ e_8yPcJZX76SPZI^erLZZ7zaeCy!eryee!2XeC8^^XBPr81_CP(3e_4ye8ezey3tezP7e?3Ze7va_Z=^ZrkZ3^daeCE^ZtreC!!XeC38eX*Pe!8a!PH3__APC3Mzey93Z_87eD7Ze78reZI^eY8Za^UaaC}^Za9ee!(aZeC8eXPPe83_ePD3eX8PZ3)_cyfvXzW7eWfzZ7XreZC^er7Ce^jaeZ8ayaWC8!,azeD8eX+eZ_a_ePz3e_7ye3:zeyUeiz*7ZFTz!7#rCZ1^ea^Ce^!aeCX!easee^8KPe38_XmPC8B_eP-8ZX3ye37zeye ez17e38_^70raZ47PrLCe^(rZC8!eaPee!CXee<8ea8e78 XQPs8C_nye36_ZyrTezC7e/_Ze7*rez87yruZ8^{r3CW!eaSCZXaXeez8eXCPe81_ee8^e_3P^3;_!ywtezvyZ38Ze7XreZr^erDCe78r^C}^yamCC!oXee&!ZX7Pe8r_ePX3e_sye88_Cyg3ez,7zHIZe7ErezP^er!Ce7QaeC3!eafP_!pX_e}8_XtPe8N_e_e3e_7ye3+zeyLoez&P3/tZa7BrCZ4^er}Ce73aeCP!ea8ee!WXeew!_X+eV8}_zP*3e_}ye3Xzey^Aeze7eW3Ze7Aa_ZQ^Xr+Ce^kaeCq^Zeaee!yXeey8eX4Pe8Er7P33r_Yy_3:zeyc3Z7a7eReZe7yreZ}^er^X^^BaaCLeyaIeC!xXeP^8eXZPe8k_ePH3eX8P_3:_!yJ=az+7eMtZeyzreZ_^er^Ce^CaeC#!Ca{C^!ta^ep8eX>eZ!7_ePX3e_yye3Dzey^3XzHy!LDr&7lrCZ?7Zz_Ce^raeZ7!ea:ee7OzEet!PXceP8sXyPo3eXPye8czeyZHez 7e38Zr7?JCZj78rcCe^AgeZy!er3ee^3XeeP8eX>e786XZPH3__>P33NzeyaGe_87e38Ze7arez8ysrlZz^#a_Ch!eaKee!8XeC38ea!Pe8x_eP%8r_>PP3jzey>xCz&7_8CZe7zreXX^er3Ce78z^Cb^!aBCX!uXee)^ezePe8z_ePz3e_aye3k!8yO3^zJ7XbLZe7#re3Z^erXCe^ZaeCi!eaK7C!,a!eJ!7X;PC8s__CC3e_yye^Pzey3Fe_8LyodZa71v_Zl^erjZZaaaeCP!eayee!kXee977X3e+8-_XPJ3e_VPZzazeyC%ezy7e(hZe7^!^ZR^rr;r3^:aCCw!e7Zee!zXeey8eX9Pe8*z7P58^_vye3xzey5QeC37e2XZe77reZZ^ervyZ^dr^C !ZaveZ!RXezr8eXyPe8z_eP_3e_^C33dzryB7zz?7C2%Ze8PreZy^er8Ce^0aeCT^Pa3ee!>XCeG8eXtPe8/_ePM"
		)
		local n = 0
		o.sDsnVZTK(function()
			o.dAOflwhu()
			n = n + 1
		end)
		local function e(e, r)
			if r then
				return n
			end
			n = e + n
		end
		local r, n, l = y(0, y, e, f, o.HYhmrcjU)
		local function z()
			local r, n = o.HYhmrcjU(f, e(1, 3), e(5, 6) + 2)
			e(2)
			return (n * 256) + r
		end
		local s = true
		local s = 0
		local function c()
			local a = n()
			local e = n()
			local _ = 1
			local a = (r(e, 1, 20) * (2 ^ 32)) + a
			local n = r(e, 21, 31)
			local e = ((-1) ^ r(e, 32))
			if n == 0 then
				if a == s then
					return e * 0
				else
					n = 1
					_ = 0
				end
			elseif n == 2047 then
				return (a == 0) and (e * (1 / 0)) or (e * (0 / 0))
			end
			return o.tMQnVJXs(e, n - 1023) * (_ + (a / (2 ^ 52)))
		end
		local b = n
		local function u(n)
			local r
			if not n then
				n = b()
				if n == 0 then
					return ""
				end
			end
			r = o.ZywUhvKc(f, e(1, 3), e(5, 6) + n - 1)
			e(n)
			local e = ""
			for n = (1 + s), #r do
				e = e .. o.ZywUhvKc(r, n, n)
			end
			return e
		end
		local b = #o.TGEVmZbM(h("\49.\48")) ~= 1
		local e = n
		local function re(...)
			return { ... }, o.YmyFSvWl("#", ...)
		end
		local function ne()
			local h = {}
			local e = {}
			local s = {}
			local f = { h, s, nil, e }
			local e = n()
			local y = {}
			for a = 1, e do
				local r = l()
				local e
				if r == 3 then
					e = (l() ~= #{})
				elseif r == 2 then
					local n = c()
					if b and o.xkyEyqBD(o.TGEVmZbM(n), ".(\48+)$") then
						n = o.wBIwOsrS(n)
					end
					e = n
				elseif r == 0 then
					e = u()
				end
				y[a] = e
			end
			f[3] = l()
			for f = 1, n() do
				local e = l()
				if r(e, 1, 1) == 0 then
					local t = r(e, 2, 3)
					local l = r(e, 4, 6)
					local e = { z(), z(), nil, nil }
					if t == 0 then
						e[_] = z()
						e[d] = z()
					elseif t == #{ 1 } then
						e[_] = n()
					elseif t == k[2] then
						e[_] = n() - (2 ^ 16)
					elseif t == k[3] then
						e[_] = n() - (2 ^ 16)
						e[d] = z()
					end
					if r(l, 1, 1) == 1 then
						e[a] = y[e[a]]
					end
					if r(l, 2, 2) == 1 then
						e[_] = y[e[_]]
					end
					if r(l, 3, 3) == 1 then
						e[d] = y[e[d]]
					end
					h[f] = e
				end
			end
			for e = 1, n() do
				s[e - #{ 1 }] = ne()
			end
			return f
		end
		local function ee(r, e, n)
			local a = e
			local a = n
			return h(o.xkyEyqBD(o.xkyEyqBD(({ o.sDsnVZTK(r) })[2], e), n))
		end
		local function u(p, f, l)
			local function ae(...)
				local z, c, b, ne, s, n, h, ee, m, g, k, r
				local e = 0
				while -1 < e do
					if 3 > e then
						if 1 > e then
							z = y(6, 61, 1, 1, p)
							c = y(6, 68, 2, 16, p)
						else
							if -1 < e then
								for r = 22, 58 do
									if 2 > e then
										b = y(6, 34, 3, 81, p)
										s = re
										ne = 0
										break
									end
									n = -41
									h = -1
									break
								end
							else
								n = -41
								h = -1
							end
						end
					else
						if e <= 4 then
							if e ~= 3 then
								g = o.YmyFSvWl("#", ...) - 1
								k = {}
							else
								ee = {}
								m = { ... }
							end
						else
							if e == 6 then
								e = -2
							else
								r = y(7)
							end
						end
					end
					e = e + 1
				end
				for e = 0, g do
					if e >= b then
						ee[e - b] = m[e + 1]
					else
						r[e] = m[e + 1]
					end
				end
				local e = g - b + 1
				local e
				local y
				local function b(...)
					while true do
					end
				end
				while true do
					if n < -40 then
						n = n + 42
					end
					e = z[n]
					y = e[j]
					if y > 153 then
						if 231 > y then
							if 191 >= y then
								if y >= 173 then
									if y > 181 then
										if 186 >= y then
											if 184 > y then
												if y >= 181 then
													repeat
														if y < 183 then
															r[e[a]] = l[e[_]]
															break
														end
														local l, t
														for y = 0, 6 do
															if 3 <= y then
																if 4 >= y then
																	if 4 ~= y then
																		r[e[a]] = {}
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if 6 == y then
																		r[e[a]][e[_]] = e[d]
																	else
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if 1 <= y then
																	if y > 1 then
																		l = e[a]
																		t = r[e[_]]
																		r[l + 1] = t
																		r[l] = t[e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	f[e[_]] = r[e[a]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													until true
												else
													local l, t
													for y = 0, 6 do
														if 3 <= y then
															if 4 >= y then
																if 4 ~= y then
																	r[e[a]] = {}
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]][e[_]] = e[d]
																	n = n + 1
																	e = z[n]
																end
															else
																if 6 == y then
																	r[e[a]][e[_]] = e[d]
																else
																	r[e[a]][e[_]] = e[d]
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if 1 <= y then
																if y > 1 then
																	l = e[a]
																	t = r[e[_]]
																	r[l + 1] = t
																	r[l] = t[e[d]]
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																f[e[_]] = r[e[a]]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											else
												if y > 184 then
													if 183 <= y then
														repeat
															if 185 ~= y then
																local y, f
																for l = 0, 9 do
																	if 5 <= l then
																		if 6 < l then
																			if l >= 8 then
																				if 8 < l then
																					r[e[a]] = {}
																				else
																					r[e[a]] = {}
																					n = n + 1
																					e = z[n]
																				end
																			else
																				y = e[a]
																				r[y] = r[y](t(r, y + 1, e[_]))
																				n = n + 1
																				e = z[n]
																			end
																		else
																			if l >= 2 then
																				repeat
																					if 6 ~= l then
																						y = e[a]
																						f = r[e[_]]
																						r[y + 1] = f
																						r[y] = f[e[d]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r(e[a], e[_])
																					n = n + 1
																					e = z[n]
																				until true
																			else
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																			end
																		end
																	else
																		if l < 2 then
																			if l ~= -3 then
																				for t = 38, 69 do
																					if 0 ~= l then
																						r(e[a], e[_])
																						n = n + 1
																						e = z[n]
																						break
																					end
																					y = e[a]
																					f = r[e[_]]
																					r[y + 1] = f
																					r[y] = f[e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																			else
																				y = e[a]
																				f = r[e[_]]
																				r[y + 1] = f
																				r[y] = f[e[d]]
																				n = n + 1
																				e = z[n]
																			end
																		else
																			if l < 3 then
																				y = e[a]
																				r[y] = r[y](t(r, y + 1, e[_]))
																				n = n + 1
																				e = z[n]
																			else
																				if 4 == l then
																					r[e[a]] = r[e[_]][e[d]]
																					n = n + 1
																					e = z[n]
																				else
																					r[e[a]] = r[e[_]][e[d]]
																					n = n + 1
																					e = z[n]
																				end
																			end
																		end
																	end
																end
																break
															end
															local t, l, h
															for y = 0, 9 do
																if y < 5 then
																	if 1 >= y then
																		if y ~= -3 then
																			repeat
																				if y ~= 1 then
																					t = e[a]
																					r[t](r[t + 1])
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]] = f[e[_]]
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			t = e[a]
																			r[t](r[t + 1])
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if 3 > y then
																			t = e[a]
																			l = r[e[_]]
																			r[t + 1] = l
																			r[t] = l[e[d]]
																			n = n + 1
																			e = z[n]
																		else
																			if y ~= 2 then
																				repeat
																					if y > 3 then
																						r[e[a]][e[_]] = e[d]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = {}
																					n = n + 1
																					e = z[n]
																				until true
																			else
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																			end
																		end
																	end
																else
																	if y >= 7 then
																		if 7 >= y then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		else
																			if y ~= 5 then
																				repeat
																					if y < 9 then
																						l = e[_]
																						h = r[l]
																						for e = l + 1, e[d] do
																							h = h .. r[e]
																						end
																						r[e[a]] = h
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]][e[_]] = r[e[d]]
																				until true
																			else
																				r[e[a]][e[_]] = r[e[d]]
																			end
																		end
																	else
																		if y > 1 then
																			for t = 16, 86 do
																				if 5 ~= y then
																					r[e[a]] = r[e[_]][e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
															end
														until true
													else
														local y, f
														for l = 0, 9 do
															if 5 <= l then
																if 6 < l then
																	if l >= 8 then
																		if 8 < l then
																			r[e[a]] = {}
																		else
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																		end
																	else
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	end
																else
																	if l >= 2 then
																		repeat
																			if 6 ~= l then
																				y = e[a]
																				f = r[e[_]]
																				r[y + 1] = f
																				r[y] = f[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if l < 2 then
																	if l ~= -3 then
																		for t = 38, 69 do
																			if 0 ~= l then
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																			y = e[a]
																			f = r[e[_]]
																			r[y + 1] = f
																			r[y] = f[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		y = e[a]
																		f = r[e[_]]
																		r[y + 1] = f
																		r[y] = f[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if l < 3 then
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	else
																		if 4 == l then
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																		else
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
															end
														end
													end
												else
													local t, l
													for y = 0, 6 do
														if y > 2 then
															if 5 <= y then
																if y > 4 then
																	repeat
																		if y ~= 6 then
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]][e[_]] = e[d]
																	until true
																else
																	r[e[a]][e[_]] = e[d]
																	n = n + 1
																	e = z[n]
																end
															else
																if y ~= -1 then
																	for f = 45, 95 do
																		if 3 ~= y then
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																			break
																		end
																		t = e[a]
																		l = r[e[_]]
																		r[t + 1] = l
																		r[t] = l[e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = {}
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if 0 < y then
																if y == 1 then
																	r[e[a]]()
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]] = f[e[_]]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											end
										else
											if 189 <= y then
												if 190 <= y then
													if 191 ~= y then
														local l, t, h
														for y = 0, 6 do
															if 3 > y then
																if y > 0 then
																	if y >= -1 then
																		for f = 49, 77 do
																			if y < 2 then
																				l = e[a]
																				t = r[e[_]]
																				r[l + 1] = t
																				r[l] = t[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		l = e[a]
																		t = r[e[_]]
																		r[l + 1] = t
																		r[l] = t[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																if 5 > y then
																	if y >= -1 then
																		for t = 44, 68 do
																			if y > 3 then
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																else
																	if 3 <= y then
																		for l = 32, 56 do
																			if y > 5 then
																				t = e[_]
																				h = r[t]
																				for e = t + 1, e[d] do
																					h = h .. r[e]
																				end
																				r[e[a]] = h
																				break
																			end
																			r[e[a]] = r[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													else
														local l, t
														for y = 0, 7 do
															if y < 4 then
																if y > 1 then
																	if -2 < y then
																		for t = 30, 67 do
																			if y ~= 2 then
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if -3 < y then
																		for h = 10, 62 do
																			if 1 ~= y then
																				r[e[a]] = f[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			l = e[a]
																			t = r[e[_]]
																			r[l + 1] = t
																			r[l] = t[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		l = e[a]
																		t = r[e[_]]
																		r[l + 1] = t
																		r[l] = t[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if 6 > y then
																	if 4 < y then
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if y > 4 then
																		repeat
																			if 6 ~= y then
																				r[e[a]][e[_]] = e[d]
																				break
																			end
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													end
												else
													local f, o, s, k, h, y, b
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													y = 0
													while y > -1 do
														if y > 2 then
															if 4 < y then
																if 3 ~= y then
																	for e = 23, 55 do
																		if 5 ~= y then
																			y = -2
																			break
																		end
																		r(h, k)
																		break
																	end
																else
																	r(h, k)
																end
															else
																if 0 < y then
																	repeat
																		if y ~= 3 then
																			h = f[o]
																			break
																		end
																		k = f[s]
																	until true
																else
																	h = f[o]
																end
															end
														else
															if 1 <= y then
																if 0 < y then
																	for e = 16, 81 do
																		if y ~= 1 then
																			s = _
																			break
																		end
																		o = a
																		break
																	end
																else
																	s = _
																end
															else
																f = e
															end
														end
														y = y + 1
													end
													n = n + 1
													e = z[n]
													y = 0
													while y > -1 do
														if y < 3 then
															if 1 > y then
																f = e
															else
																if y >= -2 then
																	for e = 34, 65 do
																		if y ~= 1 then
																			s = _
																			break
																		end
																		o = a
																		break
																	end
																else
																	s = _
																end
															end
														else
															if 5 > y then
																if 2 < y then
																	repeat
																		if y < 4 then
																			k = f[s]
																			break
																		end
																		h = f[o]
																	until true
																else
																	h = f[o]
																end
															else
																if y == 5 then
																	r(h, k)
																else
																	y = -2
																end
															end
														end
														y = y + 1
													end
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													b = e[a]
													r[b] = r[b](t(r, b + 1, e[_]))
												end
											else
												if 188 == y then
													local y
													for t = 0, 3 do
														if t <= 1 then
															if t >= -1 then
																for l = 49, 96 do
																	if 1 ~= t then
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																		break
																	end
																	y = e[a]
																	r[y] = r[y](r[y + 1])
																	n = n + 1
																	e = z[n]
																	break
																end
															else
																y = e[a]
																r[y] = r[y](r[y + 1])
																n = n + 1
																e = z[n]
															end
														else
															if t >= -1 then
																for y = 15, 93 do
																	if t > 2 then
																		if r[e[a]] ~= e[d] then
																			n = n + 1
																		else
																			n = e[_]
																		end
																		break
																	end
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																	break
																end
															else
																if r[e[a]] ~= e[d] then
																	n = n + 1
																else
																	n = e[_]
																end
															end
														end
													end
												else
													local t, y
													t = e[a]
													y = r[e[_]]
													r[t + 1] = y
													r[t] = y[e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r[e[a]] = {}
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													t = e[a]
													y = r[e[_]]
													r[t + 1] = y
													r[t] = y[e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
												end
											end
										end
									else
										if 176 >= y then
											if y > 174 then
												if 174 < y then
													for f = 27, 73 do
														if 175 < y then
															for y = 0, 4 do
																if y <= 1 then
																	if -1 ~= y then
																		repeat
																			if 1 > y then
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if 2 >= y then
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		if 1 ~= y then
																			repeat
																				if y ~= 3 then
																					r[e[a]][e[_]] = e[d]
																					break
																				end
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			r[e[a]][e[_]] = e[d]
																		end
																	end
																end
															end
															break
														end
														local y
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														break
													end
												else
													for y = 0, 4 do
														if y <= 1 then
															if -1 ~= y then
																repeat
																	if 1 > y then
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																until true
															else
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
															end
														else
															if 2 >= y then
																r[e[a]][e[_]] = r[e[d]]
																n = n + 1
																e = z[n]
															else
																if 1 ~= y then
																	repeat
																		if y ~= 3 then
																			r[e[a]][e[_]] = e[d]
																			break
																		end
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]][e[_]] = e[d]
																end
															end
														end
													end
												end
											else
												if y > 173 then
													local y, d, l, t, z
													local n = 0
													while n > -1 do
														if n <= 2 then
															if 0 >= n then
																y = e
															else
																if -3 <= n then
																	repeat
																		if n < 2 then
																			d = a
																			break
																		end
																		l = _
																	until true
																else
																	d = a
																end
															end
														else
															if n > 4 then
																if 3 <= n then
																	repeat
																		if n > 5 then
																			n = -2
																			break
																		end
																		r(z, t)
																	until true
																else
																	r(z, t)
																end
															else
																if 1 ~= n then
																	repeat
																		if n ~= 4 then
																			t = y[l]
																			break
																		end
																		z = y[d]
																	until true
																else
																	z = y[d]
																end
															end
														end
														n = n + 1
													end
												else
													local d, b, k, o
													for y = 0, 5 do
														if 2 < y then
															if y >= 4 then
																if 5 > y then
																	d = e[a]
																	r[d] = r[d](t(r, d + 1, h))
																	n = n + 1
																	e = z[n]
																else
																	if not r[e[a]] then
																		n = n + 1
																	else
																		n = e[_]
																	end
																end
															else
																d = e[a]
																b, k = s(r[d](r[d + 1]))
																h = k + d - 1
																o = 0
																for e = d, h do
																	o = o + 1
																	r[e] = b[o]
																end
																n = n + 1
																e = z[n]
															end
														else
															if 0 < y then
																if y ~= -3 then
																	repeat
																		if y > 1 then
																			r[e[a]] = f[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]] = f[e[_]]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											end
										else
											if y <= 178 then
												if 174 ~= y then
													repeat
														if y ~= 178 then
															r[e[a]] = r[e[_]] + e[d]
															break
														end
														local y, u, k, b, o
														for f = 0, 6 do
															if f <= 2 then
																if f < 1 then
																	y = e[a]
																	u = r[e[_]]
																	r[y + 1] = u
																	r[y] = u[e[d]]
																	n = n + 1
																	e = z[n]
																else
																	if -3 <= f then
																		for y = 48, 59 do
																			if f < 2 then
																				r[e[a]] = {}
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]] = {}
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if f >= 5 then
																	if 4 ~= f then
																		for _ = 12, 81 do
																			if 6 ~= f then
																				y = e[a]
																				k, b = s(r[y]())
																				h = b + y - 1
																				o = 0
																				for e = y, h do
																					o = o + 1
																					r[e] = k[o]
																				end
																				n = n + 1
																				e = z[n]
																				break
																			end
																			y = e[a]
																			r[y] = r[y](t(r, y + 1, h))
																			break
																		end
																	else
																		y = e[a]
																		k, b = s(r[y]())
																		h = b + y - 1
																		o = 0
																		for e = y, h do
																			o = o + 1
																			r[e] = k[o]
																		end
																		n = n + 1
																		e = z[n]
																	end
																else
																	if f > 3 then
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													until true
												else
													local y, u, b, k, o
													for f = 0, 6 do
														if f <= 2 then
															if f < 1 then
																y = e[a]
																u = r[e[_]]
																r[y + 1] = u
																r[y] = u[e[d]]
																n = n + 1
																e = z[n]
															else
																if -3 <= f then
																	for y = 48, 59 do
																		if f < 2 then
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = {}
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if f >= 5 then
																if 4 ~= f then
																	for _ = 12, 81 do
																		if 6 ~= f then
																			y = e[a]
																			b, k = s(r[y]())
																			h = k + y - 1
																			o = 0
																			for e = y, h do
																				o = o + 1
																				r[e] = b[o]
																			end
																			n = n + 1
																			e = z[n]
																			break
																		end
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, h))
																		break
																	end
																else
																	y = e[a]
																	b, k = s(r[y]())
																	h = k + y - 1
																	o = 0
																	for e = y, h do
																		o = o + 1
																		r[e] = b[o]
																	end
																	n = n + 1
																	e = z[n]
																end
															else
																if f > 3 then
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											else
												if 180 <= y then
													if y > 178 then
														for l = 21, 96 do
															if y ~= 180 then
																if e[a] <= r[e[d]] then
																	n = e[_]
																else
																	n = n + 1
																end
																break
															end
															local l, h
															for y = 0, 9 do
																if y < 5 then
																	if 2 <= y then
																		if y > 2 then
																			if 0 <= y then
																				for d = 25, 97 do
																					if y > 3 then
																						r[e[a]] = f[e[_]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					l = e[a]
																					r[l](t(r, l + 1, e[_]))
																					n = n + 1
																					e = z[n]
																					break
																				end
																			else
																				r[e[a]] = f[e[_]]
																				n = n + 1
																				e = z[n]
																			end
																		else
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if y ~= -4 then
																			repeat
																				if y > 0 then
																					r[e[a]] = f[e[_]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			r[e[a]] = f[e[_]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if 6 < y then
																		if y >= 8 then
																			if 8 == y then
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																			else
																				r[e[a]] = r[e[_]][e[d]]
																			end
																		else
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if y ~= 2 then
																			for t = 33, 90 do
																				if 6 > y then
																					l = e[a]
																					h = r[e[_]]
																					r[l + 1] = h
																					r[l] = h[e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]] = {}
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			l = e[a]
																			h = r[e[_]]
																			r[l + 1] = h
																			r[l] = h[e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
															end
															break
														end
													else
														if e[a] <= r[e[d]] then
															n = e[_]
														else
															n = n + 1
														end
													end
												else
													r[e[a]] = #r[e[_]]
												end
											end
										end
									end
								else
									if 162 < y then
										if 167 < y then
											if y > 169 then
												if 170 < y then
													if y > 171 then
														local f, k, h, o, s, y, t
														for y = 0, 6 do
															if 3 <= y then
																if y >= 5 then
																	if y >= 4 then
																		for l = 15, 54 do
																			if 5 ~= y then
																				if r[e[a]] ~= e[d] then
																					n = n + 1
																				else
																					n = e[_]
																				end
																				break
																			end
																			t = e[a]
																			r[t] = r[t](r[t + 1])
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		t = e[a]
																		r[t] = r[t](r[t + 1])
																		n = n + 1
																		e = z[n]
																	end
																else
																	if y < 4 then
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if y >= 1 then
																	if y >= -2 then
																		repeat
																			if y ~= 1 then
																				t = e[a]
																				r[t] = r[t](r[t + 1])
																				n = n + 1
																				e = z[n]
																				break
																			end
																			y = 0
																			while y > -1 do
																				if y > 2 then
																					if y >= 5 then
																						if 6 > y then
																							r(s, o)
																						else
																							y = -2
																						end
																					else
																						if 4 > y then
																							o = f[h]
																						else
																							s = f[k]
																						end
																					end
																				else
																					if y >= 1 then
																						if -1 ~= y then
																							repeat
																								if y > 1 then
																									h = _
																									break
																								end
																								k = a
																							until true
																						else
																							h = _
																						end
																					else
																						f = e
																					end
																				end
																				y = y + 1
																			end
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		y = 0
																		while y > -1 do
																			if y > 2 then
																				if y >= 5 then
																					if 6 > y then
																						r(s, o)
																					else
																						y = -2
																					end
																				else
																					if 4 > y then
																						o = f[h]
																					else
																						s = f[k]
																					end
																				end
																			else
																				if y >= 1 then
																					if -1 ~= y then
																						repeat
																							if y > 1 then
																								h = _
																								break
																							end
																							k = a
																						until true
																					else
																						h = _
																					end
																				else
																					f = e
																				end
																			end
																			y = y + 1
																		end
																		n = n + 1
																		e = z[n]
																	end
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													else
														local y, l
														r[e[a]] = r[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														y = e[a]
														l = r[e[_]]
														r[y + 1] = l
														r[y] = l[e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y](t(r, y + 1, e[_]))
													end
												else
													local y, g, j, m, y, y, y, y, y, c, u, y, s, o, ee, t, p, h, b, k
													for y = 0, 9 do
														if y <= 4 then
															if y < 2 then
																if 1 ~= y then
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																if 2 < y then
																	if 0 ~= y then
																		repeat
																			if 3 < y then
																				y = 0
																				while y > -1 do
																					if y > 3 then
																						if y <= 5 then
																							if y > 2 then
																								for e = 46, 88 do
																									if y > 4 then
																										h = t[s]
																										break
																									end
																									u = c[t[o]]
																									break
																								end
																							else
																								h = t[s]
																							end
																						else
																							if 4 <= y then
																								repeat
																									if 7 ~= y then
																										r[h] = u
																										break
																									end
																									y = -2
																								until true
																							else
																								y = -2
																							end
																						end
																					else
																						if y < 2 then
																							if y > -2 then
																								for n = 43, 82 do
																									if y > 0 then
																										s = a
																										break
																									end
																									t = e
																									break
																								end
																							else
																								t = e
																							end
																						else
																							if 0 <= y then
																								for e = 43, 93 do
																									if 3 > y then
																										o = _
																										break
																									end
																									c = r
																									break
																								end
																							else
																								o = _
																							end
																						end
																					end
																					y = y + 1
																				end
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		y = 0
																		while y > -1 do
																			if y > 3 then
																				if y <= 5 then
																					if y > 2 then
																						for e = 46, 88 do
																							if y > 4 then
																								h = t[s]
																								break
																							end
																							u = c[t[o]]
																							break
																						end
																					else
																						h = t[s]
																					end
																				else
																					if 4 <= y then
																						repeat
																							if 7 ~= y then
																								r[h] = u
																								break
																							end
																							y = -2
																						until true
																					else
																						y = -2
																					end
																				end
																			else
																				if y < 2 then
																					if y > -2 then
																						for n = 43, 82 do
																							if y > 0 then
																								s = a
																								break
																							end
																							t = e
																							break
																						end
																					else
																						t = e
																					end
																				else
																					if 0 <= y then
																						for e = 43, 93 do
																							if 3 > y then
																								o = _
																								break
																							end
																							c = r
																							break
																						end
																					else
																						o = _
																					end
																				end
																			end
																			y = y + 1
																		end
																		n = n + 1
																		e = z[n]
																	end
																else
																	y = 0
																	while y > -1 do
																		if y <= 2 then
																			if 1 <= y then
																				if y ~= -3 then
																					for e = 40, 52 do
																						if y ~= 1 then
																							j = _
																							break
																						end
																						g = a
																						break
																					end
																				else
																					j = _
																				end
																			else
																				t = e
																			end
																		else
																			if 5 > y then
																				if y ~= 4 then
																					m = t[j]
																				else
																					h = t[g]
																				end
																			else
																				if y > 5 then
																					y = -2
																				else
																					r(h, m)
																				end
																			end
																		end
																		y = y + 1
																	end
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if y > 6 then
																if 7 < y then
																	if y == 8 then
																		k = e[a]
																		r[k] = r[k](r[k + 1])
																		n = n + 1
																		e = z[n]
																	else
																		if r[e[a]] == r[e[d]] then
																			n = n + 1
																		else
																			n = e[_]
																		end
																	end
																else
																	y = 0
																	while y > -1 do
																		if 2 >= y then
																			if y < 1 then
																				s = a
																				o = _
																				ee = d
																			else
																				if y < 2 then
																					t = e
																				else
																					p = t[o]
																				end
																			end
																		else
																			if 4 >= y then
																				if y ~= 3 then
																					b = r[p]
																					for e = 1 + p, t[ee] do
																						b = b .. r[e]
																					end
																				else
																					h = t[s]
																				end
																			else
																				if y >= 3 then
																					for e = 29, 83 do
																						if 5 ~= y then
																							y = -2
																							break
																						end
																						r[h] = b
																						break
																					end
																				else
																					y = -2
																				end
																			end
																		end
																		y = y + 1
																	end
																	n = n + 1
																	e = z[n]
																end
															else
																if 6 > y then
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											else
												if 168 < y then
													if not r[e[a]] then
														n = n + 1
													else
														n = e[_]
													end
												else
													local y, h
													for l = 0, 5 do
														if l <= 2 then
															if 0 >= l then
																r[e[a]][e[_]] = r[e[d]]
																n = n + 1
																e = z[n]
															else
																if 1 ~= l then
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																else
																	y = e[a]
																	r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if 3 < l then
																if l > 0 then
																	for y = 44, 66 do
																		if 4 < l then
																			r[e[a]][e[_]] = e[d]
																			break
																		end
																		r[e[a]] = {}
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = {}
																	n = n + 1
																	e = z[n]
																end
															else
																y = e[a]
																h = r[e[_]]
																r[y + 1] = h
																r[y] = h[e[d]]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											end
										else
											if y > 164 then
												if y >= 166 then
													if 162 ~= y then
														for l = 32, 66 do
															if 167 > y then
																local y, f
																for l = 0, 9 do
																	if l >= 5 then
																		if l <= 6 then
																			if 4 <= l then
																				for t = 22, 56 do
																					if l ~= 6 then
																						y = e[a]
																						f = r[e[_]]
																						r[y + 1] = f
																						r[y] = f[e[d]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = {}
																					n = n + 1
																					e = z[n]
																					break
																				end
																			else
																				r[e[a]] = {}
																				n = n + 1
																				e = z[n]
																			end
																		else
																			if l > 7 then
																				if l > 4 then
																					for f = 12, 75 do
																						if l ~= 9 then
																							r[e[a]][e[_]] = e[d]
																							n = n + 1
																							e = z[n]
																							break
																						end
																						y = e[a]
																						r[y](t(r, y + 1, e[_]))
																						break
																					end
																				else
																					r[e[a]][e[_]] = e[d]
																					n = n + 1
																					e = z[n]
																				end
																			else
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																			end
																		end
																	else
																		if l > 1 then
																			if l <= 2 then
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																			else
																				if -1 <= l then
																					for f = 36, 71 do
																						if l ~= 3 then
																							y = e[a]
																							r[y] =
																								r[y](t(r, y + 1, e[_]))
																							n = n + 1
																							e = z[n]
																							break
																						end
																						r[e[a]][e[_]] = e[d]
																						n = n + 1
																						e = z[n]
																						break
																					end
																				else
																					y = e[a]
																					r[y] = r[y](t(r, y + 1, e[_]))
																					n = n + 1
																					e = z[n]
																				end
																			end
																		else
																			if l > -4 then
																				repeat
																					if 1 > l then
																						y = e[a]
																						f = r[e[_]]
																						r[y + 1] = f
																						r[y] = f[e[d]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = {}
																					n = n + 1
																					e = z[n]
																				until true
																			else
																				r[e[a]] = {}
																				n = n + 1
																				e = z[n]
																			end
																		end
																	end
																end
																break
															end
															local n = e[a]
															r[n] = r[n](t(r, n + 1, e[_]))
															break
														end
													else
														local y, f
														for l = 0, 9 do
															if l >= 5 then
																if l <= 6 then
																	if 4 <= l then
																		for t = 22, 56 do
																			if l ~= 6 then
																				y = e[a]
																				f = r[e[_]]
																				r[y + 1] = f
																				r[y] = f[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]] = {}
																		n = n + 1
																		e = z[n]
																	end
																else
																	if l > 7 then
																		if l > 4 then
																			for f = 12, 75 do
																				if l ~= 9 then
																					r[e[a]][e[_]] = e[d]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				y = e[a]
																				r[y](t(r, y + 1, e[_]))
																				break
																			end
																		else
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if l > 1 then
																	if l <= 2 then
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	else
																		if -1 <= l then
																			for f = 36, 71 do
																				if l ~= 3 then
																					y = e[a]
																					r[y] = r[y](t(r, y + 1, e[_]))
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			y = e[a]
																			r[y] = r[y](t(r, y + 1, e[_]))
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if l > -4 then
																		repeat
																			if 1 > l then
																				y = e[a]
																				f = r[e[_]]
																				r[y + 1] = f
																				r[y] = f[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r[e[a]] = {}
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													end
												else
													local n = e[a]
													local a = r[e[_]]
													r[n + 1] = a
													r[n] = a[e[d]]
												end
											else
												if 161 <= y then
													repeat
														if 164 > y then
															local l, y, t
															l = e[a]
															y = r[e[_]]
															r[l + 1] = y
															r[l] = y[e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = {}
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = e[d]
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															y = e[_]
															t = r[y]
															for e = y + 1, e[d] do
																t = t .. r[e]
															end
															r[e[a]] = t
															n = n + 1
															e = z[n]
															if not r[e[a]] then
																n = n + 1
															else
																n = e[_]
															end
															break
														end
														local f, h, t
														for y = 0, 5 do
															if y > 2 then
																if y < 4 then
																	f = e[a]
																	r[f] = r[f](r[f + 1])
																	n = n + 1
																	e = z[n]
																else
																	if y ~= 5 then
																		h = e[_]
																		t = r[h]
																		for e = h + 1, e[d] do
																			t = t .. r[e]
																		end
																		r[e[a]] = t
																		n = n + 1
																		e = z[n]
																	else
																		n = e[_]
																	end
																end
															else
																if 0 >= y then
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																else
																	if y ~= 0 then
																		for t = 44, 84 do
																			if 1 ~= y then
																				r[e[a]] = r[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													until true
												else
													local t, h, f
													for y = 0, 5 do
														if y > 2 then
															if y < 4 then
																t = e[a]
																r[t] = r[t](r[t + 1])
																n = n + 1
																e = z[n]
															else
																if y ~= 5 then
																	h = e[_]
																	f = r[h]
																	for e = h + 1, e[d] do
																		f = f .. r[e]
																	end
																	r[e[a]] = f
																	n = n + 1
																	e = z[n]
																else
																	n = e[_]
																end
															end
														else
															if 0 >= y then
																r[e[a]] = l[e[_]]
																n = n + 1
																e = z[n]
															else
																if y ~= 0 then
																	for t = 44, 84 do
																		if 1 ~= y then
																			r[e[a]] = r[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											end
										end
									else
										if y >= 158 then
											if y > 159 then
												if 161 <= y then
													if y >= 157 then
														for l = 29, 89 do
															if 161 < y then
																local e = e[a]
																local a, n = s(r[e](r[e + 1]))
																h = n + e - 1
																local n = 0
																for e = e, h do
																	n = n + 1
																	r[e] = a[n]
																end
																break
															end
															local y
															for l = 0, 4 do
																if 1 >= l then
																	if 1 == l then
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																else
																	if 3 > l then
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		if 4 > l then
																			y = e[a]
																			r[y](t(r, y + 1, e[_]))
																			n = n + 1
																			e = z[n]
																		else
																			n = e[_]
																		end
																	end
																end
															end
															break
														end
													else
														local y
														for l = 0, 4 do
															if 1 >= l then
																if 1 == l then
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															else
																if 3 > l then
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																else
																	if 4 > l then
																		y = e[a]
																		r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	else
																		n = e[_]
																	end
																end
															end
														end
													end
												else
													local y, h
													for l = 0, 7 do
														if 4 <= l then
															if 6 <= l then
																if l ~= 4 then
																	repeat
																		if 7 > l then
																			y = e[a]
																			r[y] = r[y](t(r, y + 1, e[_]))
																			n = n + 1
																			e = z[n]
																			break
																		end
																		f[e[_]] = r[e[a]]
																	until true
																else
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															else
																if l < 5 then
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = (e[_] ~= 0)
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if l >= 2 then
																if 0 <= l then
																	for t = 35, 56 do
																		if l > 2 then
																			y = e[a]
																			h = r[e[_]]
																			r[y + 1] = h
																			r[y] = h[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																if 0 ~= l then
																	f[e[_]] = r[e[a]]
																	n = n + 1
																	e = z[n]
																else
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											else
												if y == 159 then
													if r[e[a]] == r[e[d]] then
														n = n + 1
													else
														n = e[_]
													end
												else
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
												end
											end
										else
											if y >= 156 then
												if y ~= 152 then
													for h = 19, 84 do
														if 157 ~= y then
															local h, k, f, o, s, y, l
															for y = 0, 6 do
																if 3 <= y then
																	if 5 <= y then
																		if y >= 4 then
																			for d = 44, 72 do
																				if y ~= 5 then
																					l = e[a]
																					r[l](t(r, l + 1, e[_]))
																					break
																				end
																				r[e[a]] = r[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			l = e[a]
																			r[l](t(r, l + 1, e[_]))
																		end
																	else
																		if -1 < y then
																			for t = 21, 91 do
																				if 4 > y then
																					r[e[a]][e[_]] = r[e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if y > 0 then
																		if y >= -3 then
																			for t = 40, 80 do
																				if y < 2 then
																					r[e[a]] = {}
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																		end
																	else
																		y = 0
																		while y > -1 do
																			if 3 > y then
																				if 1 > y then
																					h = e
																				else
																					if 0 < y then
																						repeat
																							if 1 < y then
																								f = _
																								break
																							end
																							k = a
																						until true
																					else
																						f = _
																					end
																				end
																			else
																				if 4 < y then
																					if y >= 1 then
																						repeat
																							if y ~= 6 then
																								r(s, o)
																								break
																							end
																							y = -2
																						until true
																					else
																						r(s, o)
																					end
																				else
																					if y < 4 then
																						o = h[f]
																					else
																						s = h[k]
																					end
																				end
																			end
																			y = y + 1
																		end
																		n = n + 1
																		e = z[n]
																	end
																end
															end
															break
														end
														for y = 0, 6 do
															if 3 > y then
																if 0 < y then
																	if y ~= -3 then
																		repeat
																			if y < 2 then
																				r[e[a]] = r[e[_]] - r[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = f[e[_]]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r[e[a]] = r[e[_]] - r[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																if 5 > y then
																	if 2 < y then
																		repeat
																			if 3 ~= y then
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if 5 < y then
																		r[e[a]] = r[e[_]][e[d]]
																	else
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
														break
													end
												else
													local f, k, o, h, s, y, l
													for y = 0, 6 do
														if 3 <= y then
															if 5 <= y then
																if y >= 4 then
																	for d = 44, 72 do
																		if y ~= 5 then
																			l = e[a]
																			r[l](t(r, l + 1, e[_]))
																			break
																		end
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	l = e[a]
																	r[l](t(r, l + 1, e[_]))
																end
															else
																if -1 < y then
																	for t = 21, 91 do
																		if 4 > y then
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if y > 0 then
																if y >= -3 then
																	for t = 40, 80 do
																		if y < 2 then
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = {}
																	n = n + 1
																	e = z[n]
																end
															else
																y = 0
																while y > -1 do
																	if 3 > y then
																		if 1 > y then
																			f = e
																		else
																			if 0 < y then
																				repeat
																					if 1 < y then
																						o = _
																						break
																					end
																					k = a
																				until true
																			else
																				o = _
																			end
																		end
																	else
																		if 4 < y then
																			if y >= 1 then
																				repeat
																					if y ~= 6 then
																						r(s, h)
																						break
																					end
																					y = -2
																				until true
																			else
																				r(s, h)
																			end
																		else
																			if y < 4 then
																				h = f[o]
																			else
																				s = f[k]
																			end
																		end
																	end
																	y = y + 1
																end
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											else
												if y ~= 154 then
													local f, h, b, s, o, y, k
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													y = 0
													while y > -1 do
														if 3 <= y then
															if 5 <= y then
																if y ~= 5 then
																	y = -2
																else
																	r(o, s)
																end
															else
																if 4 > y then
																	s = f[b]
																else
																	o = f[h]
																end
															end
														else
															if y > 0 then
																if 0 < y then
																	for e = 37, 79 do
																		if y ~= 2 then
																			h = a
																			break
																		end
																		b = _
																		break
																	end
																else
																	h = a
																end
															else
																f = e
															end
														end
														y = y + 1
													end
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = 0
													while y > -1 do
														if 3 > y then
															if 1 <= y then
																if -2 <= y then
																	repeat
																		if 2 ~= y then
																			h = a
																			break
																		end
																		b = _
																	until true
																else
																	h = a
																end
															else
																f = e
															end
														else
															if y <= 4 then
																if 1 < y then
																	repeat
																		if y ~= 4 then
																			s = f[b]
																			break
																		end
																		o = f[h]
																	until true
																else
																	o = f[h]
																end
															else
																if y >= 3 then
																	for e = 26, 75 do
																		if y ~= 5 then
																			y = -2
																			break
																		end
																		r(o, s)
																		break
																	end
																else
																	r(o, s)
																end
															end
														end
														y = y + 1
													end
													n = n + 1
													e = z[n]
													k = e[a]
													r[k] = r[k](t(r, k + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
												else
													local y
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y](r[y + 1])
													n = n + 1
													e = z[n]
													for e = e[a], e[_] do
														r[e] = nil
													end
													n = n + 1
													e = z[n]
													do
														return r[e[a]]
													end
													n = n + 1
													e = z[n]
													n = e[_]
												end
											end
										end
									end
								end
							else
								if y <= 210 then
									if y <= 200 then
										if 195 >= y then
											if y > 193 then
												if y > 190 then
													repeat
														if y ~= 195 then
															local h, t
															for y = 0, 9 do
																if 5 > y then
																	if 2 > y then
																		if y ~= -4 then
																			for l = 41, 64 do
																				if 1 ~= y then
																					h = e[_]
																					t = r[h]
																					for e = h + 1, e[d] do
																						t = t .. r[e]
																					end
																					r[e[a]] = t
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]][e[_]] = r[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			h = e[_]
																			t = r[h]
																			for e = h + 1, e[d] do
																				t = t .. r[e]
																			end
																			r[e[a]] = t
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if y <= 2 then
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																		else
																			if 0 < y then
																				repeat
																					if y ~= 3 then
																						r[e[a]] = {}
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = l[e[_]]
																					n = n + 1
																					e = z[n]
																				until true
																			else
																				r[e[a]] = l[e[_]]
																				n = n + 1
																				e = z[n]
																			end
																		end
																	end
																else
																	if 7 <= y then
																		if 7 < y then
																			if y ~= 7 then
																				for d = 32, 79 do
																					if y < 9 then
																						r[e[a]] = l[e[_]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = r[e[_]]
																					break
																				end
																			else
																				r[e[a]] = r[e[_]]
																			end
																		else
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if y >= 2 then
																			repeat
																				if y ~= 6 then
																					r[e[a]] = f[e[_]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]][e[_]] = r[e[d]]
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			r[e[a]] = f[e[_]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
															end
															break
														end
														local d, l, o, y
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														d = e[a]
														l, o = s(r[d]())
														h = o + d - 1
														y = 0
														for e = d, h do
															y = y + 1
															r[e] = l[y]
														end
														n = n + 1
														e = z[n]
														d = e[a]
														r[d] = r[d](t(r, d + 1, h))
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
													until true
												else
													local d, l, o, y
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													d = e[a]
													l, o = s(r[d]())
													h = o + d - 1
													y = 0
													for e = d, h do
														y = y + 1
														r[e] = l[y]
													end
													n = n + 1
													e = z[n]
													d = e[a]
													r[d] = r[d](t(r, d + 1, h))
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = {}
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
												end
											else
												if 193 == y then
													local t, f, h, o, s, y
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = {}
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													y = 0
													while y > -1 do
														if 3 > y then
															if 1 <= y then
																if y >= 0 then
																	for e = 36, 85 do
																		if 1 ~= y then
																			h = _
																			break
																		end
																		f = a
																		break
																	end
																else
																	f = a
																end
															else
																t = e
															end
														else
															if y > 4 then
																if 1 < y then
																	for e = 35, 58 do
																		if 5 < y then
																			y = -2
																			break
																		end
																		r(s, o)
																		break
																	end
																else
																	y = -2
																end
															else
																if y > 2 then
																	repeat
																		if y > 3 then
																			s = t[f]
																			break
																		end
																		o = t[h]
																	until true
																else
																	o = t[h]
																end
															end
														end
														y = y + 1
													end
													n = n + 1
													e = z[n]
													r(e[a], e[_])
												else
													local y
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
												end
											end
										else
											if 198 <= y then
												if 199 <= y then
													if y >= 198 then
														repeat
															if 199 < y then
																local e = e[a]
																do
																	return t(r, e, h)
																end
																break
															end
															local y
															for l = 0, 4 do
																if 1 >= l then
																	if 1 ~= l then
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, h))
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if l >= 3 then
																		if 0 <= l then
																			for y = 45, 60 do
																				if 4 > l then
																					r[e[a]][e[_]] = r[e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]] = {}
																				break
																			end
																		else
																			r[e[a]] = {}
																		end
																	else
																		y = e[a]
																		r[y] = r[y](r[y + 1])
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														until true
													else
														local y
														for l = 0, 4 do
															if 1 >= l then
																if 1 ~= l then
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, h))
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if l >= 3 then
																	if 0 <= l then
																		for y = 45, 60 do
																			if 4 > l then
																				r[e[a]][e[_]] = r[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = {}
																			break
																		end
																	else
																		r[e[a]] = {}
																	end
																else
																	y = e[a]
																	r[y] = r[y](r[y + 1])
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													local l
													for y = 0, 4 do
														if y < 2 then
															if -1 < y then
																for t = 23, 72 do
																	if 0 < y then
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																	break
																end
															else
																r[e[a]] = f[e[_]]
																n = n + 1
																e = z[n]
															end
														else
															if y > 2 then
																if y ~= 3 then
																	if not r[e[a]] then
																		n = n + 1
																	else
																		n = e[_]
																	end
																else
																	l = e[a]
																	r[l] = r[l](t(r, l + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											else
												if 193 < y then
													repeat
														if 197 > y then
															local t, h
															for y = 0, 6 do
																if y >= 3 then
																	if y >= 5 then
																		if 4 ~= y then
																			repeat
																				if y > 5 then
																					r[e[a]] = f[e[_]]
																					break
																				end
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			r[e[a]] = f[e[_]]
																		end
																	else
																		if y >= -1 then
																			repeat
																				if y > 3 then
																					r[e[a]] = l[e[_]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if y >= 1 then
																		if -1 ~= y then
																			for l = 19, 55 do
																				if y ~= 1 then
																					r[e[a]] = {}
																					n = n + 1
																					e = z[n]
																					break
																				end
																				t = e[a]
																				h = r[e[_]]
																				r[t + 1] = h
																				r[t] = h[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			t = e[a]
																			h = r[e[_]]
																			r[t + 1] = h
																			r[t] = h[e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
															break
														end
														for y = 0, 6 do
															if 3 > y then
																if 0 < y then
																	if y ~= -3 then
																		for t = 17, 93 do
																			if 1 ~= y then
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	end
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if y >= 5 then
																	if y > 4 then
																		repeat
																			if y < 6 then
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]][e[_]] = e[d]
																		until true
																	else
																		r[e[a]][e[_]] = e[d]
																	end
																else
																	if 3 ~= y then
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													until true
												else
													for y = 0, 6 do
														if 3 > y then
															if 0 < y then
																if y ~= -3 then
																	for t = 17, 93 do
																		if 1 ~= y then
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]][e[_]] = e[d]
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
															end
														else
															if y >= 5 then
																if y > 4 then
																	repeat
																		if y < 6 then
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]][e[_]] = e[d]
																	until true
																else
																	r[e[a]][e[_]] = e[d]
																end
															else
																if 3 ~= y then
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											end
										end
									else
										if 206 <= y then
											if y >= 208 then
												if y <= 208 then
													local h, b, o, k, s, y, f
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = 0
													while y > -1 do
														if 2 < y then
															if 5 > y then
																if y ~= 4 then
																	k = h[o]
																else
																	s = h[b]
																end
															else
																if 4 < y then
																	repeat
																		if y > 5 then
																			y = -2
																			break
																		end
																		r(s, k)
																	until true
																else
																	r(s, k)
																end
															end
														else
															if y <= 0 then
																h = e
															else
																if 0 <= y then
																	for e = 41, 77 do
																		if y > 1 then
																			o = _
																			break
																		end
																		b = a
																		break
																	end
																else
																	o = _
																end
															end
														end
														y = y + 1
													end
													n = n + 1
													e = z[n]
													f = e[a]
													r[f] = r[f](t(r, f + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
												else
													if 206 ~= y then
														repeat
															if 210 > y then
																local n = e[a]
																r[n](t(r, n + 1, e[_]))
																break
															end
															local e = e[a]
															r[e] = r[e](r[e + 1])
														until true
													else
														local e = e[a]
														r[e] = r[e](r[e + 1])
													end
												end
											else
												if 203 ~= y then
													for f = 40, 59 do
														if y ~= 206 then
															local y, f
															r[e[a]][e[_]] = e[d]
															n = n + 1
															e = z[n]
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](t(r, y + 1, e[_]))
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = r[e[d]]
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](t(r, y + 1, e[_]))
															n = n + 1
															e = z[n]
															y = e[a]
															f = r[e[_]]
															r[y + 1] = f
															r[y] = f[e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = {}
															break
														end
														r[e[a]][e[_]] = r[e[d]]
														break
													end
												else
													r[e[a]][e[_]] = r[e[d]]
												end
											end
										else
											if 203 <= y then
												if y > 203 then
													if y >= 201 then
														for z = 38, 66 do
															if 204 < y then
																local a = e[a]
																local z = r[a]
																local d = r[a + 2]
																if d > 0 then
																	if z > r[a + 1] then
																		n = e[_]
																	else
																		r[a + 3] = z
																	end
																elseif z < r[a + 1] then
																	n = e[_]
																else
																	r[a + 3] = z
																end
																break
															end
															r[e[a]] = l[e[_]]
															break
														end
													else
														local a = e[a]
														local z = r[a]
														local d = r[a + 2]
														if d > 0 then
															if z > r[a + 1] then
																n = e[_]
															else
																r[a + 3] = z
															end
														elseif z < r[a + 1] then
															n = e[_]
														else
															r[a + 3] = z
														end
													end
												else
													local y
													for l = 0, 4 do
														if 1 >= l then
															if 1 == l then
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
															else
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
															end
														else
															if l >= 3 then
																if l ~= 4 then
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]][e[_]] = r[e[d]]
																end
															else
																r[e[a]] = r[e[_]] + r[e[d]]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											else
												if y >= 197 then
													for l = 41, 96 do
														if 202 ~= y then
															local y, t
															f[e[_]] = r[e[a]]
															n = n + 1
															e = z[n]
															r[e[a]] = f[e[_]]
															n = n + 1
															e = z[n]
															y = e[a]
															t = r[e[_]]
															r[y + 1] = t
															r[y] = t[e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = {}
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = e[d]
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = e[d]
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = e[d]
															break
														end
														local y, l
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														y = e[a]
														l = r[e[_]]
														r[y + 1] = l
														r[y] = l[e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														break
													end
												else
													local y, l
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													y = e[a]
													l = r[e[_]]
													r[y + 1] = l
													r[y] = l[e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
												end
											end
										end
									end
								else
									if 220 >= y then
										if y <= 215 then
											if y > 212 then
												if 214 > y then
													r[e[a]] = r[e[_]]
												else
													if 214 == y then
														local y
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](r[y + 1])
														n = n + 1
														e = z[n]
														if r[e[a]] == e[d] then
															n = n + 1
														else
															n = e[_]
														end
													else
														do
															return r[e[a]]
														end
													end
												end
											else
												if 209 <= y then
													repeat
														if 211 < y then
															local s, u, b, h, k, c, y, l, o
															y = 0
															while y > -1 do
																if 3 < y then
																	if y >= 6 then
																		if 3 ~= y then
																			for e = 35, 68 do
																				if y ~= 6 then
																					y = -2
																					break
																				end
																				r[c] = k
																				break
																			end
																		else
																			y = -2
																		end
																	else
																		if 5 == y then
																			c = s[u]
																		else
																			k = h[s[b]]
																		end
																	end
																else
																	if 2 > y then
																		if y < 1 then
																			s = e
																		else
																			u = a
																		end
																	else
																		if y > 1 then
																			repeat
																				if 2 ~= y then
																					h = r
																					break
																				end
																				b = _
																			until true
																		else
																			h = r
																		end
																	end
																end
																y = y + 1
															end
															n = n + 1
															e = z[n]
															l = e[a]
															r[l] = r[l](r[l + 1])
															n = n + 1
															e = z[n]
															r[e[a]] = f[e[_]]
															n = n + 1
															e = z[n]
															l = e[a]
															o = r[e[_]]
															r[l + 1] = o
															r[l] = o[e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]]
															n = n + 1
															e = z[n]
															l = e[a]
															r[l] = r[l](t(r, l + 1, e[_]))
															n = n + 1
															e = z[n]
															if not r[e[a]] then
																n = n + 1
															else
																n = e[_]
															end
															break
														end
														local d
														for y = 0, 1 do
															if 0 ~= y then
																d = e[a]
																r[d](r[d + 1])
															else
																r[e[a]] = r[e[_]]
																n = n + 1
																e = z[n]
															end
														end
													until true
												else
													local h, b, c, o, u, k, y, l, s
													y = 0
													while y > -1 do
														if 3 < y then
															if y >= 6 then
																if 3 ~= y then
																	for e = 35, 68 do
																		if y ~= 6 then
																			y = -2
																			break
																		end
																		r[k] = u
																		break
																	end
																else
																	y = -2
																end
															else
																if 5 == y then
																	k = h[b]
																else
																	u = o[h[c]]
																end
															end
														else
															if 2 > y then
																if y < 1 then
																	h = e
																else
																	b = a
																end
															else
																if y > 1 then
																	repeat
																		if 2 ~= y then
																			o = r
																			break
																		end
																		c = _
																	until true
																else
																	o = r
																end
															end
														end
														y = y + 1
													end
													n = n + 1
													e = z[n]
													l = e[a]
													r[l] = r[l](r[l + 1])
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													l = e[a]
													s = r[e[_]]
													r[l + 1] = s
													r[l] = s[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]]
													n = n + 1
													e = z[n]
													l = e[a]
													r[l] = r[l](t(r, l + 1, e[_]))
													n = n + 1
													e = z[n]
													if not r[e[a]] then
														n = n + 1
													else
														n = e[_]
													end
												end
											end
										else
											if 217 < y then
												if y > 218 then
													if 220 ~= y then
														local l, f
														for y = 0, 6 do
															if y < 3 then
																if 0 < y then
																	if y > 1 then
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]] = {}
																		n = n + 1
																		e = z[n]
																	end
																else
																	l = e[a]
																	f = r[e[_]]
																	r[l + 1] = f
																	r[l] = f[e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if 5 > y then
																	if y >= 0 then
																		for t = 49, 61 do
																			if y > 3 then
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if y ~= 6 then
																		l = e[a]
																		r[l](t(r, l + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	else
																		n = e[_]
																	end
																end
															end
														end
													else
														local n = e[a]
														local a = r[n]
														for e = n + 1, e[_] do
															o.KtjR_Kcj(a, r[e])
														end
													end
												else
													local y
													r[e[a]] = {}
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](r[y + 1])
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
												end
											else
												if 212 < y then
													repeat
														if 216 ~= y then
															local z = e[a]
															local _ = {}
															for e = 1, #k do
																local e = k[e]
																for n = 0, #e do
																	local n = e[n]
																	local a = n[1]
																	local e = n[2]
																	if a == r and e >= z then
																		_[e] = a[e]
																		n[1] = _
																	end
																end
															end
															break
														end
														local y, k, o, f
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][r[e[d]]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][r[e[d]]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														k, o = s(r[y](t(r, y + 1, e[_])))
														h = o + y - 1
														f = 0
														for e = y, h do
															f = f + 1
															r[e] = k[f]
														end
														n = n + 1
														e = z[n]
														y = e[a]
														r[y](t(r, y + 1, h))
													until true
												else
													local y, o, k, f
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][r[e[d]]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][r[e[d]]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													o, k = s(r[y](t(r, y + 1, e[_])))
													h = k + y - 1
													f = 0
													for e = y, h do
														f = f + 1
														r[e] = o[f]
													end
													n = n + 1
													e = z[n]
													y = e[a]
													r[y](t(r, y + 1, h))
												end
											end
										end
									else
										if y > 225 then
											if y < 228 then
												if 223 <= y then
													repeat
														if y ~= 227 then
															for e = e[a], e[_] do
																r[e] = nil
															end
															break
														end
														local y
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
													until true
												else
													for e = e[a], e[_] do
														r[e] = nil
													end
												end
											else
												if 228 < y then
													if y ~= 229 then
														local d
														d = e[a]
														r[d] = r[d]()
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														d = e[a]
														r[d] = r[d](r[d + 1])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
													else
														local y, o, k, b, f
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y]()
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														o = r[e[_]]
														r[y + 1] = o
														r[y] = o[e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														k, b = s(r[y](t(r, y + 1, e[_])))
														h = b + y - 1
														f = 0
														for e = y, h do
															f = f + 1
															r[e] = k[f]
														end
													end
												else
													for y = 0, 3 do
														if 2 <= y then
															if y < 3 then
																r[e[a]] = l[e[_]]
																n = n + 1
																e = z[n]
															else
																if r[e[a]] == e[d] then
																	n = n + 1
																else
																	n = e[_]
																end
															end
														else
															if -1 < y then
																for d = 48, 96 do
																	if 1 ~= y then
																		r[e[a]] = (e[_] ~= 0)
																		n = n + 1
																		e = z[n]
																		break
																	end
																	l[e[_]] = r[e[a]]
																	n = n + 1
																	e = z[n]
																	break
																end
															else
																r[e[a]] = (e[_] ~= 0)
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											end
										else
											if 223 > y then
												if y > 217 then
													for f = 49, 65 do
														if y ~= 222 then
															l[e[_]] = r[e[a]]
															break
														end
														local f
														for y = 0, 6 do
															if 3 > y then
																if y < 1 then
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																else
																	if -3 ~= y then
																		repeat
																			if 2 > y then
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if y > 4 then
																	if 3 ~= y then
																		repeat
																			if y ~= 6 then
																				r[e[a]][e[_]] = r[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = l[e[_]]
																		until true
																	else
																		r[e[a]] = l[e[_]]
																	end
																else
																	if 2 <= y then
																		repeat
																			if 4 ~= y then
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																			f = e[a]
																			r[f] = r[f](t(r, f + 1, e[_]))
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		f = e[a]
																		r[f] = r[f](t(r, f + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
														break
													end
												else
													local f
													for y = 0, 6 do
														if 3 > y then
															if y < 1 then
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
															else
																if -3 ~= y then
																	repeat
																		if 2 > y then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if y > 4 then
																if 3 ~= y then
																	repeat
																		if y ~= 6 then
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = l[e[_]]
																	until true
																else
																	r[e[a]] = l[e[_]]
																end
															else
																if 2 <= y then
																	repeat
																		if 4 ~= y then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																		f = e[a]
																		r[f] = r[f](t(r, f + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	until true
																else
																	f = e[a]
																	r[f] = r[f](t(r, f + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											else
												if y <= 223 then
													local y, f
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													y = e[a]
													f = r[e[_]]
													r[y + 1] = f
													r[y] = f[e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
												else
													if y >= 222 then
														for t = 13, 64 do
															if 224 ~= y then
																r[e[a]] = r[e[_]][r[e[d]]]
																break
															end
															local l, t
															for y = 0, 6 do
																if y > 2 then
																	if y < 5 then
																		if y ~= -1 then
																			repeat
																				if 4 ~= y then
																					r[e[a]] = r[e[_]][e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]][e[_]] = r[e[d]]
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if 5 < y then
																			r[e[a]][e[_]] = e[d]
																		else
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if 0 >= y then
																		l = e[a]
																		t = r[e[_]]
																		r[l + 1] = t
																		r[l] = t[e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		if y > -3 then
																			for d = 49, 71 do
																				if y > 1 then
																					r[e[a]] = {}
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
															end
															break
														end
													else
														r[e[a]] = r[e[_]][r[e[d]]]
													end
												end
											end
										end
									end
								end
							end
						else
							if y < 270 then
								if y < 250 then
									if 239 >= y then
										if y > 234 then
											if y <= 236 then
												if 233 <= y then
													repeat
														if y ~= 236 then
															local y, f
															for t = 0, 6 do
																if t <= 2 then
																	if t >= 1 then
																		if t > 1 then
																			y = e[a]
																			r[y](r[y + 1])
																			n = n + 1
																			e = z[n]
																		else
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		end
																	else
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if 5 > t then
																		if -1 <= t then
																			repeat
																				if t < 4 then
																					r[e[a]] = l[e[_]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				y = e[a]
																				f = r[e[_]]
																				r[y + 1] = f
																				r[y] = f[e[d]]
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			y = e[a]
																			f = r[e[_]]
																			r[y + 1] = f
																			r[y] = f[e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if t >= 4 then
																			for d = 12, 69 do
																				if 5 ~= t then
																					if not r[e[a]] then
																						n = n + 1
																					else
																						n = e[_]
																					end
																					break
																				end
																				y = e[a]
																				r[y] = r[y](r[y + 1])
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			if not r[e[a]] then
																				n = n + 1
																			else
																				n = e[_]
																			end
																		end
																	end
																end
															end
															break
														end
														local y, l, t
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y]()
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]] * e[d]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](r[y + 1])
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]] + e[d]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](r[y + 1])
														n = n + 1
														e = z[n]
														l = e[_]
														t = r[l]
														for e = l + 1, e[d] do
															t = t .. r[e]
														end
														r[e[a]] = t
													until true
												else
													local y, l, t
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y]()
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]] * e[d]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](r[y + 1])
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]] + e[d]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](r[y + 1])
													n = n + 1
													e = z[n]
													l = e[_]
													t = r[l]
													for e = l + 1, e[d] do
														t = t .. r[e]
													end
													r[e[a]] = t
												end
											else
												if 237 < y then
													if 236 <= y then
														for t = 38, 98 do
															if y > 238 then
																for y = 0, 4 do
																	if 2 <= y then
																		if 2 < y then
																			if -1 ~= y then
																				for t = 46, 90 do
																					if 3 < y then
																						if r[e[a]] == r[e[d]] then
																							n = n + 1
																						else
																							n = e[_]
																						end
																						break
																					end
																					r[e[a]] = r[e[_]][e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																			else
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																			end
																		else
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if -3 < y then
																			repeat
																				if 1 > y then
																					r[e[a]] = r[e[_]][e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]] = l[e[_]]
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
																break
															end
															if r[e[a]] ~= e[d] then
																n = n + 1
															else
																n = e[_]
															end
															break
														end
													else
														if r[e[a]] ~= e[d] then
															n = n + 1
														else
															n = e[_]
														end
													end
												else
													r[e[a]] = f[e[_]]
												end
											end
										else
											if y < 233 then
												if 230 <= y then
													repeat
														if y > 231 then
															r[e[a]] = r[e[_]][e[d]]
															break
														end
														local y
														for l = 0, 4 do
															if 2 <= l then
																if 3 > l then
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																else
																	if 1 <= l then
																		for d = 19, 53 do
																			if l > 3 then
																				if not r[e[a]] then
																					n = n + 1
																				else
																					n = e[_]
																				end
																				break
																			end
																			y = e[a]
																			r[y] = r[y](t(r, y + 1, e[_]))
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if -4 <= l then
																	repeat
																		if l ~= 0 then
																			r[e[a]] = f[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													until true
												else
													r[e[a]] = r[e[_]][e[d]]
												end
											else
												if y > 232 then
													repeat
														if 234 ~= y then
															local t, f
															for y = 0, 4 do
																if y >= 2 then
																	if y > 2 then
																		if y ~= 0 then
																			for d = 22, 74 do
																				if 4 > y then
																					r[e[a]] = (e[_] ~= 0)
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]] = l[e[_]]
																				break
																			end
																		else
																			r[e[a]] = l[e[_]]
																		end
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																else
																	if y > -1 then
																		for l = 36, 78 do
																			if 0 ~= y then
																				r[e[a]] = (e[_] ~= 0)
																				n = n + 1
																				e = z[n]
																				break
																			end
																			t = e[a]
																			f = r[e[_]]
																			r[t + 1] = f
																			r[t] = f[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]] = (e[_] ~= 0)
																		n = n + 1
																		e = z[n]
																	end
																end
															end
															break
														end
														local y
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y](r[y + 1])
														n = n + 1
														e = z[n]
														r[e[a]] = (e[_] ~= 0)
														n = n + 1
														e = z[n]
														do
															return r[e[a]]
														end
														n = n + 1
														e = z[n]
														n = e[_]
													until true
												else
													local y
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y](r[y + 1])
													n = n + 1
													e = z[n]
													r[e[a]] = (e[_] ~= 0)
													n = n + 1
													e = z[n]
													do
														return r[e[a]]
													end
													n = n + 1
													e = z[n]
													n = e[_]
												end
											end
										end
									else
										if 244 < y then
											if 247 > y then
												if 244 <= y then
													repeat
														if 246 > y then
															if r[e[a]] ~= e[d] then
																n = n + 1
															else
																n = e[_]
															end
															break
														end
														local y, t, l, o, s, h, d
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y]()
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														d = 0
														while d > -1 do
															if 2 < d then
																if d > 4 then
																	if d == 6 then
																		d = -2
																	else
																		r(h, s)
																	end
																else
																	if -1 <= d then
																		repeat
																			if 4 ~= d then
																				s = t[o]
																				break
																			end
																			h = t[l]
																		until true
																	else
																		h = t[l]
																	end
																end
															else
																if 1 > d then
																	t = e
																else
																	if -1 ~= d then
																		for e = 38, 61 do
																			if d ~= 1 then
																				o = _
																				break
																			end
																			l = a
																			break
																		end
																	else
																		l = a
																	end
																end
															end
															d = d + 1
														end
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](r[y + 1])
													until true
												else
													if r[e[a]] ~= e[d] then
														n = n + 1
													else
														n = e[_]
													end
												end
											else
												if y >= 248 then
													if 245 ~= y then
														for f = 28, 59 do
															if y < 249 then
																local y, f
																y = e[a]
																f = r[e[_]]
																r[y + 1] = f
																r[y] = f[e[d]]
																n = n + 1
																e = z[n]
																r[e[a]] = {}
																n = n + 1
																e = z[n]
																r[e[a]][e[_]] = e[d]
																n = n + 1
																e = z[n]
																r[e[a]][e[_]] = e[d]
																n = n + 1
																e = z[n]
																r[e[a]][e[_]] = e[d]
																n = n + 1
																e = z[n]
																y = e[a]
																r[y](t(r, y + 1, e[_]))
																n = n + 1
																e = z[n]
																r[e[a]] = l[e[_]]
																break
															end
															local h, k, f, o, s, y, b
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															y = 0
															while y > -1 do
																if 2 >= y then
																	if 1 <= y then
																		if 0 ~= y then
																			for e = 12, 84 do
																				if y > 1 then
																					f = _
																					break
																				end
																				k = a
																				break
																			end
																		else
																			f = _
																		end
																	else
																		h = e
																	end
																else
																	if 4 >= y then
																		if y ~= 4 then
																			o = h[f]
																		else
																			s = h[k]
																		end
																	else
																		if y ~= 4 then
																			for e = 14, 57 do
																				if 6 > y then
																					r(s, o)
																					break
																				end
																				y = -2
																				break
																			end
																		else
																			y = -2
																		end
																	end
																end
																y = y + 1
															end
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															y = 0
															while y > -1 do
																if 2 < y then
																	if y > 4 then
																		if 5 == y then
																			r(s, o)
																		else
																			y = -2
																		end
																	else
																		if 1 ~= y then
																			repeat
																				if 4 > y then
																					o = h[f]
																					break
																				end
																				s = h[k]
																			until true
																		else
																			o = h[f]
																		end
																	end
																else
																	if 1 <= y then
																		if -2 <= y then
																			repeat
																				if y ~= 1 then
																					f = _
																					break
																				end
																				k = a
																			until true
																		else
																			f = _
																		end
																	else
																		h = e
																	end
																end
																y = y + 1
															end
															n = n + 1
															e = z[n]
															b = e[a]
															r[b] = r[b](t(r, b + 1, e[_]))
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = r[e[d]]
															break
														end
													else
														local y, f
														y = e[a]
														f = r[e[_]]
														r[y + 1] = f
														r[y] = f[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
													end
												else
													local t, y, l, f, h, b, s, k, o
													local z = 0
													while z > -1 do
														if 2 < z then
															if 4 >= z then
																if z > 0 then
																	for e = 25, 61 do
																		if z < 4 then
																			s = t[f]
																			k = t[h]
																			break
																		end
																		o = s == k and y[b] or 1 + l
																		break
																	end
																else
																	s = t[f]
																	k = t[h]
																end
															else
																if 3 ~= z then
																	for e = 32, 91 do
																		if z < 6 then
																			n = o
																			break
																		end
																		z = -2
																		break
																	end
																else
																	n = o
																end
															end
														else
															if z > 0 then
																if z > -3 then
																	for r = 38, 52 do
																		if z < 2 then
																			y = e
																			l = n
																			break
																		end
																		f = y[a]
																		h = y[d]
																		b = _
																		break
																	end
																else
																	y = e
																	l = n
																end
															else
																t = r
															end
														end
														z = z + 1
													end
												end
											end
										else
											if y < 242 then
												if y > 236 then
													for f = 14, 64 do
														if y ~= 240 then
															local y
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](t(r, y + 1, e[_]))
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = r[e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															break
														end
														local y, b, k, o
														for f = 0, 5 do
															if 3 <= f then
																if f >= 4 then
																	if 4 == f then
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, h))
																		n = n + 1
																		e = z[n]
																	else
																		if r[e[a]] == e[d] then
																			n = n + 1
																		else
																			n = e[_]
																		end
																	end
																else
																	y = e[a]
																	b, k = s(r[y](r[y + 1]))
																	h = k + y - 1
																	o = 0
																	for e = y, h do
																		o = o + 1
																		r[e] = b[o]
																	end
																	n = n + 1
																	e = z[n]
																end
															else
																if f > 0 then
																	if f ~= -1 then
																		repeat
																			if 1 < f then
																				r[e[a]] = r[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	r[e[a]] = r[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
														break
													end
												else
													local y, b, k, o
													for f = 0, 5 do
														if 3 <= f then
															if f >= 4 then
																if 4 == f then
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, h))
																	n = n + 1
																	e = z[n]
																else
																	if r[e[a]] == e[d] then
																		n = n + 1
																	else
																		n = e[_]
																	end
																end
															else
																y = e[a]
																b, k = s(r[y](r[y + 1]))
																h = k + y - 1
																o = 0
																for e = y, h do
																	o = o + 1
																	r[e] = b[o]
																end
																n = n + 1
																e = z[n]
															end
														else
															if f > 0 then
																if f ~= -1 then
																	repeat
																		if 1 < f then
																			r[e[a]] = r[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]] = r[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]] = r[e[_]]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											else
												if 242 >= y then
													local l, h
													for y = 0, 6 do
														if 2 < y then
															if 5 <= y then
																if 3 < y then
																	for t = 49, 53 do
																		if y < 6 then
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]][e[_]] = e[d]
																		break
																	end
																else
																	r[e[a]][e[_]] = e[d]
																	n = n + 1
																	e = z[n]
																end
															else
																if y > -1 then
																	repeat
																		if 3 < y then
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																			break
																		end
																		l = e[a]
																		h = r[e[_]]
																		r[l + 1] = h
																		r[l] = h[e[d]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]] = {}
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if y <= 0 then
																r[e[a]][e[_]] = r[e[d]]
																n = n + 1
																e = z[n]
															else
																if -3 <= y then
																	for d = 42, 75 do
																		if 1 ~= y then
																			r[e[a]] = f[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		l = e[a]
																		r[l](t(r, l + 1, e[_]))
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													if y ~= 241 then
														repeat
															if 243 ~= y then
																r[e[a]] = {}
																break
															end
															r[e[a]] = f[e[_]]
														until true
													else
														r[e[a]] = {}
													end
												end
											end
										end
									end
								else
									if 260 > y then
										if 255 > y then
											if y < 252 then
												if 251 ~= y then
													local z = r[e[d]]
													if z then
														n = n + 1
													else
														r[e[a]] = z
														n = e[_]
													end
												else
													local y, b, k, o
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													y = e[a]
													b, k = s(r[y](t(r, y + 1, e[_])))
													h = k + y - 1
													o = 0
													for e = y, h do
														o = o + 1
														r[e] = b[o]
													end
													n = n + 1
													e = z[n]
													y = e[a]
													r[y](t(r, y + 1, h))
												end
											else
												if y <= 252 then
													local y
													for t = 0, 7 do
														if t < 4 then
															if t <= 1 then
																if t == 1 then
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																else
																	y = e[a]
																	r[y] = r[y]()
																	n = n + 1
																	e = z[n]
																end
															else
																if -1 <= t then
																	repeat
																		if t < 3 then
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if 5 < t then
																if t > 5 then
																	for l = 32, 60 do
																		if t < 7 then
																			y = e[a]
																			r[y] = r[y]()
																			n = n + 1
																			e = z[n]
																			break
																		end
																		if r[e[a]] ~= r[e[d]] then
																			n = n + 1
																		else
																			n = e[_]
																		end
																		break
																	end
																else
																	y = e[a]
																	r[y] = r[y]()
																	n = n + 1
																	e = z[n]
																end
															else
																if 3 ~= t then
																	for d = 39, 59 do
																		if 5 ~= t then
																			y = e[a]
																			r[y](r[y + 1])
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = r[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													if y ~= 254 then
														r[e[a]] = r[e[_]] * e[d]
													else
														r[e[a]] = (e[_] ~= 0)
														n = n + 1
													end
												end
											end
										else
											if 256 >= y then
												if 254 ~= y then
													for n = 24, 53 do
														if 255 < y then
															local e = e[a]
															do
																return t(r, e, h)
															end
															break
														end
														local n = e[a]
														local _ = { r[n](r[n + 1]) }
														local a = 0
														for e = n, e[d] do
															a = a + 1
															r[e] = _[a]
														end
														break
													end
												else
													local n = e[a]
													local _ = { r[n](r[n + 1]) }
													local a = 0
													for e = n, e[d] do
														a = a + 1
														r[e] = _[a]
													end
												end
											else
												if y > 257 then
													if y > 256 then
														repeat
															if y ~= 258 then
																if not r[e[a]] then
																	n = n + 1
																else
																	n = e[_]
																end
																break
															end
															local e = e[a]
															do
																return r[e], r[e + 1]
															end
														until true
													else
														if not r[e[a]] then
															n = n + 1
														else
															n = e[_]
														end
													end
												else
													r[e[a]][r[e[_]]] = r[e[d]]
												end
											end
										end
									else
										if y > 264 then
											if 267 > y then
												if y >= 264 then
													repeat
														if y > 265 then
															local f
															for y = 0, 6 do
																if 2 < y then
																	if 4 < y then
																		if y >= 1 then
																			for d = 24, 56 do
																				if 5 < y then
																					r(e[a], e[_])
																					break
																				end
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			r(e[a], e[_])
																		end
																	else
																		if 0 ~= y then
																			for t = 21, 69 do
																				if 3 < y then
																					r(e[a], e[_])
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if 0 >= y then
																		f = e[a]
																		r[f] = r[f](t(r, f + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	else
																		if y > -3 then
																			repeat
																				if y ~= 1 then
																					r[e[a]] = l[e[_]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]][e[_]] = r[e[d]]
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
															end
															break
														end
														local y
														for l = 0, 5 do
															if l > 2 then
																if l >= 4 then
																	if 0 ~= l then
																		for d = 44, 98 do
																			if l > 4 then
																				y = e[a]
																				r[y](t(r, y + 1, e[_]))
																				break
																			end
																			r[e[a]] = r[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if 1 > l then
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																else
																	if l ~= -2 then
																		for d = 17, 78 do
																			if 2 > l then
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																			y = e[a]
																			r[y] = r[y](t(r, y + 1, e[_]))
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													until true
												else
													local y
													for l = 0, 5 do
														if l > 2 then
															if l >= 4 then
																if 0 ~= l then
																	for d = 44, 98 do
																		if l > 4 then
																			y = e[a]
																			r[y](t(r, y + 1, e[_]))
																			break
																		end
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = r[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]][e[_]] = r[e[d]]
																n = n + 1
																e = z[n]
															end
														else
															if 1 > l then
																r(e[a], e[_])
																n = n + 1
																e = z[n]
															else
																if l ~= -2 then
																	for d = 17, 78 do
																		if 2 > l then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											else
												if 267 < y then
													if 267 < y then
														repeat
															if y ~= 268 then
																local y, l
																r[e[a]] = {}
																n = n + 1
																e = z[n]
																r[e[a]] = f[e[_]]
																n = n + 1
																e = z[n]
																r[e[a]][e[_]] = r[e[d]]
																n = n + 1
																e = z[n]
																y = e[a]
																r[y] = r[y](t(r, y + 1, e[_]))
																n = n + 1
																e = z[n]
																y = e[a]
																l = r[e[_]]
																r[y + 1] = l
																r[y] = l[e[d]]
																n = n + 1
																e = z[n]
																y = e[a]
																r[y](r[y + 1])
																n = n + 1
																e = z[n]
																r[e[a]] = f[e[_]]
																n = n + 1
																e = z[n]
																y = e[a]
																l = r[e[_]]
																r[y + 1] = l
																r[y] = l[e[d]]
																n = n + 1
																e = z[n]
																r(e[a], e[_])
																n = n + 1
																e = z[n]
																y = e[a]
																r[y] = r[y](t(r, y + 1, e[_]))
																break
															end
															local d
															r[e[a]] = r[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]]
															n = n + 1
															e = z[n]
															d = e[a]
															do
																return r[d](t(r, d + 1, e[_]))
															end
															n = n + 1
															e = z[n]
															d = e[a]
															do
																return t(r, d, h)
															end
															n = n + 1
															e = z[n]
															do
																return
															end
														until true
													else
														local y, l
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														y = e[a]
														l = r[e[_]]
														r[y + 1] = l
														r[y] = l[e[d]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y](r[y + 1])
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														l = r[e[_]]
														r[y + 1] = l
														r[y] = l[e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
													end
												else
													local n = e[a]
													local _ = { r[n](r[n + 1]) }
													local a = 0
													for e = n, e[d] do
														a = a + 1
														r[e] = _[a]
													end
												end
											end
										else
											if y >= 262 then
												if 262 < y then
													if 261 < y then
														repeat
															if 263 < y then
																local d
																d = e[a]
																r[d](t(r, d + 1, e[_]))
																n = n + 1
																e = z[n]
																do
																	return
																end
																break
															end
															local y
															y = e[a]
															r[y] = r[y](t(r, y + 1, e[_]))
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = r[e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](t(r, y + 1, e[_]))
														until true
													else
														local y
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
													end
												else
													for y = 0, 6 do
														if 3 > y then
															if y >= 1 then
																if y == 1 then
																	r[e[a]] = {}
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]] = {}
																n = n + 1
																e = z[n]
															end
														else
															if y <= 4 then
																if 1 <= y then
																	for t = 18, 56 do
																		if y ~= 4 then
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if y >= 2 then
																	repeat
																		if 6 ~= y then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																	until true
																else
																	r(e[a], e[_])
																end
															end
														end
													end
												end
											else
												if 259 ~= y then
													for l = 31, 60 do
														if 260 ~= y then
															local y, l
															r[e[a]][e[_]] = e[d]
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](t(r, y + 1, e[_]))
															n = n + 1
															e = z[n]
															f[e[_]] = r[e[a]]
															n = n + 1
															e = z[n]
															r[e[a]] = f[e[_]]
															n = n + 1
															e = z[n]
															y = e[a]
															l = r[e[_]]
															r[y + 1] = l
															r[y] = l[e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = {}
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = e[d]
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = e[d]
															break
														end
														local l, o, f, h, s, y, k
														for y = 0, 6 do
															if y <= 2 then
																if 0 < y then
																	if -1 < y then
																		for d = 30, 57 do
																			if 2 ~= y then
																				y = 0
																				while y > -1 do
																					if y > 2 then
																						if y >= 5 then
																							if 6 > y then
																								r(s, h)
																							else
																								y = -2
																							end
																						else
																							if y ~= 2 then
																								for e = 39, 73 do
																									if y ~= 4 then
																										h = l[f]
																										break
																									end
																									s = l[o]
																									break
																								end
																							else
																								h = l[f]
																							end
																						end
																					else
																						if y < 1 then
																							l = e
																						else
																							if y > -3 then
																								repeat
																									if 2 > y then
																										o = a
																										break
																									end
																									f = _
																								until true
																							else
																								f = _
																							end
																						end
																					end
																					y = y + 1
																				end
																				n = n + 1
																				e = z[n]
																				break
																			end
																			y = 0
																			while y > -1 do
																				if 2 < y then
																					if y >= 5 then
																						if 5 == y then
																							r(s, h)
																						else
																							y = -2
																						end
																					else
																						if 3 ~= y then
																							s = l[o]
																						else
																							h = l[f]
																						end
																					end
																				else
																					if y <= 0 then
																						l = e
																					else
																						if y ~= 1 then
																							f = _
																						else
																							o = a
																						end
																					end
																				end
																				y = y + 1
																			end
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		y = 0
																		while y > -1 do
																			if 2 < y then
																				if y >= 5 then
																					if 5 == y then
																						r(s, h)
																					else
																						y = -2
																					end
																				else
																					if 3 ~= y then
																						s = l[o]
																					else
																						h = l[f]
																					end
																				end
																			else
																				if y <= 0 then
																					l = e
																				else
																					if y ~= 1 then
																						f = _
																					else
																						o = a
																					end
																				end
																			end
																			y = y + 1
																		end
																		n = n + 1
																		e = z[n]
																	end
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if y >= 5 then
																	if 2 <= y then
																		repeat
																			if 5 ~= y then
																				r[e[a]][e[_]] = r[e[d]]
																				break
																			end
																			k = e[a]
																			r[k] = r[k](t(r, k + 1, e[_]))
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		k = e[a]
																		r[k] = r[k](t(r, k + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	end
																else
																	if 2 ~= y then
																		repeat
																			if 3 < y then
																				y = 0
																				while y > -1 do
																					if 2 >= y then
																						if 1 > y then
																							l = e
																						else
																							if -2 <= y then
																								for e = 47, 68 do
																									if y > 1 then
																										f = _
																										break
																									end
																									o = a
																									break
																								end
																							else
																								o = a
																							end
																						end
																					else
																						if 4 < y then
																							if y > 2 then
																								for e = 35, 83 do
																									if 6 ~= y then
																										r(s, h)
																										break
																									end
																									y = -2
																									break
																								end
																							else
																								y = -2
																							end
																						else
																							if 4 == y then
																								s = l[o]
																							else
																								h = l[f]
																							end
																						end
																					end
																					y = y + 1
																				end
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
														break
													end
												else
													local l, h, f, o, s, y, k
													for y = 0, 6 do
														if y <= 2 then
															if 0 < y then
																if -1 < y then
																	for d = 30, 57 do
																		if 2 ~= y then
																			y = 0
																			while y > -1 do
																				if y > 2 then
																					if y >= 5 then
																						if 6 > y then
																							r(s, o)
																						else
																							y = -2
																						end
																					else
																						if y ~= 2 then
																							for e = 39, 73 do
																								if y ~= 4 then
																									o = l[f]
																									break
																								end
																								s = l[h]
																								break
																							end
																						else
																							o = l[f]
																						end
																					end
																				else
																					if y < 1 then
																						l = e
																					else
																						if y > -3 then
																							repeat
																								if 2 > y then
																									h = a
																									break
																								end
																								f = _
																							until true
																						else
																							f = _
																						end
																					end
																				end
																				y = y + 1
																			end
																			n = n + 1
																			e = z[n]
																			break
																		end
																		y = 0
																		while y > -1 do
																			if 2 < y then
																				if y >= 5 then
																					if 5 == y then
																						r(s, o)
																					else
																						y = -2
																					end
																				else
																					if 3 ~= y then
																						s = l[h]
																					else
																						o = l[f]
																					end
																				end
																			else
																				if y <= 0 then
																					l = e
																				else
																					if y ~= 1 then
																						f = _
																					else
																						h = a
																					end
																				end
																			end
																			y = y + 1
																		end
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	y = 0
																	while y > -1 do
																		if 2 < y then
																			if y >= 5 then
																				if 5 == y then
																					r(s, o)
																				else
																					y = -2
																				end
																			else
																				if 3 ~= y then
																					s = l[h]
																				else
																					o = l[f]
																				end
																			end
																		else
																			if y <= 0 then
																				l = e
																			else
																				if y ~= 1 then
																					f = _
																				else
																					h = a
																				end
																			end
																		end
																		y = y + 1
																	end
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
															end
														else
															if y >= 5 then
																if 2 <= y then
																	repeat
																		if 5 ~= y then
																			r[e[a]][e[_]] = r[e[d]]
																			break
																		end
																		k = e[a]
																		r[k] = r[k](t(r, k + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	until true
																else
																	k = e[a]
																	r[k] = r[k](t(r, k + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															else
																if 2 ~= y then
																	repeat
																		if 3 < y then
																			y = 0
																			while y > -1 do
																				if 2 >= y then
																					if 1 > y then
																						l = e
																					else
																						if -2 <= y then
																							for e = 47, 68 do
																								if y > 1 then
																									f = _
																									break
																								end
																								h = a
																								break
																							end
																						else
																							h = a
																						end
																					end
																				else
																					if 4 < y then
																						if y > 2 then
																							for e = 35, 83 do
																								if 6 ~= y then
																									r(s, o)
																									break
																								end
																								y = -2
																								break
																							end
																						else
																							y = -2
																						end
																					else
																						if 4 == y then
																							s = l[h]
																						else
																							o = l[f]
																						end
																					end
																				end
																				y = y + 1
																			end
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											end
										end
									end
								end
							else
								if 288 < y then
									if 298 >= y then
										if 293 >= y then
											if y <= 290 then
												if 290 ~= y then
													local y
													for l = 0, 4 do
														if l <= 1 then
															if l >= -2 then
																for y = 23, 90 do
																	if l < 1 then
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																	break
																end
															else
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
															end
														else
															if l >= 3 then
																if l > -1 then
																	repeat
																		if l > 3 then
																			if r[e[a]] then
																				n = n + 1
																			else
																				n = e[_]
																			end
																			break
																		end
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	until true
																else
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
															end
														end
													end
												else
													r[e[a]] = r[e[_]] + e[d]
												end
											else
												if 292 > y then
													r[e[a]] = r[e[_]] - r[e[d]]
												else
													if 288 < y then
														repeat
															if 292 ~= y then
																local f, o, b, k, s, y, h
																y = 0
																while y > -1 do
																	if y > 2 then
																		if y > 4 then
																			if y > 5 then
																				y = -2
																			else
																				r(s, k)
																			end
																		else
																			if 0 < y then
																				repeat
																					if y ~= 4 then
																						k = f[b]
																						break
																					end
																					s = f[o]
																				until true
																			else
																				s = f[o]
																			end
																		end
																	else
																		if 1 <= y then
																			if 1 ~= y then
																				b = _
																			else
																				o = a
																			end
																		else
																			f = e
																		end
																	end
																	y = y + 1
																end
																n = n + 1
																e = z[n]
																h = e[a]
																r[h] = r[h](t(r, h + 1, e[_]))
																n = n + 1
																e = z[n]
																r[e[a]][e[_]] = r[e[d]]
																n = n + 1
																e = z[n]
																r[e[a]] = l[e[_]]
																n = n + 1
																e = z[n]
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
																r(e[a], e[_])
																n = n + 1
																e = z[n]
																r(e[a], e[_])
																break
															end
															local y
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]]
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](r[y + 1])
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															if not r[e[a]] then
																n = n + 1
															else
																n = e[_]
															end
														until true
													else
														local f, s, k, b, o, y, h
														y = 0
														while y > -1 do
															if y > 2 then
																if y > 4 then
																	if y > 5 then
																		y = -2
																	else
																		r(o, b)
																	end
																else
																	if 0 < y then
																		repeat
																			if y ~= 4 then
																				b = f[k]
																				break
																			end
																			o = f[s]
																		until true
																	else
																		o = f[s]
																	end
																end
															else
																if 1 <= y then
																	if 1 ~= y then
																		k = _
																	else
																		s = a
																	end
																else
																	f = e
																end
															end
															y = y + 1
														end
														n = n + 1
														e = z[n]
														h = e[a]
														r[h] = r[h](t(r, h + 1, e[_]))
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
													end
												end
											end
										else
											if 295 >= y then
												if 293 < y then
													for f = 14, 91 do
														if 295 ~= y then
															for e = e[a], e[_] do
																r[e] = nil
															end
															break
														end
														local y
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														break
													end
												else
													local y
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
												end
											else
												if 297 > y then
													local e = e[a]
													do
														return r[e], r[e + 1]
													end
												else
													if 293 < y then
														repeat
															if 297 ~= y then
																local y
																for t = 0, 4 do
																	if t < 2 then
																		if t == 0 then
																			r[e[a]] = f[e[_]]
																			n = n + 1
																			e = z[n]
																		else
																			r[e[a]] = r[e[_]] + e[d]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if 2 >= t then
																			r[e[a]] = f[e[_]]
																			n = n + 1
																			e = z[n]
																		else
																			if t > 2 then
																				repeat
																					if t ~= 3 then
																						if r[e[a]] < r[e[d]] then
																							n = n + 1
																						else
																							n = e[_]
																						end
																						break
																					end
																					y = e[a]
																					r[y] = r[y]()
																					n = n + 1
																					e = z[n]
																				until true
																			else
																				y = e[a]
																				r[y] = r[y]()
																				n = n + 1
																				e = z[n]
																			end
																		end
																	end
																end
																break
															end
															local l, y, t
															r[e[a]] = r[e[_]]
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															r[e[a]] = f[e[_]]
															n = n + 1
															e = z[n]
															l = e[_]
															y = r[l]
															for e = l + 1, e[d] do
																y = y .. r[e]
															end
															r[e[a]] = y
															n = n + 1
															e = z[n]
															t = e[a]
															r[t] = r[t](r[t + 1])
															n = n + 1
															e = z[n]
															if r[e[a]] ~= r[e[d]] then
																n = n + 1
															else
																n = e[_]
															end
														until true
													else
														local l, t, y
														r[e[a]] = r[e[_]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														l = e[_]
														t = r[l]
														for e = l + 1, e[d] do
															t = t .. r[e]
														end
														r[e[a]] = t
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](r[y + 1])
														n = n + 1
														e = z[n]
														if r[e[a]] ~= r[e[d]] then
															n = n + 1
														else
															n = e[_]
														end
													end
												end
											end
										end
									else
										if 303 < y then
											if y > 305 then
												if y <= 306 then
													local y, h, f
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][r[e[_]]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][r[e[d]]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													h = e[_]
													f = r[h]
													for e = h + 1, e[d] do
														f = f .. r[e]
													end
													r[e[a]] = f
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
												else
													if y ~= 303 then
														for l = 36, 57 do
															if y ~= 308 then
																local e = e[a]
																r[e] = r[e](r[e + 1])
																break
															end
															local l
															for y = 0, 6 do
																if y >= 3 then
																	if 4 < y then
																		if 2 ~= y then
																			for t = 13, 87 do
																				if 5 ~= y then
																					r[e[a]] = {}
																					break
																				end
																				r[e[a]][e[_]] = r[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			r[e[a]] = {}
																		end
																	else
																		if y == 4 then
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																		else
																			l = e[a]
																			r[l] = r[l](t(r, l + 1, e[_]))
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if y < 1 then
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	else
																		if y == 1 then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		else
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
															end
															break
														end
													else
														local l
														for y = 0, 6 do
															if y >= 3 then
																if 4 < y then
																	if 2 ~= y then
																		for t = 13, 87 do
																			if 5 ~= y then
																				r[e[a]] = {}
																				break
																			end
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]] = {}
																	end
																else
																	if y == 4 then
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		l = e[a]
																		r[l] = r[l](t(r, l + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if y < 1 then
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																else
																	if y == 1 then
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													end
												end
											else
												if y == 304 then
													local d, y
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													d = e[a]
													y = r[d]
													for e = d + 1, e[_] do
														o.KtjR_Kcj(y, r[e])
													end
												else
													local f, t, l
													for y = 0, 6 do
														if 3 > y then
															if 1 <= y then
																if 0 <= y then
																	for t = 46, 67 do
																		if y ~= 2 then
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = {}
																	n = n + 1
																	e = z[n]
																end
															else
																f = e[a]
																t = r[e[_]]
																r[f + 1] = t
																r[f] = t[e[d]]
																n = n + 1
																e = z[n]
															end
														else
															if y > 4 then
																if y >= 3 then
																	repeat
																		if 6 > y then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																		t = e[_]
																		l = r[t]
																		for e = t + 1, e[d] do
																			l = l .. r[e]
																		end
																		r[e[a]] = l
																	until true
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															else
																if 0 ~= y then
																	for d = 29, 88 do
																		if 3 < y then
																			r[e[a]] = r[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											end
										else
											if y < 301 then
												if y == 299 then
													local h, y, l
													for t = 0, 6 do
														if 3 > t then
															if 0 >= t then
																r[e[a]] = f[e[_]]
																n = n + 1
																e = z[n]
															else
																if -2 < t then
																	for l = 41, 96 do
																		if t > 1 then
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																			break
																		end
																		h = e[a]
																		y = r[e[_]]
																		r[h + 1] = y
																		r[h] = y[e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	h = e[a]
																	y = r[e[_]]
																	r[h + 1] = y
																	r[h] = y[e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if 4 >= t then
																if 3 ~= t then
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]][e[_]] = e[d]
																	n = n + 1
																	e = z[n]
																end
															else
																if t > 4 then
																	repeat
																		if 5 < t then
																			y = e[_]
																			l = r[y]
																			for e = y + 1, e[d] do
																				l = l .. r[e]
																			end
																			r[e[a]] = l
																			break
																		end
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	y = e[_]
																	l = r[y]
																	for e = y + 1, e[d] do
																		l = l .. r[e]
																	end
																	r[e[a]] = l
																end
															end
														end
													end
												else
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
												end
											else
												if y <= 301 then
													r[e[a]] = #r[e[_]]
												else
													if 303 > y then
														local a = e[a]
														local n = r[e[_]]
														r[a + 1] = n
														r[a] = n[e[d]]
													else
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
													end
												end
											end
										end
									end
								else
									if y < 279 then
										if y < 274 then
											if 271 >= y then
												if 271 ~= y then
													r[e[a]]()
												else
													do
														return
													end
												end
											else
												if y > 268 then
													for l = 24, 81 do
														if 273 > y then
															local y
															for l = 0, 4 do
																if l < 2 then
																	if l ~= 1 then
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if l < 3 then
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		if l ~= 4 then
																			y = e[a]
																			r[y] = r[y](t(r, y + 1, e[_]))
																			n = n + 1
																			e = z[n]
																		else
																			if r[e[a]] then
																				n = n + 1
																			else
																				n = e[_]
																			end
																		end
																	end
																end
															end
															break
														end
														local y, f
														for l = 0, 6 do
															if 3 <= l then
																if 5 <= l then
																	if 3 <= l then
																		for d = 48, 92 do
																			if l > 5 then
																				r[e[a]] = {}
																				break
																			end
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																else
																	if 4 > l then
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	else
																		y = e[a]
																		f = r[e[_]]
																		r[y + 1] = f
																		r[y] = f[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if 1 > l then
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																else
																	if l > 0 then
																		repeat
																			if 1 ~= l then
																				r[e[a]] = r[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
														break
													end
												else
													local y, f
													for l = 0, 6 do
														if 3 <= l then
															if 5 <= l then
																if 3 <= l then
																	for d = 48, 92 do
																		if l > 5 then
																			r[e[a]] = {}
																			break
																		end
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															else
																if 4 > l then
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																else
																	y = e[a]
																	f = r[e[_]]
																	r[y + 1] = f
																	r[y] = f[e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if 1 > l then
																y = e[a]
																r[y] = r[y](t(r, y + 1, e[_]))
																n = n + 1
																e = z[n]
															else
																if l > 0 then
																	repeat
																		if 1 ~= l then
																			r[e[a]] = r[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											end
										else
											if 275 < y then
												if 276 < y then
													if 276 < y then
														repeat
															if 278 > y then
																local f, o, h, u, k, b, s, y
																for y = 0, 4 do
																	if y > 1 then
																		if 3 <= y then
																			if y > -1 then
																				for d = 36, 60 do
																					if y ~= 4 then
																						y = 0
																						while y > -1 do
																							if 3 <= y then
																								if y <= 4 then
																									if y ~= 4 then
																										b = h[k]
																									else
																										s = h[u]
																									end
																								else
																									if 3 <= y then
																										repeat
																											if
																												6 ~= y
																											then
																												r(s, b)
																												break
																											end
																											y = -2
																										until true
																									else
																										r(s, b)
																									end
																								end
																							else
																								if 0 >= y then
																									h = e
																								else
																									if y > -2 then
																										for e = 30, 73 do
																											if
																												2 ~= y
																											then
																												u = a
																												break
																											end
																											k = _
																											break
																										end
																									else
																										k = _
																									end
																								end
																							end
																							y = y + 1
																						end
																						n = n + 1
																						e = z[n]
																						break
																					end
																					f = e[a]
																					r[f] = r[f](t(r, f + 1, e[_]))
																					break
																				end
																			else
																				f = e[a]
																				r[f] = r[f](t(r, f + 1, e[_]))
																			end
																		else
																			f = e[a]
																			o = r[e[_]]
																			r[f + 1] = o
																			r[f] = o[e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if -3 < y then
																			for d = 47, 56 do
																				if 0 ~= y then
																					r[e[a]] = l[e[_]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				f = e[a]
																				r[f] = r[f](t(r, f + 1, e[_]))
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
																break
															end
															local l, t
															for y = 0, 6 do
																if 2 < y then
																	if 4 >= y then
																		if y ~= 0 then
																			for t = 24, 60 do
																				if 3 < y then
																					r[e[a]][e[_]] = e[d]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if y ~= 5 then
																			r[e[a]][e[_]] = e[d]
																		else
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if 0 < y then
																		if y >= 0 then
																			repeat
																				if 1 ~= y then
																					r[e[a]][e[_]] = e[d]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]] = {}
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																		end
																	else
																		l = e[a]
																		t = r[e[_]]
																		r[l + 1] = t
																		r[l] = t[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														until true
													else
														local f, k, b, u, o, h, s, y
														for y = 0, 4 do
															if y > 1 then
																if 3 <= y then
																	if y > -1 then
																		for d = 36, 60 do
																			if y ~= 4 then
																				y = 0
																				while y > -1 do
																					if 3 <= y then
																						if y <= 4 then
																							if y ~= 4 then
																								h = b[o]
																							else
																								s = b[u]
																							end
																						else
																							if 3 <= y then
																								repeat
																									if 6 ~= y then
																										r(s, h)
																										break
																									end
																									y = -2
																								until true
																							else
																								r(s, h)
																							end
																						end
																					else
																						if 0 >= y then
																							b = e
																						else
																							if y > -2 then
																								for e = 30, 73 do
																									if 2 ~= y then
																										u = a
																										break
																									end
																									o = _
																									break
																								end
																							else
																								o = _
																							end
																						end
																					end
																					y = y + 1
																				end
																				n = n + 1
																				e = z[n]
																				break
																			end
																			f = e[a]
																			r[f] = r[f](t(r, f + 1, e[_]))
																			break
																		end
																	else
																		f = e[a]
																		r[f] = r[f](t(r, f + 1, e[_]))
																	end
																else
																	f = e[a]
																	k = r[e[_]]
																	r[f + 1] = k
																	r[f] = k[e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if -3 < y then
																	for d = 47, 56 do
																		if 0 ~= y then
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		f = e[a]
																		r[f] = r[f](t(r, f + 1, e[_]))
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													local d
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													d = e[a]
													r[d](r[d + 1])
													n = n + 1
													e = z[n]
													r[e[a]] = (e[_] ~= 0)
													n = n + 1
													e = z[n]
													do
														return r[e[a]]
													end
													n = n + 1
													e = z[n]
													n = e[_]
												end
											else
												if 272 <= y then
													for l = 18, 77 do
														if 275 > y then
															r(e[a], e[_])
															break
														end
														local y, f
														for l = 0, 9 do
															if 4 >= l then
																if 2 > l then
																	if 0 == l then
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		y = e[a]
																		f = r[e[_]]
																		r[y + 1] = f
																		r[y] = f[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if l < 3 then
																		r[e[a]] = {}
																		n = n + 1
																		e = z[n]
																	else
																		if l > -1 then
																			for t = 16, 94 do
																				if 4 ~= l then
																					r[e[a]][e[_]] = e[d]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				y = e[a]
																				f = r[e[_]]
																				r[y + 1] = f
																				r[y] = f[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			y = e[a]
																			f = r[e[_]]
																			r[y + 1] = f
																			r[y] = f[e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
															else
																if 7 > l then
																	if l < 6 then
																		r[e[a]] = (e[_] ~= 0)
																		n = n + 1
																		e = z[n]
																	else
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	end
																else
																	if l < 8 then
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		if 7 < l then
																			repeat
																				if l ~= 9 then
																					r[e[a]] = {}
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]][e[_]] = e[d]
																			until true
																		else
																			r[e[a]][e[_]] = e[d]
																		end
																	end
																end
															end
														end
														break
													end
												else
													local y, f
													for l = 0, 9 do
														if 4 >= l then
															if 2 > l then
																if 0 == l then
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																else
																	y = e[a]
																	f = r[e[_]]
																	r[y + 1] = f
																	r[y] = f[e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if l < 3 then
																	r[e[a]] = {}
																	n = n + 1
																	e = z[n]
																else
																	if l > -1 then
																		for t = 16, 94 do
																			if 4 ~= l then
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			y = e[a]
																			f = r[e[_]]
																			r[y + 1] = f
																			r[y] = f[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		y = e[a]
																		f = r[e[_]]
																		r[y + 1] = f
																		r[y] = f[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														else
															if 7 > l then
																if l < 6 then
																	r[e[a]] = (e[_] ~= 0)
																	n = n + 1
																	e = z[n]
																else
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															else
																if l < 8 then
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																else
																	if 7 < l then
																		repeat
																			if l ~= 9 then
																				r[e[a]] = {}
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]][e[_]] = e[d]
																		until true
																	else
																		r[e[a]][e[_]] = e[d]
																	end
																end
															end
														end
													end
												end
											end
										end
									else
										if y < 284 then
											if y < 281 then
												if y >= 276 then
													repeat
														if 280 > y then
															local n = e[a]
															local a, e = s(r[n](t(r, n + 1, e[_])))
															h = e + n - 1
															local e = 0
															for n = n, h do
																e = e + 1
																r[n] = a[e]
															end
															break
														end
														local y
														for d = 0, 5 do
															if 2 >= d then
																if 0 < d then
																	if 0 <= d then
																		repeat
																			if d < 2 then
																				r[e[a]] = r[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			y = e[a]
																			r[y](r[y + 1])
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	r[e[a]] = r[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																if 4 > d then
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																else
																	if d >= 0 then
																		repeat
																			if 5 > d then
																				r[e[a]] = r[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			y = e[a]
																			r[y](r[y + 1])
																		until true
																	else
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													until true
												else
													local n = e[a]
													local a, e = s(r[n](t(r, n + 1, e[_])))
													h = e + n - 1
													local e = 0
													for n = n, h do
														e = e + 1
														r[n] = a[e]
													end
												end
											else
												if y >= 282 then
													if 283 == y then
														r[e[a]] = r[e[_]] + r[e[d]]
													else
														local y, k, b, o
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														k, b = s(r[y](r[y + 1]))
														h = b + y - 1
														o = 0
														for e = y, h do
															o = o + 1
															r[e] = k[o]
														end
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, h))
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]] + e[d]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
													end
												else
													if r[e[a]] < r[e[d]] then
														n = e[_]
													else
														n = n + 1
													end
												end
											end
										else
											if 285 >= y then
												if y == 285 then
													local y
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y](r[y + 1])
													n = n + 1
													e = z[n]
													r[e[a]] = (e[_] ~= 0)
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													y = e[a]
													do
														return r[y], r[y + 1]
													end
													n = n + 1
													e = z[n]
													n = e[_]
												else
													local y
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													f[e[_]] = r[e[a]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y]()
													n = n + 1
													e = z[n]
													f[e[_]] = r[e[a]]
													n = n + 1
													e = z[n]
													r[e[a]] = (e[_] ~= 0)
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													y = e[a]
													do
														return r[y], r[y + 1]
													end
													n = n + 1
													e = z[n]
													n = e[_]
												end
											else
												if y <= 286 then
													local y, o, b, u, k
													for f = 0, 9 do
														if f >= 5 then
															if f < 7 then
																if 6 == f then
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, h))
																	n = n + 1
																	e = z[n]
																else
																	y = e[a]
																	b, u = s(r[y](t(r, y + 1, e[_])))
																	h = u + y - 1
																	k = 0
																	for e = y, h do
																		k = k + 1
																		r[e] = b[k]
																	end
																	n = n + 1
																	e = z[n]
																end
															else
																if f > 7 then
																	if 4 ~= f then
																		repeat
																			if 9 > f then
																				r[e[a]] = l[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			y = e[a]
																			o = r[e[_]]
																			r[y + 1] = o
																			r[y] = o[e[d]]
																		until true
																	else
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	y = e[a]
																	r[y] = r[y]()
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if f > 1 then
																if f >= 3 then
																	if f < 4 then
																		y = e[a]
																		o = r[e[_]]
																		r[y + 1] = o
																		r[y] = o[e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																if -4 < f then
																	repeat
																		if 1 > f then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													if 284 < y then
														repeat
															if y ~= 288 then
																local f
																for y = 0, 6 do
																	if y < 3 then
																		if 1 > y then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		else
																			if 1 == y then
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																			else
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																			end
																		end
																	else
																		if y < 5 then
																			if y >= 2 then
																				repeat
																					if y ~= 3 then
																						f = e[a]
																						r[f] = r[f](t(r, f + 1, e[_]))
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r(e[a], e[_])
																					n = n + 1
																					e = z[n]
																				until true
																			else
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																			end
																		else
																			if y < 6 then
																				r[e[a]][e[_]] = r[e[d]]
																				n = n + 1
																				e = z[n]
																			else
																				r[e[a]] = l[e[_]]
																			end
																		end
																	end
																end
																break
															end
															local y
															r[e[a]][e[_]] = r[e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](t(r, y + 1, e[_]))
														until true
													else
														local y
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
													end
												end
											end
										end
									end
								end
							end
						end
					else
						if 77 > y then
							if 37 >= y then
								if y < 19 then
									if y < 9 then
										if 3 >= y then
											if 1 < y then
												if y == 3 then
													local e = e[a]
													r[e] = r[e](t(r, e + 1, h))
												else
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
												end
											else
												if 0 == y then
													local n = e[a]
													do
														return r[n](t(r, n + 1, e[_]))
													end
												else
													local e = e[a]
													r[e] = r[e]()
												end
											end
										else
											if y <= 5 then
												if 4 ~= y then
													r[e[a]] = {}
												else
													local t
													for y = 0, 4 do
														if 1 < y then
															if 2 < y then
																if 3 == y then
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																else
																	if r[e[a]] == e[d] then
																		n = n + 1
																	else
																		n = e[_]
																	end
																end
															else
																t = e[a]
																r[t] = r[t](r[t + 1])
																n = n + 1
																e = z[n]
															end
														else
															if -2 ~= y then
																for t = 27, 66 do
																	if y < 1 then
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																		break
																	end
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																	break
																end
															else
																r[e[a]][e[_]] = e[d]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											else
												if y < 7 then
													r[e[a]] = u(c[e[_]], nil, l)
												else
													if y > 7 then
														for y = 0, 4 do
															if 2 <= y then
																if 3 > y then
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																else
																	if 2 < y then
																		for t = 36, 72 do
																			if y < 4 then
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			if r[e[a]] then
																				n = n + 1
																			else
																				n = e[_]
																			end
																			break
																		end
																	else
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if 1 > y then
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]]()
																	n = n + 1
																	e = z[n]
																end
															end
														end
													else
														local y, f
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														f = r[e[_]]
														r[y + 1] = f
														r[y] = f[e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
													end
												end
											end
										end
									else
										if y <= 13 then
											if y < 11 then
												if y > 7 then
													repeat
														if 9 < y then
															local e = e[a]
															local a, n = s(r[e](t(r, e + 1, h)))
															h = n + e - 1
															local n = 0
															for e = e, h do
																n = n + 1
																r[e] = a[n]
															end
															break
														end
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
													until true
												else
													local e = e[a]
													local a, n = s(r[e](t(r, e + 1, h)))
													h = n + e - 1
													local n = 0
													for e = e, h do
														n = n + 1
														r[e] = a[n]
													end
												end
											else
												if 11 >= y then
													local l, h
													for y = 0, 5 do
														if y >= 3 then
															if 4 <= y then
																if 2 < y then
																	repeat
																		if y > 4 then
																			r[e[a]][e[_]] = e[d]
																			break
																		end
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]][e[_]] = e[d]
																end
															else
																r[e[a]] = {}
																n = n + 1
																e = z[n]
															end
														else
															if 1 > y then
																l = e[a]
																r[l](t(r, l + 1, e[_]))
																n = n + 1
																e = z[n]
															else
																if y == 2 then
																	l = e[a]
																	h = r[e[_]]
																	r[l + 1] = h
																	r[l] = h[e[d]]
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													if 10 ~= y then
														repeat
															if y < 13 then
																r[e[a]] = (e[_] ~= 0)
																break
															end
															local e = e[a]
															r[e](r[e + 1])
														until true
													else
														r[e[a]] = (e[_] ~= 0)
													end
												end
											end
										else
											if 16 > y then
												if 15 > y then
													local l, f, h, s, o, y, k
													for y = 0, 5 do
														if 2 < y then
															if 3 < y then
																if 2 < y then
																	for l = 34, 56 do
																		if 5 ~= y then
																			k = e[a]
																			r[k] = r[k](t(r, k + 1, e[_]))
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]][e[_]] = r[e[d]]
																		break
																	end
																else
																	r[e[a]][e[_]] = r[e[d]]
																end
															else
																r(e[a], e[_])
																n = n + 1
																e = z[n]
															end
														else
															if 1 > y then
																y = 0
																while y > -1 do
																	if y < 3 then
																		if y >= 1 then
																			if 1 ~= y then
																				h = _
																			else
																				f = a
																			end
																		else
																			l = e
																		end
																	else
																		if 4 >= y then
																			if y ~= 4 then
																				s = l[h]
																			else
																				o = l[f]
																			end
																		else
																			if y >= 2 then
																				for e = 37, 70 do
																					if y > 5 then
																						y = -2
																						break
																					end
																					r(o, s)
																					break
																				end
																			else
																				y = -2
																			end
																		end
																	end
																	y = y + 1
																end
																n = n + 1
																e = z[n]
															else
																if y >= -1 then
																	repeat
																		if y > 1 then
																			y = 0
																			while y > -1 do
																				if y > 2 then
																					if y <= 4 then
																						if y > 1 then
																							repeat
																								if y ~= 4 then
																									s = l[h]
																									break
																								end
																								o = l[f]
																							until true
																						else
																							o = l[f]
																						end
																					else
																						if 5 == y then
																							r(o, s)
																						else
																							y = -2
																						end
																					end
																				else
																					if 0 < y then
																						if -1 < y then
																							for e = 35, 61 do
																								if y > 1 then
																									h = _
																									break
																								end
																								f = a
																								break
																							end
																						else
																							h = _
																						end
																					else
																						l = e
																					end
																				end
																				y = y + 1
																			end
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	until true
																else
																	y = 0
																	while y > -1 do
																		if y > 2 then
																			if y <= 4 then
																				if y > 1 then
																					repeat
																						if y ~= 4 then
																							s = l[h]
																							break
																						end
																						o = l[f]
																					until true
																				else
																					o = l[f]
																				end
																			else
																				if 5 == y then
																					r(o, s)
																				else
																					y = -2
																				end
																			end
																		else
																			if 0 < y then
																				if -1 < y then
																					for e = 35, 61 do
																						if y > 1 then
																							h = _
																							break
																						end
																						f = a
																						break
																					end
																				else
																					h = _
																				end
																			else
																				l = e
																			end
																		end
																		y = y + 1
																	end
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													local e = e[a]
													r[e] = r[e](t(r, e + 1, h))
												end
											else
												if 16 < y then
													if y < 18 then
														r[e[a]][e[_]] = e[d]
													else
														local n = e[a]
														r[n] = r[n](t(r, n + 1, e[_]))
													end
												else
													local d
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													d = e[a]
													r[d] = r[d]()
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													d = e[a]
													r[d] = r[d](r[d + 1])
												end
											end
										end
									end
								else
									if y <= 27 then
										if y <= 22 then
											if y <= 20 then
												if y >= 15 then
													for f = 10, 84 do
														if y > 19 then
															local y, t, f
															for l = 0, 4 do
																if l < 2 then
																	if l > 0 then
																		r[e[a]] = r[e[_]][r[e[d]]]
																		n = n + 1
																		e = z[n]
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																else
																	if l > 2 then
																		if 3 == l then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		else
																			y = e[a]
																			t = r[y]
																			f = r[y + 2]
																			if f > 0 then
																				if t > r[y + 1] then
																					n = e[_]
																				else
																					r[y + 3] = t
																				end
																			elseif t < r[y + 1] then
																				n = e[_]
																			else
																				r[y + 3] = t
																			end
																		end
																	else
																		r[e[a]] = #r[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
															break
														end
														local y, h
														for f = 0, 4 do
															if 1 < f then
																if f >= 3 then
																	if f > 2 then
																		for d = 47, 59 do
																			if f ~= 4 then
																				y = e[a]
																				r[y] = r[y](t(r, y + 1, e[_]))
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = l[e[_]]
																			break
																		end
																	else
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	end
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															else
																if -2 ~= f then
																	repeat
																		if f > 0 then
																			y = e[a]
																			h = r[e[_]]
																			r[y + 1] = h
																			r[y] = h[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	y = e[a]
																	h = r[e[_]]
																	r[y + 1] = h
																	r[y] = h[e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
														break
													end
												else
													local y, f
													for h = 0, 4 do
														if 1 < h then
															if h >= 3 then
																if h > 2 then
																	for d = 47, 59 do
																		if h ~= 4 then
																			y = e[a]
																			r[y] = r[y](t(r, y + 1, e[_]))
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = l[e[_]]
																		break
																	end
																else
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															else
																r(e[a], e[_])
																n = n + 1
																e = z[n]
															end
														else
															if -2 ~= h then
																repeat
																	if h > 0 then
																		y = e[a]
																		f = r[e[_]]
																		r[y + 1] = f
																		r[y] = f[e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																until true
															else
																y = e[a]
																f = r[e[_]]
																r[y + 1] = f
																r[y] = f[e[d]]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											else
												if 17 < y then
													for h = 40, 53 do
														if y ~= 21 then
															local y, h
															for l = 0, 6 do
																if 2 < l then
																	if 5 <= l then
																		if 5 < l then
																			r[e[a]] = f[e[_]]
																		else
																			f[e[_]] = r[e[a]]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if l ~= 4 then
																			r[e[a]] = (e[_] ~= 0)
																			n = n + 1
																			e = z[n]
																		else
																			y = e[a]
																			r[y] = r[y](t(r, y + 1, e[_]))
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if 0 < l then
																		if 0 ~= l then
																			for t = 46, 93 do
																				if 2 ~= l then
																					y = e[a]
																					h = r[e[_]]
																					r[y + 1] = h
																					r[y] = h[e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			y = e[a]
																			h = r[e[_]]
																			r[y + 1] = h
																			r[y] = h[e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
															break
														end
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														break
													end
												else
													local y, h
													for l = 0, 6 do
														if 2 < l then
															if 5 <= l then
																if 5 < l then
																	r[e[a]] = f[e[_]]
																else
																	f[e[_]] = r[e[a]]
																	n = n + 1
																	e = z[n]
																end
															else
																if l ~= 4 then
																	r[e[a]] = (e[_] ~= 0)
																	n = n + 1
																	e = z[n]
																else
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if 0 < l then
																if 0 ~= l then
																	for t = 46, 93 do
																		if 2 ~= l then
																			y = e[a]
																			h = r[e[_]]
																			r[y + 1] = h
																			r[y] = h[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	y = e[a]
																	h = r[e[_]]
																	r[y + 1] = h
																	r[y] = h[e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]] = f[e[_]]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											end
										else
											if 24 < y then
												if 25 < y then
													if y >= 23 then
														for t = 10, 65 do
															if 26 ~= y then
																for y = 0, 6 do
																	if 2 >= y then
																		if y >= 1 then
																			if y >= -3 then
																				repeat
																					if 1 < y then
																						r[e[a]] = l[e[_]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = l[e[_]]
																					n = n + 1
																					e = z[n]
																				until true
																			else
																				r[e[a]] = l[e[_]]
																				n = n + 1
																				e = z[n]
																			end
																		else
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if y > 4 then
																			if y == 5 then
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																			else
																				r[e[a]] = l[e[_]]
																			end
																		else
																			if 3 < y then
																				r[e[a]] = l[e[_]]
																				n = n + 1
																				e = z[n]
																			else
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																			end
																		end
																	end
																end
																break
															end
															r[e[a]] = (e[_] ~= 0)
															break
														end
													else
														for y = 0, 6 do
															if 2 >= y then
																if y >= 1 then
																	if y >= -3 then
																		repeat
																			if 1 < y then
																				r[e[a]] = l[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if y > 4 then
																	if y == 5 then
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]] = l[e[_]]
																	end
																else
																	if 3 < y then
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													end
												else
													local f, k, h, s, b, y, o
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = 0
													while y > -1 do
														if 2 >= y then
															if y >= 1 then
																if 0 ~= y then
																	repeat
																		if 2 > y then
																			k = a
																			break
																		end
																		h = _
																	until true
																else
																	h = _
																end
															else
																f = e
															end
														else
															if 5 > y then
																if -1 ~= y then
																	for e = 41, 92 do
																		if 3 < y then
																			b = f[k]
																			break
																		end
																		s = f[h]
																		break
																	end
																else
																	s = f[h]
																end
															else
																if y >= 1 then
																	for e = 30, 52 do
																		if y > 5 then
																			y = -2
																			break
																		end
																		r(b, s)
																		break
																	end
																else
																	y = -2
																end
															end
														end
														y = y + 1
													end
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													o = e[a]
													r[o] = r[o](t(r, o + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
												end
											else
												if 19 <= y then
													for o = 39, 94 do
														if 23 < y then
															local u, b, y, c, p, k
															for o = 0, 9 do
																if o >= 5 then
																	if o >= 7 then
																		if 8 > o then
																			y = e[a]
																			r[y] = r[y](t(r, y + 1, h))
																			n = n + 1
																			e = z[n]
																		else
																			if o > 7 then
																				repeat
																					if 8 ~= o then
																						r[e[a]][e[_]] = r[e[d]]
																						break
																					end
																					r[e[a]][e[_]] = r[e[d]]
																					n = n + 1
																					e = z[n]
																				until true
																			else
																				r[e[a]][e[_]] = r[e[d]]
																				n = n + 1
																				e = z[n]
																			end
																		end
																	else
																		if 5 == o then
																			y = e[a]
																			c, p = s(r[y]())
																			h = p + y - 1
																			k = 0
																			for e = y, h do
																				k = k + 1
																				r[e] = c[k]
																			end
																			n = n + 1
																			e = z[n]
																		else
																			y = e[a]
																			c, p = s(r[y](t(r, y + 1, h)))
																			h = p + y - 1
																			k = 0
																			for e = y, h do
																				k = k + 1
																				r[e] = c[k]
																			end
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if 2 <= o then
																		if 3 <= o then
																			if o ~= 0 then
																				repeat
																					if 4 > o then
																						r[e[a]] = l[e[_]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = f[e[_]]
																					n = n + 1
																					e = z[n]
																				until true
																			else
																				r[e[a]] = f[e[_]]
																				n = n + 1
																				e = z[n]
																			end
																		else
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if o >= -4 then
																			repeat
																				if 1 ~= o then
																					u = e[_]
																					b = r[u]
																					for e = u + 1, e[d] do
																						b = b .. r[e]
																					end
																					r[e[a]] = b
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]] = {}
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			u = e[_]
																			b = r[u]
																			for e = u + 1, e[d] do
																				b = b .. r[e]
																			end
																			r[e[a]] = b
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
															end
															break
														end
														local z = e[a]
														local d = e[d]
														local a = z + 2
														local z = { r[z](r[z + 1], r[a]) }
														for e = 1, d do
															r[a + e] = z[e]
														end
														local z = z[1]
														if z then
															r[a] = z
															n = e[_]
														else
															n = n + 1
														end
														break
													end
												else
													local a = e[a]
													local d = e[d]
													local z = a + 2
													local a = { r[a](r[a + 1], r[z]) }
													for e = 1, d do
														r[z + e] = a[e]
													end
													local a = a[1]
													if a then
														r[z] = a
														n = e[_]
													else
														n = n + 1
													end
												end
											end
										end
									else
										if y >= 33 then
											if y > 34 then
												if y <= 35 then
													for d = 0, 1 do
														if d >= -1 then
															for y = 45, 77 do
																if 0 < d then
																	if r[e[a]] then
																		n = n + 1
																	else
																		n = e[_]
																	end
																	break
																end
																r[e[a]] = l[e[_]]
																n = n + 1
																e = z[n]
																break
															end
														else
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
														end
													end
												else
													if y ~= 34 then
														for l = 13, 60 do
															if y ~= 37 then
																r[e[a]] = r[e[_]][e[d]]
																break
															end
															local y, f
															for l = 0, 4 do
																if 1 < l then
																	if l > 2 then
																		if l >= 2 then
																			repeat
																				if l < 4 then
																					r[e[a]] = r[e[_]][e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				y = e[a]
																				f = r[e[_]]
																				r[y + 1] = f
																				r[y] = f[e[d]]
																			until true
																		else
																			y = e[a]
																			f = r[e[_]]
																			r[y + 1] = f
																			r[y] = f[e[d]]
																		end
																	else
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	end
																else
																	if -1 ~= l then
																		for y = 39, 79 do
																			if 0 ~= l then
																				r[e[a]] = r[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
															break
														end
													else
														local y, f
														for l = 0, 4 do
															if 1 < l then
																if l > 2 then
																	if l >= 2 then
																		repeat
																			if l < 4 then
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			y = e[a]
																			f = r[e[_]]
																			r[y + 1] = f
																			r[y] = f[e[d]]
																		until true
																	else
																		y = e[a]
																		f = r[e[_]]
																		r[y + 1] = f
																		r[y] = f[e[d]]
																	end
																else
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															else
																if -1 ~= l then
																	for y = 39, 79 do
																		if 0 ~= l then
																			r[e[a]] = r[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											else
												if y < 34 then
													f[e[_]] = r[e[a]]
												else
													local a = e[a]
													local _ = { r[a](t(r, a + 1, h)) }
													local n = 0
													for e = a, e[d] do
														n = n + 1
														r[e] = _[n]
													end
												end
											end
										else
											if y > 29 then
												if y > 30 then
													if 31 < y then
														do
															return
														end
													else
														local y
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
													end
												else
													local y
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]] = (e[_] ~= 0)
													n = n + 1
													e = z[n]
													f[e[_]] = r[e[a]]
													n = n + 1
													e = z[n]
													do
														return
													end
												end
											else
												if 26 <= y then
													repeat
														if 28 ~= y then
															local y, o, b, k, f
															y = e[a]
															o = r[e[_]]
															r[y + 1] = o
															r[y] = o[e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = {}
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = e[d]
															n = n + 1
															e = z[n]
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															y = e[a]
															b, k = s(r[y]())
															h = k + y - 1
															f = 0
															for e = y, h do
																f = f + 1
																r[e] = b[f]
															end
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](t(r, y + 1, h))
															break
														end
														for y = 0, 3 do
															if 2 <= y then
																if 2 == y then
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																else
																	if not r[e[a]] then
																		n = n + 1
																	else
																		n = e[_]
																	end
																end
															else
																if -2 ~= y then
																	for t = 35, 75 do
																		if y > 0 then
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													until true
												else
													for y = 0, 3 do
														if 2 <= y then
															if 2 == y then
																r[e[a]] = l[e[_]]
																n = n + 1
																e = z[n]
															else
																if not r[e[a]] then
																	n = n + 1
																else
																	n = e[_]
																end
															end
														else
															if -2 ~= y then
																for t = 35, 75 do
																	if y > 0 then
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																	break
																end
															else
																r[e[a]] = l[e[_]]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											end
										end
									end
								end
							else
								if y < 57 then
									if 47 > y then
										if y < 42 then
											if y > 39 then
												if 36 <= y then
													repeat
														if 40 < y then
															local a = e[a]
															local d = r[a + 2]
															local z = r[a] + d
															r[a] = z
															if d > 0 then
																if z <= r[a + 1] then
																	n = e[_]
																	r[a + 3] = z
																end
															elseif z >= r[a + 1] then
																n = e[_]
																r[a + 3] = z
															end
															break
														end
														local n = e[a]
														local a, e = s(r[n]())
														h = e + n - 1
														local e = 0
														for n = n, h do
															e = e + 1
															r[n] = a[e]
														end
													until true
												else
													local n = e[a]
													local a, e = s(r[n]())
													h = e + n - 1
													local e = 0
													for n = n, h do
														e = e + 1
														r[n] = a[e]
													end
												end
											else
												if y > 36 then
													for l = 48, 67 do
														if y ~= 38 then
															local n = e[a]
															r[n](t(r, n + 1, e[_]))
															break
														end
														local y
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](r[y + 1])
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														if r[e[a]] == e[d] then
															n = n + 1
														else
															n = e[_]
														end
														break
													end
												else
													local y
													r[e[a]] = {}
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](r[y + 1])
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													if r[e[a]] == e[d] then
														n = n + 1
													else
														n = e[_]
													end
												end
											end
										else
											if 44 > y then
												if y == 43 then
													local y, h, f, l, t, d, o, s, k
													for d = 0, 4 do
														if d < 2 then
															if -1 ~= d then
																for o = 20, 82 do
																	if d ~= 1 then
																		d = 0
																		while d > -1 do
																			if 2 >= d then
																				if 0 < d then
																					if d == 2 then
																						f = _
																					else
																						h = a
																					end
																				else
																					y = e
																				end
																			else
																				if d > 4 then
																					if d > 4 then
																						repeat
																							if 5 ~= d then
																								d = -2
																								break
																							end
																							r(t, l)
																						until true
																					else
																						r(t, l)
																					end
																				else
																					if d ~= -1 then
																						for e = 33, 63 do
																							if 3 < d then
																								t = y[h]
																								break
																							end
																							l = y[f]
																							break
																						end
																					else
																						t = y[h]
																					end
																				end
																			end
																			d = d + 1
																		end
																		n = n + 1
																		e = z[n]
																		break
																	end
																	d = 0
																	while d > -1 do
																		if d >= 3 then
																			if d > 4 then
																				if 3 < d then
																					for e = 47, 68 do
																						if 6 > d then
																							r(t, l)
																							break
																						end
																						d = -2
																						break
																					end
																				else
																					r(t, l)
																				end
																			else
																				if 0 ~= d then
																					for e = 45, 53 do
																						if 3 ~= d then
																							t = y[h]
																							break
																						end
																						l = y[f]
																						break
																					end
																				else
																					l = y[f]
																				end
																			end
																		else
																			if d < 1 then
																				y = e
																			else
																				if -3 ~= d then
																					repeat
																						if d ~= 1 then
																							f = _
																							break
																						end
																						h = a
																					until true
																				else
																					f = _
																				end
																			end
																		end
																		d = d + 1
																	end
																	n = n + 1
																	e = z[n]
																	break
																end
															else
																d = 0
																while d > -1 do
																	if 2 >= d then
																		if 0 < d then
																			if d == 2 then
																				f = _
																			else
																				h = a
																			end
																		else
																			y = e
																		end
																	else
																		if d > 4 then
																			if d > 4 then
																				repeat
																					if 5 ~= d then
																						d = -2
																						break
																					end
																					r(t, l)
																				until true
																			else
																				r(t, l)
																			end
																		else
																			if d ~= -1 then
																				for e = 33, 63 do
																					if 3 < d then
																						t = y[h]
																						break
																					end
																					l = y[f]
																					break
																				end
																			else
																				t = y[h]
																			end
																		end
																	end
																	d = d + 1
																end
																n = n + 1
																e = z[n]
															end
														else
															if d <= 2 then
																d = 0
																while d > -1 do
																	if 2 >= d then
																		if 0 >= d then
																			y = e
																		else
																			if d >= 0 then
																				repeat
																					if d ~= 1 then
																						f = _
																						break
																					end
																					h = a
																				until true
																			else
																				f = _
																			end
																		end
																	else
																		if d < 5 then
																			if d > 3 then
																				t = y[h]
																			else
																				l = y[f]
																			end
																		else
																			if 5 == d then
																				r(t, l)
																			else
																				d = -2
																			end
																		end
																	end
																	d = d + 1
																end
																n = n + 1
																e = z[n]
															else
																if 3 == d then
																	d = 0
																	while d > -1 do
																		if 2 >= d then
																			if 0 < d then
																				if d > -1 then
																					for e = 35, 64 do
																						if d ~= 1 then
																							f = _
																							break
																						end
																						h = a
																						break
																					end
																				else
																					f = _
																				end
																			else
																				y = e
																			end
																		else
																			if d <= 4 then
																				if 1 <= d then
																					repeat
																						if d ~= 4 then
																							l = y[f]
																							break
																						end
																						t = y[h]
																					until true
																				else
																					t = y[h]
																				end
																			else
																				if 1 ~= d then
																					repeat
																						if 6 > d then
																							r(t, l)
																							break
																						end
																						d = -2
																					until true
																				else
																					r(t, l)
																				end
																			end
																		end
																		d = d + 1
																	end
																	n = n + 1
																	e = z[n]
																else
																	o = e[a]
																	s = r[o]
																	k = r[o + 2]
																	if k > 0 then
																		if s > r[o + 1] then
																			n = e[_]
																		else
																			r[o + 3] = s
																		end
																	elseif s < r[o + 1] then
																		n = e[_]
																	else
																		r[o + 3] = s
																	end
																end
															end
														end
													end
												else
													l[e[_]] = r[e[a]]
												end
											else
												if 44 >= y then
													r[e[a]] = (e[_] ~= 0)
													n = n + 1
												else
													if 46 ~= y then
														local e = e[a]
														r[e] = r[e]()
													else
														local z = e[a]
														local d = e[d]
														local a = z + 2
														local z = { r[z](r[z + 1], r[a]) }
														for e = 1, d do
															r[a + e] = z[e]
														end
														local z = z[1]
														if z then
															r[a] = z
															n = e[_]
														else
															n = n + 1
														end
													end
												end
											end
										end
									else
										if 51 >= y then
											if y >= 49 then
												if 50 <= y then
													if y == 50 then
														local y
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y](t(r, y + 1, e[_]))
													else
														n = e[_]
													end
												else
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
												end
											else
												if 45 < y then
													repeat
														if y < 48 then
															local y
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](t(r, y + 1, e[_]))
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = r[e[d]]
															n = n + 1
															e = z[n]
															r[e[a]][r[e[_]]] = r[e[d]]
															break
														end
														local e = e[a]
														r[e](t(r, e + 1, h))
													until true
												else
													local y
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][r[e[_]]] = r[e[d]]
												end
											end
										else
											if y >= 54 then
												if 55 > y then
													local y, h
													for l = 0, 6 do
														if 3 > l then
															if l > 0 then
																if -1 < l then
																	for d = 46, 72 do
																		if 2 > l then
																			y = e[a]
																			r[y](t(r, y + 1, e[_]))
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	y = e[a]
																	r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]][e[_]] = r[e[d]]
																n = n + 1
																e = z[n]
															end
														else
															if l > 4 then
																if 6 ~= l then
																	r[e[a]][e[_]] = e[d]
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]][e[_]] = e[d]
																end
															else
																if l ~= 1 then
																	for t = 33, 76 do
																		if l ~= 4 then
																			y = e[a]
																			h = r[e[_]]
																			r[y + 1] = h
																			r[y] = h[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = {}
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	y = e[a]
																	h = r[e[_]]
																	r[y + 1] = h
																	r[y] = h[e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													if 51 < y then
														for t = 31, 89 do
															if y ~= 55 then
																local l, y, t
																r[e[a]] = f[e[_]]
																n = n + 1
																e = z[n]
																l = e[a]
																y = r[e[_]]
																r[l + 1] = y
																r[l] = y[e[d]]
																n = n + 1
																e = z[n]
																r[e[a]] = {}
																n = n + 1
																e = z[n]
																r[e[a]][e[_]] = e[d]
																n = n + 1
																e = z[n]
																r(e[a], e[_])
																n = n + 1
																e = z[n]
																r[e[a]] = r[e[_]]
																n = n + 1
																e = z[n]
																y = e[_]
																t = r[y]
																for e = y + 1, e[d] do
																	t = t .. r[e]
																end
																r[e[a]] = t
																break
															end
															r[e[a]] = u(c[e[_]], nil, l)
															break
														end
													else
														r[e[a]] = u(c[e[_]], nil, l)
													end
												end
											else
												if 51 <= y then
													repeat
														if 53 ~= y then
															local l
															for y = 0, 4 do
																if 2 <= y then
																	if 2 >= y then
																		l = e[a]
																		r[l] = r[l](t(r, l + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	else
																		if 1 < y then
																			for t = 38, 94 do
																				if 3 < y then
																					r[e[a]][e[_]] = e[d]
																					break
																				end
																				r[e[a]][e[_]] = r[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																		else
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if 0 < y then
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																end
															end
															break
														end
														local f, o, s, b, k, y, h
														for y = 0, 6 do
															if 3 <= y then
																if y < 5 then
																	if y >= -1 then
																		repeat
																			if 4 > y then
																				h = e[a]
																				r[h] = r[h](t(r, h + 1, e[_]))
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if 2 <= y then
																		repeat
																			if 6 ~= y then
																				r[e[a]] = l[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = r[e[_]][e[d]]
																		until true
																	else
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if 1 > y then
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																else
																	if -3 < y then
																		for d = 48, 85 do
																			if 2 > y then
																				y = 0
																				while y > -1 do
																					if y >= 3 then
																						if 5 <= y then
																							if y >= 3 then
																								for e = 38, 59 do
																									if 6 ~= y then
																										r(k, b)
																										break
																									end
																									y = -2
																									break
																								end
																							else
																								y = -2
																							end
																						else
																							if y ~= -1 then
																								for e = 37, 92 do
																									if 3 < y then
																										k = f[o]
																										break
																									end
																									b = f[s]
																									break
																								end
																							else
																								k = f[o]
																							end
																						end
																					else
																						if y >= 1 then
																							if -3 < y then
																								for e = 12, 52 do
																									if 1 < y then
																										s = _
																										break
																									end
																									o = a
																									break
																								end
																							else
																								s = _
																							end
																						else
																							f = e
																						end
																					end
																					y = y + 1
																				end
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													until true
												else
													local f, s, k, b, o, y, h
													for y = 0, 6 do
														if 3 <= y then
															if y < 5 then
																if y >= -1 then
																	repeat
																		if 4 > y then
																			h = e[a]
																			r[h] = r[h](t(r, h + 1, e[_]))
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if 2 <= y then
																	repeat
																		if 6 ~= y then
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = r[e[_]][e[d]]
																	until true
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if 1 > y then
																r(e[a], e[_])
																n = n + 1
																e = z[n]
															else
																if -3 < y then
																	for d = 48, 85 do
																		if 2 > y then
																			y = 0
																			while y > -1 do
																				if y >= 3 then
																					if 5 <= y then
																						if y >= 3 then
																							for e = 38, 59 do
																								if 6 ~= y then
																									r(o, b)
																									break
																								end
																								y = -2
																								break
																							end
																						else
																							y = -2
																						end
																					else
																						if y ~= -1 then
																							for e = 37, 92 do
																								if 3 < y then
																									o = f[s]
																									break
																								end
																								b = f[k]
																								break
																							end
																						else
																							o = f[s]
																						end
																					end
																				else
																					if y >= 1 then
																						if -3 < y then
																							for e = 12, 52 do
																								if 1 < y then
																									k = _
																									break
																								end
																								s = a
																								break
																							end
																						else
																							k = _
																						end
																					else
																						f = e
																					end
																				end
																				y = y + 1
																			end
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											end
										end
									end
								else
									if y <= 66 then
										if y <= 61 then
											if y <= 58 then
												if 53 ~= y then
													for n = 13, 58 do
														if 58 > y then
															r[e[a]] = r[e[_]] + r[e[d]]
															break
														end
														local e = e[a]
														r[e](r[e + 1])
														break
													end
												else
													local e = e[a]
													r[e](r[e + 1])
												end
											else
												if 59 < y then
													if 56 < y then
														repeat
															if y > 60 then
																local t, y
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
																r[e[a]] = f[e[_]]
																n = n + 1
																e = z[n]
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
																f[e[_]] = r[e[a]]
																n = n + 1
																e = z[n]
																f[e[_]] = r[e[a]]
																n = n + 1
																e = z[n]
																f[e[_]] = r[e[a]]
																n = n + 1
																e = z[n]
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
																t = e[a]
																y = r[e[_]]
																r[t + 1] = y
																r[t] = y[e[d]]
																break
															end
															local a = e[a]
															local z = r[a]
															local d = r[a + 2]
															if d > 0 then
																if z > r[a + 1] then
																	n = e[_]
																else
																	r[a + 3] = z
																end
															elseif z < r[a + 1] then
																n = e[_]
															else
																r[a + 3] = z
															end
														until true
													else
														local a = e[a]
														local z = r[a]
														local d = r[a + 2]
														if d > 0 then
															if z > r[a + 1] then
																n = e[_]
															else
																r[a + 3] = z
															end
														elseif z < r[a + 1] then
															n = e[_]
														else
															r[a + 3] = z
														end
													end
												else
													if r[e[a]] < r[e[d]] then
														n = n + 1
													else
														n = e[_]
													end
												end
											end
										else
											if 64 <= y then
												if y < 65 then
													local y
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
												else
													if 65 ~= y then
														local y
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
													else
														r[e[a]][r[e[_]]] = r[e[d]]
													end
												end
											else
												if y ~= 59 then
													for z = 39, 83 do
														if y > 62 then
															local h, f, o, z, t, l, y
															local n = 0
															while n > -1 do
																if 2 >= n then
																	if 0 >= n then
																		h = a
																		f = _
																		o = d
																	else
																		if -2 <= n then
																			repeat
																				if 1 ~= n then
																					t = z[f]
																					break
																				end
																				z = e
																			until true
																		else
																			t = z[f]
																		end
																	end
																else
																	if n > 4 then
																		if 2 < n then
																			repeat
																				if n < 6 then
																					r[l] = y
																					break
																				end
																				n = -2
																			until true
																		else
																			r[l] = y
																		end
																	else
																		if 0 <= n then
																			for e = 30, 78 do
																				if 4 ~= n then
																					l = z[h]
																					break
																				end
																				y = r[t]
																				for e = 1 + t, z[o] do
																					y = y .. r[e]
																				end
																				break
																			end
																		else
																			l = z[h]
																		end
																	end
																end
																n = n + 1
															end
															break
														end
														if r[e[a]] < r[e[d]] then
															n = n + 1
														else
															n = e[_]
														end
														break
													end
												else
													if r[e[a]] < r[e[d]] then
														n = n + 1
													else
														n = e[_]
													end
												end
											end
										end
									else
										if y < 72 then
											if 68 >= y then
												if 67 ~= y then
													local y, o
													for l = 0, 6 do
														if 3 <= l then
															if l < 5 then
																if l == 4 then
																	y = e[a]
																	o = r[e[_]]
																	r[y + 1] = o
																	r[y] = o[e[d]]
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																if l > 1 then
																	repeat
																		if 5 ~= l then
																			r[e[a]][e[_]] = e[d]
																			break
																		end
																		r[e[a]] = {}
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]] = {}
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if 1 > l then
																y = e[a]
																r[y] = r[y](t(r, y + 1, h))
																n = n + 1
																e = z[n]
															else
																if l ~= -3 then
																	for d = 22, 70 do
																		if l ~= 1 then
																			f[e[_]] = r[e[a]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		y = e[a]
																		r[y] = r[y]()
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	y = e[a]
																	r[y] = r[y]()
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													local t, s, o, u, b, k, y, h, l
													for y = 0, 4 do
														if y < 2 then
															if -1 <= y then
																for d = 21, 58 do
																	if y < 1 then
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																		break
																	end
																	y = 0
																	while y > -1 do
																		if 4 > y then
																			if 2 > y then
																				if -2 < y then
																					for n = 16, 90 do
																						if y ~= 1 then
																							t = e
																							break
																						end
																						s = a
																						break
																					end
																				else
																					t = e
																				end
																			else
																				if -1 < y then
																					for e = 26, 60 do
																						if 3 > y then
																							o = _
																							break
																						end
																						u = r
																						break
																					end
																				else
																					o = _
																				end
																			end
																		else
																			if 6 > y then
																				if y ~= 5 then
																					b = u[t[o]]
																				else
																					k = t[s]
																				end
																			else
																				if y ~= 7 then
																					r[k] = b
																				else
																					y = -2
																				end
																			end
																		end
																		y = y + 1
																	end
																	n = n + 1
																	e = z[n]
																	break
																end
															else
																r(e[a], e[_])
																n = n + 1
																e = z[n]
															end
														else
															if 3 <= y then
																if 0 ~= y then
																	for d = 35, 80 do
																		if y ~= 3 then
																			if r[e[a]] then
																				n = n + 1
																			else
																				n = e[_]
																			end
																			break
																		end
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	if r[e[a]] then
																		n = n + 1
																	else
																		n = e[_]
																	end
																end
															else
																h = e[_]
																l = r[h]
																for e = h + 1, e[d] do
																	l = l .. r[e]
																end
																r[e[a]] = l
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											else
												if 70 <= y then
													if y == 71 then
														local y
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
													else
														for d = 0, 6 do
															if d > 2 then
																if d < 5 then
																	if d ~= 4 then
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																else
																	if d >= 2 then
																		for y = 31, 60 do
																			if d ~= 6 then
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r(e[a], e[_])
																			break
																		end
																	else
																		r(e[a], e[_])
																	end
																end
															else
																if d >= 1 then
																	if d >= -3 then
																		for y = 24, 86 do
																			if 1 ~= d then
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													local h, f, s, k, b, o, y
													for y = 0, 6 do
														if 2 < y then
															if y < 5 then
																if y >= 2 then
																	repeat
																		if 4 > y then
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															else
																if y >= 1 then
																	for d = 46, 97 do
																		if 6 > y then
																			y = 0
																			while y > -1 do
																				if 2 < y then
																					if 5 <= y then
																						if 1 <= y then
																							for e = 22, 74 do
																								if 5 ~= y then
																									y = -2
																									break
																								end
																								r(o, b)
																								break
																							end
																						else
																							y = -2
																						end
																					else
																						if 2 ~= y then
																							repeat
																								if y ~= 3 then
																									o = f[s]
																									break
																								end
																								b = f[k]
																							until true
																						else
																							o = f[s]
																						end
																					end
																				else
																					if 0 < y then
																						if 1 ~= y then
																							k = _
																						else
																							s = a
																						end
																					else
																						f = e
																					end
																				end
																				y = y + 1
																			end
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																		break
																	end
																else
																	r(e[a], e[_])
																end
															end
														else
															if y >= 1 then
																if y ~= -2 then
																	repeat
																		if y ~= 2 then
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																h = e[a]
																r[h] = r[h](t(r, h + 1, e[_]))
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											end
										else
											if 73 >= y then
												if 68 ~= y then
													repeat
														if 73 ~= y then
															local t, o, f, u, h, b, k, s, y
															t = e[a]
															o = r[e[_]]
															r[t + 1] = o
															r[t] = o[e[d]]
															n = n + 1
															e = z[n]
															y = 0
															while y > -1 do
																if 3 >= y then
																	if y <= 1 then
																		if y > -2 then
																			for n = 18, 61 do
																				if y ~= 0 then
																					u = a
																					break
																				end
																				f = e
																				break
																			end
																		else
																			f = e
																		end
																	else
																		if 0 ~= y then
																			for e = 38, 57 do
																				if y ~= 2 then
																					b = r
																					break
																				end
																				h = _
																				break
																			end
																		else
																			h = _
																		end
																	end
																else
																	if y > 5 then
																		if y ~= 6 then
																			y = -2
																		else
																			r[s] = k
																		end
																	else
																		if 4 == y then
																			k = b[f[h]]
																		else
																			s = f[u]
																		end
																	end
																end
																y = y + 1
															end
															n = n + 1
															e = z[n]
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															t = e[a]
															r[t] = r[t](r[t + 1])
															n = n + 1
															e = z[n]
															r[e[a]] = {}
															break
														end
														f[e[_]] = r[e[a]]
													until true
												else
													f[e[_]] = r[e[a]]
												end
											else
												if y >= 75 then
													if 71 < y then
														repeat
															if y ~= 76 then
																local h = c[e[_]]
																local t
																local y = {}
																t = o.UnTDunMi({}, {
																	__index = function(n, e)
																		local e = y[e]
																		return e[1][e[2]]
																	end,
																	__newindex = function(r, e, n)
																		local e = y[e]
																		e[1][e[2]] = n
																	end,
																})
																for a = 1, e[d] do
																	n = n + 1
																	local e = z[n]
																	if e[j] == 213 then
																		y[a - 1] = { r, e[_] }
																	else
																		y[a - 1] = { f, e[_] }
																	end
																	k[#k + 1] = y
																end
																r[e[a]] = u(h, t, l)
																break
															end
															local f
															for y = 0, 6 do
																if 2 >= y then
																	if 1 > y then
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	else
																		if y > -1 then
																			repeat
																				if y < 2 then
																					r[e[a]] = r[e[_]][e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if 4 < y then
																		if y ~= 2 then
																			for l = 15, 88 do
																				if y < 6 then
																					f = e[a]
																					r[f] = r[f](t(r, f + 1, e[_]))
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]][e[_]] = r[e[d]]
																				break
																			end
																		else
																			f = e[a]
																			r[f] = r[f](t(r, f + 1, e[_]))
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if 2 <= y then
																			repeat
																				if y ~= 3 then
																					r(e[a], e[_])
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
															end
														until true
													else
														local h = c[e[_]]
														local t
														local y = {}
														t = o.UnTDunMi({}, {
															__index = function(n, e)
																local e = y[e]
																return e[1][e[2]]
															end,
															__newindex = function(r, e, n)
																local e = y[e]
																e[1][e[2]] = n
															end,
														})
														for a = 1, e[d] do
															n = n + 1
															local e = z[n]
															if e[j] == 213 then
																y[a - 1] = { r, e[_] }
															else
																y[a - 1] = { f, e[_] }
															end
															k[#k + 1] = y
														end
														r[e[a]] = u(h, t, l)
													end
												else
													local y, t
													y = e[a]
													t = r[e[_]]
													r[y + 1] = t
													r[y] = t[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = {}
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
												end
											end
										end
									end
								end
							end
						else
							if 114 >= y then
								if 96 > y then
									if y <= 85 then
										if 81 > y then
											if y > 78 then
												if 76 ~= y then
													repeat
														if y ~= 79 then
															local y, h
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															y = e[a]
															r[y](t(r, y + 1, e[_]))
															n = n + 1
															e = z[n]
															r[e[a]] = f[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															y = e[a]
															h = r[e[_]]
															r[y + 1] = h
															r[y] = h[e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															y = e[a]
															r[y](t(r, y + 1, e[_]))
															break
														end
														local f, o, s, h, k, y, l
														for y = 0, 5 do
															if y > 2 then
																if 4 <= y then
																	if 4 == y then
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																	else
																		l = e[a]
																		r[l](t(r, l + 1, e[_]))
																	end
																else
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if 1 <= y then
																	if y ~= -3 then
																		repeat
																			if y < 2 then
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																			l = e[a]
																			r[l] = r[l](t(r, l + 1, e[_]))
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																else
																	y = 0
																	while y > -1 do
																		if y >= 3 then
																			if 4 >= y then
																				if y ~= 0 then
																					repeat
																						if 3 ~= y then
																							k = f[o]
																							break
																						end
																						h = f[s]
																					until true
																				else
																					h = f[s]
																				end
																			else
																				if 6 == y then
																					y = -2
																				else
																					r(k, h)
																				end
																			end
																		else
																			if 1 > y then
																				f = e
																			else
																				if y >= -3 then
																					repeat
																						if y > 1 then
																							s = _
																							break
																						end
																						o = a
																					until true
																				else
																					o = a
																				end
																			end
																		end
																		y = y + 1
																	end
																	n = n + 1
																	e = z[n]
																end
															end
														end
													until true
												else
													local f, s, o, h, k, y, l
													for y = 0, 5 do
														if y > 2 then
															if 4 <= y then
																if 4 == y then
																	r[e[a]] = r[e[_]]
																	n = n + 1
																	e = z[n]
																else
																	l = e[a]
																	r[l](t(r, l + 1, e[_]))
																end
															else
																r[e[a]][e[_]] = r[e[d]]
																n = n + 1
																e = z[n]
															end
														else
															if 1 <= y then
																if y ~= -3 then
																	repeat
																		if y < 2 then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																		l = e[a]
																		r[l] = r[l](t(r, l + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															else
																y = 0
																while y > -1 do
																	if y >= 3 then
																		if 4 >= y then
																			if y ~= 0 then
																				repeat
																					if 3 ~= y then
																						k = f[s]
																						break
																					end
																					h = f[o]
																				until true
																			else
																				h = f[o]
																			end
																		else
																			if 6 == y then
																				y = -2
																			else
																				r(k, h)
																			end
																		end
																	else
																		if 1 > y then
																			f = e
																		else
																			if y >= -3 then
																				repeat
																					if y > 1 then
																						o = _
																						break
																					end
																					s = a
																				until true
																			else
																				s = a
																			end
																		end
																	end
																	y = y + 1
																end
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											else
												if y ~= 77 then
													local e = e[a]
													local a, n = s(r[e](r[e + 1]))
													h = n + e - 1
													local n = 0
													for e = e, h do
														n = n + 1
														r[e] = a[n]
													end
												else
													r[e[a]][e[_]] = e[d]
												end
											end
										else
											if y >= 83 then
												if y > 83 then
													if y >= 81 then
														repeat
															if y ~= 84 then
																local y, f
																r[e[a]] = l[e[_]]
																n = n + 1
																e = z[n]
																y = e[a]
																f = r[e[_]]
																r[y + 1] = f
																r[y] = f[e[d]]
																n = n + 1
																e = z[n]
																r(e[a], e[_])
																n = n + 1
																e = z[n]
																y = e[a]
																r[y] = r[y](t(r, y + 1, e[_]))
																n = n + 1
																e = z[n]
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
																do
																	return r[e[a]]
																end
																break
															end
															for y = 0, 5 do
																if y < 3 then
																	if 0 >= y then
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																	else
																		if 1 ~= y then
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																		else
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if y <= 3 then
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	else
																		if y >= 1 then
																			repeat
																				if 5 ~= y then
																					r[e[a]] = r[e[_]][e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				if r[e[a]] ~= r[e[d]] then
																					n = n + 1
																				else
																					n = e[_]
																				end
																			until true
																		else
																			if r[e[a]] ~= r[e[d]] then
																				n = n + 1
																			else
																				n = e[_]
																			end
																		end
																	end
																end
															end
														until true
													else
														for y = 0, 5 do
															if y < 3 then
																if 0 >= y then
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																else
																	if 1 ~= y then
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if y <= 3 then
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																else
																	if y >= 1 then
																		repeat
																			if 5 ~= y then
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			if r[e[a]] ~= r[e[d]] then
																				n = n + 1
																			else
																				n = e[_]
																			end
																		until true
																	else
																		if r[e[a]] ~= r[e[d]] then
																			n = n + 1
																		else
																			n = e[_]
																		end
																	end
																end
															end
														end
													end
												else
													for y = 0, 6 do
														if 3 > y then
															if 0 < y then
																if y > -1 then
																	repeat
																		if y ~= 2 then
																			r[e[a]][e[_]] = e[d]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]][e[_]] = e[d]
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]][e[_]] = e[d]
																n = n + 1
																e = z[n]
															end
														else
															if 5 <= y then
																if y ~= 4 then
																	for d = 46, 72 do
																		if y > 5 then
																			r(e[a], e[_])
																			break
																		end
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r(e[a], e[_])
																end
															else
																if 3 ~= y then
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											else
												if y == 81 then
													r[e[a]][e[_]] = r[e[d]]
												else
													local y, h
													for f = 0, 6 do
														if f <= 2 then
															if 1 <= f then
																if f ~= -1 then
																	repeat
																		if f > 1 then
																			y = e[a]
																			h = r[e[_]]
																			r[y + 1] = h
																			r[y] = h[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	until true
																else
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]] = r[e[_]]
																n = n + 1
																e = z[n]
															end
														else
															if f >= 5 then
																if 1 < f then
																	repeat
																		if f ~= 6 then
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = r[e[_]][e[d]]
																	until true
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																if f >= 1 then
																	repeat
																		if f > 3 then
																			r[e[a]] = {}
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											end
										end
									else
										if 90 >= y then
											if y <= 87 then
												if 86 < y then
													r[e[a]] = r[e[_]] - r[e[d]]
												else
													local _ = e[_]
													local n = r[_]
													for e = _ + 1, e[d] do
														n = n .. r[e]
													end
													r[e[a]] = n
												end
											else
												if 89 <= y then
													if y ~= 86 then
														for h = 37, 91 do
															if y ~= 89 then
																local y, h
																for l = 0, 6 do
																	if l < 3 then
																		if l >= 1 then
																			if 0 <= l then
																				for d = 24, 70 do
																					if 2 > l then
																						y = e[a]
																						r[y](t(r, y + 1, e[_]))
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = r[e[_]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																			else
																				y = e[a]
																				r[y](t(r, y + 1, e[_]))
																				n = n + 1
																				e = z[n]
																			end
																		else
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if l >= 5 then
																			if 6 ~= l then
																				r[e[a]] = {}
																				n = n + 1
																				e = z[n]
																			else
																				r[e[a]][e[_]] = e[d]
																			end
																		else
																			if l >= -1 then
																				for t = 21, 88 do
																					if l ~= 4 then
																						r[e[a]] = f[e[_]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					y = e[a]
																					h = r[e[_]]
																					r[y + 1] = h
																					r[y] = h[e[d]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																			else
																				y = e[a]
																				h = r[e[_]]
																				r[y + 1] = h
																				r[y] = h[e[d]]
																				n = n + 1
																				e = z[n]
																			end
																		end
																	end
																end
																break
															end
															local h = c[e[_]]
															local t
															local y = {}
															t = o.UnTDunMi({}, {
																__index = function(n, e)
																	local e = y[e]
																	return e[1][e[2]]
																end,
																__newindex = function(r, e, n)
																	local e = y[e]
																	e[1][e[2]] = n
																end,
															})
															for a = 1, e[d] do
																n = n + 1
																local e = z[n]
																if e[j] == 213 then
																	y[a - 1] = { r, e[_] }
																else
																	y[a - 1] = { f, e[_] }
																end
																k[#k + 1] = y
															end
															r[e[a]] = u(h, t, l)
															break
														end
													else
														local y, h
														for l = 0, 6 do
															if l < 3 then
																if l >= 1 then
																	if 0 <= l then
																		for d = 24, 70 do
																			if 2 > l then
																				y = e[a]
																				r[y](t(r, y + 1, e[_]))
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = r[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		y = e[a]
																		r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	end
																else
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if l >= 5 then
																	if 6 ~= l then
																		r[e[a]] = {}
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]][e[_]] = e[d]
																	end
																else
																	if l >= -1 then
																		for t = 21, 88 do
																			if l ~= 4 then
																				r[e[a]] = f[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			y = e[a]
																			h = r[e[_]]
																			r[y + 1] = h
																			r[y] = h[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		y = e[a]
																		h = r[e[_]]
																		r[y + 1] = h
																		r[y] = h[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													end
												else
													local y, h, s, b, f, t, d, l, k
													for d = 0, 4 do
														if 2 <= d then
															if 3 > d then
																d = 0
																while d > -1 do
																	if d <= 3 then
																		if 1 >= d then
																			if -1 <= d then
																				repeat
																					if 0 ~= d then
																						h = a
																						break
																					end
																					y = e
																				until true
																			else
																				y = e
																			end
																		else
																			if -2 <= d then
																				repeat
																					if d ~= 3 then
																						s = _
																						break
																					end
																					b = r
																				until true
																			else
																				s = _
																			end
																		end
																	else
																		if d >= 6 then
																			if d > 3 then
																				repeat
																					if d > 6 then
																						d = -2
																						break
																					end
																					r[t] = f
																				until true
																			else
																				r[t] = f
																			end
																		else
																			if d ~= 5 then
																				f = b[y[s]]
																			else
																				t = y[h]
																			end
																		end
																	end
																	d = d + 1
																end
																n = n + 1
																e = z[n]
															else
																if 1 ~= d then
																	for y = 12, 78 do
																		if 3 ~= d then
																			l = e[a]
																			k = r[l]
																			for e = l + 1, e[_] do
																				o.KtjR_Kcj(k, r[e])
																			end
																			break
																		end
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	l = e[a]
																	k = r[l]
																	for e = l + 1, e[_] do
																		o.KtjR_Kcj(k, r[e])
																	end
																end
															end
														else
															if d ~= 0 then
																r[e[a]] = r[e[_]]
																n = n + 1
																e = z[n]
															else
																d = 0
																while d > -1 do
																	if d <= 3 then
																		if d >= 2 then
																			if 1 < d then
																				for e = 16, 74 do
																					if d < 3 then
																						s = _
																						break
																					end
																					b = r
																					break
																				end
																			else
																				s = _
																			end
																		else
																			if -2 <= d then
																				for n = 12, 68 do
																					if d ~= 0 then
																						h = a
																						break
																					end
																					y = e
																					break
																				end
																			else
																				h = a
																			end
																		end
																	else
																		if 5 >= d then
																			if d ~= 3 then
																				for e = 36, 59 do
																					if d ~= 5 then
																						f = b[y[s]]
																						break
																					end
																					t = y[h]
																					break
																				end
																			else
																				t = y[h]
																			end
																		else
																			if d >= 5 then
																				for e = 48, 71 do
																					if d > 6 then
																						d = -2
																						break
																					end
																					r[t] = f
																					break
																				end
																			else
																				r[t] = f
																			end
																		end
																	end
																	d = d + 1
																end
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											end
										else
											if 93 > y then
												if y ~= 89 then
													for t = 31, 63 do
														if y < 92 then
															local z = e[a]
															local _ = {}
															for e = 1, #k do
																local e = k[e]
																for n = 0, #e do
																	local e = e[n]
																	local a = e[1]
																	local n = e[2]
																	if a == r and n >= z then
																		_[n] = a[n]
																		e[1] = _
																	end
																end
															end
															break
														end
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]] + r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														break
													end
												else
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]] + r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
												end
											else
												if y > 93 then
													if 91 < y then
														repeat
															if y ~= 94 then
																if r[e[a]] == e[d] then
																	n = n + 1
																else
																	n = e[_]
																end
																break
															end
															local a = e[a]
															local _ = { r[a](t(r, a + 1, h)) }
															local n = 0
															for e = a, e[d] do
																n = n + 1
																r[e] = _[n]
															end
														until true
													else
														if r[e[a]] == e[d] then
															n = n + 1
														else
															n = e[_]
														end
													end
												else
													local y, f
													for l = 0, 7 do
														if l > 3 then
															if l <= 5 then
																if 3 < l then
																	repeat
																		if l > 4 then
																			y = e[a]
																			f = r[e[_]]
																			r[y + 1] = f
																			r[y] = f[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		y = e[a]
																		r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	until true
																else
																	y = e[a]
																	r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															else
																if 6 == l then
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = {}
																end
															end
														else
															if 1 < l then
																if -1 < l then
																	for d = 42, 90 do
																		if l ~= 2 then
																			r[e[a]] = r[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = r[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																if l >= -3 then
																	for d = 12, 53 do
																		if l ~= 1 then
																			y = e[a]
																			r[y](t(r, y + 1, e[_]))
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	y = e[a]
																	r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											end
										end
									end
								else
									if 105 <= y then
										if y > 109 then
											if y > 111 then
												if y > 112 then
													if y > 112 then
														for t = 46, 54 do
															if 113 ~= y then
																local y
																r[e[a]] = {}
																n = n + 1
																e = z[n]
																r[e[a]][e[_]] = r[e[d]]
																n = n + 1
																e = z[n]
																r[e[a]][e[_]] = e[d]
																n = n + 1
																e = z[n]
																y = e[a]
																r[y] = r[y](r[y + 1])
																n = n + 1
																e = z[n]
																r[e[a]] = (e[_] ~= 0)
																n = n + 1
																e = z[n]
																f[e[_]] = r[e[a]]
																n = n + 1
																e = z[n]
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
																if r[e[a]] == e[d] then
																	n = n + 1
																else
																	n = e[_]
																end
																break
															end
															if r[e[a]] then
																n = n + 1
															else
																n = e[_]
															end
															break
														end
													else
														local y
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](r[y + 1])
														n = n + 1
														e = z[n]
														r[e[a]] = (e[_] ~= 0)
														n = n + 1
														e = z[n]
														f[e[_]] = r[e[a]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														if r[e[a]] == e[d] then
															n = n + 1
														else
															n = e[_]
														end
													end
												else
													local f
													for y = 0, 6 do
														if y < 3 then
															if 0 < y then
																if y < 2 then
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																else
																	f = e[a]
																	r[f] = r[f](t(r, f + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															else
																r(e[a], e[_])
																n = n + 1
																e = z[n]
															end
														else
															if 4 < y then
																if y ~= 3 then
																	for t = 26, 93 do
																		if y > 5 then
																			r(e[a], e[_])
																			break
																		end
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r(e[a], e[_])
																end
															else
																if 3 == y then
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											else
												if y ~= 110 then
													local y, h
													for t = 0, 6 do
														if 3 <= t then
															if t >= 5 then
																if t >= 1 then
																	for d = 13, 92 do
																		if t < 6 then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																		y = e[a]
																		r[y] = r[y](r[y + 1])
																		break
																	end
																else
																	y = e[a]
																	r[y] = r[y](r[y + 1])
																end
															else
																if t >= 0 then
																	repeat
																		if 3 < t then
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if t > 0 then
																if t > 0 then
																	for l = 20, 88 do
																		if t > 1 then
																			r[e[a]] = f[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		y = e[a]
																		h = r[e[_]]
																		r[y + 1] = h
																		r[y] = h[e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]] = f[e[_]]
																n = n + 1
																e = z[n]
															end
														end
													end
												else
													if r[e[a]] == e[d] then
														n = n + 1
													else
														n = e[_]
													end
												end
											end
										else
											if y < 107 then
												if 104 <= y then
													repeat
														if 106 ~= y then
															local y, f
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															y = e[a]
															f = r[e[_]]
															r[y + 1] = f
															r[y] = f[e[d]]
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](t(r, y + 1, e[_]))
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															break
														end
														local d
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														d = e[a]
														r[d](r[d + 1])
														n = n + 1
														e = z[n]
														r[e[a]] = (e[_] ~= 0)
														n = n + 1
														e = z[n]
														do
															return r[e[a]]
														end
														n = n + 1
														e = z[n]
														n = e[_]
													until true
												else
													local y, f
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													y = e[a]
													f = r[e[_]]
													r[y + 1] = f
													r[y] = f[e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
												end
											else
												if 107 >= y then
													local f
													for y = 0, 6 do
														if 2 >= y then
															if y <= 0 then
																r(e[a], e[_])
																n = n + 1
																e = z[n]
															else
																if y > -3 then
																	repeat
																		if 1 < y then
																			r[e[a]][e[_]] = r[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		f = e[a]
																		r[f] = r[f](t(r, f + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]][e[_]] = r[e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if 4 < y then
																if 3 <= y then
																	repeat
																		if y < 6 then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r(e[a], e[_])
																	until true
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															else
																if 0 < y then
																	repeat
																		if 4 ~= y then
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													if 106 < y then
														repeat
															if 109 ~= y then
																local y, k, b, s, y, y, c, u, o, t, f, h, l
																for y = 0, 7 do
																	if y < 4 then
																		if 1 >= y then
																			if y == 0 then
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																			else
																				y = 0
																				while y > -1 do
																					if y <= 2 then
																						if 1 <= y then
																							if -3 <= y then
																								for e = 44, 54 do
																									if y < 2 then
																										k = a
																										break
																									end
																									b = _
																									break
																								end
																							else
																								k = a
																							end
																						else
																							t = e
																						end
																					else
																						if 4 < y then
																							if y ~= 6 then
																								r(h, s)
																							else
																								y = -2
																							end
																						else
																							if 3 == y then
																								s = t[b]
																							else
																								h = t[k]
																							end
																						end
																					end
																					y = y + 1
																				end
																				n = n + 1
																				e = z[n]
																			end
																		else
																			if -2 < y then
																				repeat
																					if y ~= 3 then
																						r[e[a]] = r[e[_]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = {}
																					n = n + 1
																					e = z[n]
																				until true
																			else
																				r[e[a]] = {}
																				n = n + 1
																				e = z[n]
																			end
																		end
																	else
																		if 5 >= y then
																			if 2 < y then
																				for d = 37, 79 do
																					if y > 4 then
																						y = 0
																						while y > -1 do
																							if 3 <= y then
																								if y >= 5 then
																									if 4 ~= y then
																										for e = 16, 55 do
																											if
																												6 ~= y
																											then
																												r(h, s)
																												break
																											end
																											y = -2
																											break
																										end
																									else
																										r(h, s)
																									end
																								else
																									if 4 == y then
																										h = t[k]
																									else
																										s = t[b]
																									end
																								end
																							else
																								if y <= 0 then
																									t = e
																								else
																									if y >= -3 then
																										repeat
																											if
																												y > 1
																											then
																												b = _
																												break
																											end
																											k = a
																										until true
																									else
																										b = _
																									end
																								end
																							end
																							y = y + 1
																						end
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = r[e[_]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																			else
																				r[e[a]] = r[e[_]]
																				n = n + 1
																				e = z[n]
																			end
																		else
																			if 2 < y then
																				repeat
																					if y < 7 then
																						y = 0
																						while y > -1 do
																							if 2 < y then
																								if 4 < y then
																									if y == 5 then
																										r[h] = l
																									else
																										y = -2
																									end
																								else
																									if 2 ~= y then
																										repeat
																											if
																												y < 4
																											then
																												h = t[c]
																												break
																											end
																											l = r[f]
																											for e = 1 + f, t[o] do
																												l = l
																													.. r[e]
																											end
																										until true
																									else
																										l = r[f]
																										for e = 1 + f, t[o] do
																											l = l
																												.. r[e]
																										end
																									end
																								end
																							else
																								if 0 >= y then
																									c = a
																									u = _
																									o = d
																								else
																									if 2 == y then
																										f = t[u]
																									else
																										t = e
																									end
																								end
																							end
																							y = y + 1
																						end
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]][e[_]] = r[e[d]]
																				until true
																			else
																				y = 0
																				while y > -1 do
																					if 2 < y then
																						if 4 < y then
																							if y == 5 then
																								r[h] = l
																							else
																								y = -2
																							end
																						else
																							if 2 ~= y then
																								repeat
																									if y < 4 then
																										h = t[c]
																										break
																									end
																									l = r[f]
																									for e = 1 + f, t[o] do
																										l = l .. r[e]
																									end
																								until true
																							else
																								l = r[f]
																								for e = 1 + f, t[o] do
																									l = l .. r[e]
																								end
																							end
																						end
																					else
																						if 0 >= y then
																							c = a
																							u = _
																							o = d
																						else
																							if 2 == y then
																								f = t[u]
																							else
																								t = e
																							end
																						end
																					end
																					y = y + 1
																				end
																				n = n + 1
																				e = z[n]
																			end
																		end
																	end
																end
																break
															end
															r[e[a]] = r[e[_]] * e[d]
														until true
													else
														r[e[a]] = r[e[_]] * e[d]
													end
												end
											end
										end
									else
										if 99 >= y then
											if y >= 98 then
												if 99 ~= y then
													if r[e[a]] then
														n = n + 1
													else
														n = e[_]
													end
												else
													local z = r[e[d]]
													if z then
														n = n + 1
													else
														r[e[a]] = z
														n = e[_]
													end
												end
											else
												if y ~= 94 then
													repeat
														if 97 > y then
															r[e[a]] = r[e[_]][r[e[d]]]
															break
														end
														if r[e[a]] ~= r[e[d]] then
															n = n + 1
														else
															n = e[_]
														end
													until true
												else
													if r[e[a]] ~= r[e[d]] then
														n = n + 1
													else
														n = e[_]
													end
												end
											end
										else
											if 101 >= y then
												if 97 ~= y then
													for t = 25, 70 do
														if 101 ~= y then
															for y = 0, 6 do
																if y < 3 then
																	if 1 > y then
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																	else
																		if 0 ~= y then
																			repeat
																				if y ~= 1 then
																					r[e[a]] = l[e[_]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																				r[e[a]][e[_]] = e[d]
																				n = n + 1
																				e = z[n]
																			until true
																		else
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																		end
																	end
																else
																	if 4 < y then
																		if 5 ~= y then
																			r(e[a], e[_])
																		else
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		end
																	else
																		if y < 4 then
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																		else
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																		end
																	end
																end
															end
															break
														end
														local y, t
														r[e[a]] = r[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = f[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														t = r[e[_]]
														r[y + 1] = t
														r[y] = t[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														break
													end
												else
													local t, y
													r[e[a]] = r[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													t = e[a]
													y = r[e[_]]
													r[t + 1] = y
													r[t] = y[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = {}
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
												end
											else
												if y >= 103 then
													if 100 < y then
														repeat
															if 104 ~= y then
																local y, f
																r[e[a]] = l[e[_]]
																n = n + 1
																e = z[n]
																y = e[a]
																f = r[e[_]]
																r[y + 1] = f
																r[y] = f[e[d]]
																n = n + 1
																e = z[n]
																r(e[a], e[_])
																n = n + 1
																e = z[n]
																y = e[a]
																r[y] = r[y](t(r, y + 1, e[_]))
																n = n + 1
																e = z[n]
																r[e[a]] = l[e[_]]
																n = n + 1
																e = z[n]
																r[e[a]] = {}
																n = n + 1
																e = z[n]
																r[e[a]][e[_]] = e[d]
																n = n + 1
																e = z[n]
																r[e[a]][e[_]] = e[d]
																n = n + 1
																e = z[n]
																r[e[a]] = {}
																n = n + 1
																e = z[n]
																r[e[a]][e[_]] = e[d]
																break
															end
															local e = e[a]
															local a, n = s(r[e](t(r, e + 1, h)))
															h = n + e - 1
															local n = 0
															for e = e, h do
																n = n + 1
																r[e] = a[n]
															end
														until true
													else
														local y, f
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														f = r[e[_]]
														r[y + 1] = f
														r[y] = f[e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
													end
												else
													local y, f
													for l = 0, 5 do
														if 3 <= l then
															if l >= 4 then
																if l >= 3 then
																	for f = 12, 58 do
																		if 4 ~= l then
																			y = e[a]
																			r[y](t(r, y + 1, e[_]))
																			break
																		end
																		r[e[a]][e[_]] = e[d]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	y = e[a]
																	r[y](t(r, y + 1, e[_]))
																end
															else
																r[e[a]][e[_]] = e[d]
																n = n + 1
																e = z[n]
															end
														else
															if 0 >= l then
																y = e[a]
																f = r[e[_]]
																r[y + 1] = f
																r[y] = f[e[d]]
																n = n + 1
																e = z[n]
															else
																if l < 2 then
																	r[e[a]] = {}
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]][e[_]] = e[d]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											end
										end
									end
								end
							else
								if 134 <= y then
									if y <= 143 then
										if y >= 139 then
											if y < 141 then
												if y ~= 136 then
													repeat
														if 140 > y then
															local n = e[a]
															local a = { r[n]() }
															local _ = e[d]
															local e = 0
															for n = n, _ do
																e = e + 1
																r[n] = a[e]
															end
															break
														end
														local t
														for y = 0, 6 do
															if 3 <= y then
																if 4 < y then
																	if y ~= 6 then
																		t = e[a]
																		r[t] = r[t](r[t + 1])
																		n = n + 1
																		e = z[n]
																	else
																		r(e[a], e[_])
																	end
																else
																	if 1 <= y then
																		repeat
																			if 4 ~= y then
																				r[e[a]] = r[e[_]][e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if y < 1 then
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																else
																	if -2 <= y then
																		for d = 36, 63 do
																			if y ~= 2 then
																				r[e[a]] = l[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = f[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													until true
												else
													local t
													for y = 0, 6 do
														if 3 <= y then
															if 4 < y then
																if y ~= 6 then
																	t = e[a]
																	r[t] = r[t](r[t + 1])
																	n = n + 1
																	e = z[n]
																else
																	r(e[a], e[_])
																end
															else
																if 1 <= y then
																	repeat
																		if 4 ~= y then
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if y < 1 then
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
															else
																if -2 <= y then
																	for d = 36, 63 do
																		if y ~= 2 then
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												end
											else
												if 141 >= y then
													local y
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
												else
													if y >= 139 then
														for h = 49, 52 do
															if 142 < y then
																local y, o
																for h = 0, 6 do
																	if 2 >= h then
																		if 0 >= h then
																			r[e[a]] = f[e[_]]
																			n = n + 1
																			e = z[n]
																		else
																			if 0 < h then
																				repeat
																					if 1 < h then
																						y = e[a]
																						o = r[e[_]]
																						r[y + 1] = o
																						r[y] = o[e[d]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = r[e[_]][e[d]]
																					n = n + 1
																					e = z[n]
																				until true
																			else
																				y = e[a]
																				o = r[e[_]]
																				r[y + 1] = o
																				r[y] = o[e[d]]
																				n = n + 1
																				e = z[n]
																			end
																		end
																	else
																		if h <= 4 then
																			if 4 ~= h then
																				r[e[a]] = l[e[_]]
																				n = n + 1
																				e = z[n]
																			else
																				y = e[a]
																				r[y](t(r, y + 1, e[_]))
																				n = n + 1
																				e = z[n]
																			end
																		else
																			if h ~= 1 then
																				repeat
																					if h ~= 6 then
																						r[e[a]] = f[e[_]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = r[e[_]][e[d]]
																				until true
																			else
																				r[e[a]] = f[e[_]]
																				n = n + 1
																				e = z[n]
																			end
																		end
																	end
																end
																break
															end
															local y
															r[e[a]] = f[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = f[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]]
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](r[y + 1])
															n = n + 1
															e = z[n]
															if r[e[a]] then
																n = n + 1
															else
																n = e[_]
															end
															break
														end
													else
														local y, o
														for h = 0, 6 do
															if 2 >= h then
																if 0 >= h then
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																else
																	if 0 < h then
																		repeat
																			if 1 < h then
																				y = e[a]
																				o = r[e[_]]
																				r[y + 1] = o
																				r[y] = o[e[d]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		y = e[a]
																		o = r[e[_]]
																		r[y + 1] = o
																		r[y] = o[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if h <= 4 then
																	if 4 ~= h then
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	else
																		y = e[a]
																		r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	end
																else
																	if h ~= 1 then
																		repeat
																			if h ~= 6 then
																				r[e[a]] = f[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = r[e[_]][e[d]]
																		until true
																	else
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													end
												end
											end
										else
											if y < 136 then
												if 134 ~= y then
													local y, u, k, c, o, b
													for k = 0, 5 do
														if k > 2 then
															if 3 < k then
																if 0 ~= k then
																	for l = 46, 98 do
																		if k > 4 then
																			n = e[_]
																			break
																		end
																		y = e[a]
																		b = { r[y](t(r, y + 1, h)) }
																		o = 0
																		for e = y, e[d] do
																			o = o + 1
																			r[e] = b[o]
																		end
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	y = e[a]
																	b = { r[y](t(r, y + 1, h)) }
																	o = 0
																	for e = y, e[d] do
																		o = o + 1
																		r[e] = b[o]
																	end
																	n = n + 1
																	e = z[n]
																end
															else
																y = e[a]
																b, c = s(r[y](r[y + 1]))
																h = c + y - 1
																o = 0
																for e = y, h do
																	o = o + 1
																	r[e] = b[o]
																end
																n = n + 1
																e = z[n]
															end
														else
															if 0 >= k then
																r[e[a]] = l[e[_]]
																n = n + 1
																e = z[n]
															else
																if k > -3 then
																	for t = 39, 59 do
																		if k ~= 1 then
																			y = e[a]
																			u = r[e[_]]
																			r[y + 1] = u
																			r[y] = u[e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = f[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													if r[e[a]] < r[e[d]] then
														n = e[_]
													else
														n = n + 1
													end
												end
											else
												if y > 136 then
													if y ~= 136 then
														for h = 37, 79 do
															if 137 ~= y then
																local h
																for y = 0, 6 do
																	if 3 > y then
																		if y < 1 then
																			h = e[a]
																			r[h](t(r, h + 1, e[_]))
																			n = n + 1
																			e = z[n]
																		else
																			if -2 ~= y then
																				for d = 40, 94 do
																					if y ~= 2 then
																						r[e[a]] = l[e[_]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					r[e[a]] = f[e[_]]
																					n = n + 1
																					e = z[n]
																					break
																				end
																			else
																				r[e[a]] = l[e[_]]
																				n = n + 1
																				e = z[n]
																			end
																		end
																	else
																		if y >= 5 then
																			if y > 3 then
																				repeat
																					if y ~= 5 then
																						r[e[a]] = r[e[_]][e[d]]
																						break
																					end
																					r[e[a]] = l[e[_]]
																					n = n + 1
																					e = z[n]
																				until true
																			else
																				r[e[a]] = l[e[_]]
																				n = n + 1
																				e = z[n]
																			end
																		else
																			if 1 <= y then
																				for d = 28, 77 do
																					if 4 > y then
																						r[e[a]] = r[e[_]]
																						n = n + 1
																						e = z[n]
																						break
																					end
																					h = e[a]
																					r[h](t(r, h + 1, e[_]))
																					n = n + 1
																					e = z[n]
																					break
																				end
																			else
																				r[e[a]] = r[e[_]]
																				n = n + 1
																				e = z[n]
																			end
																		end
																	end
																end
																break
															end
															n = e[_]
															break
														end
													else
														local h
														for y = 0, 6 do
															if 3 > y then
																if y < 1 then
																	h = e[a]
																	r[h](t(r, h + 1, e[_]))
																	n = n + 1
																	e = z[n]
																else
																	if -2 ~= y then
																		for d = 40, 94 do
																			if y ~= 2 then
																				r[e[a]] = l[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			r[e[a]] = f[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if y >= 5 then
																	if y > 3 then
																		repeat
																			if y ~= 5 then
																				r[e[a]] = r[e[_]][e[d]]
																				break
																			end
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r[e[a]] = l[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if 1 <= y then
																		for d = 28, 77 do
																			if 4 > y then
																				r[e[a]] = r[e[_]]
																				n = n + 1
																				e = z[n]
																				break
																			end
																			h = e[a]
																			r[h](t(r, h + 1, e[_]))
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
														end
													end
												else
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
												end
											end
										end
									else
										if y >= 149 then
											if 151 > y then
												if y ~= 150 then
													local l, h, o, s, k, y, f
													for y = 0, 4 do
														if y >= 2 then
															if 3 > y then
																y = 0
																while y > -1 do
																	if 2 < y then
																		if y < 5 then
																			if y ~= 0 then
																				repeat
																					if y < 4 then
																						s = l[o]
																						break
																					end
																					k = l[h]
																				until true
																			else
																				s = l[o]
																			end
																		else
																			if 6 ~= y then
																				r(k, s)
																			else
																				y = -2
																			end
																		end
																	else
																		if y <= 0 then
																			l = e
																		else
																			if 1 < y then
																				o = _
																			else
																				h = a
																			end
																		end
																	end
																	y = y + 1
																end
																n = n + 1
																e = z[n]
															else
																if 2 <= y then
																	for l = 37, 61 do
																		if y < 4 then
																			f = e[a]
																			r[f] = r[f](t(r, f + 1, e[_]))
																			n = n + 1
																			e = z[n]
																			break
																		end
																		if r[e[a]] == e[d] then
																			n = n + 1
																		else
																			n = e[_]
																		end
																		break
																	end
																else
																	f = e[a]
																	r[f] = r[f](t(r, f + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if y ~= 0 then
																y = 0
																while y > -1 do
																	if 2 < y then
																		if y < 5 then
																			if -1 ~= y then
																				repeat
																					if 4 > y then
																						s = l[o]
																						break
																					end
																					k = l[h]
																				until true
																			else
																				k = l[h]
																			end
																		else
																			if y > 5 then
																				y = -2
																			else
																				r(k, s)
																			end
																		end
																	else
																		if 0 >= y then
																			l = e
																		else
																			if 2 > y then
																				h = a
																			else
																				o = _
																			end
																		end
																	end
																	y = y + 1
																end
																n = n + 1
																e = z[n]
															else
																r[e[a]] = r[e[_]][e[d]]
																n = n + 1
																e = z[n]
															end
														end
													end
												else
													local f
													for y = 0, 6 do
														if y >= 3 then
															if 5 > y then
																if y > 3 then
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															else
																if 5 == y then
																	f = e[a]
																	r[f] = r[f](t(r, f + 1, e[_]))
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]][e[_]] = r[e[d]]
																end
															end
														else
															if y >= 1 then
																if -2 < y then
																	repeat
																		if 2 ~= y then
																			r[e[a]] = l[e[_]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]][e[_]] = r[e[d]]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											else
												if 152 <= y then
													if 151 < y then
														for z = 22, 52 do
															if y > 152 then
																if r[e[a]] == r[e[d]] then
																	n = n + 1
																else
																	n = e[_]
																end
																break
															end
															local n = e[a]
															local a, e = s(r[n](t(r, n + 1, e[_])))
															h = e + n - 1
															local e = 0
															for n = n, h do
																e = e + 1
																r[n] = a[e]
															end
															break
														end
													else
														if r[e[a]] == r[e[d]] then
															n = n + 1
														else
															n = e[_]
														end
													end
												else
													local h, y, t
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													h = e[_]
													y = r[h]
													for e = h + 1, e[d] do
														y = y .. r[e]
													end
													r[e[a]] = y
													n = n + 1
													e = z[n]
													t = e[a]
													r[t] = r[t](r[t + 1])
													n = n + 1
													e = z[n]
													if r[e[a]] == r[e[d]] then
														n = n + 1
													else
														n = e[_]
													end
												end
											end
										else
											if 146 > y then
												if y >= 141 then
													for h = 43, 55 do
														if 145 > y then
															local y, l
															r[e[a]] = {}
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = e[d]
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](t(r, y + 1, e[_]))
															n = n + 1
															e = z[n]
															y = e[a]
															l = r[e[_]]
															r[y + 1] = l
															r[y] = l[e[d]]
															n = n + 1
															e = z[n]
															y = e[a]
															r[y](r[y + 1])
															n = n + 1
															e = z[n]
															r[e[a]] = f[e[_]]
															n = n + 1
															e = z[n]
															y = e[a]
															l = r[e[_]]
															r[y + 1] = l
															r[y] = l[e[d]]
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](t(r, y + 1, e[_]))
															n = n + 1
															e = z[n]
															if r[e[a]] then
																n = n + 1
															else
																n = e[_]
															end
															break
														end
														local y, f
														for h = 0, 6 do
															if 3 <= h then
																if 5 <= h then
																	if h >= 4 then
																		repeat
																			if h ~= 5 then
																				r(e[a], e[_])
																				break
																			end
																			y = e[a]
																			f = r[e[_]]
																			r[y + 1] = f
																			r[y] = f[e[d]]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		y = e[a]
																		f = r[e[_]]
																		r[y + 1] = f
																		r[y] = f[e[d]]
																		n = n + 1
																		e = z[n]
																	end
																else
																	if h < 4 then
																		y = e[a]
																		r[y] = r[y](t(r, y + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	else
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															else
																if h >= 1 then
																	if h >= -2 then
																		repeat
																			if h ~= 1 then
																				r(e[a], e[_])
																				n = n + 1
																				e = z[n]
																				break
																			end
																			y = e[a]
																			f = r[e[_]]
																			r[y + 1] = f
																			r[y] = f[e[d]]
																			n = n + 1
																			e = z[n]
																		until true
																	else
																		r(e[a], e[_])
																		n = n + 1
																		e = z[n]
																	end
																else
																	r[e[a]] = l[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
														break
													end
												else
													local y, f
													for h = 0, 6 do
														if 3 <= h then
															if 5 <= h then
																if h >= 4 then
																	repeat
																		if h ~= 5 then
																			r(e[a], e[_])
																			break
																		end
																		y = e[a]
																		f = r[e[_]]
																		r[y + 1] = f
																		r[y] = f[e[d]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	y = e[a]
																	f = r[e[_]]
																	r[y + 1] = f
																	r[y] = f[e[d]]
																	n = n + 1
																	e = z[n]
																end
															else
																if h < 4 then
																	y = e[a]
																	r[y] = r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																else
																	r[e[a]] = r[e[_]][e[d]]
																	n = n + 1
																	e = z[n]
																end
															end
														else
															if h >= 1 then
																if h >= -2 then
																	repeat
																		if h ~= 1 then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																		y = e[a]
																		f = r[e[_]]
																		r[y + 1] = f
																		r[y] = f[e[d]]
																		n = n + 1
																		e = z[n]
																	until true
																else
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]] = l[e[_]]
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											else
												if y >= 147 then
													if y ~= 145 then
														for z = 10, 76 do
															if 147 ~= y then
																local n = e[a]
																local _ = { r[n]() }
																local a = e[d]
																local e = 0
																for n = n, a do
																	e = e + 1
																	r[n] = _[e]
																end
																break
															end
															if e[a] <= r[e[d]] then
																n = e[_]
															else
																n = n + 1
															end
															break
														end
													else
														if e[a] <= r[e[d]] then
															n = e[_]
														else
															n = n + 1
														end
													end
												else
													r[e[a]]()
												end
											end
										end
									end
								else
									if 124 > y then
										if 118 < y then
											if 120 < y then
												if y > 121 then
													if y ~= 123 then
														r[e[a]] = r[e[_]]
													else
														local l
														for y = 0, 4 do
															if y > 1 then
																if 2 >= y then
																	r(e[a], e[_])
																	n = n + 1
																	e = z[n]
																else
																	if 3 == y then
																		l = e[a]
																		r[l] = r[l](t(r, l + 1, e[_]))
																		n = n + 1
																		e = z[n]
																	else
																		if r[e[a]] ~= e[d] then
																			n = n + 1
																		else
																			n = e[_]
																		end
																	end
																end
															else
																if -3 <= y then
																	for d = 48, 93 do
																		if 0 < y then
																			r(e[a], e[_])
																			n = n + 1
																			e = z[n]
																			break
																		end
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																else
																	r[e[a]] = r[e[_]]
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													local y, l
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													y = e[a]
													l = r[e[_]]
													r[y + 1] = l
													r[y] = l[e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r[e[a]] = {}
												end
											else
												if y >= 115 then
													repeat
														if y ~= 120 then
															local y, f
															for l = 0, 2 do
																if l < 1 then
																	y = e[a]
																	r[y](t(r, y + 1, e[_]))
																	n = n + 1
																	e = z[n]
																else
																	if -2 ~= l then
																		for t = 24, 97 do
																			if l > 1 then
																				y = e[a]
																				f = r[e[_]]
																				r[y + 1] = f
																				r[y] = f[e[d]]
																				break
																			end
																			r[e[a]] = r[e[_]][e[d]]
																			n = n + 1
																			e = z[n]
																			break
																		end
																	else
																		r[e[a]] = r[e[_]][e[d]]
																		n = n + 1
																		e = z[n]
																	end
																end
															end
															break
														end
														local n = e[a]
														local a = r[n]
														for e = n + 1, e[_] do
															o.KtjR_Kcj(a, r[e])
														end
													until true
												else
													local n = e[a]
													local a = r[n]
													for e = n + 1, e[_] do
														o.KtjR_Kcj(a, r[e])
													end
												end
											end
										else
											if 116 < y then
												if 117 ~= y then
													local y
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
												else
													local d
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													d = e[a]
													r[d](r[d + 1])
													n = n + 1
													e = z[n]
													for e = e[a], e[_] do
														r[e] = nil
													end
													n = n + 1
													e = z[n]
													do
														return r[e[a]]
													end
													n = n + 1
													e = z[n]
													n = e[_]
												end
											else
												if y ~= 113 then
													for h = 21, 64 do
														if y < 116 then
															local y, l
															y = e[a]
															l = r[e[_]]
															r[y + 1] = l
															r[y] = l[e[d]]
															n = n + 1
															e = z[n]
															r[e[a]] = {}
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = e[d]
															n = n + 1
															e = z[n]
															r[e[a]][e[_]] = e[d]
															n = n + 1
															e = z[n]
															y = e[a]
															r[y] = r[y](t(r, y + 1, e[_]))
															n = n + 1
															e = z[n]
															r[e[a]] = f[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]][e[d]]
															n = n + 1
															e = z[n]
															if not r[e[a]] then
																n = n + 1
															else
																n = e[_]
															end
															break
														end
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														break
													end
												else
													local y, l
													y = e[a]
													l = r[e[_]]
													r[y + 1] = l
													r[y] = l[e[d]]
													n = n + 1
													e = z[n]
													r[e[a]] = {}
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = e[d]
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													if not r[e[a]] then
														n = n + 1
													else
														n = e[_]
													end
												end
											end
										end
									else
										if 129 <= y then
											if 131 > y then
												if y ~= 128 then
													for l = 22, 64 do
														if y ~= 129 then
															local e = e[a]
															local a, n = s(r[e]())
															h = n + e - 1
															local n = 0
															for e = e, h do
																n = n + 1
																r[e] = a[n]
															end
															break
														end
														local y
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														break
													end
												else
													local y
													r[e[a]] = r[e[_]][e[d]]
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													y = e[a]
													r[y] = r[y](t(r, y + 1, e[_]))
													n = n + 1
													e = z[n]
													r[e[a]][e[_]] = r[e[d]]
												end
											else
												if y > 131 then
													if 132 == y then
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = e[d]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
													else
														local y, f
														y = e[a]
														r[y] = r[y](t(r, y + 1, h))
														n = n + 1
														e = z[n]
														y = e[a]
														f = r[e[_]]
														r[y + 1] = f
														r[y] = f[e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														r[e[a]][e[_]] = r[e[d]]
													end
												else
													local l, y, h
													for f = 0, 4 do
														if f > 1 then
															if 3 <= f then
																if f > 3 then
																	n = e[_]
																else
																	h = e[a]
																	r[h](t(r, h + 1, e[_]))
																	n = n + 1
																	e = z[n]
																end
															else
																r[e[a]][e[_]] = e[d]
																n = n + 1
																e = z[n]
															end
														else
															if f > -3 then
																repeat
																	if f > 0 then
																		r[e[a]][e[_]] = r[e[d]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																	l = e[_]
																	y = r[l]
																	for e = l + 1, e[d] do
																		y = y .. r[e]
																	end
																	r[e[a]] = y
																	n = n + 1
																	e = z[n]
																until true
															else
																l = e[_]
																y = r[l]
																for e = l + 1, e[d] do
																	y = y .. r[e]
																end
																r[e[a]] = y
																n = n + 1
																e = z[n]
															end
														end
													end
												end
											end
										else
											if 125 >= y then
												if 123 < y then
													repeat
														if y > 124 then
															local d, o, k, y
															r[e[a]] = l[e[_]]
															n = n + 1
															e = z[n]
															r[e[a]] = f[e[_]]
															n = n + 1
															e = z[n]
															d = e[a]
															o, k = s(r[d]())
															h = k + d - 1
															y = 0
															for e = d, h do
																y = y + 1
																r[e] = o[y]
															end
															n = n + 1
															e = z[n]
															d = e[a]
															o, k = s(r[d](t(r, d + 1, h)))
															h = k + d - 1
															y = 0
															for e = d, h do
																y = y + 1
																r[e] = o[y]
															end
															n = n + 1
															e = z[n]
															d = e[a]
															r[d] = r[d](t(r, d + 1, h))
															n = n + 1
															e = z[n]
															r(e[a], e[_])
															n = n + 1
															e = z[n]
															r[e[a]] = r[e[_]]
															break
														end
														local e = e[a]
														r[e](t(r, e + 1, h))
													until true
												else
													local d, k, o, y
													r[e[a]] = l[e[_]]
													n = n + 1
													e = z[n]
													r[e[a]] = f[e[_]]
													n = n + 1
													e = z[n]
													d = e[a]
													k, o = s(r[d]())
													h = o + d - 1
													y = 0
													for e = d, h do
														y = y + 1
														r[e] = k[y]
													end
													n = n + 1
													e = z[n]
													d = e[a]
													k, o = s(r[d](t(r, d + 1, h)))
													h = o + d - 1
													y = 0
													for e = d, h do
														y = y + 1
														r[e] = k[y]
													end
													n = n + 1
													e = z[n]
													d = e[a]
													r[d] = r[d](t(r, d + 1, h))
													n = n + 1
													e = z[n]
													r(e[a], e[_])
													n = n + 1
													e = z[n]
													r[e[a]] = r[e[_]]
												end
											else
												if 126 >= y then
													local t, h, l
													for y = 0, 4 do
														if 2 > y then
															if y ~= -3 then
																for d = 38, 55 do
																	if y ~= 0 then
																		r[e[a]] = r[e[_]]
																		n = n + 1
																		e = z[n]
																		break
																	end
																	r[e[a]] = f[e[_]]
																	n = n + 1
																	e = z[n]
																	break
																end
															else
																r[e[a]] = f[e[_]]
																n = n + 1
																e = z[n]
															end
														else
															if y <= 2 then
																t = e[a]
																r[t] = r[t](r[t + 1])
																n = n + 1
																e = z[n]
															else
																if y > 3 then
																	n = e[_]
																else
																	h = e[_]
																	l = r[h]
																	for e = h + 1, e[d] do
																		l = l .. r[e]
																	end
																	r[e[a]] = l
																	n = n + 1
																	e = z[n]
																end
															end
														end
													end
												else
													if y == 127 then
														local y, f
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]]
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
														n = n + 1
														e = z[n]
														y = e[a]
														f = r[e[_]]
														r[y + 1] = f
														r[y] = f[e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r[e[a]] = {}
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
													else
														local y
														r[e[a]][e[_]] = r[e[d]]
														n = n + 1
														e = z[n]
														r[e[a]] = l[e[_]]
														n = n + 1
														e = z[n]
														r[e[a]] = r[e[_]][e[d]]
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														r(e[a], e[_])
														n = n + 1
														e = z[n]
														y = e[a]
														r[y] = r[y](t(r, y + 1, e[_]))
													end
												end
											end
										end
									end
								end
							end
						end
					end
					n = 1 + n
				end
			end
			return ae
		end
		local a = 0xff
		local l = {}
		local z = 1
		local _ = "";
		(function(n)
			local r = n
			local d = 0x00
			local e = 0x00
			r = {
				function(a)
					if d > 0x20 then
						return a
					end
					d = d + 1
					e = (e + 0x87e - a) % 0x15
					return (
						e % 0x03 == 0x0
						and (function(r)
							if not n[r] then
								e = e + 0x01
								n[r] = 0xd8
							end
							return true
						end)("QwfiK")
						and r[0x1](0x16e + a)
					)
						or (e % 0x03 == 0x1 and (function(r)
							if not n[r] then
								e = e + 0x01
								n[r] = 0x5c
							end
							return true
						end)("Tffpf") and r[0x3](a + 0x306))
						or (e % 0x03 == 0x2 and (function(r)
							if not n[r] then
								e = e + 0x01
								n[r] = 0xb9
							end
							return true
						end)("YIzDk") and r[0x2](a + 0x190))
						or a
				end,
				function(y)
					if d > 0x2c then
						return y
					end
					d = d + 1
					e = (e + 0x62a - y) % 0x12
					return (
						e % 0x03 == 0x1
						and (function(r)
							if not n[r] then
								e = e + 0x01
								n[r] = 0x30
								a[2] = (a[2] * (ee(function()
									l()
								end, t(_)) - ee(a[1], t(_)))) + 1
								l[z] = {}
								a = a[2]
								z = z + a
							end
							return true
						end)("nOUgz")
						and r[0x3](0xeb + y)
					)
						or (e % 0x03 == 0x2 and (function(r)
							if not n[r] then
								e = e + 0x01
								n[r] = 0xed
								l[z] = ae()
								z = z + a
							end
							return true
						end)("Oallx") and r[0x2](y + 0x73))
						or (e % 0x03 == 0x0 and (function(r)
							if not n[r] then
								e = e + 0x01
								n[r] = 0xf9
							end
							return true
						end)("MxHDx") and r[0x1](y + 0x202))
						or y
				end,
				function(y)
					if d > 0x2e then
						return y
					end
					d = d + 1
					e = (e + 0xc21 - y) % 0x33
					return (
						e % 0x03 == 0x0
						and (function(r)
							if not n[r] then
								e = e + 0x01
								n[r] = 0x31
								_ = "\37"
								a = {
									function()
										a()
									end,
								}
								_ = _ .. "\100\43"
							end
							return true
						end)("HiqgM")
						and r[0x3](0x1f4 + y)
					)
						or (e % 0x03 == 0x1 and (function(r)
							if not n[r] then
								e = e + 0x01
								n[r] = 0xd9
							end
							return true
						end)("UKyFm") and r[0x1](y + 0x229))
						or (e % 0x03 == 0x2 and (function(r)
							if not n[r] then
								e = e + 0x01
								n[r] = 0x46
								_ = { _ .. "\58 a", _ }
								l[z] = ne()
								z = z + ((not o.JhfuSsPo) and 1 or 0)
								_[1] = "\58" .. _[1]
								a[2] = 0xff
							end
							return true
						end)("BZsuW") and r[0x2](y + 0x3d2))
						or y
				end,
			}
			r[0x3](0x18d8)
		end)({})
		local e = u(t(l))
		return e(...)
	end
	return re(
		(function()
			local n = {}
			local e = 0x01
			local r
			if o.JhfuSsPo then
				r = o.JhfuSsPo(re)
			else
				r = ""
			end
			if o.xkyEyqBD(r, o.Ku_bUmFO) then
				e = e + 0
			else
				e = e + 1
			end
			n[e] = 0x02
			n[n[e] + 0x01] = 0x03
			return n
		end)(),
		...
	)
end)(function(e, n, r, _, a, z)
	local z
	if e >= 4 then
		if e > 5 then
			if e >= 7 then
				if 8 > e then
					do
						return setmetatable({}, {
							["__\99\97\108\108"] = function(e, a, _, r, n)
								if n then
									return e[n]
								elseif r then
									return e
								else
									e[a] = _
								end
							end,
						})
					end
				else
					do
						return r(e, nil, r)
					end
				end
			else
				do
					return a[r]
				end
			end
		else
			if e == 5 then
				local e = _
				do
					return function()
						local n = n(r, e(e, e), e(e, e))
						e(1)
						return n
					end
				end
			else
				local e = _
				local z, _, a = a(2)
				do
					return function()
						local n, d, r, y = n(r, e(e, e), e(e, e) + 3)
						e(4)
						return (y * z) + (r * _) + (d * a) + n
					end
				end
			end
		end
	else
		if 2 <= e then
			if -1 ~= e then
				for z = 43, 95 do
					if e ~= 2 then
						do
							return n(1), n(4, a, _, r, n), n(5, a, _, r)
						end
						break
					end
					do
						return 16777216, 65536, 256
					end
					break
				end
			else
				do
					return 16777216, 65536, 256
				end
			end
		else
			if -4 <= e then
				repeat
					if e < 1 then
						do
							return n(1), n(4, a, _, r, n), n(5, a, _, r)
						end
						break
					end
					do
						return function(r, e, n)
							if n then
								local e = (r / 2 ^ (e - 1)) % 2 ^ ((n - 1) - (e - 1) + 1)
								return e - e % 1
							else
								local e = 2 ^ (e - 1)
								return (r % (e + e) >= e) and 1 or 0
							end
						end
					end
				until true
			else
				do
					return function(r, e, n)
						if n then
							local e = (r / 2 ^ (e - 1)) % 2 ^ ((n - 1) - (e - 1) + 1)
							return e - e % 1
						else
							local e = 2 ^ (e - 1)
							return (r % (e + e) >= e) and 1 or 0
						end
					end
				end
			end
		end
	end
end, ...)
