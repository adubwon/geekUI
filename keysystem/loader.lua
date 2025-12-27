-- Warp Key System - FIXED WITH PROPER SCRIPT SELECTION UI

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

-- SUPPORTED GAMES WITH MULTIPLE OPTIONS FOR SAME PLACE ID
local GAME_SCRIPTS = {
    -- Format: [PlaceId] = {ScriptName = "URL", ScriptName2 = "URL2", ...}
    [88929752766075] = {
        ["Blade Battle"] = "https://raw.githubusercontent.com/adubwon/geekUI/main/Games/BladeBattle.lua",
        ["Blade Battle Alt"] = "https://raw.githubusercontent.com/adubwon/geekUI/main/Games/BladeBattle_Alt.lua"
    },
    [109397169461300] = {
        ["Universal Warp"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua"
    },
    [286090429] = {
        ["Universal Warp"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
        ["Arsenal Enhanced"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/ArsenalEnhanced.lua"
    },
    [2788229376] = {
        ["Universal Warp"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua"
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
    [292439477] = {
        ["Universal Warp"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua"
    },
    [17625359962] = {
        ["Universal Warp"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua"
    },
    [3623096087] = {
        ["Muscle Legends"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/musclelegends.lua",
        ["Private server"] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/privateserver.lua"
    },
}

local CURRENT_PLACE_ID = game.PlaceId
local AVAILABLE_SCRIPTS = GAME_SCRIPTS[CURRENT_PLACE_ID]

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
}

--------------------------------------------------
-- HELPERS
--------------------------------------------------

local function notify(title, text, dur)
    pcall(function()
        sg:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = dur or 3
        })
    end)
end

local function tween(obj, props, time, style)
    tw:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quad), props):Play()
end

local function createCorner(obj, r)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, r or 10)
end

local function createStroke(obj, color, thickness)
    local s = Instance.new("UIStroke", obj)
    s.Color = color
    s.Thickness = thickness or 2
end

local function createGlow(parent, color)
    local g = Instance.new("ImageLabel", parent)
    g.Size = UDim2.new(1, 30, 1, 30)
    g.Position = UDim2.new(0, -15, 0, -15)
    g.BackgroundTransparency = 1
    g.Image = "rbxassetid://94551274981295"
    g.ImageColor3 = color
    g.ImageTransparency = 0.6
    g.ZIndex = 0
    return g
end

-- Hover animation
local function hover(btn, base, hover)
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

local function saveKeyData(scriptName)
    pcall(function()
        writefile(KEY_STORAGE_FILE, http:JSONEncode({
            key_verified = true,
            user_id = plr.UserId,
            saved_key = CORRECT_KEY,
            last_script = scriptName or "default",
            saved_at = os.time()
        }))
    end)
end

local function loadKeyData()
    local success, result = pcall(function()
        if isfile(KEY_STORAGE_FILE) then
            local data = http:JSONDecode(readfile(KEY_STORAGE_FILE))
            if data.key_verified and data.user_id == plr.UserId and data.saved_key == CORRECT_KEY then
                return data.last_script
            end
        end
        return nil
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
-- SCRIPT SELECTION UI (Looks like key system)
--------------------------------------------------

local selectionGui = nil

local function showScriptSelection()
    if not AVAILABLE_SCRIPTS then
        notify("Error", "No scripts available for this game.", 3)
        return nil
    end
    
    local scriptCount = 0
    for _ in pairs(AVAILABLE_SCRIPTS) do
        scriptCount = scriptCount + 1
    end
    
    if scriptCount == 0 then
        notify("Error", "No scripts available for this game.", 3)
        return nil
    end
    
    -- Destroy existing selection GUI if it exists
    if selectionGui and selectionGui.Parent then
        selectionGui:Destroy()
    end
    
    -- Create selection GUI (similar to key system)
    selectionGui = Instance.new("ScreenGui")
    selectionGui.Name = "ScriptSelection"
    selectionGui.ResetOnSpawn = false
    selectionGui.Parent = game.CoreGui
    
    local mainFrame = Instance.new("Frame", selectionGui)
    mainFrame.Size = UDim2.new(0, 450, 0, 100 + (scriptCount * 60))
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -(50 + (scriptCount * 30)))
    mainFrame.BackgroundColor3 = COLORS.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    createCorner(mainFrame, 20)
    createStroke(mainFrame, COLORS.Primary)
    createGlow(mainFrame, COLORS.Primary)
    
    -- Header
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 70)
    header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    header.BorderSizePixel = 0
    createCorner(header, 20)
    
    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -40, 0, 40)
    title.Position = UDim2.new(0, 20, 0, 15)
    title.Text = "Select Script"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = COLORS.Text
    title.BackgroundTransparency = 1
    
    local subtitle = Instance.new("TextLabel", header)
    subtitle.Size = UDim2.new(1, -40, 0, 20)
    subtitle.Position = UDim2.new(0, 20, 0, 45)
    subtitle.Text = "Choose a script to load for this game"
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.TextColor3 = COLORS.TextDim
    subtitle.BackgroundTransparency = 1
    
    -- Script buttons
    local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
    scrollFrame.Size = UDim2.new(1, -40, 0, scriptCount * 55)
    scrollFrame.Position = UDim2.new(0, 20, 0, 85)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scriptCount * 55)
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = COLORS.Primary
    
    local buttonLayout = Instance.new("UIListLayout", scrollFrame)
    buttonLayout.Padding = UDim.new(0, 10)
    
    local selectedScript = nil
    local selectedScriptName = nil
    
    for name, url in pairs(AVAILABLE_SCRIPTS) do
        local scriptBtn = Instance.new("TextButton", scrollFrame)
        scriptBtn.Size = UDim2.new(1, 0, 0, 50)
        scriptBtn.Text = name
        scriptBtn.Font = Enum.Font.GothamBold
        scriptBtn.TextSize = 16
        scriptBtn.TextColor3 = COLORS.Text
        scriptBtn.BackgroundColor3 = COLORS.Frame
        scriptBtn.BorderSizePixel = 0
        createCorner(scriptBtn, 10)
        createStroke(scriptBtn, Color3.fromRGB(60, 60, 60))
        
        hover(scriptBtn, COLORS.Frame, COLORS.Primary)
        
        scriptBtn.MouseButton1Click:Connect(function()
            selectedScript = url
            selectedScriptName = name
            selectionGui:Destroy()
        end)
    end
    
    -- Cancel button
    local cancelBtn = Instance.new("TextButton", mainFrame)
    cancelBtn.Size = UDim2.new(1, -40, 0, 45)
    cancelBtn.Position = UDim2.new(0, 20, 1, -55)
    cancelBtn.Text = "Cancel"
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.TextSize = 15
    cancelBtn.TextColor3 = COLORS.Text
    cancelBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    cancelBtn.BorderSizePixel = 0
    createCorner(cancelBtn, 10)
    
    hover(cancelBtn, Color3.fromRGB(60, 60, 60), Color3.fromRGB(80, 80, 80))
    
    cancelBtn.MouseButton1Click:Connect(function()
        selectionGui:Destroy()
        selectedScript = nil
    end)
    
    -- Wait for selection
    while selectionGui and selectionGui.Parent do
        task.wait()
    end
    
    return selectedScript, selectedScriptName
end

--------------------------------------------------
-- LOAD SCRIPT
--------------------------------------------------

local function loadSelectedScript(scriptUrl, scriptName)
    if not scriptUrl then
        notify("Error", "No script URL provided.", 3)
        return false
    end
    
    local ok, err = pcall(function()
        loadstring(game:HttpGet(scriptUrl))()
    end)

    if ok then
        notify("Success", string.format("'%s' loaded successfully!", scriptName), 3)
        -- Save the selected script name
        if scriptName then
            saveKeyData(scriptName)
        end
        return true
    else
        notify("Error", "Failed to load script: " .. tostring(err), 5)
        return false
    end
end

--------------------------------------------------
-- CREATE MAIN UI
--------------------------------------------------

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "WarpKeySystem"
mainGui.ResetOnSpawn = false
mainGui.Parent = game.CoreGui

local iconBtn = Instance.new("ImageButton", mainGui)
iconBtn.Size = UDim2.new(0, 70, 0, 70)
iconBtn.Position = UDim2.new(0, 20, 0, 20)
iconBtn.Image = "rbxassetid://90013112630319"
iconBtn.BackgroundColor3 = COLORS.Background
iconBtn.AutoButtonColor = false
iconBtn.BorderSizePixel = 0
iconBtn.Active = true
iconBtn.Draggable = true

createCorner(iconBtn, 16)
createStroke(iconBtn, COLORS.Primary)
createGlow(iconBtn, COLORS.Primary)

--------------------------------------------------
-- MAIN FRAME
--------------------------------------------------

local mainFrame = Instance.new("Frame", mainGui)
mainFrame.Size = UDim2.new(0, 420, 0, 320)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
mainFrame.BackgroundColor3 = COLORS.Background
mainFrame.Visible = false
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

createCorner(mainFrame, 20)
createStroke(mainFrame, COLORS.Primary)
createGlow(mainFrame, COLORS.Primary)

--------------------------------------------------
-- HEADER
--------------------------------------------------

local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 80)
header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
header.BorderSizePixel = 0
createCorner(header, 20)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 20, 0, 20)
title.Text = "Warp Key System"
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1

--------------------------------------------------
-- INPUT
--------------------------------------------------

local inputFrame = Instance.new("Frame", mainFrame)
inputFrame.Size = UDim2.new(1, -40, 0, 50)
inputFrame.Position = UDim2.new(0, 20, 0, 120)
inputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
inputFrame.BorderSizePixel = 0
createCorner(inputFrame, 12)

local inputStroke = createStroke(inputFrame, Color3.fromRGB(40, 40, 40))

local keyBox = Instance.new("TextBox", inputFrame)
keyBox.Size = UDim2.new(1, -20, 1, 0)
keyBox.Position = UDim2.new(0, 10, 0, 0)
keyBox.PlaceholderText = "Enter key..."
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.BackgroundTransparency = 1
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 15

--------------------------------------------------
-- BUTTONS
--------------------------------------------------

local submit = Instance.new("TextButton", mainFrame)
submit.Size = UDim2.new(1, -40, 0, 50)
submit.Position = UDim2.new(0, 20, 0, 190)
submit.Text = "Verify Key"
submit.Font = Enum.Font.GothamBold
submit.TextSize = 16
submit.TextColor3 = Color3.fromRGB(255, 255, 255)
submit.BackgroundColor3 = COLORS.Primary
submit.BorderSizePixel = 0

createCorner(submit, 12)
createGlow(submit, COLORS.Primary)

local getKey = Instance.new("TextButton", mainFrame)
getKey.Size = UDim2.new(1, -40, 0, 45)
getKey.Position = UDim2.new(0, 20, 0, 250)
getKey.Text = "Get Key"
getKey.Font = Enum.Font.GothamBold
getKey.TextSize = 15
getKey.TextColor3 = Color3.fromRGB(255, 255, 255)
getKey.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
getKey.BorderSizePixel = 0

createCorner(getKey, 12)

hover(submit, COLORS.Primary, Color3.fromRGB(0, 180, 255))
hover(getKey, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 60))

--------------------------------------------------
-- PROCESS SCRIPT LOADING
--------------------------------------------------

local function processScriptLoading()
    if not AVAILABLE_SCRIPTS then
        notify("Error", "No scripts available for this game.", 3)
        mainFrame.Visible = true
        iconBtn.Visible = true
        return
    end
    
    local scriptCount = 0
    for _ in pairs(AVAILABLE_SCRIPTS) do
        scriptCount = scriptCount + 1
    end
    
    if scriptCount == 0 then
        notify("Error", "No scripts available for this game.", 3)
        mainFrame.Visible = true
        iconBtn.Visible = true
    else
        -- Show script selection UI
        local scriptUrl, scriptName = showScriptSelection()
        if scriptUrl and scriptName then
            loadSelectedScript(scriptUrl, scriptName)
        else
            -- If user cancelled, show the main UI again
            mainFrame.Visible = true
            iconBtn.Visible = true
        end
    end
end

--------------------------------------------------
-- AUTO LOAD
--------------------------------------------------

local function handleAutoLoad()
    if isKeyVerified() and AVAILABLE_SCRIPTS then
        -- Hide main UI
        mainFrame.Visible = false
        iconBtn.Visible = true
        
        -- Check if we have a saved script preference
        local lastScript = loadKeyData()
        local scriptCount = 0
        for _ in pairs(AVAILABLE_SCRIPTS) do
            scriptCount = scriptCount + 1
        end
        
        if scriptCount == 1 then
            -- Only one script, load it directly
            for name, url in pairs(AVAILABLE_SCRIPTS) do
                loadSelectedScript(url, name)
                break
            end
        elseif lastScript and AVAILABLE_SCRIPTS[lastScript] then
            -- Load last used script
            loadSelectedScript(AVAILABLE_SCRIPTS[lastScript], lastScript)
        else
            -- Multiple scripts, show selection
            notify("Verified", "Select a script to load...", 2)
            task.wait(0.5)
            processScriptLoading()
        end
    else
        -- Key not verified, show the main UI
        mainFrame.Visible = true
        iconBtn.Visible = true
    end
end

-- Run auto-load
handleAutoLoad()

--------------------------------------------------
-- LOGIC
--------------------------------------------------

submit.MouseButton1Click:Connect(function()
    if keyBox.Text == CORRECT_KEY then
        saveKeyData("default")
        notify("Success", "Key verified!", 3)
        
        -- Hide main UI
        mainFrame.Visible = false
        
        -- Process script loading
        processScriptLoading()
    else
        notify("Invalid Key", "Wrong key entered.", 3)
    end
end)

getKey.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_LINK)
    end

    pcall(function()
        if syn and syn.request then
            syn.request({ Url = DISCORD_LINK, Method = "GET" })
        elseif request then
            request({ Url = DISCORD_LINK, Method = "GET" })
        end
    end)

    notify("Copied!", "Discord invite copied.", 3)
end)

iconBtn.MouseButton1Click:Connect(function()
    if isKeyVerified() then
        -- If key is already verified, show script selection
        mainFrame.Visible = false
        processScriptLoading()
    else
        -- If key not verified, show the main frame
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Close main frame when pressing escape
uis.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Escape and mainFrame.Visible then
        mainFrame.Visible = false
    end
end)
