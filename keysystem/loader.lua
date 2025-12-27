-- Warp Key System - PREMIUM UI VERSION

local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local http = game:GetService("HttpService")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local CORRECT_KEY = "warpkey"
local DISCORD_LINK = "https://discord.gg/warphub"

-- UNIVERSAL SCRIPTS (Available in all games)
local UNIVERSAL_SCRIPTS = {
    ["Universal Warp"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    ["Private Server"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/privateserver.lua",
    ["Admin Commands"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/admin.lua",
    ["ESP & Aimbot"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/esp.lua",
    ["Infinite Yield"] = "https://github.com/EdgeIY/infiniteyield/raw/master/source",
    ["Simple Spy"] = "https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua",
    ["Chat Bypass"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/chatbypass.lua"
}

-- GAME-SPECIFIC SCRIPTS
local GAME_SCRIPTS = {
    [88929752766075] = {
        ["Blade Battle"] = "https://raw.githubusercontent.com/adubwon/geekUI/main/Games/BladeBattle.lua",
        ["Blade Battle Alt"] = "https://raw.githubusercontent.com/adubwon/geekUI/main/Games/BladeBattle_Alt.lua"
    },
    [286090429] = {
        ["Arsenal Enhanced"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/ArsenalEnhanced.lua",
        ["Silent Aim"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/ArsenalSilent.lua"
    },
    [85509428618863] = {
        ["WormIO"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/WormIO.lua"
    },
    [116610479068550] = {
        ["Class Clash"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/ClassClash.lua"
    },
    [133614490579000] = {
        ["Laser A Planet"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/Laser%20A%20Planet.lua"
    },
    [8737602449] = {
        ["PlsDonate"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/PlsDonate.lua",
        ["Auto Farm"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/PlsDonateFarm.lua"
    },
    [3623096087] = {
        ["Muscle Legends"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/musclelegends.lua",
        ["Auto Train"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/MuscleAutoTrain.lua"
    },
    [2788229376] = {
        ["Da Hood"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/DaHood.lua",
        ["Silent Aim"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/DaHoodSilent.lua"
    },
    [4520749081] = {
        ["Knight"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/Knight.lua"
    },
    [6447798030] = {
        ["Doors"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/Doors.lua"
    }
}

local CURRENT_PLACE_ID = game.PlaceId
local GAME_SPECIFIC_SCRIPTS = GAME_SCRIPTS[CURRENT_PLACE_ID] or {}

--------------------------------------------------
-- STORAGE
--------------------------------------------------

local KEY_STORAGE_FILE = "Warp_KeyData.json"

--------------------------------------------------
-- XANBAR UI LOAD
--------------------------------------------------

local UI = loadstring(game:HttpGet("https://xan.bar/init.lua"))()
local Window = nil
local MainTab = nil

--------------------------------------------------
-- FILE HANDLING
--------------------------------------------------

local function saveKeyData(scriptType, scriptName)
    pcall(function()
        writefile(KEY_STORAGE_FILE, http:JSONEncode({
            key_verified = true,
            user_id = plr.UserId,
            saved_key = CORRECT_KEY,
            last_script_type = scriptType or "universal",
            last_script_name = scriptName or "",
            saved_at = os.time(),
            place_id = CURRENT_PLACE_ID
        }))
    end)
end

local function loadKeyData()
    local success, result = pcall(function()
        if isfile(KEY_STORAGE_FILE) then
            local data = http:JSONDecode(readfile(KEY_STORAGE_FILE))
            if data.key_verified and data.user_id == plr.UserId and data.saved_key == CORRECT_KEY then
                return data.last_script_type, data.last_script_name
            end
        end
        return nil, nil
    end)
    return success and result
end

local function isKeyVerified()
    local success, result = pcall(function()
        if isfile(KEY_STORAGE_FILE) then
            local data = http:JSONDecode(readfile(KEY_STORAGE_FILE))
            return data.key_verified and data.user_id == plr.UserId and data.saved_key == CORRECT_KEY
        end
        return false
    end)
    return success and result
end

--------------------------------------------------
-- SCRIPT LOADING FUNCTION
--------------------------------------------------

local function loadScript(url, scriptName, scriptType)
    if not url then
        UI.Error("Script Error", "No script URL provided")
        return false
    end
    
    UI.Info("Loading Script", string.format("Loading '%s'...", scriptName))
    
    local success, result = pcall(function()
        local scriptContent = game:HttpGet(url, true)
        loadstring(scriptContent)()
    end)
    
    if success then
        UI.Success("Script Loaded", string.format("'%s' loaded successfully!", scriptName))
        saveKeyData(scriptType, scriptName)
        return true
    else
        UI.Error("Load Failed", "Failed to load script: " .. tostring(result))
        return false
    end
end

--------------------------------------------------
-- CREATE SCRIPT SELECTION UI
--------------------------------------------------

local function createScriptSelectionUI()
    Window = UI.New({
        Title = "Warp Script Hub",
        Theme = "Midnight",
        Size = UDim2.new(0, 650, 0, 550),
        ShowUserInfo = true,
        ShowActiveList = true,
        AutoHide = false
    })
    
    -- Universal Scripts Tab
    local UniversalTab = Window:AddTab("Universal", UI.Icons.Globe)
    
    UniversalTab:AddSection("Available in All Games")
    
    -- Add universal scripts as buttons
    for scriptName, scriptUrl in pairs(UNIVERSAL_SCRIPTS) do
        UniversalTab:AddButton(scriptName, function()
            loadScript(scriptUrl, scriptName, "universal")
        end)
    end
    
    -- Game Specific Tab
    if next(GAME_SPECIFIC_SCRIPTS) ~= nil then
        local GameTab = Window:AddTab("Game Specific", UI.Icons.Gamepad)
        
        GameTab:AddSection(string.format("Scripts for %s", game:GetService("MarketplaceService"):GetProductInfo(CURRENT_PLACE_ID).Name))
        
        for scriptName, scriptUrl in pairs(GAME_SPECIFIC_SCRIPTS) do
            GameTab:AddButton(scriptName, function()
                loadScript(scriptUrl, scriptName, "game")
            end)
        end
        
        GameTab:AddSection("Auto Execute")
        
        local lastGameScript = nil
        local scriptType, scriptName = loadKeyData()
        if scriptType == "game" and GAME_SPECIFIC_SCRIPTS[scriptName] then
            lastGameScript = scriptName
        end
        
        GameTab:AddDropdown("Auto Load", {
            Options = {"None", unpack(GameTab:GetButtonNames())},
            Default = lastGameScript or "None"
        }, function(selected)
            if selected ~= "None" then
                saveKeyData("game", selected)
                UI.Success("Auto Load Set", string.format("'%s' will load automatically", selected))
            end
        end)
    end
    
    -- Settings Tab
    local SettingsTab = Window:AddTab("Settings", UI.Icons.Settings)
    
    SettingsTab:AddSection("Key Management")
    
    local keyInput = SettingsTab:AddTextbox("Key", {
        Placeholder = "Enter your key here",
        Default = ""
    })
    
    SettingsTab:AddButton("Verify Key", function()
        if keyInput:Get() == CORRECT_KEY then
            saveKeyData()
            UI.Success("Key Verified", "Key has been verified successfully!")
            keyInput:Set("")
            Window:Close()
            createScriptSelectionUI() -- Reopen with full access
        else
            UI.Error("Invalid Key", "Please enter the correct key")
        end
    end)
    
    SettingsTab:AddButton("Get Key from Discord", function()
        if setclipboard then
            setclipboard(DISCORD_LINK)
            UI.Info("Discord Link", "Link copied to clipboard!")
        end
    end)
    
    SettingsTab:AddSection("Auto Load Settings")
    
    local lastUniversalScript = nil
    local scriptType, scriptName = loadKeyData()
    if scriptType == "universal" and UNIVERSAL_SCRIPTS[scriptName] then
        lastUniversalScript = scriptName
    end
    
    SettingsTab:AddDropdown("Universal Auto Load", {
        Options = {"None", unpack(UniversalTab:GetButtonNames())},
        Default = lastUniversalScript or "None"
    }, function(selected)
        if selected ~= "None" then
            saveKeyData("universal", selected)
            UI.Success("Auto Load Set", string.format("'%s' will load automatically", selected))
        end
    end)
    
    SettingsTab:AddSection("Data Management")
    
    SettingsTab:AddButton("Clear Saved Data", function()
        pcall(function()
            if isfile(KEY_STORAGE_FILE) then
                delfile(KEY_STORAGE_FILE)
                UI.Info("Data Cleared", "All saved data has been cleared")
                Window:Close()
                task.wait(0.5)
                createScriptSelectionUI()
            end
        end)
    end)
    
    SettingsTab:AddButton("Copy Discord", function()
        if setclipboard then
            setclipboard(DISCORD_LINK)
            UI.Info("Copied", "Discord link copied to clipboard!")
        end
    end)
    
    -- Info Tab
    local InfoTab = Window:AddTab("Info", UI.Icons.Info)
    
    InfoTab:AddSection("Warp Script Hub")
    
    InfoTab:AddLabel("Version: 2.0.0")
    InfoTab:AddLabel(string.format("Game: %s", game:GetService("MarketplaceService"):GetProductInfo(CURRENT_PLACE_ID).Name))
    InfoTab:AddLabel(string.format("Place ID: %d", CURRENT_PLACE_ID))
    InfoTab:AddLabel(string.format("User: %s", plr.Name))
    
    InfoTab:AddSection("Statistics")
    
    local universalCount = 0
    for _ in pairs(UNIVERSAL_SCRIPTS) do universalCount = universalCount + 1 end
    
    local gameCount = 0
    for _ in pairs(GAME_SPECIFIC_SCRIPTS) do gameCount = gameCount + 1 end
    
    InfoTab:AddLabel(string.format("Universal Scripts: %d", universalCount))
    InfoTab:AddLabel(string.format("Game Scripts: %d", gameCount))
    InfoTab:AddLabel(string.format("Total Scripts: %d", universalCount + gameCount))
    
    InfoTab:AddSection("Support")
    InfoTab:AddButton("Join Discord", function()
        if setclipboard then
            setclipboard(DISCORD_LINK)
            UI.Info("Discord", "Link copied to clipboard!")
        end
    end)
    
    InfoTab:AddButton("Report Issue", function()
        UI.Info("Report Issue", "Please report issues in our Discord server")
    end)
    
    -- Auto load feature
    local autoLoadToggle = SettingsTab:AddToggle("Auto Load Last Script", { Default = true })
    
    -- Quick Load Section
    if next(GAME_SPECIFIC_SCRIPTS) ~= nil then
        local QuickTab = Window:AddTab("Quick Load", UI.Icons.Bolt)
        
        QuickTab:AddSection("One-Click Load")
        
        local scriptType, scriptName = loadKeyData()
        local lastScriptName = nil
        
        if scriptType == "universal" and UNIVERSAL_SCRIPTS[scriptName] then
            lastScriptName = scriptName
        elseif scriptType == "game" and GAME_SPECIFIC_SCRIPTS[scriptName] then
            lastScriptName = scriptName
        end
        
        if lastScriptName then
            QuickTab:AddButton(string.format("Load Last: %s", lastScriptName), function()
                local scriptUrl = nil
                if UNIVERSAL_SCRIPTS[lastScriptName] then
                    scriptUrl = UNIVERSAL_SCRIPTS[lastScriptName]
                    loadScript(scriptUrl, lastScriptName, "universal")
                elseif GAME_SPECIFIC_SCRIPTS[lastScriptName] then
                    scriptUrl = GAME_SPECIFIC_SCRIPTS[lastScriptName]
                    loadScript(scriptUrl, lastScriptName, "game")
                end
            end)
        end
        
        QuickTab:AddSection("Popular Scripts")
        
        -- Add first 3 universal scripts as quick buttons
        local count = 0
        for scriptName, scriptUrl in pairs(UNIVERSAL_SCRIPTS) do
            if count < 3 then
                QuickTab:AddButton(scriptName, function()
                    loadScript(scriptUrl, scriptName, "universal")
                end)
                count = count + 1
            else
                break
            end
        end
        
        -- Add first 3 game scripts as quick buttons
        count = 0
        for scriptName, scriptUrl in pairs(GAME_SPECIFIC_SCRIPTS) do
            if count < 3 then
                QuickTab:AddButton(scriptName, function()
                    loadScript(scriptUrl, scriptName, "game")
                end)
                count = count + 1
            else
                break
            end
        end
    end
    
    -- Add toggle for UI
    SettingsTab:AddButton("Toggle UI Visibility", function()
        Window:Toggle()
    end)
    
    -- Bind UI toggle to RightControl
    uis.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightControl then
            Window:Toggle()
        end
    end)
end

--------------------------------------------------
-- CREATE KEY VERIFICATION UI
--------------------------------------------------

local function createKeyVerificationUI()
    Window = UI.New({
        Title = "Warp Key System",
        Theme = "Midnight",
        Size = UDim2.new(0, 500, 0, 400),
        ShowUserInfo = true,
        ShowActiveList = false,
        AutoHide = false
    })
    
    local MainTab = Window:AddTab("Verification", UI.Icons.Lock)
    
    MainTab:AddSection("🔑 Key Verification Required")
    
    MainTab:AddLabel("Welcome to Warp Script Hub!")
    MainTab:AddLabel("Please enter your key to access the scripts.")
    MainTab:AddLabel("")
    
    local keyInput = MainTab:AddTextbox("Enter Key", {
        Placeholder = "Paste your key here",
        Default = ""
    })
    
    MainTab:AddButton("Verify Key", function()
        local enteredKey = keyInput:Get()
        if enteredKey == CORRECT_KEY then
            saveKeyData()
            UI.Success("Access Granted", "Key verified successfully!")
            Window:Close()
            createScriptSelectionUI() -- Open main UI
        else
            UI.Error("Invalid Key", "Please check your key and try again")
            keyInput:Set("")
        end
    end)
    
    MainTab:AddSection("Get Your Key")
    
    MainTab:AddLabel("Don't have a key? Join our Discord!")
    
    MainTab:AddButton("Copy Discord Link", function()
        if setclipboard then
            setclipboard(DISCORD_LINK)
            UI.Info("Discord Link", "Link copied to clipboard!")
        end
    end)
    
    MainTab:AddButton("Open Discord", function()
        pcall(function()
            if syn and syn.request then
                syn.request({ Url = DISCORD_LINK, Method = "GET" })
            elseif request then
                request({ Url = DISCORD_LINK, Method = "GET" })
            end
        end)
        UI.Info("Discord", "Attempting to open Discord...")
    end)
    
    MainTab:AddSection("Info")
    MainTab:AddLabel("Place ID: " .. tostring(CURRENT_PLACE_ID))
    MainTab:AddLabel(string.format("Universal Scripts: %d", #UNIVERSAL_SCRIPTS))
    MainTab:AddLabel(string.format("Game Scripts: %d", #GAME_SPECIFIC_SCRIPTS))
    
    -- Bind escape to close
    uis.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightControl then
            Window:Toggle()
        end
    end)
end

--------------------------------------------------
-- INITIALIZATION
--------------------------------------------------

local function initialize()
    -- Add a delay to ensure everything loads
    task.wait(1)
    
    if isKeyVerified() then
        -- Show welcome notification
        UI.Success("Welcome Back", "Loading Warp Script Hub...")
        
        -- Open main UI
        createScriptSelectionUI()
        
        -- Auto load last script if enabled
        local scriptType, scriptName = loadKeyData()
        if scriptType and scriptName then
            task.wait(2) -- Give UI time to load
            
            local scriptUrl = nil
            if scriptType == "universal" then
                scriptUrl = UNIVERSAL_SCRIPTS[scriptName]
            elseif scriptType == "game" then
                scriptUrl = GAME_SPECIFIC_SCRIPTS[scriptName]
            end
            
            if scriptUrl then
                UI.Info("Auto Loading", string.format("Loading '%s'...", scriptName))
                task.wait(1)
                loadScript(scriptUrl, scriptName, scriptType)
            end
        end
    else
        -- Show verification UI
        createKeyVerificationUI()
        UI.Info("Key Required", "Please verify your key to continue")
    end
    
    -- Add icon to screen
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "WarpHubIcon"
    gui.ResetOnSpawn = false
    
    local icon = Instance.new("ImageButton", gui)
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0, 20, 0, 20)
    icon.Image = "rbxassetid://90013112630319"
    icon.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    icon.AutoButtonColor = false
    icon.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", icon)
    corner.CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", icon)
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 2
    
    icon.MouseButton1Click:Connect(function()
        if Window then
            Window:Toggle()
        end
    end)
    
    -- Make icon draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = icon.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    icon.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

--------------------------------------------------
-- START
--------------------------------------------------

-- Add a loading notification
UI.Info("Warp Script Hub", "Initializing...")

-- Initialize after a short delay
task.spawn(function()
    local success, err = pcall(initialize)
    if not success then
        UI.Error("Initialization Failed", tostring(err))
    end
end)

-- Add key system for manual execution
return {
    OpenUI = function()
        if Window then
            Window:Toggle()
        elseif isKeyVerified() then
            createScriptSelectionUI()
        else
            createKeyVerificationUI()
        end
    end,
    
    LoadUniversal = function(scriptName)
        if UNIVERSAL_SCRIPTS[scriptName] then
            return loadScript(UNIVERSAL_SCRIPTS[scriptName], scriptName, "universal")
        else
            UI.Error("Script Not Found", string.format("Universal script '%s' not found", scriptName))
            return false
        end
    end,
    
    LoadGame = function(scriptName)
        if GAME_SPECIFIC_SCRIPTS[scriptName] then
            return loadScript(GAME_SPECIFIC_SCRIPTS[scriptName], scriptName, "game")
        else
            UI.Error("Script Not Found", string.format("Game script '%s' not found", scriptName))
            return false
        end
    end
}
