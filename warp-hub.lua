-- warp-hub.lua
-- WarpHub UI Library - Loadstring Version
-- Load with: local WarpHub = loadstring(game:HttpGet("URL_TO_THIS_FILE"))()

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

local isMobile = UserInputService.TouchEnabled

-- Create the main WarpHub table
local WarpHub = {}
WarpHub.__index = WarpHub

-- Configuration
WarpHub.Config = {
    GlassTransparency = 0.15,
    DarkGlassTransparency = 0.1,
    CornerRadius = isMobile and 12 or 18,
    AccentColor = Color3.fromRGB(168, 128, 255),
    SecondaryColor = Color3.fromRGB(128, 96, 255),
    GlassColor = Color3.fromRGB(25, 25, 35),
    DarkGlassColor = Color3.fromRGB(15, 15, 22),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(200, 200, 220),
    ButtonColor = Color3.fromRGB(35, 35, 45),
    ButtonHoverColor = Color3.fromRGB(168, 128, 255),
    InputBackground = Color3.fromRGB(40, 40, 50),
    SliderTrack = Color3.fromRGB(45, 45, 55),
    SliderFill = Color3.fromRGB(168, 128, 255),
    DropdownBackground = Color3.fromRGB(40, 40, 50),
    DropdownHover = Color3.fromRGB(50, 50, 60)
}

-- Helper functions
local function createFrame(parent, size, position, transparency, color, cornerRadius)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color or WarpHub.Config.GlassColor
    frame.BackgroundTransparency = transparency or WarpHub.Config.GlassTransparency
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius or WarpHub.Config.CornerRadius)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = color or WarpHub.Config.GlassColor
    stroke.Thickness = 1.5
    stroke.Transparency = 0.6
    stroke.Parent = frame

    if parent then
        frame.Parent = parent
    end
    
    return frame
end

-- Notification System
function WarpHub:Notify(title, message, duration, notificationType)
    local duration = duration or 2.5
    local notificationType = notificationType or "info"
    
    -- Create notification GUI
    local notificationGUI = Instance.new("ScreenGui")
    notificationGUI.Name = "WarpHubNotification_" .. HttpService:GenerateGUID(false)
    notificationGUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
    notificationGUI.ResetOnSpawn = false
    
    -- Calculate notification size
    local titleHeight = isMobile and 28 or 32
    local messageHeight = isMobile and 40 or 44
    local padding = isMobile and 12 or 16
    local totalHeight = titleHeight + messageHeight + padding
    
    -- Determine width
    local titleTextSize = TextService:GetTextSize(title or "Notification", isMobile and 16 or 18, Enum.Font.GothamBold, Vector2.new(400, 50))
    local messageTextSize = TextService:GetTextSize(message or "", isMobile and 13 or 14, Enum.Font.GothamMedium, Vector2.new(400, 100))
    local maxWidth = math.max(titleTextSize.X, messageTextSize.X) + 80
    local notificationWidth = math.clamp(maxWidth, isMobile and 280 or 320, isMobile and 360 or 420)
    
    -- Position at top middle
    local screenWidth = workspace.CurrentCamera.ViewportSize.X
    local xPosition = (screenWidth - notificationWidth) / 2
    
    local mainFrame = createFrame(nil, UDim2.new(0, notificationWidth, 0, totalHeight), 
        UDim2.new(0, xPosition, 0, -totalHeight), 
        0.05, WarpHub.Config.DarkGlassColor, isMobile and 10 or 14)
    
    -- Add border effect
    local borderFrame = Instance.new("Frame")
    borderFrame.Size = UDim2.new(1, 0, 1, 0)
    borderFrame.Position = UDim2.new(0, 0, 0, 0)
    borderFrame.BackgroundTransparency = 1
    borderFrame.ZIndex = 2
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, isMobile and 10 or 14)
    borderCorner.Parent = borderFrame
    
    local borderStroke = Instance.new("UIStroke")
    borderStroke.Color = WarpHub.Config.AccentColor
    borderStroke.Thickness = 2
    borderStroke.Transparency = 0.3
    borderStroke.Parent = borderFrame
    
    -- Title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -padding * 2, 0, titleHeight)
    titleLabel.Position = UDim2.new(0, padding, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.TextColor3 = WarpHub.Config.AccentColor
    titleLabel.TextSize = isMobile and 16 or 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    
    -- Title gradient
    local titleGlow = Instance.new("UIGradient")
    titleGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WarpHub.Config.AccentColor),
        ColorSequenceKeypoint.new(0.7, WarpHub.Config.SecondaryColor),
        ColorSequenceKeypoint.new(1, WarpHub.Config.AccentColor)
    })
    titleGlow.Parent = titleLabel
    
    -- Message label
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -padding * 2, 0, messageHeight)
    messageLabel.Position = UDim2.new(0, padding, 0, titleHeight)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message or ""
    messageLabel.TextColor3 = WarpHub.Config.TextColor
    messageLabel.TextSize = isMobile and 13 or 14
    messageLabel.Font = Enum.Font.GothamMedium
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.TextTruncate = Enum.TextTruncate.AtEnd
    messageLabel.LineHeight = 1.2
    
    -- Progress bar for duration
    local progressBarContainer = Instance.new("Frame")
    progressBarContainer.Size = UDim2.new(1, -padding * 2, 0, 2)
    progressBarContainer.Position = UDim2.new(0, padding, 1, -6)
    progressBarContainer.BackgroundColor3 = WarpHub.Config.GlassColor
    progressBarContainer.BackgroundTransparency = 0.5
    progressBarContainer.BorderSizePixel = 0
    
    local progressBarCorner = Instance.new("UICorner")
    progressBarCorner.CornerRadius = UDim.new(1, 0)
    progressBarCorner.Parent = progressBarContainer
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.BackgroundColor3 = WarpHub.Config.AccentColor
    progressBar.BorderSizePixel = 0
    
    local progressBarInnerCorner = Instance.new("UICorner")
    progressBarInnerCorner.CornerRadius = UDim.new(1, 0)
    progressBarInnerCorner.Parent = progressBar
    
    local progressGradient = Instance.new("UIGradient")
    progressGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WarpHub.Config.AccentColor),
        ColorSequenceKeypoint.new(1, WarpHub.Config.SecondaryColor)
    })
    progressGradient.Parent = progressBar
    
    -- Icon for notification
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, isMobile and 20 or 22, 0, isMobile and 20 or 22)
    icon.Position = UDim2.new(1, -(padding + isMobile and 20 or 22), 0, padding / 2)
    icon.BackgroundTransparency = 1
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Set icon based on type
    local iconAsset = "rbxassetid://6031094678"
    local iconColor = WarpHub.Config.AccentColor
    
    if notificationType == "success" then
        iconAsset = "rbxassetid://6031094667"
        iconColor = Color3.fromRGB(85, 255, 127)
    elseif notificationType == "warning" then
        iconAsset = "rbxassetid://6031094669"
        iconColor = Color3.fromRGB(255, 100, 100)
    elseif notificationType == "error" then
        iconAsset = "rbxassetid://6031094670"
        iconColor = Color3.fromRGB(255, 170, 0)
    end
    
    icon.Image = iconAsset
    icon.ImageColor3 = iconColor
    
    -- Assemble GUI
    borderFrame.Parent = mainFrame
    titleLabel.Parent = mainFrame
    messageLabel.Parent = mainFrame
    progressBar.Parent = progressBarContainer
    progressBarContainer.Parent = mainFrame
    icon.Parent = mainFrame
    mainFrame.Parent = notificationGUI
    notificationGUI.Parent = CoreGui
    
    -- Store active notifications
    if not WarpHub.ActiveNotifications then
        WarpHub.ActiveNotifications = {}
    end
    
    local notificationId = #WarpHub.ActiveNotifications + 1
    WarpHub.ActiveNotifications[notificationId] = {
        frame = mainFrame,
        id = notificationId,
        duration = duration
    }
    
    -- Position notification
    local verticalOffset = 0
    for i, notif in ipairs(WarpHub.ActiveNotifications) do
        if notif.id ~= notificationId then
            verticalOffset = verticalOffset + notif.frame.AbsoluteSize.Y + 8
        end
    end
    
    WarpHub.ActiveNotifications[notificationId].verticalOffset = verticalOffset
    
    -- Slide in animation
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, xPosition, 0, 20 + verticalOffset)
    }):Play()
    
    -- Progress bar animation
    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()
    
    -- Auto-remove after duration
    local removeConnection
    removeConnection = RunService.Heartbeat:Connect(function(dt)
        duration = duration - dt
        if duration <= 0 then
            removeConnection:Disconnect()
            
            -- Slide out animation
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0, xPosition, 0, -totalHeight)
            }):Play()
            
            -- Fade out
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {
                BackgroundTransparency = 1
            }):Play()
            
            TweenService:Create(titleLabel, TweenInfo.new(0.3), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(messageLabel, TweenInfo.new(0.3), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(icon, TweenInfo.new(0.3), {
                ImageTransparency = 1
            }):Play()
            
            -- Remove from active notifications
            for i, notif in ipairs(WarpHub.ActiveNotifications) do
                if notif.id == notificationId then
                    table.remove(WarpHub.ActiveNotifications, i)
                    break
                end
            end
            
            -- Update positions of remaining notifications
            for i, notif in ipairs(WarpHub.ActiveNotifications) do
                local newY = 20 + ((i - 1) * (notif.frame.AbsoluteSize.Y + 8))
                local screenWidth = workspace.CurrentCamera.ViewportSize.X
                local notifWidth = notif.frame.AbsoluteSize.X
                local notifX = (screenWidth - notifWidth) / 2
                TweenService:Create(notif.frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Position = UDim2.new(0, notifX, 0, newY)
                }):Play()
            end
            
            -- Destroy after animation
            task.wait(0.3)
            if notificationGUI and notificationGUI.Parent then
                notificationGUI:Destroy()
            end
        end
    end)
    
    -- Click to dismiss
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
            if removeConnection then
                removeConnection:Disconnect()
            end
            
            -- Quick fade out
            TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, xPosition, 0, 20 + verticalOffset - 30),
                BackgroundTransparency = 1
            }):Play()
            
            TweenService:Create(titleLabel, TweenInfo.new(0.2), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(messageLabel, TweenInfo.new(0.2), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(icon, TweenInfo.new(0.2), {
                ImageTransparency = 1
            }):Play()
            
            -- Remove from active notifications
            for i, notif in ipairs(WarpHub.ActiveNotifications) do
                if notif.id == notificationId then
                    table.remove(WarpHub.ActiveNotifications, i)
                    break
                end
            end
            
            -- Update positions
            for i, notif in ipairs(WarpHub.ActiveNotifications) do
                local newY = 20 + ((i - 1) * (notif.frame.AbsoluteSize.Y + 8))
                local screenWidth = workspace.CurrentCamera.ViewportSize.X
                local notifWidth = notif.frame.AbsoluteSize.X
                local notifX = (screenWidth - notifWidth) / 2
                TweenService:Create(notif.frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Position = UDim2.new(0, notifX, 0, newY)
                }):Play()
            end
            
            task.wait(0.2)
            if notificationGUI and notificationGUI.Parent then
                notificationGUI:Destroy()
            end
        end
    end)
    
    -- Hover effects (desktop only)
    if not isMobile then
        mainFrame.MouseEnter:Connect(function()
            TweenService:Create(mainFrame, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.02
            }):Play()
            TweenService:Create(borderStroke, TweenInfo.new(0.15), {
                Transparency = 0.1
            }):Play()
            TweenService:Create(icon, TweenInfo.new(0.15), {
                Size = UDim2.new(0, isMobile and 22 or 24, 0, isMobile and 22 or 24)
            }):Play()
        end)
        
        mainFrame.MouseLeave:Connect(function()
            TweenService:Create(mainFrame, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.05
            }):Play()
            TweenService:Create(borderStroke, TweenInfo.new(0.15), {
                Transparency = 0.3
            }):Play()
            TweenService:Create(icon, TweenInfo.new(0.15), {
                Size = UDim2.new(0, isMobile and 20 or 22, 0, isMobile and 20 or 22)
            }):Play()
        end)
    end
    
    return notificationId
end

-- Window Creation
function WarpHub:CreateWindow(title)
    local self = setmetatable({}, WarpHub)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "WarpHubUI_" .. HttpService:GenerateGUID(false)
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.ScreenGui.ResetOnSpawn = false
    
    -- Adjust window size
    self.windowWidth = isMobile and 340 or 520
    self.windowHeight = isMobile and 480 or 520
    
    self.MainFrame = createFrame(nil, UDim2.new(0, self.windowWidth, 0, self.windowHeight), 
        UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2), 
        WarpHub.Config.DarkGlassTransparency, WarpHub.Config.DarkGlassColor, isMobile and 16 or 20)

    local sidebarWidth = isMobile and 100 or 150
    local topBarHeight = isMobile and 40 or 50
    
    self.TopBar = createFrame(self.MainFrame, UDim2.new(1, -20, 0, topBarHeight), 
        UDim2.new(0, 10, 0, 10), 0.1, WarpHub.Config.GlassColor, isMobile and 10 or 12)
    
    local titleContainer = Instance.new("Frame")
    titleContainer.Size = UDim2.new(isMobile and 0.6 or 0, isMobile and 0 or 200, 1, 0)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = self.TopBar
    
    local windowTitle = Instance.new("TextLabel")
    windowTitle.Size = UDim2.new(1, -12, 1, 0)
    windowTitle.Position = UDim2.new(0, 12, 0, 0)
    windowTitle.BackgroundTransparency = 1
    windowTitle.Text = title or "Warp Hub"
    windowTitle.TextColor3 = WarpHub.Config.TextColor
    windowTitle.TextSize = isMobile and 18 or 22
    windowTitle.Font = Enum.Font.GothamBlack
    windowTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local titleGlow = Instance.new("UIGradient")
    titleGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WarpHub.Config.AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, WarpHub.Config.SecondaryColor)
    })
    titleGlow.Parent = windowTitle
    windowTitle.Parent = titleContainer
    
    -- Minimize and Close buttons
    self.MinimizeButton = Instance.new("ImageButton")
    self.MinimizeButton.Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
    self.MinimizeButton.Position = UDim2.new(1, isMobile and -60 or -84, 0.5, isMobile and -10 or -12)
    self.MinimizeButton.BackgroundTransparency = 1
    self.MinimizeButton.Image = "rbxassetid://3926305904"
    self.MinimizeButton.ImageRectOffset = Vector2.new(564, 284)
    self.MinimizeButton.ImageRectSize = Vector2.new(36, 36)
    self.MinimizeButton.ImageColor3 = WarpHub.Config.TextColor
    
    self.CloseButton = Instance.new("ImageButton")
    self.CloseButton.Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
    self.CloseButton.Position = UDim2.new(1, isMobile and -30 or -44, 0.5, isMobile and -10 or -12)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Image = "rbxassetid://3926305904"
    self.CloseButton.ImageRectOffset = Vector2.new(284, 4)
    self.CloseButton.ImageRectSize = Vector2.new(24, 24)
    self.CloseButton.ImageColor3 = WarpHub.Config.TextColor
    
    self.Sidebar = createFrame(self.MainFrame, UDim2.new(0, sidebarWidth, 1, -(topBarHeight + 20)), 
        UDim2.new(0, 10, 0, topBarHeight + 16), 0.1, WarpHub.Config.GlassColor, isMobile and 10 or 12)
    
    self.ContentArea = createFrame(self.MainFrame, UDim2.new(1, -(sidebarWidth + 20), 1, -(topBarHeight + 20)), 
        UDim2.new(0, sidebarWidth + 16, 0, topBarHeight + 16), 0.1, WarpHub.Config.GlassColor, isMobile and 10 or 12)
    
    self.SidebarTabs = Instance.new("Frame")
    self.SidebarTabs.Size = UDim2.new(1, -10, 1, -10)
    self.SidebarTabs.Position = UDim2.new(0, 5, 0, 5)
    self.SidebarTabs.BackgroundTransparency = 1
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, isMobile and 6 or 8)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Parent = self.SidebarTabs
    
    self.MinimizeButton.Parent = self.TopBar
    self.CloseButton.Parent = self.TopBar
    self.SidebarTabs.Parent = self.Sidebar
    self.MainFrame.Parent = self.ScreenGui
    self.ScreenGui.Parent = CoreGui
    
    self.isMinimized = false
    self.isClosing = false
    self.tabs = {}
    self.currentTab = nil
    self.dragging = false
    self.dragStart = Vector2.new(0, 0)
    self.startPos = UDim2.new(0, 0, 0, 0)
    
    self:setupWindow()
    
    return self
end

function WarpHub:setupWindow()
    local function toggleMinimize()
        if self.isClosing then return end
        
        if self.isMinimized then
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, self.windowWidth, 0, self.windowHeight),
                Position = UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2)
            }):Play()
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = WarpHub.Config.TextColor
            }):Play()
        else
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, self.windowWidth, 0, 70),
                Position = UDim2.new(0.5, -self.windowWidth/2, 0.5, -35)
            }):Play()
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = WarpHub.Config.AccentColor
            }):Play()
        end
        self.isMinimized = not self.isMinimized
    end
    
    local function closeUI()
        if self.isClosing then return end
        self.isClosing = true
        
        TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.5)
        if self.ScreenGui then
            self.ScreenGui:Destroy()
        end
    end
    
    local function handleDragInput(input, isTouch)
        if (isTouch and input.UserInputType == Enum.UserInputType.Touch) or 
           (not isTouch and input.UserInputType == Enum.UserInputType.MouseButton1) then
            self.dragging = true
            self.dragStart = input.Position
            self.startPos = self.MainFrame.Position
        end
    end
    
    if self.TopBar then
        self.TopBar.InputBegan:Connect(function(input)
            handleDragInput(input, isMobile)
        end)
    end
    
    UserInputService.InputChanged:Connect(function(input)
        if self.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
           (isMobile and input.UserInputType == Enum.UserInputType.Touch)) then
            local delta = input.Position - self.dragStart
            self.MainFrame.Position = UDim2.new(
                self.startPos.X.Scale, 
                self.startPos.X.Offset + delta.X, 
                self.startPos.Y.Scale, 
                self.startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if (isMobile and input.UserInputType == Enum.UserInputType.Touch) or 
           (not isMobile and input.UserInputType == Enum.UserInputType.MouseButton1) then
            self.dragging = false
        end
    end)
    
    if self.MinimizeButton then
        self.MinimizeButton.MouseButton1Click:Connect(toggleMinimize)
        if isMobile then
            self.MinimizeButton.TouchTap:Connect(toggleMinimize)
        end
    end
    
    if self.CloseButton then
        self.CloseButton.MouseButton1Click:Connect(closeUI)
        if isMobile then
            self.CloseButton.TouchTap:Connect(closeUI)
        end
    end
    
    if self.MinimizeButton then
        self.MinimizeButton.MouseEnter:Connect(function()
            if self.isClosing then return end
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = WarpHub.Config.AccentColor,
                Size = UDim2.new(0, isMobile and 22 or 26, 0, isMobile and 22 or 26)
            }):Play()
        end)
        
        self.MinimizeButton.MouseLeave:Connect(function()
            if self.isClosing then return end
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = self.isMinimized and WarpHub.Config.AccentColor or WarpHub.Config.TextColor,
                Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
            }):Play()
        end)
    end
    
    if self.CloseButton then
        self.CloseButton.MouseEnter:Connect(function()
            if self.isClosing then return end
            TweenService:Create(self.CloseButton, TweenInfo.new(0.15), {
                ImageColor3 = Color3.fromRGB(255, 85, 85),
                Size = UDim2.new(0, isMobile and 22 or 26, 0, isMobile and 22 or 26)
            }):Play()
        end)
        
        self.CloseButton.MouseLeave:Connect(function()
            if self.isClosing then return end
            TweenService:Create(self.CloseButton, TweenInfo.new(0.15), {
                ImageColor3 = WarpHub.Config.TextColor,
                Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
            }):Play()
        end)
    end
end

function WarpHub:AddTab(name)
    local tab = {}
    setmetatable(tab, {__index = self})
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -6, 0, isMobile and 36 or 42)
    TabButton.BackgroundColor3 = WarpHub.Config.ButtonColor
    TabButton.BackgroundTransparency = 0.2
    TabButton.AutoButtonColor = false
    TabButton.Text = ""
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = #self.SidebarTabs:GetChildren() + 1
    
    if isMobile then
        TabButton.TouchTap:Connect(function()
            TabButton.MouseButton1Click:Fire()
        end)
    end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, isMobile and 8 or 10)
    corner.Parent = TabButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = WarpHub.Config.GlassColor
    stroke.Thickness = 1.5
    stroke.Transparency = 0.5
    stroke.Parent = TabButton
    
    local buttonText = Instance.new("TextLabel")
    buttonText.Size = UDim2.new(1, -12, 1, 0)
    buttonText.Position = UDim2.new(0, 8, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = name
    buttonText.TextColor3 = WarpHub.Config.SubTextColor
    buttonText.TextSize = isMobile and 12 or 14
    buttonText.Font = Enum.Font.GothamSemibold
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    buttonText.Parent = TabButton
    
    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    
    local TabScrolling = Instance.new("ScrollingFrame")
    TabScrolling.Size = UDim2.new(1, -12, 1, -12)
    TabScrolling.Position = UDim2.new(0, 6, 0, 6)
    TabScrolling.BackgroundTransparency = 1
    TabScrolling.ScrollBarThickness = isMobile and 3 or 4
    TabScrolling.ScrollBarImageColor3 = WarpHub.Config.AccentColor
    TabScrolling.ScrollBarImageTransparency = 0.5
    TabScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, isMobile and 10 or 14)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabScrolling
    
    local tabData = {
        button = TabButton, 
        content = TabContent, 
        scrolling = TabScrolling,
        text = buttonText,
        name = name
    }
    table.insert(self.tabs, tabData)
    
    local function selectTab()
        for _, tData in ipairs(self.tabs) do
            tData.content.Visible = false
            TweenService:Create(tData.button, TweenInfo.new(0.25), {
                BackgroundTransparency = 0.2,
                BackgroundColor3 = WarpHub.Config.ButtonColor
            }):Play()
            TweenService:Create(tData.text, TweenInfo.new(0.25), {
                TextColor3 = WarpHub.Config.SubTextColor
            }):Play()
        end
        
        TabContent.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.1,
            BackgroundColor3 = WarpHub.Config.AccentColor
        }):Play()
        TweenService:Create(buttonText, TweenInfo.new(0.25), {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        
        self.currentTab = tabData
    end
    
    if TabButton then
        TabButton.MouseEnter:Connect(function()
            if self.isClosing then return end
            if not TabContent.Visible then
                TweenService:Create(TabButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.15,
                    BackgroundColor3 = WarpHub.Config.ButtonHoverColor
                }):Play()
                TweenService:Create(buttonText, TweenInfo.new(0.15), {
                    TextColor3 = WarpHub.Config.TextColor
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if self.isClosing then return end
            if not TabContent.Visible then
                TweenService:Create(TabButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.2,
                    BackgroundColor3 = WarpHub.Config.ButtonColor
                }):Play()
                TweenService:Create(buttonText, TweenInfo.new(0.15), {
                    TextColor3 = WarpHub.Config.SubTextColor
                }):Play()
            end
        end)
        
        TabButton.MouseButton1Click:Connect(selectTab)
        
        if isMobile then
            TabButton.TouchTap:Connect(selectTab)
        end
    end
    
    if #self.tabs == 1 then
        task.wait(0.5)
        selectTab()
    end
    
    TabButton.Parent = self.SidebarTabs
    TabScrolling.Parent = TabContent
    TabContent.Parent = self.ContentArea
    
    function tab:AddSection(title)
        local section = {}
        
        local SectionContainer = Instance.new("Frame")
        SectionContainer.Size = UDim2.new(1, -6, 0, 0)
        SectionContainer.Position = UDim2.new(0, 3, 0, 0)
        SectionContainer.BackgroundTransparency = 1
        SectionContainer.LayoutOrder = #TabScrolling:GetChildren() + 1
        
        local SectionHeader = createFrame(SectionContainer, UDim2.new(1, 0, 0, isMobile and 38 or 44), 
            UDim2.new(0, 0, 0, 0), 0.08, WarpHub.Config.GlassColor, isMobile and 8 or 10)
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -12, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = WarpHub.Config.TextColor
        titleLabel.TextSize = isMobile and 14 or 16
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = SectionHeader
        
        local SectionContent = Instance.new("Frame")
        SectionContent.Size = UDim2.new(1, 0, 0, 0)
        SectionContent.Position = UDim2.new(0, 0, 0, isMobile and 42 or 48)
        SectionContent.BackgroundTransparency = 1
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, isMobile and 8 or 10)
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Parent = SectionContent
        
        local function updateSectionHeight()
            local totalHeight = 0
            for _, child in ipairs(SectionContent:GetChildren()) do
                if child:IsA("GuiObject") and child.Visible then
                    totalHeight = totalHeight + child.AbsoluteSize.Y
                end
            end
            totalHeight = totalHeight + (ContentList.Padding.Offset * (#SectionContent:GetChildren() - 1))
            SectionContent.Size = UDim2.new(1, 0, 0, totalHeight)
            SectionContainer.Size = UDim2.new(1, -6, 0, (isMobile and 42 or 48) + totalHeight)
        end
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionHeight)
        
        SectionHeader.Parent = SectionContainer
        SectionContent.Parent = SectionContainer
        SectionContainer.Parent = TabScrolling
        
        function section:AddButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            Button.BackgroundColor3 = WarpHub.Config.ButtonColor
            Button.BackgroundTransparency = 0.15
            Button.AutoButtonColor = false
            Button.Text = ""
            Button.BorderSizePixel = 0
            Button.LayoutOrder = #SectionContent:GetChildren() + 1
            
            if isMobile then
                Button.TouchTap:Connect(function()
                    Button.MouseButton1Click:Fire()
                end)
            end
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, isMobile and 8 or 10)
            buttonCorner.Parent = Button
            
            local buttonStroke = Instance.new("UIStroke")
            buttonStroke.Color = WarpHub.Config.GlassColor
            buttonStroke.Thickness = 1.5
            buttonStroke.Transparency = 0.5
            buttonStroke.Parent = Button
            
            local buttonText = Instance.new("TextLabel")
            buttonText.Size = UDim2.new(1, -12, 1, 0)
            buttonText.Position = UDim2.new(0, 10, 0, 0)
            buttonText.BackgroundTransparency = 1
            buttonText.Text = name
            buttonText.TextColor3 = WarpHub.Config.TextColor
            buttonText.TextSize = isMobile and 13 or 14
            buttonText.Font = Enum.Font.GothamMedium
            buttonText.TextXAlignment = Enum.TextXAlignment.Left
            buttonText.Parent = Button
            
            local buttonIcon = Instance.new("ImageLabel")
            buttonIcon.Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
            buttonIcon.Position = UDim2.new(1, isMobile and -28 or -32, 0.5, isMobile and -10 or -12)
            buttonIcon.BackgroundTransparency = 1
            buttonIcon.Image = "rbxassetid://6031094667"
            buttonIcon.ImageColor3 = WarpHub.Config.AccentColor
            buttonIcon.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                if callback then 
                    pcall(callback)
                end
                -- Show notification for button click
                if WarpHub and WarpHub.Notify then
                    WarpHub:Notify("Button Pressed", "You clicked: " .. name, 2, "success")
                end
            end)
            
            Button.MouseEnter:Connect(function()
                if self.isClosing then return end
                TweenService:Create(Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.08,
                    BackgroundColor3 = WarpHub.Config.ButtonHoverColor
                }):Play()
                TweenService:Create(buttonStroke, TweenInfo.new(0.15), {
                    Color = WarpHub.Config.AccentColor
                }):Play()
                TweenService:Create(buttonIcon, TweenInfo.new(0.15), {
                    ImageColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                if self.isClosing then return end
                TweenService:Create(Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.15,
                    BackgroundColor3 = WarpHub.Config.ButtonColor
                }):Play()
                TweenService:Create(buttonStroke, TweenInfo.new(0.15), {
                    Color = WarpHub.Config.GlassColor
                }):Play()
                TweenService:Create(buttonIcon, TweenInfo.new(0.15), {
                    ImageColor3 = WarpHub.Config.AccentColor
                }):Play()
            end)
            
            Button.Parent = SectionContent
            updateSectionHeight()
            
            return Button
        end
        
        function section:AddToggle(name, callback)
            local toggleState = false
            
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            Toggle.BackgroundTransparency = 1
            Toggle.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = WarpHub.Config.TextColor
            label.TextSize = isMobile and 13 or 14
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, isMobile and 40 or 46, 0, isMobile and 20 or 24)
            toggleButton.Position = UDim2.new(1, isMobile and -40 or -46, 0.5, isMobile and -10 or -12)
            toggleButton.BackgroundColor3 = WarpHub.Config.ButtonColor
            toggleButton.BackgroundTransparency = 0.15
            toggleButton.AutoButtonColor = false
            toggleButton.Text = ""
            toggleButton.BorderSizePixel = 0
            
            if isMobile then
                toggleButton.TouchTap:Connect(function()
                    toggleButton.MouseButton1Click:Fire()
                end)
            end
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, isMobile and 10 or 12)
            toggleCorner.Parent = toggleButton
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, isMobile and 16 or 20, 0, isMobile and 16 or 20)
            toggleCircle.Position = UDim2.new(0, isMobile and 2 or 2, isMobile and 0.5 or 0.5, isMobile and -8 or -10)
            toggleCircle.BackgroundColor3 = WarpHub.Config.GlassColor
            toggleCircle.BackgroundTransparency = 0.1
            toggleCircle.BorderSizePixel = 0
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = toggleCircle
            
            local function updateToggle()
                if toggleState then
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        Position = UDim2.new(1, isMobile and -18 or -22, isMobile and 0.5 or 0.5, isMobile and -8 or -10),
                        BackgroundColor3 = WarpHub.Config.AccentColor
                    }):Play()
                    TweenService:Create(toggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = WarpHub.Config.AccentColor,
                        BackgroundTransparency = 0.3
                    }):Play()
                else
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        Position = UDim2.new(0, isMobile and 2 or 2, isMobile and 0.5 or 0.5, isMobile and -8 or -10),
                        BackgroundColor3 = WarpHub.Config.GlassColor
                    }):Play()
                    TweenService:Create(toggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = WarpHub.Config.ButtonColor,
                        BackgroundTransparency = 0.15
                    }):Play()
                end
                
                if callback then 
                    pcall(callback, toggleState)
                end
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                toggleState = not toggleState
                updateToggle()
                
                -- Show notification when toggle changes
                if WarpHub and WarpHub.Notify then
                    local status = toggleState and "Enabled" or "Disabled"
                    local notificationType = toggleState and "success" or "warning"
                    WarpHub:Notify("Toggle Updated", name .. ": " .. status, 2, notificationType)
                end
            end)
            
            toggleButton.MouseEnter:Connect(function()
                TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.1
                }):Play()
            end)
            
            toggleButton.MouseLeave:Connect(function()
                TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = toggleState and 0.3 or 0.15
                }):Play()
            end)
            
            toggleCircle.Parent = toggleButton
            label.Parent = Toggle
            toggleButton.Parent = Toggle
            Toggle.Parent = SectionContent
            
            updateToggle()
            updateSectionHeight()
            
            local toggleObj = {
                instance = Toggle,
                state = toggleState,
                Update = function(self, newState)
                    toggleState = newState
                    updateToggle()
                end,
                GetState = function(self)
                    return toggleState
                end
            }
            
            return toggleObj
        end
        
        function section:AddSlider(name, minValue, maxValue, defaultValue, callback)
            local sliderValue = defaultValue or minValue
            local isDragging = false
            
            local Slider = Instance.new("Frame")
            Slider.Size = UDim2.new(1, 0, 0, isMobile and 46 or 50)
            Slider.BackgroundTransparency = 1
            Slider.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, isMobile and 18 or 20)
            label.BackgroundTransparency = 1
            label.Text = name .. ": " .. tostring(sliderValue)
            label.TextColor3 = WarpHub.Config.TextColor
            label.TextSize = isMobile and 13 or 14
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local sliderContainer = Instance.new("Frame")
            sliderContainer.Size = UDim2.new(1, 0, 0, isMobile and 24 or 26)
            sliderContainer.Position = UDim2.new(0, 0, 1, isMobile and -24 or -26)
            sliderContainer.BackgroundTransparency = 1
            
            local track = Instance.new("TextButton")
            track.Size = UDim2.new(1, 0, 0, isMobile and 6 or 7)
            track.Position = UDim2.new(0, 0, isMobile and 0.5 or 0.5, isMobile and -3 or -3.5)
            track.BackgroundColor3 = WarpHub.Config.SliderTrack
            track.BackgroundTransparency = 0.2
            track.AutoButtonColor = false
            track.Text = ""
            track.BorderSizePixel = 0
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = track
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.Position = UDim2.new(0, 0, 0, 0)
            fill.BackgroundColor3 = WarpHub.Config.SliderFill
            fill.BackgroundTransparency = 0
            fill.BorderSizePixel = 0
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = fill
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Size = UDim2.new(0, isMobile and 20 or 22, 0, isMobile and 20 or 22)
            sliderButton.Position = UDim2.new(0, isMobile and -10 or -11, isMobile and 0.5 or 0.5, isMobile and -10 or -11)
            sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderButton.BackgroundTransparency = 0
            sliderButton.AutoButtonColor = false
            sliderButton.Text = ""
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(1, 0)
            buttonCorner.Parent = sliderButton
            
            local buttonStroke = Instance.new("UIStroke")
            buttonStroke.Color = WarpHub.Config.AccentColor
            buttonStroke.Thickness = isMobile and 2 or 2.5
            buttonStroke.Transparency = 0
            buttonStroke.Parent = sliderButton
            
            local function updateSlider(value, showNotification)
                local normalized = (value - minValue) / (maxValue - minValue)
                local fillWidth = track.AbsoluteSize.X * normalized
                
                fill.Size = UDim2.new(normalized, 0, 1, 0)
                sliderButton.Position = UDim2.new(normalized, isMobile and -10 or -11, isMobile and 0.5 or 0.5, isMobile and -10 or -11)
                label.Text = name .. ": " .. tostring(math.floor(value * 100) / 100)
                sliderValue = value
                
                if showNotification and WarpHub and WarpHub.Notify and not isDragging then
                    WarpHub:Notify("Slider Updated", name .. " set to: " .. tostring(math.floor(value * 100) / 100), 1.5, "info")
                end
                
                if callback then
                    pcall(callback, value)
                end
            end
            
            local function onInput(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                   (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
                    isDragging = true
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        local mousePos
                        if isMobile then
                            local touch = UserInputService:GetTouchInputs()
                            if #touch > 0 then
                                mousePos = touch[1].Position
                            end
                        else
                            mousePos = UserInputService:GetMouseLocation()
                        end
                        
                        if mousePos then
                            local trackPos = track.AbsolutePosition
                            local trackSize = track.AbsoluteSize
                            
                            local relativeX = (mousePos.X - trackPos.X) / trackSize.X
                            relativeX = math.clamp(relativeX, 0, 1)
                            
                            local newValue = minValue + (relativeX * (maxValue - minValue))
                            updateSlider(newValue, false)
                        end
                    end)
                    
                    local function onInputEnded(endInput)
                        if endInput.UserInputType == Enum.UserInputType.MouseButton1 or 
                           (isMobile and endInput.UserInputType == Enum.UserInputType.Touch) then
                            if connection then
                                connection:Disconnect()
                            end
                            isDragging = false
                            
                            if WarpHub and WarpHub.Notify then
                                WarpHub:Notify("Slider Updated", name .. " set to: " .. tostring(math.floor(sliderValue * 100) / 100), 1.5, "info")
                            end
                        end
                    end
                    
                    UserInputService.InputEnded:Connect(onInputEnded)
                end
            end
            
            track.InputBegan:Connect(onInput)
            sliderButton.InputBegan:Connect(onInput)
            
            updateSlider(sliderValue, false)
            
            sliderButton.Parent = sliderContainer
            fill.Parent = track
            track.Parent = sliderContainer
            sliderContainer.Parent = Slider
            label.Parent = Slider
            Slider.Parent = SectionContent
            
            updateSectionHeight()
            
            local sliderObj = {
                instance = Slider,
                value = sliderValue,
                Update = function(self, newValue)
                    updateSlider(newValue, true)
                end,
                GetValue = function(self)
                    return sliderValue
                end
            }
            
            return sliderObj
        end
        
        function section:AddDropdown(name, options, defaultOption, callback)
            local selectedOption = defaultOption or options[1]
            local dropdownOpen = false
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            Dropdown.BackgroundTransparency = 1
            Dropdown.LayoutOrder = #SectionContent:GetChildren() + 1
            Dropdown.ClipsDescendants = true
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            dropdownButton.Position = UDim2.new(0, 0, 0, 0)
            dropdownButton.BackgroundColor3 = WarpHub.Config.DropdownBackground
            dropdownButton.BackgroundTransparency = 0.15
            dropdownButton.AutoButtonColor = false
            dropdownButton.Text = ""
            dropdownButton.BorderSizePixel = 0
            
            if isMobile then
                dropdownButton.TouchTap:Connect(function()
                    dropdownButton.MouseButton1Click:Fire()
                end)
            end
            
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, isMobile and 8 or 10)
            dropdownCorner.Parent = dropdownButton
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name .. ": " .. selectedOption
            label.TextColor3 = WarpHub.Config.TextColor
            label.TextSize = isMobile and 13 or 14
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = dropdownButton
            
            local arrow = Instance.new("ImageLabel")
            arrow.Size = UDim2.new(0, isMobile and 16 or 20, 0, isMobile and 16 or 20)
            arrow.Position = UDim2.new(1, isMobile and -28 or -32, isMobile and 0.5 or 0.5, isMobile and -8 or -10)
            arrow.BackgroundTransparency = 1
            arrow.Image = "rbxassetid://6031091006"
            arrow.ImageColor3 = WarpHub.Config.AccentColor
            arrow.Parent = dropdownButton
            
            local optionsFrame = Instance.new("Frame")
            optionsFrame.Size = UDim2.new(1, -6, 0, 0)
            optionsFrame.Position = UDim2.new(0, 3, 0, isMobile and 40 or 44)
            optionsFrame.BackgroundTransparency = 1
            optionsFrame.Visible = false
            
            local optionsList = Instance.new("UIListLayout")
            optionsList.Padding = UDim.new(0, isMobile and 3 or 4)
            optionsList.SortOrder = Enum.SortOrder.LayoutOrder
            optionsList.Parent = optionsFrame
            
            local function toggleDropdown()
                dropdownOpen = not dropdownOpen
                
                if dropdownOpen then
                    local totalHeight = 0
                    for _, option in ipairs(options) do
                        totalHeight = totalHeight + (isMobile and 32 or 36)
                    end
                    totalHeight = totalHeight + (optionsList.Padding.Offset * (#options - 1))
                    
                    Dropdown.Size = UDim2.new(1, 0, 0, (isMobile and 36 or 40) + totalHeight + 6)
                    optionsFrame.Size = UDim2.new(1, -6, 0, totalHeight)
                    optionsFrame.Visible = true
                    
                    TweenService:Create(arrow, TweenInfo.new(0.2), {
                        Rotation = 180
                    }):Play()
                else
                    Dropdown.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
                    optionsFrame.Visible = false
                    
                    TweenService:Create(arrow, TweenInfo.new(0.2), {
                        Rotation = 0
                    }):Play()
                end
                
                updateSectionHeight()
            end
            
            dropdownButton.MouseButton1Click:Connect(toggleDropdown)
            
            dropdownButton.MouseEnter:Connect(function()
                TweenService:Create(dropdownButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.1
                }):Play()
            end)
            
            dropdownButton.MouseLeave:Connect(function()
                TweenService:Create(dropdownButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.15
                }):Play()
            end)
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, isMobile and 32 or 36)
                optionButton.Position = UDim2.new(0, 0, 0, 0)
                optionButton.BackgroundColor3 = WarpHub.Config.DropdownBackground
                optionButton.BackgroundTransparency = 0.2
                optionButton.AutoButtonColor = false
                optionButton.Text = ""
                optionButton.BorderSizePixel = 0
                optionButton.LayoutOrder = i
                
                if isMobile then
                    optionButton.TouchTap:Connect(function()
                        optionButton.MouseButton1Click:Fire()
                    end)
                end
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, isMobile and 6 or 8)
                optionCorner.Parent = optionButton
                
                local optionText = Instance.new("TextLabel")
                optionText.Size = UDim2.new(1, -10, 1, 0)
                optionText.Position = UDim2.new(0, 8, 0, 0)
                optionText.BackgroundTransparency = 1
                optionText.Text = option
                optionText.TextColor3 = option == selectedOption and WarpHub.Config.AccentColor or WarpHub.Config.TextColor
                optionText.TextSize = isMobile and 12 or 13
                optionText.Font = Enum.Font.GothamMedium
                optionText.TextXAlignment = Enum.TextXAlignment.Left
                optionText.Parent = optionButton
                
                optionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    label.Text = name .. ": " .. selectedOption
                    
                    for _, child in ipairs(optionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            local text = child:FindFirstChild("TextLabel")
                            if text then
                                text.TextColor3 = child == optionButton and WarpHub.Config.AccentColor or WarpHub.Config.TextColor
                            end
                        end
                    end
                    
                    toggleDropdown()
                    
                    if WarpHub and WarpHub.Notify then
                        WarpHub:Notify("Selection Changed", name .. " set to: " .. selectedOption, 2, "info")
                    end
                    
                    if callback then
                        pcall(callback, selectedOption)
                    end
                end)
                
                optionButton.MouseEnter:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.1,
                        BackgroundColor3 = WarpHub.Config.DropdownHover
                    }):Play()
                end)
                
                optionButton.MouseLeave:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.2,
                        BackgroundColor3 = WarpHub.Config.DropdownBackground
                    }):Play()
                end)
                
                optionButton.Parent = optionsFrame
            end
            
            dropdownButton.Parent = Dropdown
            optionsFrame.Parent = Dropdown
            Dropdown.Parent = SectionContent
            
            updateSectionHeight()
            
            local dropdownObj = {
                instance = Dropdown,
                selected = selectedOption,
                Update = function(self, newOption)
                    selectedOption = newOption
                    label.Text = name .. ": " .. selectedOption
                    
                    for _, child in ipairs(optionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            local text = child:FindFirstChild("TextLabel")
                            if text then
                                text.TextColor3 = text.Text == newOption and WarpHub.Config.AccentColor or WarpHub.Config.TextColor
                            end
                        end
                    end
                    
                    if WarpHub and WarpHub.Notify then
                        WarpHub:Notify("Dropdown Updated", name .. " set to: " .. selectedOption, 2, "info")
                    end
                    
                    if callback then
                        pcall(callback, selectedOption)
                    end
                end,
                GetSelected = function(self)
                    return selectedOption
                end
            }
            
            return dropdownObj
        end
        
        function section:AddInput(name, placeholder, callback)
            local Input = Instance.new("Frame")
            Input.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            Input.BackgroundTransparency = 1
            Input.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.3, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = WarpHub.Config.TextColor
            label.TextSize = isMobile and 13 or 14
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local inputContainer = Instance.new("Frame")
            inputContainer.Size = UDim2.new(0.7, 0, 0.8, 0)
            inputContainer.Position = UDim2.new(0.3, 0, 0.1, 0)
            inputContainer.BackgroundColor3 = WarpHub.Config.InputBackground
            inputContainer.BackgroundTransparency = 0.15
            inputContainer.BorderSizePixel = 0
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, isMobile and 6 or 8)
            inputCorner.Parent = inputContainer
            
            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, -16, 1, 0)
            textBox.Position = UDim2.new(0, 8, 0, 0)
            textBox.BackgroundTransparency = 1
            textBox.Text = ""
            textBox.PlaceholderText = placeholder or "Enter text..."
            textBox.TextColor3 = WarpHub.Config.TextColor
            textBox.PlaceholderColor3 = WarpHub.Config.SubTextColor
            textBox.TextSize = isMobile and 12 or 13
            textBox.Font = Enum.Font.GothamMedium
            textBox.TextXAlignment = Enum.TextXAlignment.Left
            textBox.ClearTextOnFocus = false
            
            if isMobile then
                textBox.TextScaled = true
            end
            
            local function submit()
                if textBox.Text ~= "" then
                    if WarpHub and WarpHub.Notify then
                        WarpHub:Notify("Input Submitted", name .. ": " .. textBox.Text, 2, "info")
                    end
                    
                    if callback then
                        pcall(callback, textBox.Text)
                    end
                end
            end
            
            textBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    submit()
                end
            end)
            
            inputContainer.MouseEnter:Connect(function()
                TweenService:Create(inputContainer, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.1
                }):Play()
            end)
            
            inputContainer.MouseLeave:Connect(function()
                TweenService:Create(inputContainer, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.15
                }):Play()
            end)
            
            textBox.Parent = inputContainer
            label.Parent = Input
            inputContainer.Parent = Input
            Input.Parent = SectionContent
            
            updateSectionHeight()
            
            local inputObj = {
                instance = Input,
                textBox = textBox,
                GetText = function(self)
                    return textBox.Text
                end,
                SetText = function(self, newText)
                    textBox.Text = newText
                    if newText ~= "" and WarpHub and WarpHub.Notify then
                        WarpHub:Notify("Input Set", name .. " updated", 1.5, "info")
                    end
                end,
                Clear = function(self)
                    textBox.Text = ""
                end
            }
            
            return inputObj
        end
        
        function section:AddLabel(text)
            local Label = Instance.new("Frame")
            Label.Size = UDim2.new(1, 0, 0, isMobile and 28 or 32)
            Label.BackgroundTransparency = 1
            Label.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local labelText = Instance.new("TextLabel")
            labelText.Size = UDim2.new(1, -6, 1, 0)
            labelText.Position = UDim2.new(0, 3, 0, 0)
            labelText.BackgroundTransparency = 1
            labelText.Text = text
            labelText.TextColor3 = WarpHub.Config.SubTextColor
            labelText.TextSize = isMobile and 12 or 13
            labelText.Font = Enum.Font.GothamMedium
            labelText.TextXAlignment = Enum.TextXAlignment.Left
            labelText.TextWrapped = true
            labelText.Parent = Label
            
            Label.Parent = SectionContent
            updateSectionHeight()
            
            local labelObj = {
                instance = Label,
                textLabel = labelText,
                UpdateText = function(self, newText)
                    if self.textLabel then
                        self.textLabel.Text = newText
                    end
                end,
                Text = labelText.Text
            }
            
            return labelObj
        end
        
        return section
    end
    
    return tab
end

-- Global notification function for backward compatibility
function Notify(titletxt, text, time)
    if WarpHub and WarpHub.Notify then
        WarpHub:Notify(titletxt, text, time)
    else
        -- Fallback notification
        local GUI = Instance.new("ScreenGui")
        local Main = Instance.new("Frame", GUI)
        local title = Instance.new("TextLabel", Main)
        local message = Instance.new("TextLabel", Main)
        
        GUI.Name = "NotificationOof"
        GUI.Parent = game.CoreGui
        
        Main.Name = "MainFrame"
        Main.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        Main.BorderSizePixel = 0
        Main.Position = UDim2.new(1, 5, 0, 50)
        Main.Size = UDim2.new(0, 330, 0, 100)
        
        title.BackgroundColor3 = Color3.new(0, 0, 0)
        title.BackgroundTransparency = 0.9
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Font = Enum.Font.SourceSansSemibold
        title.Text = titletxt
        title.TextColor3 = Color3.fromRGB(168, 128, 255)
        title.TextSize = 25
        
        message.BackgroundColor3 = Color3.new(0, 0, 0)
        message.BackgroundTransparency = 1
        message.Position = UDim2.new(0, 0, 0, 30)
        message.Size = UDim2.new(1, 0, 1, -30)
        message.Font = Enum.Font.SourceSans
        message.Text = text
        message.TextColor3 = Color3.fromRGB(168, 128, 255)
        message.TextSize = 15
        
        wait(0.1)
        Main:TweenPosition(UDim2.new(1, -1050, 0, 50), "Out", "Sine", 0.5)
        wait(time)
        Main:TweenPosition(UDim2.new(1, 5, 0, 50), "Out", "Sine", 0.5)
        wait(10.0)
        GUI:Destroy()
    end
end

-- Success function alias
function WarpHub:Success(title, message)
    return self:Notify(title, message, 2.5, "success")
end

-- Error function alias
function WarpHub:Error(title, message)
    return self:Notify(title, message, 2.5, "error")
end

-- Warning function alias
function WarpHub:Warning(title, message)
    return self:Notify(title, message, 2.5, "warning")
end

-- Info function alias
function WarpHub:Info(title, message)
    return self:Notify(title, message, 2.5, "info")
end

-- Version and metadata
WarpHub.Version = "1.0.0"
WarpHub.Author = "WarpHub UI Library"

-- Return the library
return WarpHub
