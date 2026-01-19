-- example.lua
-- How to use the WarpHub UI library

-- Load the library (replace with your actual URL)
local WarpHub = loadstring(game:HttpGet("https://github.com/adubwon/geekUI/raw/refs/heads/main/warp-hub.lua"))()

-- Create a window
local Window = WarpHub:CreateWindow("My Script")

-- Add tabs
local MainTab = Window:AddTab("Main")
local SettingsTab = Window:AddTab("Settings")
local PlayerTab = Window:AddTab("Players")

-- Add sections and elements
local MainSection = MainTab:AddSection("Features")

-- Add toggle with notification
local toggle = MainSection:AddToggle("Enable Feature", function(state)
    print("Feature enabled:", state)
end)

-- Add slider
local slider = MainSection:AddSlider("Walk Speed", 16, 100, 16, function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)

-- Add button
MainSection:AddButton("Click Me", function()
    Window:Success("Button Clicked!", "It works!")
end)

-- Add dropdown
local dropdown = MainSection:AddDropdown("Select Weapon", {"Sword", "Axe", "Bow", "Staff"}, "Sword", function(selected)
    print("Selected weapon:", selected)
end)

-- Add input
local input = MainSection:AddInput("Player Name", "Enter name", function(text)
    print("Input text:", text)
end)

-- Add label
MainSection:AddLabel("Welcome to My Script!")

-- Settings tab
local SettingsSection = SettingsTab:AddSection("Configuration")
SettingsSection:AddToggle("Auto Farm", function(state)
    print("Auto Farm:", state)
end)

SettingsSection:AddSlider("Farm Speed", 1, 10, 5, function(value)
    print("Farm Speed:", value)
end)

-- Player tab
local PlayerSection = PlayerTab:AddSection("Player List")
local playerNames = {}
for _, player in ipairs(game.Players:GetPlayers()) do
    table.insert(playerNames, player.Name)
end

local playerDropdown = PlayerSection:AddDropdown("Select Player", playerNames, playerNames[1], function(selected)
    print("Selected player:", selected)
end)

-- Test notifications
task.wait(1)
Window:Success("UI Loaded", "WarpHub UI has been successfully loaded!")

-- You can also update elements programmatically
task.wait(3)
toggle:Update(true) -- Enable toggle
slider:Update(50) -- Set slider to 50
dropdown:Update("Bow") -- Change dropdown selection
input:SetText("Player123") -- Set input text
