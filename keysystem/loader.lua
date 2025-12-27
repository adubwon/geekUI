make this look better and more organized, -- Warp Key System - WITH UNIVERSAL SECTION AND FIXED UI

local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local tw = game:GetService("TweenService")
local sg = game:GetService("StarterGui")
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
    ["ESP & Aimbot"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/esp.lua"
}

-- GAME-SPECIFIC SCRIPTS
local GAME_SCRIPTS = {
    [88929752766075] = {
        ["Blade Battle"] = "https://raw.githubusercontent.com/adubwon/geekUI/main/Games/BladeBattle.lua",
        ["Blade Battle Alt"] = "https://raw.githubusercontent.com/adubwon/geekUI/main/Games/BladeBattle_Alt.lua"
    },
    [109397169461300] = {
        ["Game Specific"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/SpecificGame.lua"
    },
    [286090429] = {
        ["Arsenal Enhanced"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/ArsenalEnhanced.lua"
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
}

local CURRENT_PLACE_ID = game.PlaceId
local GAME_SPECIFIC_SCRIPTS = GAME_SCRIPTS[CURRENT_PLACE_ID] or {}

--------------------------------------------------
-- STORAGE
--------------------------------------------------

local KEY_STORAGE_FILE = "Warp_KeyData.json"

--------------------------------------------------
-- COLORS
--------------------------------------------------

local COLORS = {
    Primary = Color3.fromRGB(0, 150, 255),
    Secondary = Color3.fromRGB(0, 100, 200),
    Accent = Color3.fromRGB(100, 200, 255),
    Background = Color3.fromRGB(15, 15, 15),
    SecondaryBG = Color3.fromRGB(25, 25, 25),
    Frame = Color3.fromRGB(35, 35, 35),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(50, 255, 50),
    Error = Color3.fromRGB(255, 50, 50),
    Warning = Color3.fromRGB(255, 200, 50),
    Universal = Color3.fromRGB(150, 50, 255),
    Game = Color3.fromRGB(50, 255, 150),
}

--------------------------------------------------
-- NOTIFICATION SYSTEM
--------------------------------------------------

local notificationQueue = {}
local isShowingNotification = false

local function showNotification(title, text, color, duration)
    if not title or not text then return end
    
    local notif = {
        Title = tostring(title),
        Text = tostring(text),
        Duration = duration or 3,
        Color = color or COLORS.Primary
    }
    
    table.insert(notificationQueue, notif)
    
    if not isShowingNotification then
        processNextNotification()
    end
end

local function processNextNotification()
    if #notificationQueue == 0 then
        isShowingNotification = false
        return
    end
    
    isShowingNotification = true
    local notif = table.remove(notificationQueue, 1)
    
    pcall(function()
        sg:SetCore("SendNotification", {
            Title = notif.Title,
            Text = notif.Text,
            Duration = notif.Duration,
            Icon = "rbxassetid://90013112630319"
        })
    end)
    
    task.wait(notif.Duration + 0.1)
    processNextNotification()
end

local function notifySuccess(text, duration)
    showNotification("✅ Success", text, COLORS.Success, duration)
end

local function notifyError(text, duration)
    showNotification("❌ Error", text, COLORS.Error, duration)
end

local function notifyInfo(text, duration)
    showNotification("ℹ️ Info", text, COLORS.Primary, duration)
end

local function notifyWarning(text, duration)
    showNotification("⚠️ Warning", text, COLORS.Warning, duration)
end

--------------------------------------------------
-- UI HELPERS
--------------------------------------------------

local function tween(obj, props, time, style)
    local tweenInfo = TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quad)
    local tweenObj = tw:Create(obj, tweenInfo, props)
    tweenObj:Play()
    return tweenObj
end

local function createCorner(obj, r)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

local function createStroke(obj, color, thickness)
    local s = Instance.new("UIStroke", obj)
    s.Color = color
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function createGlow(parent, color)
    local g = Instance.new("ImageLabel", parent)
    g.Size = UDim2.new(1, 20, 1, 20)
    g.Position = UDim2.new(0, -10, 0, -10)
    g.BackgroundTransparency = 1
    g.Image = "rbxassetid://4996891970"
    g.ImageColor3 = color
    g.ImageTransparency = 0.8
    g.ZIndex = 0
    return g
end

local function hoverEffect(btn, base, hover)
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = hover})
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = base})
    end)
end

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
            saved_at = os.time()
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
-- CREATE MAIN UI
--------------------------------------------------

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "WarpKeySystem"
mainGui.ResetOnSpawn = false
mainGui.Parent = game.CoreGui

local iconBtn = Instance.new("ImageButton", mainGui)
iconBtn.Size = UDim2.new(0, 60, 0, 60)
iconBtn.Position = UDim2.new(0, 20, 0, 20)
iconBtn.Image = "rbxassetid://90013112630319"
iconBtn.BackgroundColor3 = COLORS.Background
iconBtn.AutoButtonColor = false
iconBtn.BorderSizePixel = 0
iconBtn.Active = true
iconBtn.Draggable = true
createCorner(iconBtn, 12)
createStroke(iconBtn, COLORS.Primary)
createGlow(iconBtn, COLORS.Primary)

--------------------------------------------------
-- KEY INPUT UI
--------------------------------------------------

local keyFrame = Instance.new("Frame", mainGui)
keyFrame.Size = UDim2.new(0, 400, 0, 320)
keyFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
keyFrame.BackgroundColor3 = COLORS.Background
keyFrame.Visible = false
keyFrame.BorderSizePixel = 0
keyFrame.Active = true
keyFrame.Draggable = true
createCorner(keyFrame, 12)
createStroke(keyFrame, COLORS.Primary)
createGlow(keyFrame, COLORS.Primary)

-- Header
local keyHeader = Instance.new("Frame", keyFrame)
keyHeader.Size = UDim2.new(1, 0, 0, 60)
keyHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
keyHeader.BorderSizePixel = 0
createCorner(keyHeader, 12)

local keyTitle = Instance.new("TextLabel", keyHeader)
keyTitle.Size = UDim2.new(1, -40, 0, 30)
keyTitle.Position = UDim2.new(0, 20, 0, 10)
keyTitle.Text = "🔑 Warp Key System"
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 22
keyTitle.TextColor3 = COLORS.Text
keyTitle.BackgroundTransparency = 1

local keySubtitle = Instance.new("TextLabel", keyHeader)
keySubtitle.Size = UDim2.new(1, -40, 0, 20)
keySubtitle.Position = UDim2.new(0, 20, 0, 35)
keySubtitle.Text = "Enter your key to access scripts"
keySubtitle.Font = Enum.Font.Gotham
keySubtitle.TextSize = 14
keySubtitle.TextColor3 = COLORS.TextDim
keySubtitle.BackgroundTransparency = 1

-- Input Field
local inputContainer = Instance.new("Frame", keyFrame)
inputContainer.Size = UDim2.new(1, -40, 0, 50)
inputContainer.Position = UDim2.new(0, 20, 0, 80)
inputContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
inputContainer.BorderSizePixel = 0
createCorner(inputContainer, 8)
createStroke(inputContainer, Color3.fromRGB(50, 50, 50))

local keyInput = Instance.new("TextBox", inputContainer)
keyInput.Size = UDim2.new(1, -20, 1, 0)
keyInput.Position = UDim2.new(0, 10, 0, 0)
keyInput.PlaceholderText = "Enter your key here..."
keyInput.Text = ""
keyInput.TextColor3 = COLORS.Text
keyInput.BackgroundTransparency = 1
keyInput.Font = Enum.Font.Gotham
keyInput.TextSize = 16
keyInput.ClearTextOnFocus = false

-- Buttons
local submitBtn = Instance.new("TextButton", keyFrame)
submitBtn.Size = UDim2.new(1, -40, 0, 45)
submitBtn.Position = UDim2.new(0, 20, 0, 145)
submitBtn.Text = "✅ Verify Key"
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 16
submitBtn.TextColor3 = COLORS.Text
submitBtn.BackgroundColor3 = COLORS.Primary
submitBtn.BorderSizePixel = 0
createCorner(submitBtn, 8)
hoverEffect(submitBtn, COLORS.Primary, Color3.fromRGB(0, 180, 255))

local discordBtn = Instance.new("TextButton", keyFrame)
discordBtn.Size = UDim2.new(1, -40, 0, 45)
discordBtn.Position = UDim2.new(0, 20, 0, 200)
discordBtn.Text = "📢 Get Key from Discord"
discordBtn.Font = Enum.Font.GothamBold
discordBtn.TextSize = 16
discordBtn.TextColor3 = COLORS.Text
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.BorderSizePixel = 0
createCorner(discordBtn, 8)
hoverEffect(discordBtn, Color3.fromRGB(88, 101, 242), Color3.fromRGB(105, 116, 245))

local closeBtn = Instance.new("TextButton", keyFrame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 15)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = COLORS.Text
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.BorderSizePixel = 0
createCorner(closeBtn, 15)
hoverEffect(closeBtn, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 60))

--------------------------------------------------
-- SCRIPT SELECTION UI
--------------------------------------------------

local selectionFrame = Instance.new("Frame", mainGui)
selectionFrame.Size = UDim2.new(0, 450, 0, 500)
selectionFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
selectionFrame.BackgroundColor3 = COLORS.Background
selectionFrame.Visible = false
selectionFrame.BorderSizePixel = 0
selectionFrame.Active = true
selectionFrame.Draggable = true
createCorner(selectionFrame, 12)
createStroke(selectionFrame, COLORS.Primary)
createGlow(selectionFrame, COLORS.Primary)

-- Header
local selectionHeader = Instance.new("Frame", selectionFrame)
selectionHeader.Size = UDim2.new(1, 0, 0, 70)
selectionHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
selectionHeader.BorderSizePixel = 0
createCorner(selectionHeader, 12)

local selectionTitle = Instance.new("TextLabel", selectionHeader)
selectionTitle.Size = UDim2.new(1, -40, 0, 30)
selectionTitle.Position = UDim2.new(0, 20, 0, 10)
selectionTitle.Text = "🎮 Script Loader"
selectionTitle.Font = Enum.Font.GothamBold
selectionTitle.TextSize = 22
selectionTitle.TextColor3 = COLORS.Text
selectionTitle.BackgroundTransparency = 1

local selectionSubtitle = Instance.new("TextLabel", selectionHeader)
selectionSubtitle.Size = UDim2.new(1, -40, 0, 20)
selectionSubtitle.Position = UDim2.new(0, 20, 0, 40)
selectionSubtitle.Text = "Select a script to load"
selectionSubtitle.Font = Enum.Font.Gotham
selectionSubtitle.TextSize = 14
selectionSubtitle.TextColor3 = COLORS.TextDim
selectionSubtitle.BackgroundTransparency = 1

local selectionCloseBtn = Instance.new("TextButton", selectionFrame)
selectionCloseBtn.Size = UDim2.new(0, 30, 0, 30)
selectionCloseBtn.Position = UDim2.new(1, -40, 0, 20)
selectionCloseBtn.Text = "✕"
selectionCloseBtn.Font = Enum.Font.GothamBold
selectionCloseBtn.TextSize = 18
selectionCloseBtn.TextColor3 = COLORS.Text
selectionCloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
selectionCloseBtn.BorderSizePixel = 0
createCorner(selectionCloseBtn, 15)
hoverEffect(selectionCloseBtn, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 60))

-- Tabs Container
local tabsContainer = Instance.new("Frame", selectionFrame)
tabsContainer.Size = UDim2.new(1, -40, 0, 40)
tabsContainer.Position = UDim2.new(0, 20, 0, 80)
tabsContainer.BackgroundTransparency = 1

local universalTab = Instance.new("TextButton", tabsContainer)
universalTab.Size = UDim2.new(0.5, -5, 1, 0)
universalTab.Position = UDim2.new(0, 0, 0, 0)
universalTab.Text = "🌐 Universal"
universalTab.Font = Enum.Font.GothamBold
universalTab.TextSize = 14
universalTab.TextColor3 = COLORS.Text
universalTab.BackgroundColor3 = COLORS.Universal
universalTab.BorderSizePixel = 0
createCorner(universalTab, 6)

local gameTab = Instance.new("TextButton", tabsContainer)
gameTab.Size = UDim2.new(0.5, -5, 1, 0)
gameTab.Position = UDim2.new(0.5, 5, 0, 0)
gameTab.Text = "🎮 Game Specific"
gameTab.Font = Enum.Font.GothamBold
gameTab.TextSize = 14
gameTab.TextColor3 = COLORS.Text
gameTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
gameTab.BorderSizePixel = 0
createCorner(gameTab, 6)
hoverEffect(gameTab, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))

-- Scripts Container
local scriptsContainer = Instance.new("ScrollingFrame", selectionFrame)
scriptsContainer.Size = UDim2.new(1, -40, 0, 350)
scriptsContainer.Position = UDim2.new(0, 20, 0, 130)
scriptsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scriptsContainer.BorderSizePixel = 0
scriptsContainer.ScrollBarThickness = 4
scriptsContainer.ScrollBarImageColor3 = COLORS.Primary
createCorner(scriptsContainer, 8)

local scriptsLayout = Instance.new("UIListLayout", scriptsContainer)
scriptsLayout.Padding = UDim.new(0, 10)
scriptsLayout.SortOrder = Enum.SortOrder.LayoutOrder

local currentTab = "universal"

--------------------------------------------------
-- LOAD SCRIPT FUNCTION
--------------------------------------------------

local function loadScript(url, scriptName, scriptType)
    if not url then
        notifyError("No script URL provided")
        return false
    end
    
    local success, result = pcall(function()
        local scriptContent = game:HttpGet(url, true)
        loadstring(scriptContent)()
    end)
    
    if success then
        notifySuccess(string.format("'%s' loaded successfully!", scriptName))
        saveKeyData(scriptType, scriptName)
        selectionFrame.Visible = false
        return true
    else
        notifyError("Failed to load script: " .. tostring(result))
        return false
    end
end

--------------------------------------------------
-- POPULATE SCRIPTS
--------------------------------------------------

local function populateScripts()
    -- Clear existing scripts
    for _, child in pairs(scriptsContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local scripts = {}
    
    if currentTab == "universal" then
        scripts = UNIVERSAL_SCRIPTS
    else
        scripts = GAME_SPECIFIC_SCRIPTS
    end
    
    if next(scripts) == nil then
        local emptyLabel = Instance.new("TextLabel", scriptsContainer)
        emptyLabel.Size = UDim2.new(1, 0, 0, 100)
        emptyLabel.Text = currentTab == "universal" and "No universal scripts available" or "No game-specific scripts available for this game"
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 16
        emptyLabel.TextColor3 = COLORS.TextDim
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.TextWrapped = true
        return
    end
    
    for scriptName, scriptUrl in pairs(scripts) do
        local scriptBtn = Instance.new("TextButton", scriptsContainer)
        scriptBtn.Size = UDim2.new(1, 0, 0, 50)
        scriptBtn.Text = scriptName
        scriptBtn.Font = Enum.Font.GothamBold
        scriptBtn.TextSize = 16
        scriptBtn.TextColor3 = COLORS.Text
        scriptBtn.BackgroundColor3 = currentTab == "universal" and Color3.fromRGB(60, 25, 100) or Color3.fromRGB(25, 60, 40)
        scriptBtn.BorderSizePixel = 0
        scriptBtn.TextXAlignment = Enum.TextXAlignment.Left
        scriptBtn.PaddingLeft = UDim.new(0, 15)
        createCorner(scriptBtn, 6)
        
        local btnColor = currentTab == "universal" and COLORS.Universal or COLORS.Game
        hoverEffect(scriptBtn, scriptBtn.BackgroundColor3, btnColor)
        
        scriptBtn.MouseButton1Click:Connect(function()
            loadScript(scriptUrl, scriptName, currentTab)
        end)
    end
    
    -- Update canvas size
    scriptsContainer.CanvasSize = UDim2.new(0, 0, 0, scriptsLayout.AbsoluteContentSize.Y)
end

--------------------------------------------------
-- TAB HANDLERS
--------------------------------------------------

universalTab.MouseButton1Click:Connect(function()
    currentTab = "universal"
    universalTab.BackgroundColor3 = COLORS.Universal
    gameTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    populateScripts()
end)

gameTab.MouseButton1Click:Connect(function()
    currentTab = "game"
    gameTab.BackgroundColor3 = COLORS.Game
    universalTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    populateScripts()
end)

--------------------------------------------------
-- BUTTON HANDLERS
--------------------------------------------------

submitBtn.MouseButton1Click:Connect(function()
    if keyInput.Text == CORRECT_KEY then
        saveKeyData()
        notifySuccess("Key verified successfully!")
        keyFrame.Visible = false
        
        -- Show script selection
        selectionFrame.Visible = true
        populateScripts()
    else
        notifyError("Invalid key! Please check and try again.")
    end
end)

discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_LINK)
        notifyInfo("Discord link copied to clipboard!")
    end
    
    pcall(function()
        if syn and syn.request then
            syn.request({ Url = DISCORD_LINK, Method = "GET" })
        elseif request then
            request({ Url = DISCORD_LINK, Method = "GET" })
        end
    end)
end)

closeBtn.MouseButton1Click:Connect(function()
    keyFrame.Visible = false
end)

selectionCloseBtn.MouseButton1Click:Connect(function()
    selectionFrame.Visible = false
end)

iconBtn.MouseButton1Click:Connect(function()
    if isKeyVerified() then
        keyFrame.Visible = false
        selectionFrame.Visible = not selectionFrame.Visible
        if selectionFrame.Visible then
            populateScripts()
        end
    else
        keyFrame.Visible = not keyFrame.Visible
    end
end)

--------------------------------------------------
-- AUTO LOAD SYSTEM
--------------------------------------------------

local function handleAutoLoad()
    if isKeyVerified() then
        iconBtn.Visible = true
        keyFrame.Visible = false
        
        -- Try to load last used script
        local scriptType, scriptName = loadKeyData()
        
        if scriptType and scriptName then
            local scriptUrl = nil
            
            if scriptType == "universal" then
                scriptUrl = UNIVERSAL_SCRIPTS[scriptName]
            elseif scriptType == "game" then
                scriptUrl = GAME_SPECIFIC_SCRIPTS[scriptName]
            end
            
            if scriptUrl then
                task.wait(1) -- Small delay for game to load
                loadScript(scriptUrl, scriptName, scriptType)
            else
                notifyInfo("Welcome back! Select a script to load.")
                selectionFrame.Visible = true
                populateScripts()
            end
        else
            notifyInfo("Welcome! Select a script to load.")
            selectionFrame.Visible = true
            populateScripts()
        end
    else
        iconBtn.Visible = true
        keyFrame.Visible = true
    end
end

--------------------------------------------------
-- INITIALIZE
--------------------------------------------------

-- Initial population
populateScripts()

-- Handle auto load
task.spawn(function()
    task.wait(1) -- Wait for game to fully load
    handleAutoLoad()
end)

-- Escape key to close UIs
uis.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Escape then
        if selectionFrame.Visible then
            selectionFrame.Visible = false
        elseif keyFrame.Visible then
            keyFrame.Visible = false
        end
    end
end)

-- Make icon button always on top
iconBtn.ZIndex = 100
keyFrame.ZIndex = 99
selectionFrame.ZIndex = 99

notifyInfo("Warp Key System Loaded!", 2)
