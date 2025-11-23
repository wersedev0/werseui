# werseui 🎨

[![Status](https://img.shields.io/badge/status-beta-yellow.svg)](https://github.com/wersedev0/werseui)
[![Version](https://img.shields.io/badge/version-3.0--beta-blue.svg)](https://github.com/wersedev0/werseui)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

> **⚠️ BETA VERSION** - This UI library is currently in beta. Some features may be unstable or subject to change.

A minimal, modern, and feature-rich UI library for Roblox with a clean black & white theme.

![werseui Preview](https://via.placeholder.com/800x400/0f0f0f/ffffff?text=werseui+UI+Library)

## ✨ Features

- 🎯 **Modern Design** - Clean black & white minimalist interface
- 🎨 **Color Picker** - Advanced RGB color selection with live preview
- ⌨️ **Keybind System** - Customizable keyboard shortcuts
- 🎚️ **Sliders** - Smooth value adjustment with visual feedback
- 🔘 **Toggles** - Elegant on/off switches
- 📝 **Sections & Labels** - Organize your UI with headers and text
- 🔔 **Notifications** - Built-in notification system
- 🖱️ **Draggable** - Title bar dragging support
- 🎭 **Loading Screen** - Branded loading animation
- 🎨 **Customizable** - Easy to modify and extend

## 📦 Installation

### Method 1: Loadstring (Recommended)
```lua
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/wersedev0/werseui/refs/heads/main/RobloxUILibrary.lua"))()
```

### Method 2: Local File
1. Download `RobloxUILibrary.lua`
2. Load it in your executor

## 🚀 Quick Start

```lua
-- Load the library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/wersedev0/werseui/refs/heads/main/RobloxUILibrary.lua"))()

-- Create a window
local Window = UILibrary.new("My Script")

-- Create a tab
local Tab = Window:CreateTab("Main")

-- Add a button
Tab:CreateButton("Click Me", function()
    Window:Notify("Success", "Button clicked!", 2)
end)

-- Add a toggle
Tab:CreateToggle("Auto Farm", false, function(state)
    print("Auto farm:", state)
end)

-- Add a slider
Tab:CreateSlider("Speed", 16, 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```

## 📚 Documentation

### Creating a Window
```lua
local Window = UILibrary.new("Window Title")
```

### Creating Tabs
```lua
local Tab = Window:CreateTab("Tab Name")
```

### UI Elements

#### Button
```lua
Tab:CreateButton("Button Text", function()
    -- Your code here
end)
```

#### Toggle
```lua
Tab:CreateToggle("Toggle Text", defaultState, function(state)
    -- state is true or false
end)
```

#### Slider
```lua
Tab:CreateSlider("Slider Text", min, max, default, function(value)
    -- value is the current slider value
end)
```

#### Color Picker
```lua
Tab:CreateColorPicker("Color Text", Color3.fromRGB(255, 255, 255), function(color)
    -- color is a Color3 value
end)
```

#### Keybind
```lua
Tab:CreateKeybind("Keybind Text", Enum.KeyCode.E, function(key)
    -- key is the selected KeyCode
end)
```

#### Section
```lua
Tab:CreateSection("Section Title")
```

#### Label
```lua
Tab:CreateLabel("Label Text")
```

#### Divider
```lua
Tab:CreateDivider()
```

### Notifications
```lua
Window:Notify("Title", "Message", duration)
```

### UI Control
```lua
-- Change toggle key
Window:SetKey(Enum.KeyCode.RightShift)

-- Change window title
Window:SetTitle("New Title")

-- Toggle UI visibility
Window:Toggle()
```

## 🎨 Customization

The UI uses a theme system that can be easily modified:

```lua
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
```

## 📋 Examples

Check out the example files:
- **`FullExample.lua`** - Complete demonstration of all features
- **`test.lua`** - Simple test file

## 🐛 Known Issues (Beta)

- Color picker may not follow menu when dragging in some cases
- Loading screen animation timing may vary on slower systems
- Some UI elements may overlap on very small screen resolutions

## 🔄 Changelog

### v3.0-beta (Current)
- ✨ Added loading screen with branding
- ✨ Implemented color picker with centered positioning
- ✨ Added title-only dragging
- ✨ Improved menu interaction blocking
- 🎨 Refined UI aesthetics
- 🐛 Fixed various bugs

## 🤝 Contributing

This is a beta version. Bug reports and feature suggestions are welcome!

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

MIT License - feel free to use in your projects!

## 👨‍💻 Developer

**wersedev** - [GitHub](https://github.com/wersedev0)

## 🙏 Credits

- Inspired by modern UI design principles
- Built for the Roblox scripting community

---

<div align="center">

**⭐ Star this repository if you find it useful!**

Made with ❤️ by wersedev

</div>
