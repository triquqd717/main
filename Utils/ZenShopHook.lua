local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventShopUIController = require(ReplicatedStorage.Modules.EventShopUIController)
local DataService = require(ReplicatedStorage.Modules.DataService)
local EventShopData = require(ReplicatedStorage.Data.EventShopData)

local OriginalGetData = DataService.GetData

local function HookedGetData(self, ...)
    local PlayerData = OriginalGetData(self, ...)

    if PlayerData and PlayerData.EventShopStock then
        if not PlayerData.EventShopStock.UnlockedShopItems then
            PlayerData.EventShopStock.UnlockedShopItems = {}
        end

        for ItemName, ItemData in pairs(EventShopData) do
            if ItemData.DisplayInShop then
                if not table.find(PlayerData.EventShopStock.UnlockedShopItems, ItemName) then
                    table.insert(PlayerData.EventShopStock.UnlockedShopItems, ItemName)
                end
            end
        end
    end

    return PlayerData
end

hookfunction(EventShopUIController.Start, function(self, ...)
    DataService.GetData = HookedGetData

    local Success, Result = pcall(self.Start, self, ...)

    DataService.GetData = OriginalGetData
    
    if not Success then
        warn("EventShopUIController.Start errored:", Result)
    end

    return Result
end)
