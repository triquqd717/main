local SEED_ITEMS = {
	"Carrot",
	"Strawberry",
	"Blueberry",
	"Orange Tulip",
	"Tomato",
	"Corn",
	"Daffodil",
	"Watermelon",
	"Pumpkin",
	"Apple",
	"Bamboo",
	"Coconut",
	"Cactus",
	"Dragon Fruit",
	"Mango",
	"Grape",
	"Mushroom",
	"Pepper",
	"Cacao",
	"Beanstalk",
}

local GEAR_ITEMS = {
	"Watering Can",
	"Trowel",
	"Basic Sprinkler",
	"Recall Wrench",
	"Advanced Sprinkler",
	"Godly Sprinkler",
	"Lightning Rod",
	"Master Sprinkler",
	"Favorite Tool",
}

local EGG_ITEMS = {
	"Common Egg",
	"Uncommon Egg",
	"Rare Egg",
	"Exotic Bug Egg",
	"Epic Egg",
	"Legendary Egg",
	"Mythical Egg",
	"Divine Egg",
	"Bug Egg",
}

local CropRarities = {
	Carrot = "Common",
	Strawberry = "Common",
	Blueberry = "Uncommon",
	["Orange Tulip"] = "Uncommon",
	Tomato = "Rare",
	Corn = "Rare",
	Daffodil = "Legendary",
	Watermelon = "Legendary",
	Pumpkin = "Legendary",
	Apple = "Legendary",
	Bamboo = "Legendary",
	Coconut = "Mythical",
	Cactus = "Mythical",
	["Dragon Fruit"] = "Mythical",
	Mango = "Mythical",
	Grape = "Divine",
	Mushroom = "Divine",
	Pepper = "Divine",
	Cacao = "Divine",
	Beanstalk = "Divine",
}

local EggRarities = {
	["Common Egg"] = "Common",
	["Uncommon Egg"] = "Uncommon",
	["Rare Egg"] = "Rare",
	["Epic Egg"] = "Epic",
	["Legendary Egg"] = "Legendary",
	["Bug Egg"] = "Legendary",
	["Mythical Egg"] = "Mythical",
	["Divine Egg"] = "Divine",
	["Exotic Bug Egg"] = "Premium",
}

local GearRarities = {
	["Watering Can"] = "Common",
	["Trowel"] = "Uncommon",
	["Recall Wrench"] = "Uncommon",
	["Basic Sprinkler"] = "Rare",
	["Advanced Sprinkler"] = "Legendary",
	["Godly Sprinkler"] = "Mythical",
	["Lightning Rod"] = "Mythical",
	["Master Sprinkler"] = "Divine",
	["Favorite Tool"] = "Divine",
}

local WEATHER_TYPES = {
	"Rain",
	"Snow",
	"Thunderstorm",
	"Nightfall",
}

local SeedEmojis = {
	Carrot = "🥕",
	Strawberry = "🍓",
	Blueberry = "🫐",
	["Orange Tulip"] = "🌷",
	Tomato = "🍅",
	Corn = "🌽",
	Daffodil = "🌼",
	Watermelon = "🍉",
	Pumpkin = "🎃",
	Apple = "🍎",
	Bamboo = "🎍",
	Coconut = "🥥",
	Cactus = "🌵",
	["Dragon Fruit"] = "🍎",
	Mango = "🥭",
	Grape = "🍇",
	Mushroom = "🍄",
	Pepper = "🌶️",
	Cacao = "🍫",
	Beanstalk = "🌱",
}

local EggEmojis = {
	["Common Egg"] = "🥚",
	["Uncommon Egg"] = "🥚",
	["Rare Egg"] = "🥚",
	["Exotic Bug Egg"] = "🐛",
	["Epic Egg"] = "🥚",
	["Legendary Egg"] = "🥚",
	["Mythical Egg"] = "🥚",
	["Divine Egg"] = "🥚",
	["Bug Egg"] = "🐞",
}

local WeatherEmojis = {
	Rain = "🌧️",
	Snow = "❄️",
	Thunderstorm = "⛈️",
	Nightfall = "🌑",
}

local RarityOrder = {
	Premium = 9,
	Prismatic = 8,
	Divine = 7,
	Mythical = 6,
	Legendary = 5,
	Epic = 4,
	Rare = 3,
	Uncommon = 2,
	Common = 1,
	Gear = 0,
	Unknown = -1,
}

return SEED_ITEMS, GEAR_ITEMS, EGG_ITEMS, CropRarities, EggRarities, GearRarities, WEATHER_TYPES, SeedEmojis, EggEmojis, WeatherEmojis, RarityOrder
