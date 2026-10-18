-- Central UI Library v5.2 - Clean Example (No Icons)
-- Demonstrates all features with a minimalistic look

local CentralUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Central-UI/main/main.lua?v=5"))()

-- 1. Setup Window
CentralUI:SetTitle("Central UI Demo")
CentralUI:CreateWatermark() 

-- 2. Create Tabs (NO ICONS - passing nil or just name)
local MainTab = CentralUI:CreateTab("Main")
local VisualsTab = CentralUI:CreateTab("Visuals")
local SettingsTab = CentralUI:CreateTab("Settings")
local AboutTab = CentralUI:CreateTab("About")

-- ==========================================
-- MAIN TAB: Basic Elements
-- ==========================================
CentralUI:CreateSection(MainTab, "General Controls")

-- Button with Callback
CentralUI:CreateButton(MainTab, "Print Hello World", function()
    print("Hello from Central UI!")
    CentralUI:Notify("Console", "Check your output window!", 3)
end)

-- Toggle with Flag (Saved in Config)
local flyToggle = CentralUI:CreateToggle(MainTab, "Enable Fly Mode", false, function(state)
    if state then
        CentralUI:Notify("Fly", "Fly Enabled! (Press Space to go up)", 3)
    else
        CentralUI:Notify("Fly", "Fly Disabled", 3)
    end
end, "fly_enabled")

-- Slider with Flag
local speedSlider = CentralUI:CreateSlider(MainTab, "Walk Speed", 16, 100, 16, function(val)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end, "walk_speed")

-- Input Field
CentralUI:CreateInput(MainTab, "Chat Message", "Type here...", "", function(text)
    CentralUI:Notify("Chat", "You typed: " .. text, 3)
end, "chat_msg")

-- Keybind
CentralUI:CreateKeybind(MainTab, "Toggle Fly Key", "F", function(key)
    CentralUI:Notify("Keybind", "Fly key changed to: " .. key, 3)
end, "fly_key")

-- Dropdown
CentralUI:CreateDropdown(MainTab, "Theme Color", {"Dark", "Light", "Blue", "Red"}, "Dark", function(selected)
    CentralUI:Notify("Theme", "Selected: " .. selected, 3)
end, "theme_choice")

-- Color Picker
CentralUI:CreateColorPicker(MainTab, "UI Accent Color", Color3.fromRGB(221, 221, 226), function(color)
    print("Color picked:", color)
end, "accent_color")

CentralUI:CreateLabel(MainTab, "Status: Ready")
CentralUI:CreateParagraph(MainTab, "Info", "This is a demonstration of the Central UI library. All elements are functional.")

-- ==========================================
-- VISUALS TAB: ESP Demo
-- ==========================================
CentralUI:CreateSection(VisualsTab, "ESP Settings")

-- Toggle ESP
local espToggle = CentralUI:CreateToggle(VisualsTab, "Enable Player ESP", false, function(enabled)
    if enabled then
        CentralUI:Notify("ESP", "ESP Enabled (Demo)", 3)
    else
        CentralUI:Notify("ESP", "ESP Disabled", 3)
    end
end, "esp_enabled")

-- ESP Color
CentralUI:CreateColorPicker(VisualsTab, "ESP Box Color", Color3.fromRGB(255, 0, 0), function(color)
    -- Update existing ESP boxes color
end, "esp_color")

-- Dropdown for ESP Type
CentralUI:CreateDropdown(VisualsTab, "ESP Type", {"2D Box", "3D Box", "Skeleton"}, "2D Box", function(type)
    print("ESP Type set to:", type)
end, "esp_type")

-- ==========================================
-- SETTINGS TAB: Config Manager
-- ==========================================
CentralUI:CreateSection(SettingsTab, "Configuration")

-- This creates a FULL config manager interface automatically!
CentralUI:CreateConfigManager(SettingsTab)

-- Manual Config Buttons
CentralUI:CreateButton(SettingsTab, "Reset All Settings", function()
    CentralUI.Flags = {}
    CentralUI:Notify("Reset", "All flags cleared.", 3)
end)

-- ==========================================
-- ABOUT TAB: Info & Dynamic Tabs
-- ==========================================
CentralUI:CreateSection(AboutTab, "Library Info")

CentralUI:CreateParagraph(AboutTab, "Version", "Central UI v5.2.0")
CentralUI:CreateParagraph(AboutTab, "Author", "WareSploit")
CentralUI:CreateLabel(AboutTab, "License: MIT")

-- Dynamic Tab Management Demo
CentralUI:CreateSection(AboutTab, "Dynamic Features")

CentralUI:CreateButton(AboutTab, "Add 'Secret' Tab", function()
    -- Creating tab without icon
    local secretTab = CentralUI:CreateTab("Secret") 
    CentralUI:CreateSection(secretTab, "Hidden Content")
    CentralUI:CreateButton(secretTab, "Click Me!", function()
        CentralUI:Notify("Secret", "You found the secret tab!", 3)
    end)
    CentralUI:Notify("System", "New tab added!", 3)
end)

-- ==========================================
-- NOTIFICATIONS DEMO
-- ==========================================
task.wait(2)
CentralUI:Notify("Welcome", "Central UI Loaded Successfully!", 5)

task.wait(3)
CentralUI:Notify("Tip", "Press RightCtrl to hide/show the UI", 4)

task.wait(3)
CentralUI:Notify("Config", "Try saving a config in the Settings tab!", 4)
