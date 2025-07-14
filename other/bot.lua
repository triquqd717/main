local TEST_MODE = false

if not game:IsLoaded() then
	game.Loaded:Wait()
	task.wait(5)
end

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local Config = {
	WebSocketUrl = "ws://localhost:3000",
	GlobalStockIdentifier = "global_stock",
	GlobalWeatherIdentifier = 1,
	TargetCheckSecond = 9,
	MainStockCheckMinuteInterval = 5,
	StockTableName = "stock_data",
	WeatherTableName = "weather_status",
	CosmeticTableName = "cosmetic_data",
	TravelerTableName = "traveling_merchant_data",
	SeedShopGuiName = "Seed_Shop",
	GearShopGuiName = "Gear_Shop",
	TravelerShopGuiName = "TravelingMerchantShop_UI",
	EggShopName = "PetShop_UI",
}

task.spawn(function()
	print("Loading jandel module...")
	jndl = loadstring(game:HttpGet("https://raw.githubusercontent.com/triquqd717/main/refs/heads/main/modules/anc.lua"))()
	print(jndl)
end)

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Connection = nil
local LastStock = { Seeds = {}, Gear = {}, Eggs = {}, TravelingMerchant = {} }
local WebSocket = typeof(WebSocket) == "table" and WebSocket or nil

local SeedData = require(ReplicatedStorage.Data.SeedData)
local GearData = require(ReplicatedStorage.Data.GearData)

local PetEggData = require(ReplicatedStorage.Data.PetEggData)
local TravelerData
pcall(function()
	TravelerData = require(game:GetService("ReplicatedStorage").Data.TravelingMerchant.TravelingMerchantData)
end)
TravelerData = TravelerData or {}

--region Data Loading
local SeedItems, CropRarities, SeedOrder = {}, {}, {}
do
	local seedKeys, p = {}, 1
	for SeedName in pairs(SeedData) do
		table.insert(seedKeys, SeedName)
	end
	table.sort(seedKeys, function(a, b)
		return (SeedData[a].LayoutOrder or 9999) < (SeedData[b].LayoutOrder or 9999)
	end)
	for _, SeedName in pairs(seedKeys) do
		if SeedData[SeedName].DisplayInShop then
			table.insert(SeedItems, SeedName)
			CropRarities[SeedName] = SeedData[SeedName].SeedRarity or "Unknown"
			SeedOrder[SeedName] = SeedData[SeedName].LayoutOrder or p
			p = p + 1
		end
	end
end

local GearItems, GearRarities, GearOrder = {}, {}, {}
do
	local gearKeys, p = {}, 1
	for GearName in pairs(GearData) do
		table.insert(gearKeys, GearName)
	end
	table.sort(gearKeys, function(a, b)
		return (GearData[a].LayoutOrder or 9999) < (GearData[b].LayoutOrder or 9999)
	end)
	for _, GearName in pairs(gearKeys) do
		if GearData[GearName].DisplayInShop then
			table.insert(GearItems, GearName)
			GearRarities[GearName] = GearData[GearName].GearRarity or "Unknown"
			GearOrder[GearName] = GearData[GearName].LayoutOrder or p
			p = p + 1
		end
	end
end

local EggItems, EggRarities, EggOrder = {}, {}, {}
do
	local eggKeys, p = {}, 1
	for EggName in pairs(PetEggData) do
		table.insert(eggKeys, EggName)
	end
	table.sort(eggKeys, function(a, b)
		return (PetEggData[a].LayoutOrder or 9999) < (PetEggData[b].LayoutOrder or 9999)
	end)
	for _, EggName in pairs(eggKeys) do
		table.insert(EggItems, EggName)
		EggRarities[EggName] = PetEggData[EggName].EggRarity or "Unknown"
		EggOrder[EggName] = PetEggData[EggName].LayoutOrder or p
		p = p + 1
	end
end

local TravelerTable, TravelerRariry, TravelerOrder = {}, {}, {}
for _, tbl in pairs(TravelerData) do
	for _, fruit in pairs(tbl.ShopData) do
		if fruit.DisplayInShop then
			-- FIX: Process the name here to match the GetShopStock logic
			local processedName = fruit.SeedName:gsub(" Seed$", "")
			TravelerRariry[processedName] = fruit.SeedRarity
			TravelerOrder[processedName] = fruit.LayoutOrder
			table.insert(TravelerTable, processedName)
		end
	end
end

local CosmeticsItems, CosmeticsCrates, CosmeticOrder = {}, {}, {}
do
	local CosmeticKeys, CosmeticIndex = {}, 1
	local Success, Result = pcall(function()
		return require(ReplicatedStorage.Data.CosmeticItemShopData)
	end)
	CosmeticsItems = Success and Result or {}
	for CosmeticName in pairs(CosmeticsItems) do
		table.insert(CosmeticKeys, CosmeticName)
	end
	Success, Result = pcall(function()
		return require(ReplicatedStorage.Data.CosmeticCrateShopData)
	end)
	CosmeticsCrates = Success and Result or {}
	for CrateName in pairs(CosmeticsCrates) do
		table.insert(CosmeticKeys, CrateName)
	end
	table.sort(CosmeticKeys, function(a, b)
		local priceA = (CosmeticsItems[a] and CosmeticsItems[a].Price)
			or (CosmeticsCrates[a] and CosmeticsCrates[a].Price)
			or math.huge
		local priceB = (CosmeticsItems[b] and CosmeticsItems[b].Price)
			or (CosmeticsCrates[b] and CosmeticsCrates[b].Price)
			or math.huge
		return priceA < priceB
	end)
	for _, Name in pairs(CosmeticKeys) do
		CosmeticOrder[Name] = (CosmeticsItems[Name] and CosmeticsItems[Name].Price)
			or (CosmeticsCrates[Name] and CosmeticsCrates[Name].Price)
			or CosmeticIndex
		CosmeticIndex = CosmeticIndex + 1
	end
end
--endregion

print("--- Item Data Loaded ---")
print("Seed Items: " .. #SeedItems)
print("Gear Items: " .. #GearItems)
print("Egg Items: " .. #EggItems)
print("Cosmetic Items: " .. #CosmeticOrder)
print("------------------------")

if not WebSocket and not TEST_MODE then
	warn("WebSocket library not found.")
	return
end

task.spawn(function()
	Player.Idled:Connect(function()
		local VirtualUser = game:GetService("VirtualUser")
		VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		task.wait(0.1)
		VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end)
end)

local Utils = {}

function Utils:SendWebSocketMessage(MessageType, MessageData)
	if TEST_MODE then
		print(
			string.format(
				"[TEST_MODE] WebSocket Send -> Type: %s\n%s",
				MessageType,
				HttpService:JSONEncode(MessageData)
			)
		)
		return true
	end

	if not Connection then
		warn("WebSocket not connected, cannot send message.")
		return false
	end
	local Success, Result = pcall(function()
		Connection:Send(HttpService:JSONEncode({ type = MessageType, data = MessageData }))
	end)
	if not Success then
		warn("Failed to send WebSocket message: " .. tostring(Result))
		return false
	end
	return true
end

function Utils:Abort(log)
	self:SendDiscordLogMessage("Bot hang himself:  " .. log, true, 0xFF0000)
	task.wait(1)
	if not TEST_MODE then
		game:Shutdown()
	else
		warn("[TEST_MODE] Abort called with log: " .. log)
	end
end

function Utils:SendDiscordLogMessage(LogMessage, AddTimestamp, Color)
	Color = Color or 0x00FF00
	AddTimestamp = AddTimestamp == nil or AddTimestamp == true
	local EmbedData = {
		description = tostring(LogMessage),
		color = tonumber(Color),
		timestamp = AddTimestamp and os.date("!%Y-%m-%dT%H:%M:%SZ") or nil,
		author = { name = Player.Name },
		footer = { text = "Roblox Stock Bot" },
	}
	self:SendWebSocketMessage("discord_log", { embed = EmbedData })
end

local function JoinLink(id, jobid)
	return string.format("https://speedhubx.vercel.app/?placeId=%s&jobId=%s", id, jobid)
end

function Utils:TablesAreEqual(t1, t2)
	if type(t1) ~= "table" or type(t2) ~= "table" then
		return t1 == t2
	end
	local t1KeyCount = 0
	for _ in pairs(t1) do
		t1KeyCount = t1KeyCount + 1
	end
	local t2KeyCount = 0
	for _ in pairs(t2) do
		t2KeyCount = t2KeyCount + 1
	end
	if t1KeyCount ~= t2KeyCount then
		return false
	end
	for k, v1 in pairs(t1) do
		local v2 = t2[k]
		if type(v1) ~= type(v2) then
			return false
		end
		if type(v1) == "table" then
			if not self:TablesAreEqual(v1, v2) then
				return false
			end
		elseif v1 ~= v2 then
			return false
		end
	end
	return true
end

function Utils.WaitUntilTargetSecond(TargetSec)
	local Sec = os.date("*t").sec
	if Sec == TargetSec then
		return 1
	elseif Sec < TargetSec then
		return TargetSec - Sec
	else
		return 60 - Sec + TargetSec
	end
end

function Utils.WaitUntilCosmetics()
	local TimerLabel = PlayerGui:FindFirstChild("CosmeticShop_UI", true)
		and PlayerGui.CosmeticShop_UI.CosmeticShop.Main.Holder.Header.TimerLabel
	if not TimerLabel then
		return 0
	end
	local Hours, Minutes, Seconds =
		tonumber(TimerLabel.Text:match("(%d+)h")) or 0,
		tonumber(TimerLabel.Text:match("(%d+)m")) or 0,
		tonumber(TimerLabel.Text:match("(%d+)s")) or 0
	return (Hours * 3600) + (Minutes * 60) + Seconds + 10
end

--<editor-fold desc="Stock Getters">
function Utils.GetShopStock(GuiName, ItemList, RarityTable, Category, OrderTable)
	local ShopGui = PlayerGui:WaitForChild(GuiName, 5)
	if not ShopGui then
		warn(string.format("'%s' not found in PlayerGui.", GuiName))
		return LastStock[Category] or {}
	end
	local ScrollingFrame = ShopGui:FindFirstChild("Frame", true)
		and ShopGui.Frame:FindFirstChild("ScrollingFrame", true)
	if not ScrollingFrame then
		warn("ScrollingFrame not found in " .. GuiName)
		return LastStock[Category] or {}
	end
	local CurrentStock = {}
	for _, ItemFrame in ipairs(ScrollingFrame:GetChildren()) do
		if ItemFrame:IsA("Frame") and ItemFrame.Name ~= "ItemPadding" then
			local MainFrame = ItemFrame:FindFirstChild("Main_Frame")
			local StockText = MainFrame and MainFrame:FindFirstChild("Stock_Text")
			local ItemText = MainFrame
				and (
					MainFrame:FindFirstChild("Seed_Text")
					or MainFrame:FindFirstChild("Gear_Text")
					or MainFrame:FindFirstChild("Item_Name_Text")
				)
			if StockText and ItemText then
				local ItemName = ItemText.Text:gsub(" Seed$", "")
				if table.find(ItemList, ItemName) then
					local stock = tonumber(StockText.Text:match("X(%d+) Stock")) or 0
					CurrentStock[ItemName] = {
						Stock = stock,
						Rarity = RarityTable[ItemName] or "Unknown",
						IsAvailable = stock > 0,
						Order = OrderTable[ItemName] or 9999,
					}
				end
			end
		end
	end
	print(string.format("Scraped %d items from %s.", table.getn(CurrentStock), GuiName))
	LastStock[Category] = CurrentStock
	return CurrentStock
end

function Utils.GetCosmeticStock()
	local Items = {}
	local CosmeticShopUI = PlayerGui:FindFirstChild("CosmeticShop_UI", true)
	if not CosmeticShopUI then
		warn("CosmeticShop_UI not found for GetCosmeticStock")
		return Items
	end
	local TopSegment = CosmeticShopUI.CosmeticShop.Main.Holder.Shop.ContentFrame.TopSegment
	local BottomSegment = CosmeticShopUI.CosmeticShop.Main.Holder.Shop.ContentFrame.BottomSegment
	for _, SegmentTable in pairs({ TopSegment, BottomSegment }) do
		for _, Frame in pairs(SegmentTable:GetChildren()) do
			if
				Frame:IsA("Frame") and (CosmeticsItems[tostring(Frame.Name)] or CosmeticsCrates[tostring(Frame.Name)])
			then
				local QuantityText = Frame.Main.Stock.STOCK_TEXT
				if QuantityText then
					local ItemName = (CosmeticsItems[Frame.Name] and CosmeticsItems[Frame.Name].CosmeticName)
						or (CosmeticsCrates[Frame.Name] and CosmeticsCrates[Frame.Name].CrateName)
					Items[#Items + 1] = {
						Name = ItemName,
						Quantity = tonumber(QuantityText.Text:match("X(%d+) Stock")) or 0,
						Price = (CosmeticsItems[Frame.Name] and CosmeticsItems[Frame.Name].Price)
							or (CosmeticsCrates[Frame.Name] and CosmeticsCrates[Frame.Name].Price),
						Order = CosmeticOrder[Frame.Name] or 9999,
					}
				end
			end
		end
	end
	table.sort(Items, function(a, b)
		return (a.Order or 9999) < (b.Order or 9999)
	end)
	print("Fetched " .. #Items .. " cosmetic items from UI.")
	return Items
end
--</editor-fold>

local lastSentStock = {}
local kickCounter = 0
function Utils:SaveStockToDatabase(FullStockData)
	if not FullStockData or next(FullStockData) == nil then
		warn("No stock data to save, skipping.")
		return
	end
	local min = os.date("*t").min
	if self:TablesAreEqual(lastSentStock, FullStockData) and (min % 30 ~= 0) then
		kickCounter = kickCounter + 1
		if kickCounter > 5 then
			self:Abort("Stock data has not changed for " .. kickCounter .. " cycles.")
		else
			local min = os.date("*t").min -- get the minute
			if tonumber(min) % 5 == 0 then
				task.wait(5)
			else
				self:SendDiscordLogMessage(
					"Same stock data received for the " .. kickCounter .. kickCounter == 1 and "st"
						or kickCounter == 2 and "nd"
						or kickCounter == 3 and "rd"
						or "th" .. " time, skipping update",
					true,
					0xFFFF00
				)
				return
			end
		end
		return
	else
		kickCounter = 0
	end
	lastSentStock = FullStockData
	local ItemsToInsert = {}
	local identifier = HttpService:GenerateGUID(false)
	for Category, ItemsInCategory in pairs(FullStockData) do
		local ItemType
		if Category == "Seeds" then
			ItemType = "Seed"
		elseif Category == "Gear" then
			ItemType = "Gear"
		elseif Category == "Eggs" then
			ItemType = "Egg"
		end
		if ItemType then
			for ItemName, ItemData in pairs(ItemsInCategory) do
				table.insert(ItemsToInsert, {
					guild_id = Config.GlobalStockIdentifier,
					item_type = ItemType,
					item_name = ItemName,
					quantity = ItemData.Stock,
					rarity = ItemData.Rarity,
					is_available = ItemData.IsAvailable,
					item_order = ItemData.Order,
					id = identifier,
				})
			end
		end
	end
	if #ItemsToInsert > 0 then
		self:SendWebSocketMessage("save_stock", { items = ItemsToInsert, stock_table = Config.StockTableName })
		self:SendDiscordLogMessage("Sent " .. #ItemsToInsert .. " stock items to database.", true)
	end
end

function Utils:SaveCosmeticToDatabase(CosmeticItemsList)
	local Merchant, MerchantData, MerchantName

	for _, obj in pairs(workspace:GetChildren()) do
		if tostring(obj.Name):find("Traveling Merchant") or tostring(obj.Name) == "SkyTravelingMerchant" then
			Merchant = obj
			MerchantName = obj.Name
			break
		end
	end

	if Merchant then
		MerchantData = Utils.GetShopStock(
			Config.TravelerShopGuiName,
			TravelerTable,
			TravelerRariry,
			"TravelingMerchant",
			TravelerOrder
		)
		print("Merchant found: " .. MerchantName .. ", Stock: " .. HttpService:JSONEncode(MerchantData))
	else
		print("No Traveling Merchant found in workspace.")
		MerchantData = {}
	end

	if CosmeticItemsList and #CosmeticItemsList > 0 or next(MerchantData) ~= nil then
		local success = self:SendWebSocketMessage("save_cosmetic", {
			items = { CosmeticItemsList or {}, MerchantData },
			cosmetic_table = Config.CosmeticTableName,
			merchant_table = Config.TravelerTableName,
			guild_id = Config.GlobalStockIdentifier,
			merchant_name = MerchantName and MerchantName == "SkyTravelingMerchant" and "Sky Traveling Merchant"
				or MerchantName
				or "Traveling Merchant",
		})
		if success then
			self:SendDiscordLogMessage(
				"Sent "
					.. #CosmeticItemsList
					.. " cosmetic items and "
					.. table.getn(MerchantData)
					.. " merchant items to database.",
				true
			)
		else
			self:SendDiscordLogMessage("Failed to send cosmetic/merchant data to database.", true, 0xFF0000)
		end
	else
		print("No cosmetic or merchant items to send.")
		self:SendDiscordLogMessage("No cosmetic or merchant items to send to database.", true, 0xFF8C00)
	end
end

function Utils:SaveWeatherToDatabase(WeatherType, Duration, Announced)
	if not WeatherType then
		return
	end
	if
		self:SendWebSocketMessage("save_weather", {
			id = Config.GlobalWeatherIdentifier,
			weather_type = WeatherType,
			last_updated = os.time(),
			announced = Announced,
			duration = Duration,
			weather_table = Config.WeatherTableName,
		})
	then
		self:SendDiscordLogMessage(string.format("Sent weather: %s for %d seconds.", WeatherType, Duration), true)
		if not TEST_MODE then
			task.spawn(function()
				task.wait(Duration)
				self:SendWebSocketMessage(
					"delete_weather",
					{ id = Config.GlobalWeatherIdentifier, weather_table = Config.WeatherTableName }
				)
			end)
		end
	end
end

function Utils:SendFeedback(FeedbackMessage)
	self:SendWebSocketMessage("lua_feedback", { message = FeedbackMessage })
end

local SentIntervals = {}
local function Main()
	if not TEST_MODE then
		local Success, Result = pcall(function()
			Connection = WebSocket.connect(Config.WebSocketUrl)
		end)
		if not Success or not Connection then
			warn("Failed to connect to WebSocket: " .. tostring(Result or "Unknown"))
			return
		end

		Connection.OnMessage:Connect(function(Msg)
			local SuccessMsg, Decoded = pcall(function()
				return HttpService:JSONDecode(Msg)
			end)
			if not SuccessMsg then
				warn("Invalid JSON from WebSocket: " .. Msg)
				return
			end
			print(
				string.format(
					"WS Server (%s): %s",
					Decoded.type or "?",
					Decoded.message or HttpService:JSONEncode(Decoded.data) or "?"
				)
			)

			if Decoded.type == "force_check" and Decoded.data and Decoded.data.item_type then
				local ItemType = Decoded.data.item_type
				Utils:SendFeedback("Force checking: " .. ItemType)
				if ItemType == "Seed" then
					Utils:SaveStockToDatabase({
						Seeds = Utils.GetShopStock(Config.SeedShopGuiName, SeedItems, CropRarities, "Seeds", SeedOrder),
					})
				elseif ItemType == "Gear" then
					Utils:SaveStockToDatabase({
						Gear = Utils.GetShopStock(Config.GearShopGuiName, GearItems, GearRarities, "Gear", GearOrder),
					})
				elseif ItemType == "Egg" then
					Utils:SaveStockToDatabase({
						Eggs = Utils.GetShopStock(Config.EggShopName, EggItems, EggRarities, "Eggs", EggOrder),
					})
				elseif ItemType == "Cosmetic" then
					Utils:SaveCosmeticToDatabase(Utils.GetCosmeticStock())
				elseif ItemType == "All" then
					Utils:SendFeedback("Force checking ALL types...")
					Utils:SaveStockToDatabase({
						Seeds = Utils.GetShopStock(Config.SeedShopGuiName, SeedItems, CropRarities, "Seeds", SeedOrder),
						Gear = Utils.GetShopStock(Config.GearShopGuiName, GearItems, GearRarities, "Gear", GearOrder),
						Eggs = Utils.GetShopStock(Config.EggShopName, EggItems, EggRarities, "Eggs", EggOrder),
					})
					Utils:SaveCosmeticToDatabase(Utils.GetCosmeticStock())
				end
				Utils:SendFeedback("Force_check for " .. ItemType .. " processed.")
			elseif Decoded.type == "run_lua_payload" and Decoded.data and Decoded.data.script_payload then
				local func, err = loadstring(Decoded.data.script_payload)
				if func then
					pcall(func)
				else
					print("Loadstring error:", err)
				end
			elseif Decoded.type == "rejoin_game" and Decoded.data then
				Utils:SendFeedback("Rejoining game. Job ID: " .. (Decoded.data.job_id or "any"))
				local JobId = Decoded.data.job_id or nil
				if JobId and JobId ~= "" then
					pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, JobId, Player)
				else
					pcall(TeleportService.Teleport, TeleportService, game.PlaceId, Player)
				end
			elseif Decoded.type == "shutdown_game" then
				Utils:Abort("Received shutdown command from server.")
			end
		end)
		Connection.OnClose:Connect(function(Code, Reason)
			warn("WebSocket connection closed. Code: " .. tostring(Code) .. ", Reason: " .. tostring(Reason))
			Connection = nil
		end)
		while not Connection do
			task.wait(1)
		end
		print("WebSocket connection established.")
	else
		print("[TEST_MODE] WebSocket connection skipped.")
	end

	pcall(function()
		Utils:SendDiscordLogMessage(
			string.format(
				"Bot started on a new server.\n- PlaceID: %s\n- JobID: %s\n\nJoin: [click here](<%s>)",
				tostring(game.PlaceId),
				tostring(game.JobId),
				JoinLink(tostring(game.PlaceId), tostring(game.JobId))
			),
			true
		)
	end)
	Utils:SendWebSocketMessage("ensure_tables", {
		stock_table = Config.StockTableName,
		weather_table = Config.WeatherTableName,
		cosmetic_table = Config.CosmeticTableName,
	})

	if _G.MainStockThread then
		task.cancel(_G.MainStockThread)
	end
	if _G.CosmeticThread then
		task.cancel(_G.CosmeticThread)
	end
	if _G.WeatherThread then
		task.cancel(_G.WeatherThread)
	end

	_G.MainStockThread = task.spawn(function()
		while true do
			task.wait(Utils.WaitUntilTargetSecond(Config.TargetCheckSecond))
			local currentTime = os.date("*t")
			local min = currentTime.min
			if min % Config.MainStockCheckMinuteInterval ~= 0 then
				task.wait(1)
				continue
			end
			local key = currentTime.hour * 60 + currentTime.min
			if SentIntervals[key] then
				task.wait(1)
				continue
			end
			SentIntervals[key] = true
			if #SentIntervals > 288 then
				SentIntervals = { [key] = true }
			end
			local stockDataToSend = {
				Seeds = Utils.GetShopStock(Config.SeedShopGuiName, SeedItems, CropRarities, "Seeds", SeedOrder),
				Gear = Utils.GetShopStock(Config.GearShopGuiName, GearItems, GearRarities, "Gear", GearOrder),
				Eggs = Utils.GetShopStock(Config.EggShopName, EggItems, EggRarities, "Eggs", EggOrder),
			}
			Utils:SaveStockToDatabase(stockDataToSend)
		end
	end)

	_G.CosmeticThread = task.spawn(function()
		while true do
			local waitTime = Utils.WaitUntilCosmetics()
			if waitTime > 0 then
				Utils:SendDiscordLogMessage(string.format("Waiting %.2f minutes for cosmetics.", waitTime / 60), true)
				task.wait(waitTime)
			else
				Utils:SendDiscordLogMessage("Cosmetic timer not found, retrying in 60s.", true, 0xFF8C00)
				task.wait(60)
				continue
			end
			task.wait(15)
			if PlayerGui:FindFirstChild("CosmeticShop_UI", true) then
				Utils:SaveCosmeticToDatabase(Utils.GetCosmeticStock())
			end
		end
	end)

	_G.WeatherThread = task.spawn(function()
		local GameEvents = ReplicatedStorage:WaitForChild("GameEvents", 60)
		if not GameEvents then
			warn("GameEvents not found. Weather will not be tracked.")
			return
		end
		GameEvents.WeatherEventStarted.OnClientEvent:Connect(function(EventType, EventDuration)
			EventType = EventType == "Frost" and "Snow" or EventType
			Utils:SaveWeatherToDatabase(EventType, EventDuration, math.floor(os.time()))
		end)
	end)
end

task.wait(2)
Main()
