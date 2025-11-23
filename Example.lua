-- Example Usage of Modern Roblox UI Library
-- This file shows how to use the UI library

-- Load the library from GitHub (after uploading)
-- local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/RobloxUILibrary.lua"))()

-- Or load locally for testing
local UILibrary = loadstring(game:HttpGet("path_to_your_file"))()

-- Create a new UI window
local Window = UILibrary.new("My Awesome UI")

-- Add a label
Window:CreateLabel("Welcome to the UI Library!")

-- Add a button
Window:CreateButton("Click Me!", function()
    print("Button clicked!")
    Window:CreateNotification("Success", "Button was clicked!", 3, "success")
end)

-- Add a toggle
Window:CreateToggle("Enable Feature", false, function(state)
    print("Toggle state:", state)
    if state then
        Window:CreateNotification("Enabled", "Feature is now enabled", 2, "success")
    else
        Window:CreateNotification("Disabled", "Feature is now disabled", 2, "error")
    end
end)

-- Add a slider
Window:CreateSlider("Speed", 0, 100, 50, function(value)
    print("Slider value:", value)
end)

-- Add another label
Window:CreateLabel("More Controls:")

-- Add more buttons
Window:CreateButton("Test Notification", function()
    Window:CreateNotification("Info", "This is a test notification!", 3)
end)

Window:CreateButton("Success Notification", function()
    Window:CreateNotification("Great!", "Operation completed successfully", 3, "success")
end)

Window:CreateButton("Error Notification", function()
    Window:CreateNotification("Oops!", "Something went wrong", 3, "error")
end)

-- Add another toggle
Window:CreateToggle("Auto Farm", true, function(state)
    if state then
        print("Auto farm enabled")
    else
        print("Auto farm disabled")
    end
end)

-- Add another slider
Window:CreateSlider("FOV", 70, 120, 90, function(value)
    -- Change FOV example
    workspace.CurrentCamera.FieldOfView = value
end)

print("UI Library loaded successfully!")
