local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/wersedev0/werseui/refs/heads/main/RobloxUILibrary.lua"))()

local Window = UILibrary.new("Game Menu")

local MainTab = Window:CreateTab("Ana Sayfa", "🏠")
local PlayerTab = Window:CreateTab("Oyuncu", "👤")
local VisualTab = Window:CreateTab("Görsel", "👁️")
local MiscTab = Window:CreateTab("Diğer", "⚙️")

MainTab:CreateLabel("Hoş Geldiniz!")
MainTab:CreateLabel("Bu gelişmiş UI kütüphanesini kullanıyorsunuz")
MainTab:CreateDivider()

MainTab:CreateButton("Test Bildirimi", function()
    Window:CreateNotification("Test", "Bildirim sistemi çalışıyor!", 3, "success")
end)

MainTab:CreateButton("Oyuncu Bilgileri", function()
    local player = game.Players.LocalPlayer
    Window:CreateNotification("Oyuncu", "İsim: " .. player.Name, 3)
end)

MainTab:CreateToggle("Karanlık Mod", true, function(state)
    print("Karanlık mod:", state)
end)

PlayerTab:CreateLabel("Karakter Ayarları")

PlayerTab:CreateSlider("Hız", 16, 200, 16, function(value)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = value
    end
end)

PlayerTab:CreateSlider("Zıplama Gücü", 50, 300, 50, function(value)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.JumpPower = value
    end
end)

PlayerTab:CreateDivider()

PlayerTab:CreateToggle("Süper Hız", false, function(state)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        if state then
            character.Humanoid.WalkSpeed = 100
            Window:CreateNotification("Aktif", "Süper hız açıldı!", 2, "success")
        else
            character.Humanoid.WalkSpeed = 16
            Window:CreateNotification("Kapalı", "Normal hız", 2, "error")
        end
    end
end)

PlayerTab:CreateToggle("Uçma Modu", false, function(state)
    if state then
        Window:CreateNotification("Uçma", "Uçma modu aktif!", 2, "success")
    else
        Window:CreateNotification("Uçma", "Uçma modu kapalı", 2, "error")
    end
end)

PlayerTab:CreateDivider()

PlayerTab:CreateButton("Spawn'a Işınlan", function()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        Window:CreateNotification("Işınlandın!", "Spawn noktasına ışınlandın", 2, "success")
    end
end)

VisualTab:CreateLabel("Görsel Efektler")

VisualTab:CreateSlider("FOV", 70, 120, 70, function(value)
    workspace.CurrentCamera.FieldOfView = value
end)

VisualTab:CreateToggle("Fullbright", false, function(state)
    if state then
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 100000
        Window:CreateNotification("Görsel", "Fullbright açık", 2, "success")
    else
        game.Lighting.Brightness = 1
        game.Lighting.ClockTime = 12
        game.Lighting.FogEnd = 10000
        Window:CreateNotification("Görsel", "Fullbright kapalı", 2, "error")
    end
end)

VisualTab:CreateToggle("ESP (Oyuncular)", false, function(state)
    print("ESP durumu:", state)
    if state then
        Window:CreateNotification("ESP", "ESP sistemi aktif", 2, "success")
    else
        Window:CreateNotification("ESP", "ESP kapatıldı", 2, "error")
    end
end)

VisualTab:CreateDivider()

VisualTab:CreateButton("Renk Değiştir", function()
    local colors = {
        Color3.fromRGB(255, 100, 100),
        Color3.fromRGB(100, 255, 100),
        Color3.fromRGB(100, 100, 255),
        Color3.fromRGB(255, 255, 100),
    }
    local randomColor = colors[math.random(1, #colors)]
    game.Lighting.Ambient = randomColor
    Window:CreateNotification("Renk", "Ortam rengi değişti!", 2)
end)

MiscTab:CreateLabel("Çeşitli Ayarlar")

MiscTab:CreateToggle("Ses Efektleri", true, function(state)
    print("Ses efektleri:", state)
end)

MiscTab:CreateToggle("Sohbet Göster", true, function(state)
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, state)
end)

MiscTab:CreateDivider()

MiscTab:CreateButton("UI'ı Yenile", function()
    Window:CreateNotification("Yenileniyor", "UI yeniden yükleniyor...", 2, "success")
    wait(1)
end)

MiscTab:CreateButton("Sunucu Bilgisi", function()
    local serverInfo = "Oyuncular: " .. #game.Players:GetPlayers()
    Window:CreateNotification("Sunucu", serverInfo, 3)
end)

MiscTab:CreateDivider()
MiscTab:CreateLabel("━━━━━━━━━━━━━━━━━")
MiscTab:CreateLabel("UI Kütüphanesi v2.0")
MiscTab:CreateLabel("wersedev0")

Window:CreateNotification("Hoş Geldin!", "UI başarıyla yüklendi", 3, "success")
