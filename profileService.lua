local profileService = {}
local databaseService = game:GetService("DataStoreService")
local playerService = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local profileDatabases = {}
local profiles = {}
local templates = {}
local sessionData = {}

local CONFIG = {
	serviceName = "PROFILESERVICE"
}

profileService.__index = profileService



function profileService:New(dataStoreName)
	table.insert(profileDatabases, dataStoreName)
	profileDatabases[dataStoreName] = databaseService:GetDataStore(dataStoreName)
end

local function getDatabase(dataStoreName)
	assert(profileDatabases[dataStoreName], string.format("Database is not valid %s", dataStoreName))
	return profileDatabases[dataStoreName]
end

function profileService:newTemplate(datatable, dataStoreName)
	templates[dataStoreName] = datatable
	for _, obj in pairs(templates[dataStoreName]) do
		print(obj)
	end
end

function profileService:LoadData(player, dataStoreName)
	local dataStore = getDatabase(dataStoreName)
	local data = dataStore:GetAsync(player.UserId)
	if not data then
		if templates[dataStoreName] then
			profiles[player.UserId] = templates[dataStoreName]
			dataStore:SetAsync(player.UserId, profiles[player.UserId])
			print("[" .. CONFIG.serviceName .. "]: Created Data")
		end
	else
		print("[" .. CONFIG.serviceName .. "]: Sucessfully loaded data!")
		profiles[player.UserId] = data
	end
end

function profileService: Save(player, databaseName)
	local database = getDatabase(databaseName)
	assert(profiles[player.UserId], string.format("Profile does not exist %s", player.UserId))
	for _, obj in pairs(profiles[player.UserId]) do
		database:SetAsync(player.UserId,profiles[player.UserId])
		print("[" .. CONFIG.serviceName .. "]:" .. obj)
	end
end

function profileService: Update(player, value, callback)
	assert(profiles[player.UserId][value], string.format("Profile value does not exist %s", player.UserId .. ", value: " .. value))
	local newData = callback(profiles[player.UserId][value])
	profiles[player.UserId][value] = newData

	return newData
end

function profileService:Removing(player)
	if player.Character then
		player:Kick("[" .. CONFIG.serviceName .. "]: (PLAYER KICK), PLAYER NOT REMOVED")
	end
end



return profileService
