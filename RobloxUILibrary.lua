-- Minimal UI Library v3.0 - Black & White Theme
-- Optimized & Clean Design

local UILibrary = {}
UILibrary.__index = UILibrary

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Theme = {
    Background = Color3.fromRGB(18, 18, 18),
    Secondary = Color3.fromRGB(28, 28, 28),
    Tertiary = Color3.fromRGB(38, 38, 38),
    Border = Color3.fromRGB(50, 50, 50),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(170, 170, 170),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentHover = Color3.fromRGB(220, 220, 220),
}

-- Animation presets for better performance
local TweenPresets = {
    Smooth = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Instant = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
}

-- Active tweens cache for cancellation
local ActiveTweens = {}

local function Tween(obj, props, time, style)
    -- Cancel existing tween on this object if any
    if ActiveTweens[obj] then
        ActiveTweens[obj]:Cancel()
    end
    
    local tweenInfo = style or TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, tweenInfo, props)
    ActiveTweens[obj] = tween
    
    tween.Completed:Connect(function()
        if ActiveTweens[obj] == tween then
            ActiveTweens[obj] = nil
        end
    end)
    
    tween:Play()
    return tween
end

local function TweenPreset(obj, props, preset)
    return Tween(obj, props, nil, TweenPresets[preset] or TweenPresets.Smooth)
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 4)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function Shadow(parent, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, size or 20, 1, size or 20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.7
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

function UILibrary.new(title)
    local self = setmetatable({}, UILibrary)
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsVisible = true
    self.ToggleKey = Enum.KeyCode.RightShift
    self.ColorPickerOpen = false
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MinimalUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Loading Screen
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingScreen"
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.Position = UDim2.new(0, 0, 0, 0)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    loadingFrame.BackgroundTransparency = 0.85
    loadingFrame.BorderSizePixel = 0
    loadingFrame.ZIndex = 100
    loadingFrame.Parent = self.ScreenGui
    
    local loadingContainer = Instance.new("Frame")
    loadingContainer.Size = UDim2.new(0, 400, 0, 140)
    loadingContainer.Position = UDim2.new(0.5, -200, 0.5, -70)
    loadingContainer.BackgroundColor3 = Theme.Secondary
    loadingContainer.BorderSizePixel = 0
    loadingContainer.ZIndex = 101
    loadingContainer.Parent = loadingFrame
    
    Corner(loadingContainer, 8)
    Stroke(loadingContainer, Theme.Border, 1)
    
    local brandLabel = Instance.new("TextLabel")
    brandLabel.Size = UDim2.new(1, 0, 0, 40)
    brandLabel.Position = UDim2.new(0, 0, 0, 15)
    brandLabel.BackgroundTransparency = 1
    brandLabel.Text = "werseui"
    brandLabel.TextColor3 = Theme.Text
    brandLabel.TextSize = 28
    brandLabel.Font = Enum.Font.GothamBold
    brandLabel.ZIndex = 102
    brandLabel.Parent = loadingContainer
    
    -- Pulsing animation for brand
    task.spawn(function()
        while loadingFrame.Parent do
            TweenPreset(brandLabel, {TextTransparency = 0.3}, "Smooth")
            task.wait(0.8)
            TweenPreset(brandLabel, {TextTransparency = 0}, "Smooth")
            task.wait(0.8)
        end
    end)
    
    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Size = UDim2.new(1, 0, 0, 20)
    loadingLabel.Position = UDim2.new(0, 0, 0, 60)
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.Text = "Loading..."
    loadingLabel.TextColor3 = Theme.TextDim
    loadingLabel.TextSize = 12
    loadingLabel.Font = Enum.Font.Gotham
    loadingLabel.ZIndex = 102
    loadingLabel.Parent = loadingContainer
    
    -- Progress bar
    local progressBack = Instance.new("Frame")
    progressBack.Size = UDim2.new(1, -40, 0, 4)
    progressBack.Position = UDim2.new(0, 20, 0, 90)
    progressBack.BackgroundColor3 = Theme.Tertiary
    progressBack.BorderSizePixel = 0
    progressBack.ZIndex = 102
    progressBack.Parent = loadingContainer
    Corner(progressBack, 2)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Theme.Accent
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 103
    progressFill.Parent = progressBack
    Corner(progressFill, 2)
    
    local authorLabel = Instance.new("TextLabel")
    authorLabel.Size = UDim2.new(1, 0, 0, 18)
    authorLabel.Position = UDim2.new(0, 0, 1, -30)
    authorLabel.BackgroundTransparency = 1
    authorLabel.Text = "by wersedev"
    authorLabel.TextColor3 = Theme.TextDim
    authorLabel.TextSize = 11
    authorLabel.Font = Enum.Font.Gotham
    authorLabel.ZIndex = 102
    authorLabel.Parent = loadingContainer
    
    -- Animate loading text
    task.spawn(function()
        local dots = 0
        while loadingFrame.Parent do
            dots = (dots + 1) % 4
            loadingLabel.Text = "Loading" .. string.rep(".", dots)
            task.wait(0.5)
        end
    end)
    
    -- Animate progress bar
    task.spawn(function()
        TweenPreset(progressFill, {Size = UDim2.new(1, 0, 1, 0)}, "Smooth")
    end)
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 500, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    self.MainFrame.BackgroundColor3 = Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true
    self.MainFrame.Draggable = false
    self.MainFrame.ZIndex = 2
    self.MainFrame.Visible = false
    self.MainFrame.Parent = self.ScreenGui
    
    Corner(self.MainFrame, 6)
    Stroke(self.MainFrame, Theme.Border, 1)
    
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 35)
    self.TitleBar.BackgroundColor3 = Theme.Secondary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Active = true
    self.TitleBar.ZIndex = 3
    self.TitleBar.Parent = self.MainFrame
    
    Corner(self.TitleBar, 6)
    
    -- Add subtle gradient overlay
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    }
    gradient.Rotation = 90
    gradient.Parent = self.TitleBar
    
    -- Make title bar draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 12, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = title or "UI"
    self.TitleLabel.TextColor3 = Theme.Text
    self.TitleLabel.TextSize = 13
    self.TitleLabel.Font = Enum.Font.Gotham
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.ZIndex = 4
    self.TitleLabel.Parent = self.TitleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -37, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.TextDim
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 4
    closeBtn.Parent = self.TitleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        TweenPreset(self.MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }, "Fast")
        task.wait(0.15)
        self.ScreenGui:Destroy()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        TweenPreset(closeBtn, {TextColor3 = Color3.fromRGB(255, 80, 80)}, "Fast")
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenPreset(closeBtn, {TextColor3 = Theme.TextDim}, "Fast")
    end)
    
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(0, 120, 1, -45)
    self.TabContainer.Position = UDim2.new(0, 8, 0, 43)
    self.TabContainer.BackgroundColor3 = Theme.Secondary
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.ZIndex = 3
    self.TabContainer.Parent = self.MainFrame
    
    Corner(self.TabContainer, 4)
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = self.TabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 8)
    tabPadding.PaddingBottom = UDim.new(0, 8)
    tabPadding.PaddingLeft = UDim.new(0, 8)
    tabPadding.PaddingRight = UDim.new(0, 8)
    tabPadding.Parent = self.TabContainer
    
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Size = UDim2.new(1, -144, 1, -45)
    self.ContentContainer.Position = UDim2.new(0, 136, 0, 43)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.ZIndex = 3
    self.ContentContainer.Parent = self.MainFrame
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == self.ToggleKey then
            self:Toggle()
        end
    end)
    
    -- Remove loading screen after UI loads (async)
    task.spawn(function()
        task.wait(3.5)
        self.MainFrame.Visible = true
        self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
        self.MainFrame.BackgroundTransparency = 1
        
        -- Smooth scale + fade in
        TweenPreset(self.MainFrame, {
            Size = UDim2.new(0, 500, 0, 400),
            BackgroundTransparency = 0
        }, "Bounce")
        
        -- Fade out loading screen
        TweenPreset(loadingFrame, {BackgroundTransparency = 1}, "Smooth")
        TweenPreset(loadingContainer, {BackgroundTransparency = 1}, "Smooth")
        TweenPreset(brandLabel, {TextTransparency = 1}, "Smooth")
        TweenPreset(loadingLabel, {TextTransparency = 1}, "Smooth")
        TweenPreset(progressBack, {BackgroundTransparency = 1}, "Smooth")
        TweenPreset(progressFill, {BackgroundTransparency = 1}, "Smooth")
        TweenPreset(authorLabel, {TextTransparency = 1}, "Smooth")
        
        task.wait(0.5)
        loadingFrame:Destroy()
    end)

    
    return self
end

function UILibrary:Toggle()
    self.IsVisible = not self.IsVisible
    
    if self.IsVisible then
        self.MainFrame.Visible = true
        self.MainFrame.BackgroundTransparency = 1
        TweenPreset(self.MainFrame, {
            Size = UDim2.new(0, 500, 0, 400),
            BackgroundTransparency = 0
        }, "Bounce")
    else
        TweenPreset(self.MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }, "Fast")
        task.wait(0.15)
        self.MainFrame.Visible = false
    end
end

function UILibrary:SetTitle(title)
    self.TitleLabel.Text = title
end

function UILibrary:SetKey(key)
    self.ToggleKey = key
end

function UILibrary:CreateTab(name)
    local tab = {}
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 34)
    tabBtn.BackgroundColor3 = Theme.Tertiary
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = name
    tabBtn.TextColor3 = Theme.TextDim
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.ZIndex = 4
    tabBtn.Parent = self.TabContainer
    
    Corner(tabBtn, 5)
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.ScrollBarImageColor3 = Theme.Accent
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.Visible = false
    tabContent.ZIndex = 4
    tabContent.Parent = self.ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = tabContent
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
    end)
    
    tabBtn.MouseButton1Click:Connect(function()
        if self.CurrentTab == tab then return end
        
        for _, t in pairs(self.Tabs) do
            TweenPreset(t.Button, {BackgroundTransparency = 1, TextColor3 = Theme.TextDim}, "Fast")
            if t.Content.Visible then
                TweenPreset(t.Content, {BackgroundTransparency = 1}, "Fast")
                task.wait(0.1)
                t.Content.Visible = false
                t.Content.BackgroundTransparency = 0
            end
        end
        
        TweenPreset(tabBtn, {BackgroundTransparency = 0, TextColor3 = Theme.Text}, "Smooth")
        tabContent.Visible = true
        tabContent.BackgroundTransparency = 1
        TweenPreset(tabContent, {BackgroundTransparency = 0}, "Smooth")
        self.CurrentTab = tab
    end)
    
    tabBtn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            TweenPreset(tabBtn, {BackgroundTransparency = 0.5}, "Fast")
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            TweenPreset(tabBtn, {BackgroundTransparency = 1}, "Fast")
        end
    end)
    
    tab.Button = tabBtn
    tab.Content = tabContent
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        tabBtn.BackgroundTransparency = 0
        tabBtn.TextColor3 = Theme.Text
        tabContent.Visible = true
        self.CurrentTab = tab
    end
    
    return setmetatable(tab, {__index = self})
end

function UILibrary:CreateButton(text, callback)
    local container = self.Content or self.Container
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = container
    
    Corner(btn, 4)
    Stroke(btn, Theme.Border, 1)
    
    -- Add subtle gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
    }
    gradient.Rotation = 90
    gradient.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        -- Press animation
        TweenPreset(btn, {Size = UDim2.new(1, -12, 0, 30)}, "Instant")
        task.wait(0.1)
        TweenPreset(btn, {Size = UDim2.new(1, -12, 0, 32)}, "Bounce")
        if callback then callback() end
    end)
    
    btn.MouseEnter:Connect(function()
        TweenPreset(btn, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, "Fast")
    end)
    
    btn.MouseLeave:Connect(function()
        TweenPreset(btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, "Fast")
    end)
    
    return btn
end

function UILibrary:CreateToggle(text, default, callback)
    local container = self.Content or self.Container
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = container
    
    Corner(frame, 4)
    Stroke(frame, Theme.Border, 1)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Position = UDim2.new(1, -46, 0.5, -10)
    toggle.BackgroundColor3 = default and Theme.Accent or Theme.Tertiary
    toggle.Text = ""
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    
    Corner(toggle, 10)
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    indicator.BackgroundColor3 = Theme.Background
    indicator.BorderSizePixel = 0
    indicator.Parent = toggle
    
    Corner(indicator, 8)
    
    local toggled = default or false
    
    toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        TweenPreset(toggle, {BackgroundColor3 = toggled and Theme.Accent or Theme.Tertiary}, "Smooth")
        TweenPreset(indicator, {
            Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }, "Spring")
        if callback then callback(toggled) end
    end)
    
    return frame
end

function UILibrary:CreateSlider(text, min, max, default, callback)
    local container = self.Content or self.Container
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = container
    
    Corner(frame, 4)
    Stroke(frame, Theme.Border, 1)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 18)
    valueLabel.Position = UDim2.new(1, -45, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default or min)
    valueLabel.TextColor3 = Theme.TextDim
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, -20, 0, 5)
    sliderBack.Position = UDim2.new(0, 10, 1, -12)
    sliderBack.BackgroundColor3 = Theme.Tertiary
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = frame
    
    Corner(sliderBack, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack
    
    Corner(sliderFill, 3)
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 14, 0, 14)
    sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderBtn.Position = UDim2.new(0, 0, 0.5, 0)
    sliderBtn.BackgroundColor3 = Theme.Accent
    sliderBtn.Text = ""
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Parent = sliderBack
    
    Corner(sliderBtn, 7)
    
    local dragging = false
    local currentValue = default or min
    
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(min + (max - min) * pos)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        sliderBtn.Position = UDim2.new(pos, 0, 0.5, 0)
        valueLabel.Text = tostring(currentValue)
        if callback then callback(currentValue) end
    end
    
    sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
    end)
    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then update(input) end
    end)
    
    local initialPos = (currentValue - min) / (max - min)
    sliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
    sliderBtn.Position = UDim2.new(initialPos, 0, 0.5, 0)
    
    return frame
end

function UILibrary:CreateSection(text)
    local container = self.Content or self.Container
    
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(1, -12, 0, 35)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    sectionFrame.BorderSizePixel = 0
    sectionFrame.Parent = container
    
    Corner(sectionFrame, 4)
    
    -- Left accent bar
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, -8)
    accentBar.Position = UDim2.new(0, 4, 0, 4)
    accentBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    accentBar.BorderSizePixel = 0
    accentBar.Parent = sectionFrame
    
    Corner(accentBar, 2)
    
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -20, 1, 0)
    section.Position = UDim2.new(0, 15, 0, 0)
    section.BackgroundTransparency = 1
    section.Text = text
    section.TextColor3 = Color3.fromRGB(255, 255, 255)
    section.TextSize = 13
    section.Font = Enum.Font.GothamBold
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Parent = sectionFrame
    
    return sectionFrame
end

function UILibrary:CreateLabel(text)
    local container = self.Content or self.Container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = container
    
    -- Add padding for better spacing
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 4)
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 4)
    padding.Parent = label
    
    return label
end

function UILibrary:CreateKeybind(text, default, callback)
    local container = self.Content or self.Container
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 32)
    frame.BackgroundColor3 = Theme.Secondary
    frame.BorderSizePixel = 0
    frame.Parent = container
    
    Corner(frame, 4)
    Stroke(frame, Theme.Border, 1)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 65, 0, 24)
    keyBtn.Position = UDim2.new(1, -71, 0, 4)
    keyBtn.BackgroundColor3 = Theme.Tertiary
    keyBtn.Text = default.Name or "None"
    keyBtn.TextColor3 = Theme.Text
    keyBtn.TextSize = 11
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.BorderSizePixel = 0
    keyBtn.Parent = frame
    
    Corner(keyBtn, 4)
    
    local binding = false
    
    keyBtn.MouseButton1Click:Connect(function()
        binding = true
        keyBtn.Text = "..."
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gp)
            if not gp and input.UserInputType == Enum.UserInputType.Keyboard then
                binding = false
                keyBtn.Text = input.KeyCode.Name
                if callback then callback(input.KeyCode) end
                connection:Disconnect()
            end
        end)
    end)
    
    return frame
end

function UILibrary:CreateColorPicker(text, default, callback)
    local container = self.Content or self.Container
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 32)
    frame.BackgroundColor3 = Theme.Secondary
    frame.BorderSizePixel = 0
    frame.Parent = container
    
    Corner(frame, 4)
    Stroke(frame, Theme.Border, 1)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 65, 0, 24)
    colorBtn.Position = UDim2.new(1, -71, 0, 4)
    colorBtn.BackgroundColor3 = default or Color3.fromRGB(255, 255, 255)
    colorBtn.Text = ""
    colorBtn.BorderSizePixel = 0
    colorBtn.Parent = frame
    
    Corner(colorBtn, 4)
    Stroke(colorBtn, Theme.Border, 1)
    
    local currentColor = default or Color3.fromRGB(255, 255, 255)
    local currentPopup = nil
    
    -- Preset color palette
    local presetColors = {
        {255, 255, 255}, {220, 220, 220}, {180, 180, 180}, {140, 140, 140}, {100, 100, 100}, {60, 60, 60}, {30, 30, 30}, {0, 0, 0},
        {255, 200, 200}, {255, 150, 150}, {255, 100, 100}, {255, 50, 50}, {255, 0, 0}, {200, 0, 0}, {150, 0, 0}, {100, 0, 0},
        {255, 220, 200}, {255, 180, 150}, {255, 140, 100}, {255, 100, 50}, {255, 140, 0}, {200, 100, 0}, {150, 80, 0}, {100, 50, 0},
        {255, 255, 200}, {255, 255, 150}, {255, 255, 100}, {255, 255, 50}, {255, 255, 0}, {200, 200, 0}, {150, 150, 0}, {100, 100, 0},
        {200, 255, 200}, {150, 255, 150}, {100, 255, 100}, {50, 255, 50}, {0, 255, 0}, {0, 200, 0}, {0, 150, 0}, {0, 100, 0},
        {200, 255, 255}, {150, 255, 255}, {100, 255, 255}, {50, 255, 255}, {0, 255, 255}, {0, 200, 200}, {0, 150, 150}, {0, 100, 100},
        {200, 200, 255}, {150, 150, 255}, {100, 100, 255}, {50, 50, 255}, {0, 0, 255}, {0, 0, 200}, {0, 0, 150}, {0, 0, 100},
        {255, 200, 255}, {255, 150, 255}, {255, 100, 255}, {255, 50, 255}, {255, 0, 255}, {200, 0, 200}, {150, 0, 150}, {100, 0, 100},
    }
    
    colorBtn.MouseButton1Click:Connect(function()
        if self.ColorPickerOpen then return end
        self.ColorPickerOpen = true
        
        -- Block menu interactions
        local blocker = Instance.new("Frame")
        blocker.Size = UDim2.new(1, 0, 1, 0)
        blocker.Position = UDim2.new(0, 0, 0, 0)
        blocker.BackgroundTransparency = 1
        blocker.BorderSizePixel = 0
        blocker.ZIndex = 49
        blocker.Parent = self.MainFrame
        
        local popup = Instance.new("Frame")
        popup.Size = UDim2.new(0, 320, 0, 360)
        popup.Position = UDim2.new(0.5, -160, 0.5, -180)
        popup.BackgroundColor3 = Theme.Background
        popup.BorderSizePixel = 0
        popup.ZIndex = 50
        popup.Parent = self.MainFrame
        currentPopup = popup
        
        Corner(popup, 8)
        Stroke(popup, Theme.Border, 2)
        
        -- Title bar
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 35)
        titleBar.BackgroundColor3 = Theme.Secondary
        titleBar.BorderSizePixel = 0
        titleBar.ZIndex = 51
        titleBar.Parent = popup
        Corner(titleBar, 8)
        
        local popupTitle = Instance.new("TextLabel")
        popupTitle.Size = UDim2.new(1, -40, 1, 0)
        popupTitle.Position = UDim2.new(0, 12, 0, 0)
        popupTitle.BackgroundTransparency = 1
        popupTitle.Text = "🎨 Select Color"
        popupTitle.TextColor3 = Theme.Text
        popupTitle.TextSize = 14
        popupTitle.Font = Enum.Font.GothamBold
        popupTitle.TextXAlignment = Enum.TextXAlignment.Left
        popupTitle.ZIndex = 52
        popupTitle.Parent = titleBar
        
        local closePopup = Instance.new("TextButton")
        closePopup.Size = UDim2.new(0, 35, 0, 35)
        closePopup.Position = UDim2.new(1, -35, 0, 0)
        closePopup.BackgroundTransparency = 1
        closePopup.Text = "×"
        closePopup.TextColor3 = Theme.TextDim
        closePopup.TextSize = 18
        closePopup.Font = Enum.Font.GothamBold
        closePopup.BorderSizePixel = 0
        closePopup.ZIndex = 52
        closePopup.Parent = titleBar
        
        closePopup.MouseButton1Click:Connect(function()
            self.ColorPickerOpen = false
            currentPopup = nil
            TweenPreset(popup, {Size = UDim2.new(0, 0, 0, 0)}, "Fast")
            task.wait(0.15)
            blocker:Destroy()
            popup:Destroy()
        end)
        
        closePopup.MouseEnter:Connect(function()
            TweenPreset(closePopup, {TextColor3 = Color3.fromRGB(255, 80, 80)}, "Fast")
        end)
        
        closePopup.MouseLeave:Connect(function()
            TweenPreset(closePopup, {TextColor3 = Theme.TextDim}, "Fast")
        end)
        
        -- Preview
        local preview = Instance.new("Frame")
        preview.Size = UDim2.new(1, -24, 0, 50)
        preview.Position = UDim2.new(0, 12, 0, 45)
        preview.BackgroundColor3 = currentColor
        preview.BorderSizePixel = 0
        preview.ZIndex = 51
        preview.Parent = popup
        
        Corner(preview, 6)
        Stroke(preview, Theme.Border, 2)
        
        -- Color palette label
        local paletteLabel = Instance.new("TextLabel")
        paletteLabel.Size = UDim2.new(1, -24, 0, 20)
        paletteLabel.Position = UDim2.new(0, 12, 0, 105)
        paletteLabel.BackgroundTransparency = 1
        paletteLabel.Text = "Preset Colors"
        paletteLabel.TextColor3 = Theme.TextDim
        paletteLabel.TextSize = 11
        paletteLabel.Font = Enum.Font.GothamBold
        paletteLabel.TextXAlignment = Enum.TextXAlignment.Left
        paletteLabel.ZIndex = 51
        paletteLabel.Parent = popup
        
        -- Color palette grid
        local paletteContainer = Instance.new("Frame")
        paletteContainer.Size = UDim2.new(1, -24, 0, 160)
        paletteContainer.Position = UDim2.new(0, 12, 0, 130)
        paletteContainer.BackgroundTransparency = 1
        paletteContainer.ZIndex = 51
        paletteContainer.Parent = popup
        
        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.CellSize = UDim2.new(0, 32, 0, 32)
        gridLayout.CellPadding = UDim2.new(0, 4, 0, 4)
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        gridLayout.Parent = paletteContainer
        
        for i, rgb in ipairs(presetColors) do
            local colorSwatch = Instance.new("TextButton")
            colorSwatch.Size = UDim2.new(0, 32, 0, 32)
            colorSwatch.BackgroundColor3 = Color3.fromRGB(rgb[1], rgb[2], rgb[3])
            colorSwatch.Text = ""
            colorSwatch.BorderSizePixel = 0
            colorSwatch.ZIndex = 52
            colorSwatch.LayoutOrder = i
            colorSwatch.Parent = paletteContainer
            
            Corner(colorSwatch, 4)
            Stroke(colorSwatch, Theme.Border, 1)
            
            colorSwatch.MouseButton1Click:Connect(function()
                currentColor = Color3.fromRGB(rgb[1], rgb[2], rgb[3])
                preview.BackgroundColor3 = currentColor
                colorBtn.BackgroundColor3 = currentColor
                if callback then callback(currentColor) end
                
                -- Visual feedback
                TweenPreset(colorSwatch, {Size = UDim2.new(0, 28, 0, 28)}, "Instant")
                task.wait(0.1)
                TweenPreset(colorSwatch, {Size = UDim2.new(0, 32, 0, 32)}, "Bounce")
            end)
            
            colorSwatch.MouseEnter:Connect(function()
                TweenPreset(colorSwatch, {Size = UDim2.new(0, 34, 0, 34)}, "Fast")
            end)
            
            colorSwatch.MouseLeave:Connect(function()
                TweenPreset(colorSwatch, {Size = UDim2.new(0, 32, 0, 32)}, "Fast")
            end)
        end
        
        -- Custom color label
        local customLabel = Instance.new("TextLabel")
        customLabel.Size = UDim2.new(1, -24, 0, 20)
        customLabel.Position = UDim2.new(0, 12, 0, 300)
        customLabel.BackgroundTransparency = 1
        customLabel.Text = "Custom Color (RGB)"
        customLabel.TextColor3 = Theme.TextDim
        customLabel.TextSize = 11
        customLabel.Font = Enum.Font.GothamBold
        customLabel.TextXAlignment = Enum.TextXAlignment.Left
        customLabel.ZIndex = 51
        customLabel.Parent = popup
        
        -- RGB input button
        local rgbButton = Instance.new("TextButton")
        rgbButton.Size = UDim2.new(1, -24, 0, 28)
        rgbButton.Position = UDim2.new(0, 12, 0, 325)
        rgbButton.BackgroundColor3 = Theme.Secondary
        rgbButton.Text = string.format("R:%d G:%d B:%d", 
            math.floor(currentColor.R * 255),
            math.floor(currentColor.G * 255),
            math.floor(currentColor.B * 255))
        rgbButton.TextColor3 = Theme.Text
        rgbButton.TextSize = 11
        rgbButton.Font = Enum.Font.GothamMedium
        rgbButton.BorderSizePixel = 0
        rgbButton.ZIndex = 51
        rgbButton.Parent = popup
        
        Corner(rgbButton, 4)
        Stroke(rgbButton, Theme.Border, 1)
        
        popup.Size = UDim2.new(0, 0, 0, 0)
        TweenPreset(popup, {Size = UDim2.new(0, 320, 0, 360)}, "Bounce")
    end)
    
    return frame
end

function UILibrary:CreateDivider()
    local container = self.Content or self.Container
    
    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, -12, 0, 1)
    div.BackgroundColor3 = Theme.Border
    div.BorderSizePixel = 0
    div.Parent = container
    
    return div
end

function UILibrary:Notify(title, message, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 220, 0, 50)
    notif.Position = UDim2.new(1, 230, 1, -60)
    notif.BackgroundColor3 = Theme.Secondary
    notif.BorderSizePixel = 0
    notif.Parent = self.ScreenGui
    
    Corner(notif, 4)
    Stroke(notif, Theme.Border, 1)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -16, 0, 16)
    titleLabel.Position = UDim2.new(0, 8, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -16, 0, 24)
    msgLabel.Position = UDim2.new(0, 8, 0, 22)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Theme.TextDim
    msgLabel.TextSize = 10
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.Parent = notif
    
    TweenPreset(notif, {Position = UDim2.new(1, -230, 1, -60)}, "Bounce")
    
    task.spawn(function()
        task.wait(duration or 2)
        TweenPreset(notif, {Position = UDim2.new(1, 230, 1, -60)}, "Fast")
        task.wait(0.15)
        notif:Destroy()
    end)
end

return UILibrary
