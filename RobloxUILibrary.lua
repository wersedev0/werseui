-- Minimal UI Library v3.0 - Black & White Theme
-- Optimized & Clean Design

local UILibrary = {}
UILibrary.__index = UILibrary

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(25, 25, 25),
    Tertiary = Color3.fromRGB(35, 35, 35),
    Border = Color3.fromRGB(45, 45, 45),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(150, 150, 150),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentHover = Color3.fromRGB(200, 200, 200),
}

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad), props):Play()
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

function UILibrary.new(title)
    local self = setmetatable({}, UILibrary)
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsVisible = true
    self.ToggleKey = Enum.KeyCode.RightShift
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MinimalUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 500, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    self.MainFrame.BackgroundColor3 = Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.Parent = self.ScreenGui
    
    Corner(self.MainFrame, 6)
    Stroke(self.MainFrame, Theme.Border, 1)
    
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 35)
    self.TitleBar.BackgroundColor3 = Theme.Secondary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    Corner(self.TitleBar, 6)
    
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 12, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = title or "UI"
    self.TitleLabel.TextColor3 = Theme.Text
    self.TitleLabel.TextSize = 13
    self.TitleLabel.Font = Enum.Font.Gotham
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -33, 0, 2.5)
    closeBtn.BackgroundColor3 = Theme.Tertiary
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = self.TitleBar
    
    Corner(closeBtn, 4)
    
    closeBtn.MouseButton1Click:Connect(function()
        Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        task.wait(0.2)
        self.ScreenGui:Destroy()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.15)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
    end)
    
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(0, 120, 1, -45)
    self.TabContainer.Position = UDim2.new(0, 8, 0, 43)
    self.TabContainer.BackgroundColor3 = Theme.Secondary
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.MainFrame
    
    Corner(self.TabContainer, 4)
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = self.TabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 6)
    tabPadding.PaddingBottom = UDim.new(0, 6)
    tabPadding.PaddingLeft = UDim.new(0, 6)
    tabPadding.PaddingRight = UDim.new(0, 6)
    tabPadding.Parent = self.TabContainer
    
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Size = UDim2.new(1, -144, 1, -45)
    self.ContentContainer.Position = UDim2.new(0, 136, 0, 43)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.Parent = self.MainFrame
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == self.ToggleKey then
            self:Toggle()
        end
    end)
    
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Tween(self.MainFrame, {Size = UDim2.new(0, 500, 0, 400)}, 0.3)
    
    return self
end

function UILibrary:Toggle()
    self.IsVisible = not self.IsVisible
    
    if self.IsVisible then
        self.MainFrame.Visible = true
        Tween(self.MainFrame, {Size = UDim2.new(0, 500, 0, 400)}, 0.25)
    else
        Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        task.wait(0.2)
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
    tabBtn.Size = UDim2.new(1, 0, 0, 32)
    tabBtn.BackgroundColor3 = Theme.Tertiary
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = name
    tabBtn.TextColor3 = Theme.TextDim
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = self.TabContainer
    
    Corner(tabBtn, 4)
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 2
    tabContent.ScrollBarImageColor3 = Theme.Border
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.Visible = false
    tabContent.Parent = self.ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = tabContent
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 6)
    end)
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Button.BackgroundTransparency = 1
            t.Button.TextColor3 = Theme.TextDim
            t.Content.Visible = false
        end
        
        tabBtn.BackgroundTransparency = 0
        tabBtn.TextColor3 = Theme.Text
        tabContent.Visible = true
        self.CurrentTab = tab
    end)
    
    tabBtn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            Tween(tabBtn, {BackgroundTransparency = 0.5}, 0.15)
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            Tween(tabBtn, {BackgroundTransparency = 1}, 0.15)
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
    btn.BackgroundColor3 = Theme.Secondary
    btn.Text = text
    btn.TextColor3 = Theme.Text
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = container
    
    Corner(btn, 4)
    Stroke(btn, Theme.Border, 1)
    
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
    end)
    
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.Secondary}, 0.15)
    end)
    
    return btn
end

function UILibrary:CreateToggle(text, default, callback)
    local container = self.Content or self.Container
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 32)
    frame.BackgroundColor3 = Theme.Secondary
    frame.BorderSizePixel = 0
    frame.Parent = container
    
    Corner(frame, 4)
    Stroke(frame, Theme.Border, 1)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 36, 0, 18)
    toggle.Position = UDim2.new(1, -42, 0.5, -9)
    toggle.BackgroundColor3 = default and Theme.Accent or Theme.Tertiary
    toggle.Text = ""
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    
    Corner(toggle, 9)
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 14, 0, 14)
    indicator.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    indicator.BackgroundColor3 = Theme.Background
    indicator.BorderSizePixel = 0
    indicator.Parent = toggle
    
    Corner(indicator, 7)
    
    local toggled = default or false
    
    toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        Tween(toggle, {BackgroundColor3 = toggled and Theme.Accent or Theme.Tertiary}, 0.2)
        Tween(indicator, {Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.2)
        if callback then callback(toggled) end
    end)
    
    return frame
end

function UILibrary:CreateSlider(text, min, max, default, callback)
    local container = self.Content or self.Container
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 45)
    frame.BackgroundColor3 = Theme.Secondary
    frame.BorderSizePixel = 0
    frame.Parent = container
    
    Corner(frame, 4)
    Stroke(frame, Theme.Border, 1)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
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
    sliderBack.Size = UDim2.new(1, -20, 0, 4)
    sliderBack.Position = UDim2.new(0, 10, 1, -12)
    sliderBack.BackgroundColor3 = Theme.Tertiary
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = frame
    
    Corner(sliderBack, 2)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack
    
    Corner(sliderFill, 2)
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 12, 0, 12)
    sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderBtn.Position = UDim2.new(0, 0, 0.5, 0)
    sliderBtn.BackgroundColor3 = Theme.Accent
    sliderBtn.Text = ""
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Parent = sliderBack
    
    Corner(sliderBtn, 6)
    
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

function UILibrary:CreateLabel(text)
    local container = self.Content or self.Container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 24)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.TextDim
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
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
    frame.Size = UDim2.new(1, -12, 0, 120)
    frame.BackgroundColor3 = Theme.Secondary
    frame.BorderSizePixel = 0
    frame.Parent = container
    
    Corner(frame, 4)
    Stroke(frame, Theme.Border, 1)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 32, 0, 18)
    preview.Position = UDim2.new(1, -38, 0, 6)
    preview.BackgroundColor3 = default or Color3.fromRGB(255, 255, 255)
    preview.BorderSizePixel = 0
    preview.Parent = frame
    
    Corner(preview, 4)
    Stroke(preview, Theme.Border, 1)
    
    local currentColor = default or Color3.fromRGB(255, 255, 255)
    local r, g, b = math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255)
    
    local function updateColor()
        currentColor = Color3.fromRGB(r, g, b)
        preview.BackgroundColor3 = currentColor
        if callback then callback(currentColor) end
    end
    
    local function createSlider(name, yPos, defaultVal, colorIndex)
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(0, 15, 0, 18)
        sliderLabel.Position = UDim2.new(0, 10, 0, yPos)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = name
        sliderLabel.TextColor3 = Theme.TextDim
        sliderLabel.TextSize = 11
        sliderLabel.Font = Enum.Font.GothamBold
        sliderLabel.Parent = frame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 30, 0, 18)
        valueLabel.Position = UDim2.new(1, -35, 0, yPos)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(defaultVal)
        valueLabel.TextColor3 = Theme.TextDim
        valueLabel.TextSize = 10
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = frame
        
        local sliderBack = Instance.new("Frame")
        sliderBack.Size = UDim2.new(1, -90, 0, 4)
        sliderBack.Position = UDim2.new(0, 30, 0, yPos + 7)
        sliderBack.BackgroundColor3 = Theme.Tertiary
        sliderBack.BorderSizePixel = 0
        sliderBack.Parent = frame
        
        Corner(sliderBack, 2)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(defaultVal / 255, 0, 1, 0)
        sliderFill.BackgroundColor3 = Theme.Accent
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBack
        
        Corner(sliderFill, 2)
        
        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(0, 10, 0, 10)
        sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderBtn.Position = UDim2.new(defaultVal / 255, 0, 0.5, 0)
        sliderBtn.BackgroundColor3 = Theme.Accent
        sliderBtn.Text = ""
        sliderBtn.BorderSizePixel = 0
        sliderBtn.Parent = sliderBack
        
        Corner(sliderBtn, 5)
        
        local dragging = false
        
        local function update(input)
            local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
            local value = math.floor(pos * 255)
            
            if colorIndex == 1 then r = value
            elseif colorIndex == 2 then g = value
            else b = value end
            
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            sliderBtn.Position = UDim2.new(pos, 0, 0.5, 0)
            valueLabel.Text = tostring(value)
            updateColor()
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
    end
    
    createSlider("R", 30, r, 1)
    createSlider("G", 54, g, 2)
    createSlider("B", 78, b, 3)
    
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
    
    Tween(notif, {Position = UDim2.new(1, -230, 1, -60)}, 0.3)
    
    task.spawn(function()
        task.wait(duration or 2)
        Tween(notif, {Position = UDim2.new(1, 230, 1, -60)}, 0.2)
        task.wait(0.2)
        notif:Destroy()
    end)
end

return UILibrary
