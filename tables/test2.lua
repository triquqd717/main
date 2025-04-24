return {
  Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/triquqd717/main/refs/heads/main/tables/testttt.lua"))(),
  UserIdOnly = false,
  AllowedUserIds = {
    ["12345"] = true,
    ["123456"] = true,
    ["1234567"] = true,
  },
  SendOptions = {
    CropStock = true,
    GearStock = true,
    EasterStock = true,
    Weather = true,
  },
  FixedSendDelay = false,
  SendDelay = 300,
}
