-- werseui - Full Feature Test Example
-- This file tests all UI functions

local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/wersedev0/werseui/refs/heads/main/RobloxUILibrary.lua"))()

-- Create UI
local Window = UILibrary.new("werseui - Full Test")

-- Create Tabs
local MainTab = Window:CreateTab("Main")
local PlayerTab = Window:CreateTab("Player")
local VisualTab = Window:CreateTab("Visual")
local SettingsTab = Window:CreateTab("Settings")

-- ==================== MAIN TAB ====================
MainTab:CreateSection("Welcome")
MainTab:CreateLabel("This UI tests all features")
MainTab:CreateDivider()

-- Button test
MainTab:CreateButton("Test Button", function()
    Window:Notify("Success", "Button is working!", 2)
    print("Test button clicked!")
end)

MainTab:CreateButton("Notification Test", function()
    Window:Notify("Info", "This is a notification message", 3)
end)

MainTab:CreateDivider()

-- Toggle test
MainTab:CreateToggle("Dark Mode", true, function(state)
    print("Dark mode:", state)
    if state then
        Window:Notify("Enabled", "Dark mode active", 2)
    else
        Window:Notify("Disabled", "Dark mode off", 2)
    end
end)

MainTab:CreateToggle("Auto Farm", false, function(state)
    print("Auto farm:", state)
end)

-- ==================== PLAYER TAB ====================
PlayerTab:CreateSection("Movement Settings")

-- Slider tests
PlayerTab:CreateSlider("Walk Speed", 16, 200, 16, function(value)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = value
        print("Walk speed:", value)
    end
end)

PlayerTab:CreateSlider("Jump Power", 50, 300, 50, function(value)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.JumpPower = value
        print("Jump power:", value)
    end
end)

PlayerTab:CreateDivider()
PlayerTab:CreateSection("Abilities")

PlayerTab:CreateToggle("Super Speed", false, function(state)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        if state then
            character.Humanoid.WalkSpeed = 100
            Window:Notify("Active", "Super speed enabled!", 2)
        else
            character.Humanoid.WalkSpeed = 16
            Window:Notify("Disabled", "Normal speed", 2)
        end
    end
end)

PlayerTab:CreateToggle("Fly Mode", false, function(state)
    if state then
        Window:Notify("Flying", "Fly mode active", 2)
        print("Fly mode enabled")
    else
        Window:Notify("Flying", "Fly mode disabled", 2)
        print("Fly mode disabled")
    end
end)

PlayerTab:CreateToggle("Infinite Jump", false, function(state)
    print("Infinite jump:", state)
end)

PlayerTab:CreateDivider()

PlayerTab:CreateButton("Teleport to Spawn", function()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        Window:Notify("Teleported", "Moved to spawn point", 2)
    end
end)

PlayerTab:CreateButton("Refresh Health", function()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.Health = character.Humanoid.MaxHealth
        Window:Notify("Refreshed", "Health restored!", 2)
    end
end)

-- ==================== VISUAL TAB ====================
VisualTab:CreateSection("Camera & Lighting")

-- FOV slider
VisualTab:CreateSlider("FOV (Field of View)", 70, 120, 70, function(value)
    workspace.CurrentCamera.FieldOfView = value
    print("FOV:", value)
end)

VisualTab:CreateToggle("Fullbright", false, function(state)
    if state then
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 100000
        Window:Notify("Visual", "Fullbright enabled", 2)
    else
        game.Lighting.Brightness = 1
        game.Lighting.ClockTime = 12
        game.Lighting.FogEnd = 10000
        Window:Notify("Visual", "Normal lighting", 2)
    end
end)

VisualTab:CreateToggle("ESP (Show Players)", false, function(state)
    print("ESP status:", state)
    if state then
        Window:Notify("ESP", "ESP system active", 2)
    else
        Window:Notify("ESP", "ESP disabled", 2)
    end
end)

VisualTab:CreateToggle("Wallhack", false, function(state)
    print("Wallhack:", state)
end)

VisualTab:CreateDivider()
VisualTab:CreateSection("Color Settings")

-- Color Picker tests
VisualTab:CreateColorPicker("Ambient Color", Color3.fromRGB(255, 255, 255), function(color)
    game.Lighting.Ambient = color
    print("Ambient color changed:", color)
end)

VisualTab:CreateColorPicker("Fog Color", Color3.fromRGB(128, 128, 128), function(color)
    game.Lighting.FogColor = color
    print("Fog color changed:", color)
end)

VisualTab:CreateColorPicker("Sky Color", Color3.fromRGB(100, 150, 255), function(color)
    game.Lighting.OutdoorAmbient = color
    print("Sky color changed:", color)
end)

VisualTab:CreateDivider()

VisualTab:CreateButton("Random Color", function()
    local randomColor = Color3.fromRGB(
        math.random(0, 255),
        math.random(0, 255),
        math.random(0, 255)
    )
    game.Lighting.Ambient = randomColor
    Window:Notify("Color", "Random color applied", 2)
end)

-- ==================== SETTINGS TAB ====================
SettingsTab:CreateSection("UI Configuration")

-- Keybind test
SettingsTab:CreateKeybind("Toggle UI Key", Enum.KeyCode.RightShift, function(key)
    Window:SetKey(key)
    Window:Notify("Key Set", "UI key: " .. key.Name, 2)
    print("UI key changed:", key.Name)
end)

SettingsTab:CreateDivider()
SettingsTab:CreateSection("Information")

SettingsTab:CreateLabel("UI Library: werseui")
SettingsTab:CreateLabel("Version: 3.0")
SettingsTab:CreateLabel("Developer: wersedev")

SettingsTab:CreateDivider()

SettingsTab:CreateButton("Refresh UI", function()
    Window:Notify("Refreshing", "UI reloading...", 2)
    task.wait(1)
    Window:Notify("Complete", "UI refreshed!", 2)
end)

SettingsTab:CreateButton("Server Info", function()
    local players = #game.Players:GetPlayers()
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    Window:Notify("Server", "Players: " .. players .. " | Ping: " .. ping, 3)
end)

SettingsTab:CreateButton("Player Info", function()
    local player = game.Players.LocalPlayer
    local info = "Name: " .. player.Name .. " | ID: " .. player.UserId
    Window:Notify("Info", info, 3)
    print(info)
end)

SettingsTab:CreateDivider()
SettingsTab:CreateLabel("━━━━━━━━━━━━━━━━━")
SettingsTab:CreateLabel("All features tested!")
SettingsTab:CreateLabel("━━━━━━━━━━━━━━━━━")

-- Startup notification
Window:Notify("Welcome", "werseui loaded successfully!", 3)
print("werseui - All features loaded!")
