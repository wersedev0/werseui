-- Modern Roblox UI Library v2.1 - Optimized
-- Created by: wersedev0

local UILibrary = {}
UILibrary.__index = UILibrary

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    Background = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 50),
    Accent = Color3.fromRGB(88, 101, 242),
    AccentHover = Color3.fromRGB(108, 121, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 200),
    Success = Color3.fromRGB(67, 181, 129),
    Warning = Color3.fromRGB(250, 166, 26),
    Error = Color3.fromRGB(240, 71, 71),
    Border = Color3.fromRGB(50, 50, 70),
}

local function CreateTween(object, properties, duration, easingStyle, easingDirection)
    local tween = TweenService:Create(object, TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    ), properties)
    tween:Play()
    return tween
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

function UILibrary.new(title)
    local self = setmetatable({}, UILibrary)
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsVisible = true
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernUILibrary"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    self.ToggleButton = Instance.new("TextButton")
    self.ToggleButton.Name = "ToggleButton"
    self.ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    self.ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
    self.ToggleButton.BackgroundColor3 = Theme.Accent
    self.ToggleButton.Text = "☰"
    self.ToggleButton.TextColor3 = Theme.Text
    self.ToggleButton.TextSize = 24
    self.ToggleButton.Font = Enum.Font.GothamBold
    self.ToggleButton.BorderSizePixel = 0
    self.ToggleButton.Parent = self.ScreenGui
    
    CreateCorner(self.ToggleButton, 25)
    CreateStroke(self.ToggleButton, Theme.Border, 2)
    
    self.ToggleButton.MouseEnter:Connect(function()
        CreateTween(self.ToggleButton, {BackgroundColor3 = Theme.AccentHover, Size = UDim2.new(0, 55, 0, 55)}, 0.2, Enum.EasingStyle.Back)
    end)
    
    self.ToggleButton.MouseLeave:Connect(function()
        CreateTween(self.ToggleButton, {BackgroundColor3 = Theme.Accent, Size = UDim2.new(0, 50, 0, 50)}, 0.2)
    end)
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 450)
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    self.MainFrame.BackgroundColor3 = Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.Parent = self.ScreenGui
    
    CreateCorner(self.MainFrame, 12)
    CreateStroke(self.MainFrame, Theme.Border, 2)
    
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 50)
    self.TitleBar.BackgroundColor3 = Theme.Secondary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    CreateCorner(self.TitleBar, 12)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -150, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Modern UI"
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = self.TitleBar
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 40, 0, 40)
    minimizeButton.Position = UDim2.new(1, -95, 0, 5)
    minimizeButton.BackgroundColor3 = Theme.Warning
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = Theme.Text
    minimizeButton.TextSize = 24
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Parent = self.TitleBar
    
    CreateCorner(minimizeButton, 8)
    
    minimizeButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    minimizeButton.MouseEnter:Connect(function()
        CreateTween(minimizeButton, {BackgroundColor3 = Color3.fromRGB(255, 186, 46)}, 0.2)
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        CreateTween(minimizeButton, {BackgroundColor3 = Theme.Warning}, 0.2)
    end)
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -50, 0, 5)
    closeButton.BackgroundColor3 = Theme.Error
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.Text
    closeButton.TextSize = 24
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = self.TitleBar
    
    CreateCorner(closeButton, 8)
    
    closeButton.MouseButton1Click:Connect(function()
        CreateTween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        CreateTween(self.ToggleButton, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        self.ScreenGui:Destroy()
    end)
    
    closeButton.MouseEnter:Connect(function()
        CreateTween(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 91, 91)}, 0.2)
    end)
    
    closeButton.MouseLeave:Connect(function()
        CreateTween(closeButton, {BackgroundColor3 = Theme.Error}, 0.2)
    end)
    
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 150, 1, -60)
    self.TabContainer.Position = UDim2.new(0, 10, 0, 60)
    self.TabContainer.BackgroundColor3 = Theme.Secondary
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.MainFrame
    
    CreateCorner(self.TabContainer, 10)
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = self.TabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.PaddingBottom = UDim.new(0, 10)
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)
    tabPadding.Parent = self.TabContainer
    
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -180, 1, -70)
    self.ContentContainer.Position = UDim2.new(0, 170, 0, 60)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.Parent = self.MainFrame
    
    self.ToggleButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftShift then
            self:Toggle()
        end
    end)
    
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.ToggleButton.Size = UDim2.new(0, 0, 0, 0)
    CreateTween(self.MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, 0.5, Enum.EasingStyle.Back)
    CreateTween(self.ToggleButton, {Size = UDim2.new(0, 50, 0, 50)}, 0.5, Enum.EasingStyle.Back)
    
    return self
end

function UILibrary:Toggle()
    self.IsVisible = not self.IsVisible
    
    if self.IsVisible then
        self.MainFrame.Visible = true
        CreateTween(self.MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, 0.4, Enum.EasingStyle.Back)
        CreateTween(self.ToggleButton, {Rotation = 0}, 0.3)
    else
        CreateTween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        CreateTween(self.ToggleButton, {Rotation = 180}, 0.3)
        task.wait(0.3)
        self.MainFrame.Visible = false
    end
end

function UILibrary:CreateTab(name, icon)
    local tab = {}
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.BackgroundColor3 = Theme.Background
    tabButton.BackgroundTransparency = 1
    tabButton.Text = (icon or "📁") .. "  " .. name
    tabButton.TextColor3 = Theme.TextDim
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.BorderSizePixel = 0
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabContainer
    
    CreateCorner(tabButton, 8)
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 15)
    tabPadding.Parent = tabButton
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.ScrollBarImageColor3 = Theme.Accent
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.Visible = false
    tabContent.Parent = self.ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = tabContent
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Button.BackgroundTransparency = 1
            t.Button.TextColor3 = Theme.TextDim
            t.Content.Visible = false
        end
        
        tabButton.BackgroundTransparency = 0
        tabButton.BackgroundColor3 = Theme.Accent
        tabButton.TextColor3 = Theme.Text
        tabContent.Visible = true
        
        CreateTween(tabButton, {BackgroundColor3 = Theme.Accent}, 0.2)
        
        self.CurrentTab = tab
    end)
    
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            CreateTween(tabButton, {BackgroundTransparency = 0.5}, 0.2)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            CreateTween(tabButton, {BackgroundTransparency = 1}, 0.2)
        end
    end)
    
    tab.Button = tabButton
    tab.Content = tabContent
    tab.Name = name
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        tabButton.BackgroundTransparency = 0
        tabButton.BackgroundColor3 = Theme.Accent
        tabButton.TextColor3 = Theme.Text
        tabContent.Visible = true
        self.CurrentTab = tab
    end
    
    return setmetatable(tab, {__index = self})
end

function UILibrary:CreateButton(text, callback)
    local container = self.Content or self.Container
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, -20, 0, 40)
    button.BackgroundColor3 = Theme.Accent
    button.Text = text or "Button"
    button.TextColor3 = Theme.Text
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Parent = container
    
    CreateCorner(button, 8)
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
        
        local ripple = Instance.new("Frame")
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.5
        ripple.BorderSizePixel = 0
        ripple.ZIndex = 2
        ripple.Parent = button
        
        CreateCorner(ripple, 999)
        CreateTween(ripple, {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}, 0.5)
        game:GetService("Debris"):AddItem(ripple, 0.5)
    end)
    
    button.MouseEnter:Connect(function()
        CreateTween(button, {BackgroundColor3 = Theme.AccentHover}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        CreateTween(button, {BackgroundColor3 = Theme.Accent}, 0.2)
    end)
    
    return button
end

function UILibrary:CreateToggle(text, default, callback)
    local container = self.Content or self.Container
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)
    toggleFrame.BackgroundColor3 = Theme.Secondary
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = container
    
    CreateCorner(toggleFrame, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Toggle"
    label.TextColor3 = Theme.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 45, 0, 24)
    toggleButton.Position = UDim2.new(1, -55, 0.5, -12)
    toggleButton.BackgroundColor3 = default and Theme.Success or Theme.Border
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    CreateCorner(toggleButton, 12)
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 18, 0, 18)
    indicator.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    indicator.BackgroundColor3 = Theme.Text
    indicator.BorderSizePixel = 0
    indicator.Parent = toggleButton
    
    CreateCorner(indicator, 9)
    
    local toggled = default or false
    
    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        CreateTween(toggleButton, {BackgroundColor3 = toggled and Theme.Success or Theme.Border}, 0.3)
        CreateTween(indicator, {Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.3, Enum.EasingStyle.Back)
        
        if callback then
            callback(toggled)
        end
    end)
    
    return toggleFrame
end

function UILibrary:CreateSlider(text, min, max, default, callback)
    local container = self.Content or self.Container
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.Size = UDim2.new(1, -20, 0, 60)
    sliderFrame.BackgroundColor3 = Theme.Secondary
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = container
    
    CreateCorner(sliderFrame, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text or "Slider"
    label.TextColor3 = Theme.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -65, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default or min)
    valueLabel.TextColor3 = Theme.Accent
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, -30, 0, 6)
    sliderBack.Position = UDim2.new(0, 15, 1, -18)
    sliderBack.BackgroundColor3 = Theme.Border
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = sliderFrame
    
    CreateCorner(sliderBack, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack
    
    CreateCorner(sliderFill, 3)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderButton.Position = UDim2.new(0, 0, 0.5, 0)
    sliderButton.BackgroundColor3 = Theme.Text
    sliderButton.Text = ""
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderBack
    
    CreateCorner(sliderButton, 8)
    
    local dragging = false
    local currentValue = default or min
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(min + (max - min) * pos)
        
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        sliderButton.Position = UDim2.new(pos, 0, 0.5, 0)
        valueLabel.Text = tostring(currentValue)
        
        if callback then
            callback(currentValue)
        end
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
        end
    end)
    
    local initialPos = (currentValue - min) / (max - min)
    sliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
    sliderButton.Position = UDim2.new(initialPos, 0, 0.5, 0)
    
    return sliderFrame
end

function UILibrary:CreateLabel(text)
    local container = self.Content or self.Container
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -20, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text or "Label"
    label.TextColor3 = Theme.TextDim
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    return label
end

function UILibrary:CreateDivider()
    local container = self.Content or self.Container
    
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, -20, 0, 2)
    divider.BackgroundColor3 = Theme.Border
    divider.BorderSizePixel = 0
    divider.Parent = container
    
    CreateCorner(divider, 1)
    
    return divider
end

function UILibrary:CreateNotification(title, message, duration, notifType)
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification"
    notifFrame.Size = UDim2.new(0, 300, 0, 80)
    notifFrame.Position = UDim2.new(1, 320, 1, -100)
    notifFrame.BackgroundColor3 = Theme.Secondary
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = self.ScreenGui
    
    CreateCorner(notifFrame, 10)
    CreateStroke(notifFrame, notifType == "success" and Theme.Success or notifType == "error" and Theme.Error or Theme.Accent, 2)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 40)
    messageLabel.Position = UDim2.new(0, 10, 0, 33)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message or ""
    messageLabel.TextColor3 = Theme.TextDim
    messageLabel.TextSize = 13
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Parent = notifFrame
    
    CreateTween(notifFrame, {Position = UDim2.new(1, -320, 1, -100)}, 0.5, Enum.EasingStyle.Back)
    
    task.spawn(function()
        task.wait(duration or 3)
        CreateTween(notifFrame, {Position = UDim2.new(1, 320, 1, -100)}, 0.3)
        task.wait(0.3)
        notifFrame:Destroy()
    end)
end

return UILibrary
