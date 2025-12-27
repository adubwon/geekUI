-- Warp Key System - PREMIUM UI VERSION

local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local http = game:GetService("HttpService")
local ts = game:GetService("TextService")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local CORRECT_KEY = "warpkey"
local DISCORD_LINK = "https://discord.gg/warphub"

-- UNIVERSAL SCRIPTS (Available in all games)
local UNIVERSAL_SCRIPTS = {
    ["Universal Warp"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    ["Private Server"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/privateserver.lua"
}

-- GAME-SPECIFIC SCRIPTS
local GAME_SCRIPTS = {
    [88929752766075] = {
        ["Blade Battle"] = "https://raw.githubusercontent.com/adubwon/geekUI/main/Games/BladeBattle.lua"
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
        ["PlsDonate"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/PlsDonate.lua"
    },
    [3623096087] = {
        ["Muscle Legends"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/musclelegends.lua"
    },
    [2788229376] = {
        ["Da Hood"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/DaHood.lua"
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

--------------------------------------------------
-- FILE HANDLING
--------------------------------------------------

local function saveKeyData(scriptType, scriptName)
    pcall(function()
        if not isfolder then 
            return -- Some executors don't support isfolder
        end
        
        if not isfolder("WarpHub") then
            makefolder("WarpHub")
        end
        
        local filePath = "WarpHub/" .. KEY_STORAGE_FILE
        writefile(filePath, http:JSONEncode({
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
    if not isfolder or not isfile then 
        return nil, nil -- Some executors don't support these functions
    end
    
    pcall(function()
        if not isfolder("WarpHub") then
            makefolder("WarpHub")
        end
    end)
    
    local filePath = "WarpHub/" .. KEY_STORAGE_FILE
    local success, result = pcall(function()
        if isfile(filePath) then
            local data = http:JSONDecode(readfile(filePath))
            if data.key_verified and data.user_id == plr.UserId and data.saved_key == CORRECT_KEY then
                return data.last_script_type, data.last_script_name
            end
        end
        return nil, nil
    end)
    return success and result
end

local function isKeyVerified()
    if not isfolder or not isfile then 
        return false
    end
    
    local filePath = "WarpHub/" .. KEY_STORAGE_FILE
    local success, result = pcall(function()
        if isfile(filePath) then
            local data = http:JSONDecode(readfile(filePath))
            return data.key_verified and data.user_id == plr.UserId and data.saved_key == CORRECT_KEY
        end
        return false
    end)
    return success and result
end

--------------------------------------------------
-- MOBILE INPUT FIX
--------------------------------------------------

local function showMobileKeyboard(defaultText, callback)
    -- Create a simple text input GUI for mobile users
    if game:GetService("UserInputService").TouchEnabled then
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "MobileKeyboardInput"
        screenGui.DisplayOrder = 999
        screenGui.ResetOnSpawn = false
        
        local background = Instance.new("Frame")
        background.Size = UDim2.new(1, 0, 1, 0)
        background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        background.BackgroundTransparency = 0.5
        background.Parent = screenGui
        
        local inputFrame = Instance.new("Frame")
        inputFrame.Size = UDim2.new(0.8, 0, 0, 150)
        inputFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
        inputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        inputFrame.BorderSizePixel = 0
        inputFrame.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = inputFrame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        title.BorderSizePixel = 0
        title.Text = "Enter Key"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 18
        title.Parent = inputFrame
        
        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(0.9, 0, 0, 40)
        inputBox.Position = UDim2.new(0.05, 0, 0.3, 0)
        inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        inputBox.BorderSizePixel = 0
        inputBox.Text = defaultText or ""
        inputBox.PlaceholderText = "Enter key here..."
        inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        inputBox.Font = Enum.Font.Gotham
        inputBox.TextSize = 16
        inputBox.ClearTextOnFocus = false
        inputBox.Parent = inputFrame
        
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 5)
        inputCorner.Parent = inputBox
        
        local buttonContainer = Instance.new("Frame")
        buttonContainer.Size = UDim2.new(1, 0, 0, 40)
        buttonContainer.Position = UDim2.new(0, 0, 0.7, 0)
        buttonContainer.BackgroundTransparency = 1
        buttonContainer.Parent = inputFrame
        
        local cancelButton = Instance.new("TextButton")
        cancelButton.Size = UDim2.new(0.45, 0, 0.8, 0)
        cancelButton.Position = UDim2.new(0.025, 0, 0.1, 0)
        cancelButton.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
        cancelButton.BorderSizePixel = 0
        cancelButton.Text = "Cancel"
        cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        cancelButton.Font = Enum.Font.Gotham
        cancelButton.TextSize = 16
        cancelButton.Parent = buttonContainer
        
        local cancelCorner = Instance.new("UICorner")
        cancelCorner.CornerRadius = UDim.new(0, 5)
        cancelCorner.Parent = cancelButton
        
        local submitButton = Instance.new("TextButton")
        submitButton.Size = UDim2.new(0.45, 0, 0.8, 0)
        submitButton.Position = UDim2.new(0.525, 0, 0.1, 0)
        submitButton.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
        submitButton.BorderSizePixel = 0
        submitButton.Text = "Submit"
        submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        submitButton.Font = Enum.Font.Gotham
        submitButton.TextSize = 16
        submitButton.Parent = buttonContainer
        
        local submitCorner = Instance.new("UICorner")
        submitCorner.CornerRadius = UDim.new(0, 5)
        submitCorner.Parent = submitButton
        
        -- Focus the textbox
        task.wait(0.1)
        inputBox:CaptureFocus()
        
        -- Button events
        cancelButton.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
        
        submitButton.MouseButton1Click:Connect(function()
            local text = inputBox.Text
            screenGui:Destroy()
            if callback then
                callback(text)
            end
        end)
        
        -- Close on background click
        background.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
        
        screenGui.Parent = game.CoreGui
        
        return inputBox
    end
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
        
        local gameName = "Unknown Game"
        pcall(function()
            gameName = game:GetService("MarketplaceService"):GetProductInfo(CURRENT_PLACE_ID).Name
        end)
        
        GameTab:AddSection(string.format("Scripts for %s", gameName))
        
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
        
        local gameScriptNames = {"None"}
        for name, _ in pairs(GAME_SPECIFIC_SCRIPTS) do
            table.insert(gameScriptNames, name)
        end
        
        GameTab:AddDropdown("Auto Load", {
            Options = gameScriptNames,
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
    
    -- Mobile-friendly key input button
    SettingsTab:AddButton("Enter Key (Mobile Friendly)", function()
        showMobileKeyboard("", function(inputText)
            if inputText and inputText == CORRECT_KEY then
                saveKeyData()
                UI.Success("Key Verified", "Key has been verified successfully!")
                if Window then
                    Window:Close()
                    task.wait(0.5)
                    createScriptSelectionUI() -- Reopen with full access
                end
            elseif inputText then
                UI.Error("Invalid Key", "Please enter the correct key")
            end
        end)
    end)
    
    SettingsTab:AddButton("Copy Discord Link", function()
        local success = false
        if setclipboard then
            setclipboard(DISCORD_LINK)
            success = true
        elseif writeclipboard then
            writeclipboard(DISCORD_LINK)
            success = true
        end
        
        if success then
            UI.Success("Discord Link", "Link copied to clipboard!")
        else
            -- Show the link in a notification for mobile users
            UI.Info("Discord Link", "Link: " .. DISCORD_LINK)
        end
    end)
    
    SettingsTab:AddSection("Auto Load Settings")
    
    local lastUniversalScript = nil
    local scriptType, scriptName = loadKeyData()
    if scriptType == "universal" and UNIVERSAL_SCRIPTS[scriptName] then
        lastUniversalScript = scriptName
    end
    
    local universalScriptNames = {"None"}
    for name, _ in pairs(UNIVERSAL_SCRIPTS) do
        table.insert(universalScriptNames, name)
    end
    
    SettingsTab:AddDropdown("Universal Auto Load", {
        Options = universalScriptNames,
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
            if isfolder and isfile then
                local filePath = "WarpHub/" .. KEY_STORAGE_FILE
                if isfile(filePath) then
                    delfile(filePath)
                    UI.Success("Data Cleared", "All saved data has been cleared")
                    if Window then
                        Window:Close()
                        task.wait(0.5)
                        createKeyVerificationUI()
                    end
                end
            end
        end)
    end)
    
    -- Info Tab
    local InfoTab = Window:AddTab("Info", UI.Icons.Info)
    
    InfoTab:AddSection("Warp Script Hub")
    
    InfoTab:AddLabel("Version: 2.0.0")
    
    local gameName = "Unknown Game"
    pcall(function()
        gameName = game:GetService("MarketplaceService"):GetProductInfo(CURRENT_PLACE_ID).Name
    end)
    
    InfoTab:AddLabel(string.format("Game: %s", gameName))
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
    
    InfoTab:AddButton("Copy Discord Link", function()
        local success = false
        if setclipboard then
            setclipboard(DISCORD_LINK)
            success = true
        elseif writeclipboard then
            writeclipboard(DISCORD_LINK)
            success = true
        end
        
        if success then
            UI.Success("Discord", "Link copied to clipboard!")
        else
            UI.Info("Discord Link", DISCORD_LINK)
        end
    end)
    
    InfoTab:AddButton("Report Issue", function()
        UI.Info("Report Issue", "Please report issues in our Discord server")
    end)
    
    -- Quick Load Section
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
    
    -- Add universal scripts as quick buttons
    for scriptName, scriptUrl in pairs(UNIVERSAL_SCRIPTS) do
        QuickTab:AddButton(scriptName, function()
            loadScript(scriptUrl, scriptName, "universal")
        end)
    end
    
    -- Add game scripts as quick buttons
    for scriptName, scriptUrl in pairs(GAME_SPECIFIC_SCRIPTS) do
        QuickTab:AddButton(scriptName, function()
            loadScript(scriptUrl, scriptName, "game")
        end)
    end
    
    -- Add toggle for UI
    SettingsTab:AddButton("Toggle UI Visibility", function()
        if Window then
            Window:Toggle()
        end
    end)
    
    -- Bind UI toggle to RightControl (desktop only)
    if not uis.TouchEnabled then
        uis.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == Enum.KeyCode.RightControl then
                if Window then
                    Window:Toggle()
                end
            end
        end)
    end
end

--------------------------------------------------
-- CREATE KEY VERIFICATION UI (MOBILE FRIENDLY)
--------------------------------------------------

local function createKeyVerificationUI()
    Window = UI.New({
        Title = "Warp Key System",
        Theme = "Midnight",
        Size = UDim2.new(0, 500, 0, 450),
        ShowUserInfo = true,
        ShowActiveList = false,
        AutoHide = false
    })
    
    local MainTab = Window:AddTab("Verification", UI.Icons.Lock)
    
    MainTab:AddSection("🔑 Key Verification Required")
    
    MainTab:AddLabel("Welcome to Warp Script Hub!")
    MainTab:AddLabel("Please enter your key to access the scripts.")
    MainTab:AddLabel("")
    
    -- Mobile-friendly key input button
    MainTab:AddButton("Enter Key (Click Here)", function()
        showMobileKeyboard("", function(enteredKey)
            if enteredKey and enteredKey == CORRECT_KEY then
                saveKeyData()
                UI.Success("Access Granted", "Key verified successfully!")
                if Window then
                    Window:Close()
                    task.wait(0.5)
                    createScriptSelectionUI() -- Open main UI
                end
            elseif enteredKey then
                UI.Error("Invalid Key", "Please check your key and try again")
            end
        end)
    end)
    
    MainTab:AddSection("Get Your Key")
    
    MainTab:AddLabel("Don't have a key? Join our Discord!")
    
    MainTab:AddButton("Copy Discord Link", function()
        local success = false
        if setclipboard then
            setclipboard(DISCORD_LINK)
            success = true
        elseif writeclipboard then
            writeclipboard(DISCORD_LINK)
            success = true
        end
        
        if success then
            UI.Success("Discord Link", "Link copied to clipboard!")
        else
            -- Show the link in a notification for mobile users
            UI.Info("Discord Link", "Link: " .. DISCORD_LINK)
        end
    end)
    
    MainTab:AddButton("Open Discord (Mobile)", function()
        pcall(function()
            local requestFunc = syn and syn.request or request or http_request
            if requestFunc then
                requestFunc({
                    Url = DISCORD_LINK,
                    Method = "GET"
                })
                UI.Info("Discord", "Attempting to open Discord...")
            else
                UI.Info("Discord Link", DISCORD_LINK)
            end
        end)
    end)
    
    MainTab:AddSection("Instructions")
    
    if uis.TouchEnabled then
        MainTab:AddLabel("📱 Mobile Instructions:")
        MainTab:AddLabel("1. Click 'Enter Key' button")
        MainTab:AddLabel("2. Type your key in the popup")
        MainTab:AddLabel("3. Click 'Submit'")
        MainTab:AddLabel("")
    else
        MainTab:AddLabel("🖥️ Desktop Instructions:")
        MainTab:AddLabel("1. Click 'Enter Key' button")
        MainTab:AddLabel("2. Type your key in the popup")
        MainTab:AddLabel("3. Click 'Submit' or press Enter")
        MainTab:AddLabel("")
    end
    
    MainTab:AddSection("Info")
    MainTab:AddLabel("Place ID: " .. tostring(CURRENT_PLACE_ID))
    
    local universalCount = 0
    for _ in pairs(UNIVERSAL_SCRIPTS) do universalCount = universalCount + 1 end
    
    local gameCount = 0
    for _ in pairs(GAME_SPECIFIC_SCRIPTS) do gameCount = gameCount + 1 end
    
    MainTab:AddLabel(string.format("Universal Scripts: %d", universalCount))
    MainTab:AddLabel(string.format("Game Scripts: %d", gameCount))
    
    -- Bind toggle for mobile (tap icon instead of keyboard)
    if not uis.TouchEnabled then
        uis.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == Enum.KeyCode.RightControl then
                if Window then
                    Window:Toggle()
                end
            end
        end)
    end
end

--------------------------------------------------
-- CREATE FLOATING ICON (MOBILE FRIENDLY)
--------------------------------------------------

local function createFloatingIcon()
    if pcall(function() return game.CoreGui end) then
        local gui = Instance.new("ScreenGui")
        gui.Name = "WarpHubIcon"
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local icon = Instance.new("ImageButton")
        icon.Size = UDim2.new(0, 60, 0, 60)
        icon.Position = UDim2.new(0, 20, 0, 20)
        icon.Image = "rbxassetid://90013112630319"
        icon.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        icon.AutoButtonColor = false
        icon.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = icon
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 150, 255)
        stroke.Thickness = 3
        stroke.Parent = icon
        
        -- Add a pulsing effect for visibility
        local pulse = Instance.new("UIScale")
        pulse.Parent = icon
        
        local pulseTween = nil
        local function startPulse()
            if pulseTween then pulseTween:Cancel() end
            pulseTween = game:GetService("TweenService"):Create(pulse, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
                Scale = 1.1
            })
            pulseTween:Play()
        end
        
        local function stopPulse()
            if pulseTween then
                pulseTween:Cancel()
            end
            pulse.Scale = 1
        end
        
        icon.MouseEnter:Connect(stopPulse)
        icon.MouseLeave:Connect(startPulse)
        
        -- Start pulsing initially
        startPulse()
        
        icon.Parent = gui
        gui.Parent = game.CoreGui
        
        icon.MouseButton1Click:Connect(function()
            if Window then
                Window:Toggle()
            end
        end)
        
        -- Make icon draggable (works on both mobile and desktop)
        local dragging = false
        local dragInput, dragStart, startPos
        
        icon.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = icon.Position
                stopPulse()
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        startPulse()
                    end
                end)
            end
        end)
        
        icon.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        uis.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        return gui
    end
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
    
    -- Create floating icon
    createFloatingIcon()
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
