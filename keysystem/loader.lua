-- Warp Key System - UPDATED WITH GAME CHECK

local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local tw = game:GetService("TweenService")
local sg = game:GetService("StarterGui")
local http = game:GetService("HttpService")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local CORRECT_KEY = "warpkey"
local DISCORD_LINK = "https://discord.gg/8Et7h9ZY"

-- SUPPORTED GAMES
local GAME_SCRIPTS = {
    [88929752766075] = "https://raw.githubusercontent.com/adubwon/geekUI/main/Games/BladeBattle.lua",
    [109397169461300] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    [286090429] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    [2788229376] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    [85509428618863] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/WormIO.lua",
    [116610479068550] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/ClassClash.lua",
    [133614490579000] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/Laser%20A%20Planet.lua",
    [8737602449] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/PlsDonate.lua",
    [292439477] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    [17625359962] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    [3623096087] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/musclelegends.lua",
}

local CURRENT_PLACE_ID = game.PlaceId
local SCRIPT_TO_LOAD = GAME_SCRIPTS[CURRENT_PLACE_ID]

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
        tw:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        tw:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = base}):Play()
    end)
end

--------------------------------------------------
-- FILE HANDLING
--------------------------------------------------

local function saveKeyData()
    pcall(function()
        writefile(KEY_STORAGE_FILE, http:JSONEncode({
            key_verified = true,
            user_id = plr.UserId,
            saved_key = CORRECT_KEY
        }))
    end)
end

local function loadKeyData()
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
-- LOAD SCRIPT
--------------------------------------------------

local function loadMainScript()
    if not SCRIPT_TO_LOAD then
        notify("Error", "No script available for this game.", 3)
        return
    end

    local ok, err = pcall(function()
        loadstring(game:HttpGet(SCRIPT_TO_LOAD))()
    end)

    if ok then
        notify("Success", "Script loaded successfully!", 3)
    else
        notify("Error", tostring(err), 5)
    end
end

--------------------------------------------------
-- CREATE UI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "WarpKeySystem"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local iconBtn = Instance.new("ImageButton", gui)
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

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 320)
frame.Position = UDim2.new(0.5, -210, 0.5, -160)
frame.BackgroundColor3 = COLORS.Background
frame.Visible = true
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

createCorner(frame, 20)
createStroke(frame, COLORS.Primary)
createGlow(frame, COLORS.Primary)

--------------------------------------------------
-- HEADER
--------------------------------------------------

local header = Instance.new("Frame", frame)
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

local inputFrame = Instance.new("Frame", frame)
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

local submit = Instance.new("TextButton", frame)
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

local getKey = Instance.new("TextButton", frame)
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
-- AUTO LOAD (MOVED AFTER UI CREATION)
--------------------------------------------------

local function handleAutoLoad()
    if loadKeyData() and SCRIPT_TO_LOAD then
        -- Hide both the frame AND the icon button
        frame.Visible = false
        iconBtn.Visible = false

        notify("Verified", "Loading script...", 2)
        task.wait(0.5)
        loadMainScript()
    end
end

-- Run auto-load after UI is created
handleAutoLoad()

--------------------------------------------------
-- LOGIC
--------------------------------------------------

submit.MouseButton1Click:Connect(function()
    if keyBox.Text == CORRECT_KEY then
        saveKeyData()
        notify("Success", "Key verified!", 3)

        -- Hide both UI elements before loading script
        frame.Visible = false
        iconBtn.Visible = false

        loadMainScript()
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
    frame.Visible = not frame.Visible
end)

--------------------------------------------------
-- END
--------------------------------------------------
