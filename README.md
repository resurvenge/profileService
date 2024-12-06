# What is profileService
profileService is a simple, secure, and fast way to make datastores in roblox!
Note: This is not the original profile service, this is another script made by kepwastaken on discord

# How to set up profileService
Instructions:
 * Copy the code from the file "profileService.lua" and put it into a module script in ServerScriptService.
 * Next require the module 

Serverscript in serverscriptservice below
```lua
local serverScripts = game:GetService("ServerScriptService")
local profileService = require(serverScripts.profileService)
```

# How to use profileService

1. It's very advised to name a variable as your dataStore

```lua
local dataStoreName = "player_profiles"
```
2. Next you want to create the dataStore
```lua
local serverScripts = game:GetService("ServerScriptService")
local profileService = require(serverScripts.profileService)

local dataStoreName = "player_profiles"
profileService:New(dataStoreName)
```
3. Next you want to define playerService and create these two functions
```lua

local serverScripts = game:GetService("ServerScriptService")
local profileService = require(serverScripts.profileService)
local playerService = game:GetService("Players")
local dataStoreName = "player_profiles" -- Define the name of the dataStore
profileService:New(dataStoreName) -- Create the dataStore

playerService.PlayerAdded:Connect(function() 

end)

playerService.PlayerRemoving:Connect(function() 

end)

```
4. Now you want to create a template (starter values for the first time a player joins)

```lua
local serverScripts = game:GetService("ServerScriptService")
local profileService = require(serverScripts.profileService)
local playerService = game:GetService("Players")
local dataStoreName = "player_profiles" -- Define the name of the dataStore
profileService:New(dataStoreName) -- Create the dataStore

profileService:newTemplate({ -- Define default values
     Agility = 0,
     Strength = 0,
     Fortitude = 0,
     Charisma = 0
}, dataStoreName) -- define the dataStore using the dataStoreName variable

```

5. Next in your playerAdded function you want to load the attributes

```lua
local serverScripts = game:GetService("ServerScriptService")
local profileService = require(serverScripts.profileService)
local playerService = game:GetService("Players")
local dataStoreName = "player_profiles" -- Define the name of the dataStore
profileService:New(dataStoreName) -- Create the dataStore

profileService:newTemplate({ -- Define default values
     Agility = 0,
     Strength = 0,
     Fortitude = 0,
     Charisma = 0
}, dataStoreName) -- define the dataStore using the dataStoreName variable

playerService.PlayerAdded:Connect(function(player) -- Define player
      profileService:LoadData(player, dataStoreName) -- Add the player and the dataStore using dataStore variable
end)


```

6. In your playerRemoving function you want to save the data and clear the table of the player


```lua
local serverScripts = game:GetService("ServerScriptService")
local profileService = require(serverScripts.profileService)
local playerService = game:GetService("Players")
local dataStoreName = "player_profiles" -- Define the name of the dataStore
profileService:New(dataStoreName) -- Create the dataStore

profileService:newTemplate({ -- Define default values
     Agility = 0,
     Strength = 0,
     Fortitude = 0,
     Charisma = 0
}, dataStoreName) -- define the dataStore using the dataStoreName variable

playerService.PlayerAdded:Connect(function(player) -- Define player
      profileService:LoadData(player, dataStoreName) -- Pass in player and the dataStore name using dataStore variable
end)

playerService.PlayerRemoving:Connect(function(player) -- Define player
      profileService:Save(player, dataStoreName) -- Pass in player and the dataStore name
      profileService:Removing(player) -- Clears the profile table of the player that left the game
end)

```

# Other functions

* Saving every single player's data in the server
```lua
profileService:saveAllPlayers(databaseName) -- for this all you want to do is pass the databaseName
```
* Saving every {amount} of seconds

```lua

profileService: Autosave(databaseName) -- for this all you want to do is pass the databaseName and the interval (how fast to save each time)

```

* Updating values in the table

```lua
profileService:newTemplate({ -- Define default values
     Agility = 0,
     Strength = 0,
     Fortitude = 0,
     Charisma = 0
}, dataStoreName)

-- Each value to update HAS to be in the template
profileService:Update(player, "Agility", function(oldValue) return oldValue + 30 end)

-- Updating the old value, 0, and add 30 to it.

```

* Getting the amount of a value

```lua

profileService:newTemplate({ -- Define default values
     Agility = 0,
     Strength = 0,
     Fortitude = 0,
     Charisma = 0
}, dataStoreName)

-- Each value to update HAS to be in the template
profileService:Get(player, "Agility") -- Returns the amount of agility that was saved.


```
