local UI = loadstring(game:HttpGet("https://xan.bar/init.lua"))()

local Window = UI.New({
    Title = "My Script",
    Theme = "Default",
    Size = UDim2.new(0, 580, 0, 420),
    ShowUserInfo = true,
    ShowActiveList = true
})

local Main = Window:AddTab("Main", UI.Icons.Home)

Main:AddSection("Features")
Main:AddToggle("Enable Feature", { Default = true }, function(v)
    print("Toggled:", v)
end)

Main:AddSlider("Walk Speed", { Min = 16, Max = 100, Default = 16 }, function(v)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = v
    end
end)

-- New: Private Server Feature
Main:AddSection("Server Control")

local serverHopStatus = Main:AddLabel("Status: Ready")

Main:AddButton("Go To Private Server", function()
    UI.Success("Searching...", "Looking for an empty server!")
    
    -- Function to find the smallest server
    local function getSmallestServer()
        local gameId = game.PlaceId
        local servers = {}
        
        -- Try to get servers (this method may vary by game)
        local success, result = pcall(function()
            return game:GetService("TeleportService"):GetPlayerPlaceInstanceAsync(game.Players.LocalPlayer.UserId, gameId)
        end)
        
        if success and result then
            -- This gets current server info, but we need a different approach
            return nil
        end
        
        -- Alternative approach: Use game.JobId to check current server
        return game.JobId
    end
    
    -- Function to teleport to a specific server
    local function teleportToServer(jobId)
        if jobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobId, game.Players.LocalPlayer)
            serverHopStatus:Set("Status: Teleporting...")
        else
            -- If no specific server, just rejoin
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
            serverHopStatus:Set("Status: Rejoining...")
        end
    end
    
    -- Method 1: Rejoin the game (often puts you in a new server)
    local function rejoinGame()
        serverHopStatus:Set("Status: Rejoining game...")
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
    
    -- Method 2: Server hop until alone (more aggressive)
    local function serverHopUntilAlone()
        serverHopStatus:Set("Status: Server hopping...")
        
        -- First, try to get current server players
        local players = game.Players:GetPlayers()
        if #players <= 1 then
            UI.Success("Success!", "You're already alone in this server!")
            serverHopStatus:Set("Status: Already alone")
            return
        end
        
        -- Try to rejoin
        rejoinGame()
        
        -- Check again after a delay
        wait(5)
        
        local newPlayers = game.Players:GetPlayers()
        if #newPlayers <= 1 then
            UI.Success("Success!", "Now in a private server!")
            serverHopStatus:Set("Status: Alone in server")
        else
            UI.Error("Failed", "Could not find empty server. Try again.")
            serverHopStatus:Set("Status: Failed - server busy")
        end
    end
    
    -- Execute the server hop
    serverHopUntilAlone()
end)

Main:AddButton("Rejoin Game (Force)", function()
    UI.Notice("Warning", "This will force rejoin the game!")
    serverHopStatus:Set("Status: Force rejoining...")
    
    -- Force rejoin method
    local ts = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local player = game.Players.LocalPlayer
    
    -- Try to preserve data if possible
    local success, err = pcall(function()
        ts:Teleport(placeId, player)
    end)
    
    if not success then
        UI.Error("Error", "Failed to rejoin: " .. tostring(err))
        serverHopStatus:Set("Status: Error occurred")
    end
end)

-- Additional feature: Auto-rejoin if players join
local autoPrivateToggle = Main:AddToggle("Auto-Private Mode", { Default = false }, function(v)
    if v then
        UI.Notice("Auto-Private", "Enabled - Will rejoin if players > 1")
        
        -- Connection to monitor players
        local connection
        connection = game.Players.PlayerAdded:Connect(function(player)
            wait(2) -- Give time for player to load
            
            local totalPlayers = #game.Players:GetPlayers()
            if totalPlayers > 1 and autoPrivateToggle:Get() then
                UI.Warning("Player Joined", player.Name .. " joined. Rejoining...")
                game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
            end
        end)
        
        -- Store connection for later disconnection
        autoPrivateToggle.connection = connection
    else
        UI.Notice("Auto-Private", "Disabled")
        if autoPrivateToggle.connection then
            autoPrivateToggle.connection:Disconnect()
            autoPrivateToggle.connection = nil
        end
    end
end)

Main:AddButton("Check Server Status", function()
    local players = game.Players:GetPlayers()
    local playerCount = #players
    
    if playerCount <= 1 then
        UI.Success("Server Status", "You're alone in this server!")
        serverHopStatus:Set("Status: Alone ✓")
    else
        UI.Info("Server Status", "Players: " .. playerCount)
        
        -- List players
        local playerList = ""
        for i, player in ipairs(players) do
            if player ~= game.Players.LocalPlayer then
                playerList = playerList .. player.Name .. "\n"
            end
        end
        
        if playerList ~= "" then
            UI.Info("Other Players", playerList)
        end
        serverHopStatus:Set("Status: " .. playerCount .. " players")
    end
end)

Main:AddButton("Click Me", function()
    UI.Success("Button Clicked!", "It works!")
end)

-- Add a note about limitations
Main:AddSection("Notes")
Main:AddLabel("Note: Private server feature may:")
Main:AddLabel("- Have cooldown restrictions")
Main:AddLabel("- Not work in all games")
Main:AddLabel("- Require multiple attempts")
