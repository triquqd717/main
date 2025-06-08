if not game:IsLoaded() then
	game.Loaded:Wait()
	task.wait(5)
end

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local LogService = game:GetService("LogService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Event = "Honey"
local WebSocketUrl = "ws://localhost:3000"
local GlobalStockIdentifier = "global_stock"
local GlobalWeatherIdentifier = 1
local TargetCheckSecond = 7
local TargetCheckMinute = 0
local StockTableName = "stock_data"
local WeatherTableName = "weather_status"
local CosmeticTableName = "cosmetic_data"
local HoneyShopTableName = "honey_shop_data"

local SeedShop = "Seed_Shop"
local GearShop = "Gear_Shop"
local HoneyShop = "HoneyEventShop_UI"

local SeedData = require(ReplicatedStorage.Data.SeedData)
local GearData = require(ReplicatedStorage.Data.GearData)
local PetEggData = require(ReplicatedStorage.Data.PetEggData)
local HoneyEventData = require(ReplicatedStorage.Data.HoneyEventShopData)

local SeedItems = {}
local CropRarities = {}
local SeedOrder = {}
local seedKeys = {}
for SeedName in pairs(SeedData) do
	table.insert(seedKeys, SeedName)
end
table.sort(seedKeys, function(a, b)
	return (SeedData[a].LayoutOrder or 9999) < (SeedData[b].LayoutOrder or 9999)
end)
local p = 1
for i, SeedName in pairs(seedKeys) do
	local Data = SeedData[SeedName]
	if Data.DisplayInShop then
		table.insert(SeedItems, SeedName)
		CropRarities[SeedName] = Data.SeedRarity or "Unknown"
		SeedOrder[SeedName] = Data.LayoutOrder or p
		p = p + 1
	end
end

local GearItems = {}
local GearRarities = {}
local GearOrder = {}
local gearKeys = {}
for GearName in pairs(GearData) do
	table.insert(gearKeys, GearName)
end
table.sort(gearKeys, function(a, b)
	return (GearData[a].LayoutOrder or 99099) < (GearData[b].LayoutOrder or 9999)
end)
for i, GearName in pairs(gearKeys) do
	local Data = GearData[GearName]
	if Data.DisplayInShop then
		table.insert(GearItems, GearName)
		GearRarities[GearName] = Data.GearRarity or "Unknown"
		GearOrder[GearName] = Data.LayoutOrder or p
		p = p + 1
	end
end

local EggItems = {}
local EggRarities = {}
local EggOrder = {}
local eggKeys = {}
for EggName in pairs(PetEggData) do
	table.insert(eggKeys, EggName)
end
table.sort(eggKeys, function(a, b)
	return (PetEggData[a].LayoutOrder or 9999) < (PetEggData[b].LayoutOrder or 9999)
end)
for i, EggName in pairs(eggKeys) do
	local Data = PetEggData[EggName]
	table.insert(EggItems, EggName)
	EggRarities[EggName] = Data.EggRarity or "Unknown"
	EggOrder[EggName] = Data.LayoutOrder or p
	p = p + 1
end

local HoneyItems = {}
local HoneyRarities = {}
local HoneyOrder = {}
local HoneyKeys = {}

for HoneyName in pairs(HoneyEventData) do
	table.insert(HoneyKeys, HoneyName)
end
table.sort(HoneyKeys, function(a, b)
	return (HoneyEventData[a].LayoutOrder or 9999) < (HoneyEventData[b].LayoutOrder or 9999)
end)

for i, HoneyName in pairs(HoneyKeys) do
	local Data = HoneyEventData[HoneyName]
	if Data.DisplayInShop then
		table.insert(HoneyItems, HoneyName)
		HoneyRarities[HoneyName] = Data.SeedRarity or "Unknown"
		HoneyOrder[HoneyName] = Data.LayoutOrder or p
		p = p + 1
	end
end

local CosmeticsItems
local CosmeticsCrates
local CosmeticOrder = {}
local CosmeticKeys = {}
local CosmeticIndex = 1
do
	local Success, Result = pcall(function()
		return require(ReplicatedStorage.Data.CosmeticItemShopData)
	end)
	if not Success then
		warn("Could not fetch cosmetics data: " .. tostring(Result))
		CosmeticsItems = {}
	else
		CosmeticsItems = Result
		for CosmeticName in pairs(CosmeticsItems) do
			table.insert(CosmeticKeys, CosmeticName)
		end
		table.sort(CosmeticKeys, function(a, b)
			return (CosmeticsItems[a].Price or 999999999) < (CosmeticsItems[b].Price or 999999999)
		end)
		for _, CosmeticName in pairs(CosmeticKeys) do
			CosmeticOrder[CosmeticName] = CosmeticsItems[CosmeticName].Price or CosmeticIndex
			CosmeticIndex = CosmeticIndex + 1
		end
	end

	local Success, Result = pcall(function()
		return require(ReplicatedStorage.Data.CosmeticCrateShopData)
	end)
	if not Success then
		warn("Could not fetch cosmetics crates: " .. tostring(Result))
		CosmeticsCrates = {}
	else
		CosmeticsCrates = Result
		for CrateName in pairs(CosmeticsCrates) do
			table.insert(CosmeticKeys, CrateName)
		end
		table.sort(CosmeticKeys, function(a, b)
			local priceA = CosmeticsItems[a] and CosmeticsItems[a].Price
				or CosmeticsCrates[a] and CosmeticsCrates[a].Price
				or 999999999
			local priceB = CosmeticsItems[b] and CosmeticsItems[b].Price
				or CosmeticsCrates[b] and CosmeticsCrates[b].Price
				or 999999999
			return priceA < priceB
		end)
		for _, CrateName in pairs(CosmeticKeys) do
			if CosmeticsCrates[CrateName] then
				CosmeticOrder[CrateName] = CosmeticsCrates[CrateName].Price or CosmeticIndex
				CosmeticIndex = CosmeticIndex + 1
			end
		end
	end
end

local totalItems = #SeedItems
	+ #GearItems
	+ #EggItems
	+ #HoneyItems
	+ (CosmeticsItems and table.getn(CosmeticsItems) or 0)
	+ (CosmeticsCrates and table.getn(CosmeticsCrates) or 0)
print("Total Items: " .. totalItems)
print("Seed Items: " .. #SeedItems)
print("Gear Items: " .. #GearItems)
print("Egg Items: " .. #EggItems)
print("Honey Items: " .. #HoneyItems)
print("Cosmetic Items: " .. (CosmeticsItems and table.getn(CosmeticsItems) or 0))
print("Cosmetic Crates: " .. (CosmeticsCrates and table.getn(CosmeticsCrates) or 0))

local LastStock = { Seeds = {}, Gear = {}, Eggs = {}, Honey = {} }

local Connection = nil
WebSocket = typeof(WebSocket) == "table" and WebSocket or nil -- usually is an option on good executors

local deb = false

if not WebSocket then
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

LogService.MessageOut:Connect(function(Message, Type)
	if Connection ~= nil then
		if not deb then
			if Type == Enum.MessageType.MessageError then
				Utils:SendDiscordLogMessage("Client Error: " .. Message, true, true, 0xE8101B)
			elseif Type == Enum.MessageType.MessageWarning then
				Utils:SendDiscordLogMessage("Client Warning: " .. Message, true, true, 0xFFA500)
			else
				return
			end
			deb = true
			task.spawn(function()
				task.wait(3)
				deb = false
			end)
		end
	end
end)

function Utils:SendWebSocketMessage(MessageType, MessageData)
	if not Connection then
		warn("WebSocket not connected or connection object invalid, cannot send message.")
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
	self:SendDiscordLogMessage("Bot hanged himself: " .. log)
	while true do
	end
	game:Shutdown()
end

function Utils:SendDiscordLogMessage(LogMessage, AddTimestamp, IncludeAvatarThumbnail, Color)
	Color = Color or tonumber("0x00FF00")
	if AddTimestamp == nil then
		AddTimestamp = false
	end
	if IncludeAvatarThumbnail == nil then
		IncludeAvatarThumbnail = false
	end
	local AvatarUrl = nil

	if IncludeAvatarThumbnail then
		local PcallSuccess, FetchedAvatarUrlOrError = pcall(function()
			local RequestUrl = string.format(
				"https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%d&size=420x420&format=Png&isCircular=false",
				Player.UserId
			)

			local ResponseData = request({
				Url = RequestUrl,
				Method = "GET",
			})

			if ResponseData and ResponseData.StatusCode == 200 and ResponseData.Body then
				local DecodedJson = HttpService:JSONDecode(ResponseData.Body)
				if
					DecodedJson
					and DecodedJson.data
					and #DecodedJson.data > 0
					and DecodedJson.data[1]
					and DecodedJson.data[1].imageUrl
				then
					return DecodedJson.data[1].imageUrl
				else
					warn(
						"Failed to parse avatar JSON or find imageUrl from 'request' response. Response body: "
							.. (ResponseData.Body or "N/A")
					)
					return nil
				end
			else
				warn(
					string.format(
						"'request' to fetch avatar failed. Status Code: %s. Response Body: %s",
						tostring(ResponseData and ResponseData.StatusCode),
						tostring(ResponseData and ResponseData.Body)
					)
				)
				return nil
			end
		end)

		if PcallSuccess and FetchedAvatarUrlOrError then
			AvatarUrl = FetchedAvatarUrlOrError
		else
			warn(
				"Error during avatar fetch using 'request' or processing its response: "
					.. tostring(FetchedAvatarUrlOrError)
			)
		end
	end

	local EmbedData = {
		description = LogMessage,
		color = tonumber(Color),
		timestamp = (AddTimestamp or AddTimestamp == nil) and os.date("!%Y-%m-%dT%H:%M:%SZ") or nil,
		author = {
			name = Player.Name,
			icon_url = AvatarUrl,
		},
		footer = {
			text = "Roblox Stock Bot",
		},
	}
	local SendSuccess, SendError = self:SendWebSocketMessage("discord_log", { embed = EmbedData })
	if not SendSuccess then
		warn("Failed to send embed log message to bot via WebSocket: " .. tostring(SendError))
	end
end

local function JoinLink(id, jobid)
	return string.format("https://speedhubx.vercel.app/?placeId=%s&jobId=%s", id, jobid)
end

function Utils:TablesAreEqual(t1, t2)
	if type(t1) ~= type(t2) then
		return false
	end
	if type(t1) ~= "table" then
		return t1 == t2
	end
	if t1 == t2 then
		return true
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

		if type(v1) == "table" then
			if type(v2) == "table" then
				if not self:TablesAreEqual(v1, v2) then
					return false
				end
			else
				return false
			end
		elseif v1 ~= v2 then
			return false
		end
	end
	return true
end

function Utils.WaitUntilTargetSecond(TargetSec)
	local CurrentTime = os.date("*t")
	local Sec = CurrentTime.sec
	if Sec == TargetSec then
		return 1
	elseif Sec < TargetSec then
		return TargetSec - Sec
	else
		return 60 - Sec + TargetSec
	end
end

function Utils.WaitUntilNextHour(TargetMinute, TargetSecond)
	local Now = os.date("*t")
	local SecondsToWait

	if Now.min < TargetMinute or (Now.min == TargetMinute and Now.sec < TargetSecond) then
		SecondsToWait = (TargetMinute - Now.min) * 60 + (TargetSecond - Now.sec)
	else
		SecondsToWait = (59 - Now.min) * 60 + (60 - Now.sec)
		SecondsToWait = SecondsToWait + (TargetMinute * 60) + TargetSecond
	end

	if SecondsToWait <= 0 then
		if SecondsToWait < 0 then
			SecondsToWait = 1
		end
	end

	local TargetHourCalculated = (Now.hour + math.floor((Now.min * 60 + Now.sec + SecondsToWait) / 3600)) % 24
	print(
		string.format(
			"Waiting for %d seconds (approx %.2f min) until next ~%02d:%02d:%02d for Bee Stock check.",
			SecondsToWait,
			SecondsToWait / 60,
			TargetHourCalculated,
			TargetMinute,
			TargetSecond
		)
	)
	return SecondsToWait
end

function Utils.WaitUntilCosmetics()
	local TimerLabel = PlayerGui:FindFirstChild("CosmeticShop_UI", true)
		and PlayerGui.CosmeticShop_UI.CosmeticShop.Main.Holder.Header.TimerLabel
	if not TimerLabel then
		warn("Cosmetic TimerLabel not found!")
		return 0
	end
	local Text = TimerLabel.Text
	local Hours, Minutes, Seconds = 0, 0, 0
	local HourStr, MinuteStr, SecondStr = Text:match("(%d+)h"), Text:match("(%d+)m"), Text:match("(%d+)s")
	if HourStr then
		Hours = tonumber(HourStr) or 0
	end
	if MinuteStr then
		Minutes = tonumber(MinuteStr) or 0
	end
	if SecondStr then
		Seconds = tonumber(SecondStr) or 0
	end
	local TotalSeconds = (Hours * 3600) + (Minutes * 60) + Seconds
	return TotalSeconds + 10
end

function Utils.GetShopStock(GuiName, ItemList, RarityTable, Category, OrderTable)
	local ShopGui = PlayerGui:WaitForChild(GuiName, 5)
	if not ShopGui then
		warn(string.format("%s not found in PlayerGui. Open the shop UI and try again.", GuiName))
		return LastStock[Category] or {}
	end
	local ScrollingFrame = ShopGui:FindFirstChild("Frame", true)
		and ShopGui.Frame:FindFirstChild("ScrollingFrame", true)
	if not ScrollingFrame then
		warn("ScrollingFrame not found in " .. GuiName .. ".Frame")
		return LastStock[Category] or {}
	end

	local CurrentStock = {}
	for _, ItemFrame in pairs(ScrollingFrame:GetChildren()) do
		if ItemFrame:IsA("Frame") and ItemFrame.Name ~= "ItemPadding" then
			local MainFrame = ItemFrame:FindFirstChild("Main_Frame")
			if MainFrame then
				local StockText = MainFrame:FindFirstChild("Stock_Text")
				local ItemText = MainFrame:FindFirstChild("Seed_Text")
					or MainFrame:FindFirstChild("Gear_Text")
					or MainFrame:FindFirstChild("Item_Name_Text")
				if StockText and ItemText then
					local ItemName = ItemText.Text
					if ItemName:find(" Seed") and not ItemName:find(" Seed ") then
						ItemName = ItemName:gsub(" Seed", "")
					end
					if table.find(ItemList, ItemName) then
						local StockCount = tonumber(StockText.Text:match("X(%d+) Stock")) or 0
						local RarityValue = RarityTable[ItemName] or "Unknown"
						CurrentStock[ItemName] = {
							Stock = StockCount,
							Rarity = RarityValue,
							IsAvailable = StockCount > 0,
							Order = OrderTable[ItemName] or 9999,
						}
					end
				end
			end
		end
	end
	print(string.format("Current %s Stock:", GuiName))
	for _, ItemName in pairs(ItemList) do
		local Data = CurrentStock[ItemName]
		if Data then
			local LastData = LastStock[Category] and LastStock[Category][ItemName]
			if not LastData or LastData.Stock ~= Data.Stock then
				print(string.format("%s (%s): %d in stock, Order: %d", ItemName, Data.Rarity, Data.Stock, Data.Order))
			end
		end
	end
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
					local ItemName = CosmeticsItems[Frame.Name] and CosmeticsItems[Frame.Name].CosmeticName
						or CosmeticsCrates[Frame.Name] and CosmeticsCrates[Frame.Name].CrateName
					Items[#Items + 1] = {
						Name = ItemName,
						Quantity = tonumber(QuantityText.Text:match("X(%d+) Stock")) or 0,
						Price = CosmeticsItems[Frame.Name] and CosmeticsItems[Frame.Name].Price
							or CosmeticsCrates[Frame.Name] and CosmeticsCrates[Frame.Name].Price,
						Order = CosmeticOrder[Frame.Name] or 9999,
					}
				else
					warn("Quantity text not found for cosmetic item: " .. Frame.Name)
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

function Utils.GetEggStock()
	local Path = workspace:FindFirstChild("NPCS", true)
		and workspace.NPCS:FindFirstChild("Pet Stand", true)
		and workspace.NPCS["Pet Stand"]:FindFirstChild("EggLocations", true)
	if not Path then
		warn("EggLocations path not found for GetEggStock")
		return LastStock.Eggs or {}
	end

	local CurrentStock = {}
	for _, EggLocation in pairs(Path:GetChildren()) do
		if EggLocation:IsA("Model") and table.find(EggItems, EggLocation.Name) then
			CurrentStock[EggLocation.Name] = {
				Stock = (CurrentStock[EggLocation.Name] and CurrentStock[EggLocation.Name].Stock or 0) + 1,
				Rarity = EggRarities[EggLocation.Name] or "Unknown",
				IsAvailable = true,
				Order = EggOrder[EggLocation.Name] or 9999,
			}
		end
	end
	print("Current Pet Stand Egg Stock:")
	for _, EggName in pairs(EggItems) do
		local Data = CurrentStock[EggName]
		if Data then
			local LastData = LastStock.Eggs and LastStock.Eggs[EggName]
			if not LastData or LastData.Stock ~= Data.Stock then
				print(string.format("%s (%s): %d in stock, Order: %d", EggName, Data.Rarity, Data.Stock, Data.Order))
			end
		end
	end
	LastStock.Eggs = CurrentStock
	return CurrentStock
end

function Utils:SaveStockToDatabase(FullStockData)
	local ItemsToInsert = {}
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
			local identifier = HttpService:GenerateGUID(false)
			for ItemName, ItemData in pairs(ItemsInCategory) do
				table.insert(ItemsToInsert, {
					guild_id = GlobalStockIdentifier,
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
		self:SendWebSocketMessage("save_stock", { items = ItemsToInsert, stock_table = StockTableName })
		self:SendDiscordLogMessage(
			"Sent " .. #ItemsToInsert .. " stock items (Seeds/Gear/Eggs) to database.",
			true,
			true
		)
	else
		print("No stock items (Seeds/Gear/Eggs) to send to database.")
	end
end

function Utils:SaveHoneyToDatabase(HoneyItemList)
	if HoneyItemList and next(HoneyItemList) ~= nil then
		local HoneyItemsToSend = {}
		for ItemName, ItemData in pairs(HoneyItemList) do
			table.insert(HoneyItemsToSend, {
				guild_id = GlobalStockIdentifier,
				item_name = ItemName,
				quantity = ItemData.Stock or 0,
				rarity = ItemData.Rarity,
				is_available = ItemData.IsAvailable,
				item_type = "Honey",
				item_order = ItemData.Order,
			})
		end
		if
			self:SendWebSocketMessage(
				"save_honey",
				{ items = HoneyItemsToSend, honey_table = HoneyShopTableName, guild_id = GlobalStockIdentifier }
			)
		then
			local count = 0
			for _, _ in pairs(HoneyItemList) do
				count = count + 1
			end
			self:SendDiscordLogMessage("Sent " .. count .. " honey items to database.", true, true)
			print("Successfully sent " .. count .. " honey items to WebSocket.")
		else
			warn("Failed to send honey items to database via WebSocket.")
		end
	else
		print("No honey items to send to database, or HoneyItemList table was nil/empty.")
	end
end

function Utils:SaveCosmeticToDatabase(CosmeticItemsList)
	if CosmeticItemsList and #CosmeticItemsList > 0 then
		if
			self:SendWebSocketMessage("save_cosmetic", {
				items = CosmeticItemsList,
				cosmetic_table = CosmeticTableName,
				guild_id = GlobalStockIdentifier,
			})
		then
			self:SendDiscordLogMessage("Sent " .. #CosmeticItemsList .. " cosmetic items to database.", true, true)
			print("Successfully sent " .. #CosmeticItemsList .. " cosmetic items to WebSocket.")
		else
			warn("Failed to send cosmetic items to database via WebSocket.")
		end
	else
		print("No cosmetic items to send to database, or CosmeticItemsList table was nil/empty.")
	end
end

function Utils:SaveWeatherToDatabase(WeatherType, Duration)
	if not WeatherType then
		print("No weather detected, skipping database save.")
		return
	end
	local Timestamp = os.time()
	if
		self:SendWebSocketMessage("save_weather", {
			id = GlobalWeatherIdentifier,
			weather_type = WeatherType,
			last_updated = Timestamp,
			weather_table = WeatherTableName,
		})
	then
		self:SendDiscordLogMessage(
			"Sent weather event: " .. WeatherType .. " for " .. Duration .. " seconds.",
			true,
			true
		)
		task.spawn(function()
			task.wait(Duration)
			self:SendWebSocketMessage(
				"delete_weather",
				{ id = GlobalWeatherIdentifier, weather_table = WeatherTableName }
			)
		end)
	end
end

function Utils:SendFeedback(FeedbackMessage)
	self:SendWebSocketMessage("lua_feedback", { message = FeedbackMessage })
end

local SentTable = {}
local function Main()
	local Success, Result = pcall(function()
		Connection = WebSocket.connect(WebSocketUrl)
	end)
	if not Success or not Connection then
		warn("Failed to connect to WebSocket: " .. tostring(Result or "Unknown error"))
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
				Decoded.type or "N/A",
				Decoded.message or HttpService:JSONEncode(Decoded.data) or "N/A"
			)
		)

		if Decoded.type == "force_check" and Decoded.data and Decoded.data.item_type then
			local ItemTypeToForce = Decoded.data.item_type
			Utils:SendFeedback("Received force_check for: " .. ItemTypeToForce)
			print("Received force_check for type:", ItemTypeToForce)
			if ItemTypeToForce == "Seed" then
				Utils:SaveStockToDatabase({
					Seeds = Utils.GetShopStock(SeedShop, SeedItems, CropRarities, "Seeds", SeedOrder),
				})
			elseif ItemTypeToForce == "Gear" then
				Utils:SaveStockToDatabase({
					Gear = Utils.GetShopStock(GearShop, GearItems, GearRarities, "Gear", GearOrder),
				})
			elseif ItemTypeToForce == "Egg" then
				Utils:SaveStockToDatabase({ Eggs = Utils.GetEggStock() })
			elseif ItemTypeToForce == "Honey" then
				Utils:SaveHoneyToDatabase(Utils.GetShopStock(HoneyShop, HoneyItems, HoneyRarities, "Honey", HoneyOrder))
			elseif ItemTypeToForce == "Cosmetic" then
				Utils:SaveCosmeticToDatabase(Utils.GetCosmeticStock())
			elseif ItemTypeToForce == "All" then
				Utils:SendFeedback("Force checking ALL types...")
				Utils:SaveStockToDatabase({
					Seeds = Utils.GetShopStock(SeedShop, SeedItems, CropRarities, "Seeds", SeedOrder),
					Gear = Utils.GetShopStock(GearShop, GearItems, GearRarities, "Gear", GearOrder),
					Eggs = Utils.GetEggStock(),
				})
				Utils:SaveHoneyToDatabase(Utils.GetShopStock(HoneyShop, HoneyItems, HoneyRarities, "Honey", HoneyOrder))
				Utils:SaveCosmeticToDatabase(Utils.GetCosmeticStock())
			else
				warn("Unknown item_type for force_check:", ItemTypeToForce)
				Utils:SendFeedback("Unknown item_type for force_check: " .. ItemTypeToForce)
			end
			Utils:SendFeedback("Force_check for " .. ItemTypeToForce .. " processed.")
		elseif Decoded.type == "run_lua_payload" then
			if Decoded.data and Decoded.data.script_payload then
				local payloadString = Decoded.data.script_payload
				print("Received script_payload from server:", payloadString)
				local func, err = loadstring(payloadString)
				if func then
					local success, resultOrError = pcall(func)
					if success then
						print("Successfully executed payload. Result (if any):", resultOrError)
					else
						print("Error during pcall of loaded payload:", resultOrError)
					end
				else
					print("Error loading string from payload:", err)
				end
			end
		elseif Decoded.type == "rejoin_game" and Decoded.data then
			local JobId = Decoded.data.job_id
			print("Received rejoin_game command. Job ID:", JobId or "any")
			Utils:SendFeedback("Rejoin command received. Job ID: " .. (JobId or "any"))
			pcall(function()
				if JobId and JobId ~= "" then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, JobId, Player)
				else
					TeleportService:Teleport(game.PlaceId, Player)
				end
			end)
		elseif Decoded.type == "shutdown_game" then
			print("Received shutdown_game command.")
			Utils:SendFeedback("Shutdown command received. Shutting down.")
			task.wait(0.5)
			pcall(function()
				game:Shutdown()
			end)
		end
	end)

	Connection.OnClose:Connect(function(Code, Reason)
		warn("WebSocket connection closed. Code: " .. tostring(Code) .. ", Reason: " .. tostring(Reason))
		Connection = nil
	end)

	while not Connection do
		task.wait(1)
		print("Waiting for WebSocket connection to establish...")
	end
	print("WebSocket connection established.")
	pcall(function()
		Utils:SendDiscordLogMessage(
			"Bot successfully started on a new server.\n\n"
				.. string.format(
					"Server info:\n- Game Name: %s\n- PlaceID: %s\n- JobID: %s\n\nJoin game: [click here](<%s>)",
					game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
					tostring(game.PlaceId),
					tostring(game.JobId),
					JoinLink(tostring(game.PlaceId), tostring(game.JobId))
				),
			true,
			true
		)
	end)

	Utils:SendWebSocketMessage("ensure_tables", {
		stock_table = StockTableName,
		weather_table = WeatherTableName,
		cosmetic_table = CosmeticTableName,
		honey_table = HoneyShopTableName,
	})

	if _G.CombinedThread and typeof(_G.CombinedThread) == "thread" then
		task.cancel(_G.CombinedThread)
		_G.CombinedThread = nil
		print("Cancelled previous combined thread")
	end
	if _G.WeatherThread and typeof(_G.WeatherThread) == "thread" then
		task.cancel(_G.WeatherThread)
		_G.WeatherThread = nil
		print("Cancelled previous weather thread")
	end
	if _G.CosmeticThread and typeof(_G.CosmeticThread) == "thread" then
		task.cancel(_G.CosmeticThread)
		_G.CosmeticThread = nil
		print("Cancelled previous cosmetic thread")
	end

	_G.CombinedThread = task.spawn(function()
		while Connection do
			task.wait(Utils.WaitUntilTargetSecond(TargetCheckSecond))
			local CurrentTime = os.date("*t")
			local CurrentMin = CurrentTime.min
			if CurrentMin % 5 ~= 0 then
				task.wait(1)
				continue
			end

			local Key = os.time()
			if SentTable[Key] then
				print("Stock check for interval " .. Key .. " already sent, skipping.")
				task.wait(1)
				continue
			end
			SentTable[Key] = true
			if #SentTable > 288 then
				SentTable = {}
				SentTable[Key] = true
			end

			Utils:SendDiscordLogMessage("Executing stock check for interval: " .. Key, true, true)
			local FullStockData = {
				Seeds = Utils.GetShopStock(SeedShop, SeedItems, CropRarities, "Seeds", SeedOrder),
				Gear = Utils.GetShopStock(GearShop, GearItems, GearRarities, "Gear", GearOrder),
				Eggs = Utils.GetEggStock(),
			}
			Utils:SaveStockToDatabase(FullStockData)
		end
	end)

	_G.CosmeticThread = task.spawn(function()
		while Connection do
			local WaitTime = Utils.WaitUntilCosmetics()
			if WaitTime > 0 then
				print("Waiting " .. WaitTime .. " seconds for cosmetic shop reset.")
				task.wait(WaitTime)
			else
				warn("Could not determine cosmetic shop reset time, retrying in 60 seconds.")
				task.wait(60)
				continue
			end
			local CosmeticShopUI = PlayerGui:FindFirstChild("CosmeticShop_UI", true)
			if CosmeticShopUI then
				Utils:SendDiscordLogMessage("Executing cosmetic stock check after reset.", true, true)
				local CosmeticStockData = Utils.GetCosmeticStock()
				Utils:SaveCosmeticToDatabase(CosmeticStockData)
			else
				warn("CosmeticShop_UI not found, Skipping cosmetic stock check.")
				task.wait(60)
			end
		end
	end)

	_G.HoneyThread = task.spawn(function()
		while Connection do
			local key = os.time()
			if SentTable[key] then
				task.wait(1)
				continue
			end

			local WaitTime = Utils.WaitUntilTargetSecond(TargetCheckSecond)
			if WaitTime > 0 then
				task.wait(WaitTime)
			else
				task.wait(5)
				continue
			end

			local time = os.date("*t")
			local min = time.min
			if min ~= 30 and min ~= 0 then
				task.wait()
				continue
			end
			SentTable[key] = true

			local HoneyItemsToSend = Utils.GetShopStock(HoneyShop, HoneyItems, HoneyRarities, "Honey", HoneyOrder)
			local count = 0
			for _, _ in pairs(HoneyItemsToSend) do
				count = count + 1
			end
			if count > 0 then
				Utils:SaveHoneyToDatabase(HoneyItemsToSend)
			else
				print("No Honey items to send for the hourly check.")
			end

			task.wait(10)
		end
	end)

	_G.WeatherThread = task.spawn(function()
		local GameEvents = ReplicatedStorage:WaitForChild("GameEvents", 60)
		if not GameEvents then
			warn("GameEvents not found in ReplicatedStorage. Weather events won't be tracked.")
			return
		end

		GameEvents.WeatherEventStarted.OnClientEvent:Connect(function(EventType, EventDuration)
			EventType = EventType == "Frost" and "Snow" or EventType
			print(string.format("Weather event: %s for %d seconds", EventType, EventDuration))
			Utils:SaveWeatherToDatabase(EventType, EventDuration)
		end)
	end)
end

task.wait(2)
Main()
