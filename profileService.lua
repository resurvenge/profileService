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
	if not playerService:IsAncestorOf(player) then
		   player:Kick("[" .. CONFIG.serviceName .. "]: playerService is not an ancestor of " .. player.UserId .. ", " .. player.Name)
	elseif not data then
			if templates[dataStoreName] then
				profiles[player.UserId] = templates[dataStoreName]
				dataStore:SetAsync(player.UserId, profiles[player.UserId])
				print("[" .. CONFIG.serviceName .. "]: Created Data")
			end
		else
			print("[" .. CONFIG.serviceName .. "]: Sucessfully loaded data!")
			profiles[player.UserId] = data
			print("[" .. CONFIG.serviceName .. "]: TABLE")
			print(profiles[player.UserId])
	  end
end

function profileService: Save(player, databaseName)
	local database = getDatabase(databaseName)
	assert(profiles[player.UserId], string.format("Profile does not exist %s", player.UserId))
	for _, obj in pairs(profiles[player.UserId]) do
		database:SetAsync(player.UserId,profiles[player.UserId])
		print("[" .. CONFIG.serviceName "]: "  .. _ .. obj)
		print(profiles[player.UserId])
	end
end

function profileService: Update(player, value, callback)
	assert(profiles[player.UserId][value], string.format("Profile value does not exist %s", player.UserId .. ", value: " .. value))
	local newData = callback(profiles[player.UserId][value])
	profiles[player.UserId][value] = newData

	return newData
end

function profileService: Get(player, value)
	assert(profiles[player.UserId][value], string.format("Profile value does not exist %s", player.UserId .. ", value: " .. value))
	return profiles[player.UserId][value]
end

function profileService: saveAllPlayers(databaseName)
	for _, player in pairs(playerService:GetPlayers()) do
		  assert(profiles[player.UserId], string.format("Profile does not exist %s", player.UserId))
		  profileService: Save(player, databaseName)
	end
end

function profileService: autoSave(databaseName, interval)
	while true do
		   self:saveAllPlayers(databaseName)
		   print("[" .. CONFIG.serviceName .. "]: ")
		   task.wait(interval)
	end
end


function profileService :__ProfileRemove(player)
	 profiles[player.UserId] = nil
end

function profileService: Removing(player)
	if player.Character then
		player:Kick("[PROFILESERVICE]: (PLAYER KICK), PLAYER NOT REMOVED")
	end
	self:__ProfileRemove(player)
end


return profileService
