--[[
    Warp Key System v2.0
    Enhanced with Universal Section and Fixed UI
    Organized and Optimized
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Player reference
local LocalPlayer = Players.LocalPlayer

--======================================================================--
-- CONFIGURATION
--======================================================================--

local CONFIG = {
    CORRECT_KEY = "warpkey",
    DISCORD_LINK = "https://discord.gg/warphub",
    
    -- Storage
    KEY_STORAGE_FILE = "Warp_KeyData.json",
    
    -- UI Sizes
    ICON_SIZE = UDim2.new(0, 60, 0, 60),
    KEY_FRAME_SIZE = UDim2.new(0, 400, 0, 320),
    SELECTION_FRAME_SIZE = UDim2.new(0, 450, 0, 500),
    
    -- Animation
    TWEEN_DURATION = 0.3,
    TWEEN_STYLE = Enum.EasingStyle.Quad,
    
    -- Notifications
    NOTIFICATION_DURATION = 3
}

--======================================================================--
-- COLOR THEME
--======================================================================--

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
    
    Discord = Color3.fromRGB(88, 101, 242)
}

--======================================================================--
-- SCRIPT DATABASE
--======================================================================--

local SCRIPT_DB = {
    Universal = {
        ["Universal Warp"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
        ["Private Server"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/privateserver.lua",
        ["Admin Commands"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/admin.lua",
        ["ESP & Aimbot"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/esp.lua"
    },
    
    GameSpecific = {
        [88929752766075] = {  -- Blade Battle
            ["Blade Battle"] = "https://raw.githubusercontent.com/adubwon/geekUI/main/Games/BladeBattle.lua",
            ["Blade Battle Alt"] = "https://raw.githubusercontent.com/adubwon/geekUI/main/Games/BladeBattle_Alt.lua"
        },
        [109397169461300] = { -- Game Specific
            ["Game Specific"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/SpecificGame.lua"
        },
        [286090429] = {       -- Arsenal
            ["Arsenal Enhanced"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/ArsenalEnhanced.lua"
        },
        [85509428618863] = {  -- WormIO
            ["WormIO"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/WormIO.lua"
        },
        [116610479068550] = { -- Class Clash
            ["Class Clash"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/ClassClash.lua"
        },
        [133614490579000] = { -- Laser A Planet
            ["Laser A Planet"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/Laser%20A%20Planet.lua"
        },
        [8737602449] = {      -- PlsDonate
            ["PlsDonate"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/PlsDonate.lua"
        },
        [3623096087] = {      -- Muscle Legends
            ["Muscle Legends"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/musclelegends.lua"
        }
    }
}

-- Current game scripts
local CurrentPlaceId = game.PlaceId
local GameScripts = SCRIPT_DB.GameSpecific[CurrentPlaceId] or {}

--======================================================================--
-- UI COMPONENTS
--======================================================================--

local UI = {
    Main = nil,
    KeyInput = nil,
    ScriptSelection = nil,
    Icon = nil
}

--======================================================================--
-- UTILITY FUNCTIONS
--======================================================================--

local Utilities = {}

-- UI Creation Helpers
function Utilities.CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

function Utilities.CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or COLORS.Primary
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

function Utilities.CreateGlow(parent, color)
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://4996891970"
    glow.ImageColor3 = color or COLORS.Primary
    glow.ImageTransparency = 0.8
    glow.ZIndex = 0
    glow.Parent = parent
    return glow
end

-- Animation
function Utilities.Tween(object, properties, duration, style)
    local tweenInfo = TweenInfo.new(
        duration or CONFIG.TWEEN_DURATION,
        style or CONFIG.TWEEN_STYLE
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Hover Effects
function Utilities.ApplyHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        Utilities.Tween(button, {BackgroundColor3 = hoverColor})
    end)
    button.MouseLeave:Connect(function()
        Utilities.Tween(button, {BackgroundColor3 = normalColor})
    end)
end

--======================================================================--
-- NOTIFICATION SYSTEM
--======================================================================--

local Notification = {
    Queue = {},
    IsShowing = false
}

function Notification.Show(title, message, color, duration)
    if not title or not message then return end
    
    table.insert(Notification.Queue, {
        Title = tostring(title),
        Message = tostring(message),
        Duration = duration or CONFIG.NOTIFICATION_DURATION,
        Color = color or COLORS.Primary
    })
    
    if not Notification.IsShowing then
        Notification.ProcessNext()
    end
end

function Notification.ProcessNext()
    if #Notification.Queue == 0 then
        Notification.IsShowing = false
        return
    end
    
    Notification.IsShowing = true
    local notif = table.remove(Notification.Queue, 1)
    
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = notif.Title,
            Text = notif.Message,
            Duration = notif.Duration,
            Icon = "rbxassetid://90013112630319"
        })
    end)
    
    task.wait(notif.Duration + 0.1)
    Notification.ProcessNext()
end

function Notification.Success(message, duration)
    Notification.Show("✅ Success", message, COLORS.Success, duration)
end

function Notification.Error(message, duration)
    Notification.Show("❌ Error", message, COLORS.Error, duration)
end

function Notification.Info(message, duration)
    Notification.Show("ℹ️ Info", message, COLORS.Primary, duration)
end

function Notification.Warning(message, duration)
    Notification.Show("⚠️ Warning", message, COLORS.Warning, duration)
end

--======================================================================--
-- STORAGE SYSTEM
--======================================================================--

local Storage = {}

function Storage.SaveKeyData(scriptType, scriptName)
    local success = pcall(function()
        local data = {
            key_verified = true,
            user_id = LocalPlayer.UserId,
            saved_key = CONFIG.CORRECT_KEY,
            last_script_type = scriptType or "universal",
            last_script_name = scriptName or "",
            saved_at = os.time(),
            place_id = CurrentPlaceId
        }
        
        writefile(CONFIG.KEY_STORAGE_FILE, HttpService:JSONEncode(data))
    end)
    
    return success
end

function Storage.LoadKeyData()
    if not isfile(CONFIG.KEY_STORAGE_FILE) then
        return nil
    end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG.KEY_STORAGE_FILE))
    end)
    
    if not success or not data then
        return nil
    end
    
    -- Validate stored data
    if data.key_verified 
       and data.user_id == LocalPlayer.UserId 
       and data.saved_key == CONFIG.CORRECT_KEY then
        return data.last_script_type, data.last_script_name
    end
    
    return nil
end

function Storage.IsKeyVerified()
    if not isfile(CONFIG.KEY_STORAGE_FILE) then
        return false
    end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG.KEY_STORAGE_FILE))
    end)
    
    if not success or not data then
        return false
    end
    
    return data.key_verified 
           and data.user_id == LocalPlayer.UserId 
           and data.saved_key == CONFIG.CORRECT_KEY
end

--======================================================================--
-- SCRIPT LOADER
--======================================================================--

local ScriptLoader = {}

function ScriptLoader.Load(url, name, type)
    if not url or url == "" then
        Notification.Error("No script URL provided")
        return false
    end
    
    local success, result = pcall(function()
        local content = game:HttpGet(url, true)
        loadstring(content)()
    end)
    
    if success then
        Notification.Success(string.format("'%s' loaded successfully!", name))
        Storage.SaveKeyData(type, name)
        return true
    else
        Notification.Error("Failed to load script: " .. tostring(result))
        return false
    end
end

function ScriptLoader.GetScriptsForTab(tabName)
    if tabName == "universal" then
        return SCRIPT_DB.Universal
    else
        return GameScripts
    end
end

--======================================================================--
-- UI CREATION
--======================================================================--

local UIBuilder = {}

-- Create Main ScreenGui
function UIBuilder.CreateMainGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WarpKeySystem"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    return screenGui
end

-- Create Icon Button
function UIBuilder.CreateIcon(parent)
    local icon = Instance.new("ImageButton")
    icon.Name = "IconButton"
    icon.Size = CONFIG.ICON_SIZE
    icon.Position = UDim2.new(0, 20, 0, 20)
    icon.Image = "rbxassetid://90013112630319"
    icon.BackgroundColor3 = COLORS.Background
    icon.AutoButtonColor = false
    icon.BorderSizePixel = 0
    icon.Active = true
    icon.Draggable = true
    icon.ZIndex = 100
    
    Utilities.CreateCorner(icon, 12)
    Utilities.CreateStroke(icon, COLORS.Primary)
    Utilities.CreateGlow(icon, COLORS.Primary)
    icon.Parent = parent
    
    return icon
end

-- Create Key Input Frame
function UIBuilder.CreateKeyInputFrame(parent)
    local frame = Instance.new("Frame")
    frame.Name = "KeyInputFrame"
    frame.Size = CONFIG.KEY_FRAME_SIZE
    frame.Position = UDim2.new(0.5, -200, 0.5, -160)
    frame.BackgroundColor3 = COLORS.Background
    frame.Visible = false
    frame.Active = true
    frame.Draggable = true
    frame.ZIndex = 99
    
    Utilities.CreateCorner(frame, 12)
    Utilities.CreateStroke(frame, COLORS.Primary)
    Utilities.CreateGlow(frame, COLORS.Primary)
    frame.Parent = parent
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    header.BorderSizePixel = 0
    Utilities.CreateCorner(header, 12)
    header.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 20, 0, 10)
    title.Text = "🔑 Warp Key System"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextColor3 = COLORS.Text
    title.BackgroundTransparency = 1
    title.Parent = header
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 20)
    subtitle.Position = UDim2.new(0, 20, 0, 35)
    subtitle.Text = "Enter your key to access scripts"
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.TextColor3 = COLORS.TextDim
    subtitle.BackgroundTransparency = 1
    subtitle.Parent = header
    
    -- Input Field
    local inputContainer = Instance.new("Frame")
    inputContainer.Size = UDim2.new(1, -40, 0, 50)
    inputContainer.Position = UDim2.new(0, 20, 0, 80)
    inputContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    inputContainer.BorderSizePixel = 0
    Utilities.CreateCorner(inputContainer, 8)
    Utilities.CreateStroke(inputContainer, Color3.fromRGB(50, 50, 50))
    inputContainer.Parent = frame
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "KeyInput"
    textBox.Size = UDim2.new(1, -20, 1, 0)
    textBox.Position = UDim2.new(0, 10, 0, 0)
    textBox.PlaceholderText = "Enter your key here..."
    textBox.Text = ""
    textBox.TextColor3 = COLORS.Text
    textBox.BackgroundTransparency = 1
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 16
    textBox.ClearTextOnFocus = false
    textBox.Parent = inputContainer
    
    -- Buttons Container
    local buttonsFrame = Instance.new("Frame")
    buttonsFrame.Size = UDim2.new(1, -40, 0, 140)
    buttonsFrame.Position = UDim2.new(0, 20, 0, 145)
    buttonsFrame.BackgroundTransparency = 1
    buttonsFrame.Parent = frame
    
    local buttonLayout = Instance.new("UIListLayout", buttonsFrame)
    buttonLayout.Padding = UDim.new(0, 10)
    buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Submit Button
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(1, 0, 0, 45)
    submitBtn.Text = "✅ Verify Key"
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 16
    submitBtn.TextColor3 = COLORS.Text
    submitBtn.BackgroundColor3 = COLORS.Primary
    submitBtn.BorderSizePixel = 0
    Utilities.CreateCorner(submitBtn, 8)
    Utilities.ApplyHoverEffect(submitBtn, COLORS.Primary, Color3.fromRGB(0, 180, 255))
    submitBtn.Parent = buttonsFrame
    
    -- Discord Button
    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, 0, 0, 45)
    discordBtn.Text = "📢 Get Key from Discord"
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = 16
    discordBtn.TextColor3 = COLORS.Text
    discordBtn.BackgroundColor3 = COLORS.Discord
    discordBtn.BorderSizePixel = 0
    Utilities.CreateCorner(discordBtn, 8)
    Utilities.ApplyHoverEffect(discordBtn, COLORS.Discord, Color3.fromRGB(105, 116, 245))
    discordBtn.Parent = buttonsFrame
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 15)
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = COLORS.Text
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    closeBtn.BorderSizePixel = 0
    Utilities.CreateCorner(closeBtn, 15)
    Utilities.ApplyHoverEffect(closeBtn, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 60))
    closeBtn.Parent = frame
    
    return {
        Frame = frame,
        Input = textBox,
        SubmitButton = submitBtn,
        DiscordButton = discordBtn,
        CloseButton = closeBtn
    }
end

-- Create Script Selection Frame
function UIBuilder.CreateScriptSelectionFrame(parent)
    local frame = Instance.new("Frame")
    frame.Name = "ScriptSelectionFrame"
    frame.Size = CONFIG.SELECTION_FRAME_SIZE
    frame.Position = UDim2.new(0.5, -225, 0.5, -250)
    frame.BackgroundColor3 = COLORS.Background
    frame.Visible = false
    frame.Active = true
    frame.Draggable = true
    frame.ZIndex = 99
    
    Utilities.CreateCorner(frame, 12)
    Utilities.CreateStroke(frame, COLORS.Primary)
    Utilities.CreateGlow(frame, COLORS.Primary)
    frame.Parent = parent
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 70)
    header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    header.BorderSizePixel = 0
    Utilities.CreateCorner(header, 12)
    header.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 20, 0, 10)
    title.Text = "🎮 Script Loader"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextColor3 = COLORS.Text
    title.BackgroundTransparency = 1
    title.Parent = header
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 20)
    subtitle.Position = UDim2.new(0, 20, 0, 40)
    subtitle.Text = "Select a script to load"
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.TextColor3 = COLORS.TextDim
    subtitle.BackgroundTransparency = 1
    subtitle.Parent = header
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 20)
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = COLORS.Text
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    closeBtn.BorderSizePixel = 0
    Utilities.CreateCorner(closeBtn, 15)
    Utilities.ApplyHoverEffect(closeBtn, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 60))
    closeBtn.Parent = frame
    
    -- Tabs
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(1, -40, 0, 40)
    tabsFrame.Position = UDim2.new(0, 20, 0, 80)
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.Parent = frame
    
    local universalTab = Instance.new("TextButton")
    universalTab.Size = UDim2.new(0.5, -5, 1, 0)
    universalTab.Position = UDim2.new(0, 0, 0, 0)
    universalTab.Text = "🌐 Universal"
    universalTab.Font = Enum.Font.GothamBold
    universalTab.TextSize = 14
    universalTab.TextColor3 = COLORS.Text
    universalTab.BackgroundColor3 = COLORS.Universal
    universalTab.BorderSizePixel = 0
    Utilities.CreateCorner(universalTab, 6)
    universalTab.Parent = tabsFrame
    
    local gameTab = Instance.new("TextButton")
    gameTab.Size = UDim2.new(0.5, -5, 1, 0)
    gameTab.Position = UDim2.new(0.5, 5, 0, 0)
    gameTab.Text = "🎮 Game Specific"
    gameTab.Font = Enum.Font.GothamBold
    gameTab.TextSize = 14
    gameTab.TextColor3 = COLORS.Text
    gameTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    gameTab.BorderSizePixel = 0
    Utilities.CreateCorner(gameTab, 6)
    Utilities.ApplyHoverEffect(gameTab, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))
    gameTab.Parent = tabsFrame
    
    -- Scripts Container
    local scriptsContainer = Instance.new("ScrollingFrame")
    scriptsContainer.Size = UDim2.new(1, -40, 0, 350)
    scriptsContainer.Position = UDim2.new(0, 20, 0, 130)
    scriptsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    scriptsContainer.BorderSizePixel = 0
    scriptsContainer.ScrollBarThickness = 4
    scriptsContainer.ScrollBarImageColor3 = COLORS.Primary
    Utilities.CreateCorner(scriptsContainer, 8)
    scriptsContainer.Parent = frame
    
    local layout = Instance.new("UIListLayout", scriptsContainer)
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    return {
        Frame = frame,
        Tabs = {
            Universal = universalTab,
            Game = gameTab
        },
        ScriptsContainer = scriptsContainer,
        CloseButton = closeBtn
    }
end

-- Populate Scripts List
function UIBuilder.PopulateScripts(container, scripts, tabName)
    -- Clear existing
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Check if empty
    if next(scripts) == nil then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 0, 100)
        emptyLabel.Text = tabName == "universal" 
            and "No universal scripts available" 
            or "No game-specific scripts available"
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 16
        emptyLabel.TextColor3 = COLORS.TextDim
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.TextWrapped = true
        emptyLabel.Parent = container
        return
    end
    
    -- Create script buttons
    for name, url in pairs(scripts) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 50)
        button.Text = name
        button.Font = Enum.Font.GothamBold
        button.TextSize = 16
        button.TextColor3 = COLORS.Text
        button.BackgroundColor3 = tabName == "universal" 
            and Color3.fromRGB(60, 25, 100) 
            or Color3.fromRGB(25, 60, 40)
        button.BorderSizePixel = 0
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.PaddingLeft = UDim.new(0, 15)
        Utilities.CreateCorner(button, 6)
        
        local hoverColor = tabName == "universal" and COLORS.Universal or COLORS.Game
        Utilities.ApplyHoverEffect(button, button.BackgroundColor3, hoverColor)
        
        button.MouseButton1Click:Connect(function()
            ScriptLoader.Load(url, name, tabName)
        end)
        
        button.Parent = container
    end
    
    -- Update canvas size
    container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

--======================================================================--
-- MAIN APPLICATION
--======================================================================--

local WarpKeySystem = {
    CurrentTab = "universal",
    Initialized = false
}

function WarpKeySystem.Initialize()
    if WarpKeySystem.Initialized then
        return
    end
    
    -- Create UI
    UI.Main = UIBuilder.CreateMainGUI()
    UI.Icon = UIBuilder.CreateIcon(UI.Main)
    UI.KeyInput = UIBuilder.CreateKeyInputFrame(UI.Main)
    UI.ScriptSelection = UIBuilder.CreateScriptSelectionFrame(UI.Main)
    
    -- Set up event handlers
    WarpKeySystem.SetupEventHandlers()
    
    -- Initialize scripts list
    WarpKeySystem.UpdateScriptsList()
    
    -- Set up input handling
    WarpKeySystem.SetupInputHandling()
    
    WarpKeySystem.Initialized = true
    Notification.Info("Warp Key System Loaded!", 2)
end

function WarpKeySystem.SetupEventHandlers()
    -- Icon click
    UI.Icon.MouseButton1Click:Connect(function()
        if Storage.IsKeyVerified() then
            UI.KeyInput.Frame.Visible = false
            UI.ScriptSelection.Frame.Visible = not UI.ScriptSelection.Frame.Visible
            if UI.ScriptSelection.Frame.Visible then
                WarpKeySystem.UpdateScriptsList()
            end
        else
            UI.KeyInput.Frame.Visible = not UI.KeyInput.Frame.Visible
        end
    end)
    
    -- Key verification
    UI.KeyInput.SubmitButton.MouseButton1Click:Connect(function()
        local input = UI.KeyInput.Input.Text
        
        if input == CONFIG.CORRECT_KEY then
            Storage.SaveKeyData()
            Notification.Success("Key verified successfully!")
            UI.KeyInput.Frame.Visible = false
            UI.ScriptSelection.Frame.Visible = true
            WarpKeySystem.UpdateScriptsList()
        else
            Notification.Error("Invalid key! Please check and try again.")
        end
    end)
    
    -- Discord button
    UI.KeyInput.DiscordButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(CONFIG.DISCORD_LINK)
            Notification.Info("Discord link copied to clipboard!")
        end
        
        -- Try to open link
        pcall(function()
            if syn and syn.request then
                syn.request({ Url = CONFIG.DISCORD_LINK, Method = "GET" })
            elseif request then
                request({ Url = CONFIG.DISCORD_LINK, Method = "GET" })
            end
        end)
    end)
    
    -- Close buttons
    UI.KeyInput.CloseButton.MouseButton1Click:Connect(function()
        UI.KeyInput.Frame.Visible = false
    end)
    
    UI.ScriptSelection.CloseButton.MouseButton1Click:Connect(function()
        UI.ScriptSelection.Frame.Visible = false
    end)
    
    -- Tab switching
    UI.ScriptSelection.Tabs.Universal.MouseButton1Click:Connect(function()
        WarpKeySystem.CurrentTab = "universal"
        UI.ScriptSelection.Tabs.Universal.BackgroundColor3 = COLORS.Universal
        UI.ScriptSelection.Tabs.Game.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        WarpKeySystem.UpdateScriptsList()
    end)
    
    UI.ScriptSelection.Tabs.Game.MouseButton1Click:Connect(function()
        WarpKeySystem.CurrentTab = "game"
        UI.ScriptSelection.Tabs.Game.BackgroundColor3 = COLORS.Game
        UI.ScriptSelection.Tabs.Universal.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        WarpKeySystem.UpdateScriptsList()
    end)
end

function WarpKeySystem.UpdateScriptsList()
    local scripts = ScriptLoader.GetScriptsForTab(WarpKeySystem.CurrentTab)
    UIBuilder.PopulateScripts(UI.ScriptSelection.ScriptsContainer, scripts, WarpKeySystem.CurrentTab)
end

function WarpKeySystem.SetupInputHandling()
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.Escape then
            if UI.ScriptSelection.Frame.Visible then
                UI.ScriptSelection.Frame.Visible = false
            elseif UI.KeyInput.Frame.Visible then
                UI.KeyInput.Frame.Visible = false
            end
        end
    end)
end

function WarpKeySystem.HandleAutoLoad()
    if Storage.IsKeyVerified() then
        UI.Icon.Visible = true
        UI.KeyInput.Frame.Visible = false
        
        -- Try to load last used script
        local scriptType, scriptName = Storage.LoadKeyData()
        
        if scriptType and scriptName then
            local scripts = scriptType == "universal" 
                and SCRIPT_DB.Universal 
                or GameScripts
            
            local scriptUrl = scripts[scriptName]
            
            if scriptUrl then
                task.wait(1) -- Wait for game to load
                ScriptLoader.Load(scriptUrl, scriptName, scriptType)
            else
                Notification.Info("Welcome back! Select a script to load.")
                UI.ScriptSelection.Frame.Visible = true
                WarpKeySystem.UpdateScriptsList()
            end
        else
            Notification.Info("Welcome! Select a script to load.")
            UI.ScriptSelection.Frame.Visible = true
            WarpKeySystem.UpdateScriptsList()
        end
    else
        UI.Icon.Visible = true
        UI.KeyInput.Frame.Visible = true
    end
end

--======================================================================--
-- INITIALIZATION
--======================================================================--

-- Initialize the system
WarpKeySystem.Initialize()

-- Handle auto-load after a short delay
task.spawn(function()
    task.wait(1)
    WarpKeySystem.HandleAutoLoad()
end)

-- Return the system for external access if needed
return WarpKeySystem
