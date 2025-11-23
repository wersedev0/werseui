local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/wersedev0/werseui/refs/heads/main/RobloxUILibrary.lua"))()

local Window = UILibrary.new("Script Hub")

local MainTab = Window:CreateTab("Main")
local PlayerTab = Window:CreateTab("Player")
local VisualTab = Window:CreateTab("Visual")
local SettingsTab = Window:CreateTab("Settings")

MainTab:CreateLabel("Welcome to Script Hub")
MainTab:CreateDivider()

MainTab:CreateButton("Test Notification", function()
    Window:Notify("Success", "Notification system working!", 2)
end)

MainTab:CreateButton("Player Info", function()
    local player = game.Players.LocalPlayer
    Window:Notify("Info", "Name: " .. player.Name, 2)
end)

MainTab:CreateToggle("Dark Mode", true, function(state)
    print("Dark mode:", state)
end)

PlayerTab:CreateLabel("Character Settings")

PlayerTab:CreateSlider("Walk Speed", 16, 200, 16, function(value)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = value
    end
end)

PlayerTab:CreateSlider("Jump Power", 50, 300, 50, function(value)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.JumpPower = value
    end
end)

PlayerTab:CreateDivider()

PlayerTab:CreateToggle("Super Speed", false, function(state)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        if state then
            character.Humanoid.WalkSpeed = 100
            Window:Notify("Enabled", "Super speed activated", 2)
        else
            character.Humanoid.WalkSpeed = 16
            Window:Notify("Disabled", "Normal speed", 2)
        end
    end
end)

PlayerTab:CreateToggle("Fly Mode", false, function(state)
    if state then
        Window:Notify("Fly", "Fly mode enabled", 2)
    else
        Window:Notify("Fly", "Fly mode disabled", 2)
    end
end)

PlayerTab:CreateDivider()

PlayerTab:CreateButton("Teleport to Spawn", function()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        Window:Notify("Teleported", "Moved to spawn point", 2)
    end
end)

VisualTab:CreateLabel("Visual Effects")

VisualTab:CreateSlider("FOV", 70, 120, 70, function(value)
    workspace.CurrentCamera.FieldOfView = value
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
        Window:Notify("Visual", "Fullbright disabled", 2)
    end
end)

VisualTab:CreateToggle("ESP Players", false, function(state)
    print("ESP state:", state)
    if state then
        Window:Notify("ESP", "ESP system active", 2)
    else
        Window:Notify("ESP", "ESP disabled", 2)
    end
end)

VisualTab:CreateDivider()

VisualTab:CreateButton("Change Ambient", function()
    local colors = {
        Color3.fromRGB(255, 100, 100),
        Color3.fromRGB(100, 255, 100),
        Color3.fromRGB(100, 100, 255),
        Color3.fromRGB(255, 255, 100),
    }
    local randomColor = colors[math.random(1, #colors)]
    game.Lighting.Ambient = randomColor
    Window:Notify("Color", "Ambient color changed", 2)
end)

SettingsTab:CreateLabel("UI Settings")

SettingsTab:CreateKeybind("Toggle UI Key", Enum.KeyCode.RightShift, function(key)
    Window:SetKey(key)
    Window:Notify("Keybind", "UI toggle key set to " .. key.Name, 2)
end)

SettingsTab:CreateDivider()

SettingsTab:CreateToggle("Sound Effects", true, function(state)
    print("Sound effects:", state)
end)

SettingsTab:CreateToggle("Show Chat", true, function(state)
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, state)
end)

SettingsTab:CreateDivider()

SettingsTab:CreateButton("Refresh UI", function()
    Window:Notify("Refreshing", "UI reloading...", 2)
    task.wait(1)
end)

SettingsTab:CreateButton("Server Info", function()
    local serverInfo = "Players: " .. #game.Players:GetPlayers()
    Window:Notify("Server", serverInfo, 2)
end)

SettingsTab:CreateDivider()
SettingsTab:CreateLabel("━━━━━━━━━━━━━━━━━")
SettingsTab:CreateLabel("Minimal UI v3.0")
SettingsTab:CreateLabel("wersedev0")

Window:Notify("Welcome", "UI loaded successfully", 2)
