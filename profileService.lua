local Store = {
}

Store.__index = Store


local signals = require(script:WaitForChild("SignalService"))

local dataStoreService = game:GetService("DataStoreService")
local players = game:GetService("Players")
local runService = game:GetService("RunService")

Store.Sessions = {}


 function Store:storeName(studioStore, liveStore)
	  if runService:IsStudio() then
			 return studioStore
	  else
			return liveStore
	  end
 end



function Store.new(Name, template) 
	  local Instance = setmetatable({}, Store)
	  Instance.dataStoreName = Name
	  Instance.dataStore =  dataStoreService:GetDataStore(Instance.dataStoreName)
	  Instance.profile = {}
	  Instance.template = template
	  Instance.data = {}
	  Instance.Parent = Store
	  
	 return Instance
end


function Store:getDataStore() 
	 assert(self.dataStore, string.format("DataStore does not exist %s", self.dataStoreName))
	 return self.dataStore
end

function Store:AssertAsync(player)
	   return task.spawn(function()
			  local suc, res = pcall(function()
					 table.insert(Store.Sessions, player.UserId)
					 table.insert(self.data, player.UserId)
					 print(self.data)
					 self.data[player.UserId] = { status = { saved = false, loaded = true}}
					 local dataStore = self:getDataStore()
					 local data = dataStore:GetAsync(player.UserId)
					 if not players:IsAncestorOf(player) then
							player:Kick("Player Service error occured, please rejoin.")
					 end
					 if not data then
						   if self.template and not self.profile[player.UserId] then
								 self.profile[player.UserId] = self.template
								 dataStore:SetAsync(player.UserId, self.profile[player.UserId])
								 print("-- PLAYER JOINED FOR THE FIRST TIME: CREATING DATA NOW. ----")
						   end
					 else
						  self.profile[player.UserId] = dataStore:GetAsync(player.UserId)
					 end
			  end)
			  if not suc then
					 player:Kick("Data error occured..")
			  end
	   end)
end

function Store: UpdateAsync(player, value, callback)
	  return task.spawn(function() 
			 local suc, res = pcall(function() 
				  assert(self.profile[player.UserId][value], string.format("Profile value does not exist %s", player.UserId .. ", value: " .. value))
				  print('found')
				  local newData = callback(self.profile[player.UserId][value])
				  self.profile[player.UserId][value] = newData
				  return newData
			 end)
	  end)
end


function Store: GetAsync(player, value)
	  return task.spawn(function()
			 local suc, res = pcall(function()
					assert(self.profile[player.UserId][value], string.format("Profile value does not exist %s", player.UserId .. ", value: " .. value))
					return self.profile[player.UserId][value] or "Could not alter value."
			 end)
	  end)
end

function Store:SaveAsync(player) 
	  return task.spawn(function() 
			  local suc, res = pcall(function() 
					 if self.profile[player.UserId] and self.dataStore and self.data[player.UserId] then
							if self.data[player.UserId].status.loaded then
								self.dataStore:UpdateAsync(player.UserId, function(oldProfileData)
									if oldProfileData then
										if not self.data[player.UserId].status.saved then
											self.data[player.UserId].status.saved = true
										end
										return self.profile[player.UserId]
									else
										 return {}
								    end
								end)
							else
								return nil
							end
					 end
			  end)
			  if not suc then 
					warn("STORES: [FUNCTION]: SaveAsync, STATUS: THERE WAS A PROBLEM ")
					player:Kick("Data error occured..")
			  end
	  end)
end

function Store:Release(player) 
	 return task.spawn(function() 
			if self.data[player.UserId].status.saved and not Store.Sessions[player.UserId] and self.data[player.UserId].status.loaded then
				self.profile[player.UserId] = nil
				self.data[player.UserId] = nil
				
				print("profile terminated")
			elseif not self.data[player.UserId].status.saved then
				 print(self.data[player.UserId].status.saved)
				 self:SaveAsync(player)
				 print(self.data[player.UserId].status.saved)
			end
	 end)
end


function Store: getDataStatusTable()
end


return Store
