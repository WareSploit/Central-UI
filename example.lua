-- Central UI Library v4.2 - Example Script
-- Demonstrates all available elements and features

local CentralUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Central-UI/main/main.lua?v=4"))()

-- 1. Change window title
CentralUI:SetTitle("My Awesome Hub")

-- 2. Create tabs with custom images
local MainTab = CentralUI:CreateTab("Main", "rbxassetid://10723407389")
local SettingsTab = CentralUI:CreateTab("Settings", "rbxassetid://10734950309")
local VisualsTab = CentralUI:CreateTab("Visuals", "rbxassetid://10734934347")

-- ==========================================
-- MAIN TAB EXAMPLES
-- ==========================================

CentralUI:CreateSection(MainTab, "General")

-- Button
CentralUI:CreateButton(MainTab, "Click Me", function()
    CentralUI:Notify("Action", "You clicked the button!", 3)
end)

-- Toggle with flag (saved in config)
local toggleFeature = CentralUI:CreateToggle(MainTab, "Enable Feature", true, function(enabled)
    print("Feature is now:", enabled)
end, "feature_enabled")

-- Slider with flag
local speedSlider = CentralUI:CreateSlider(MainTab, "Walk Speed", 16, 100, 16, function(value)
    -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end, "walk_speed")

-- Input field
local nicknameInput = CentralUI:CreateInput(MainTab, "Nickname", "Enter name...", "", function(value)
    print("Nickname set to:", value)
end, "player_nickname")

-- Dropdown
local modeDropdown = CentralUI:CreateDropdown(MainTab, "Aim Mode", {"Silent", "Legit", "Rage"}, "Legit", function(selected)
    print("Mode selected:", selected)
end, "aim_mode")

-- Keybind
local aimKey = CentralUI:CreateKeybind(MainTab, "Aim Key", "E", function(key)
    print("Aim key changed to:", key)
end, "aim_keybind")

-- Color Picker
local espColor = CentralUI:CreateColorPicker(MainTab, "ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    print("Color changed")
end, "esp_color")

CentralUI:CreateLabel(MainTab, "Status: Active")
CentralUI:CreateParagraph(MainTab, "Info", "This is a demonstration of the Central UI library capabilities.")

-- ==========================================
-- SETTINGS & CONFIG MANAGER
-- ==========================================

-- This creates a full config manager interface automatically
CentralUI:CreateConfigManager(SettingsTab)

-- ==========================================
-- VISUALS TAB (Dynamic Management Demo)
-- ==========================================

CentralUI:CreateSection(VisualsTab, "Dynamic Tabs")

-- Button to add a new tab dynamically
CentralUI:CreateButton(VisualsTab, "Add 'Extra' Tab", function()
    local extraTab = CentralUI:CreateTab("Extra", "rbxassetid://10723415903")
    CentralUI:CreateSection(extraTab, "New Content")
    CentralUI:CreateButton(extraTab, "Hello from Extra!", function()
        CentralUI:Notify("Extra", "This tab was created at runtime!", 3)
    end)
    CentralUI:Notify("System", "New tab added!", 3)
end)

-- Update Tab Demo
local demoTab = CentralUI:CreateTab("Demo", "rbxassetid://10723407389")
task.wait(2)
demoTab:SetName("Updated Demo")
demoTab:SetIcon("rbxassetid://10734950309")
CentralUI:Notify("System", "Tab 'Demo' updated name and icon!", 3)


-- ==========================================
-- NOTIFICATIONS & WATERMARK
-- ==========================================

task.wait(1)
CentralUI:Notify("Welcome", "Central UI v4.2 Loaded Successfully!", 5)

task.wait(2)
-- Show watermark with Executor detection
CentralUI:CreateWatermark() 
-- Result: "Central UI v4.2.0 | [YourExecutor]"

task.wait(2)
CentralUI:Notify("Tip", "Press RightCtrl to toggle UI visibility", 4)

-- ==========================================
-- TESTING FLAGS & DYNAMIC VALUES
-- ==========================================

task.wait(3)
print("--- Testing Dynamic Updates ---")

-- Change slider value via code
speedSlider.SetValue(50)
print("Speed set to 50")

-- Toggle feature off
toggleFeature.SetValue(false)
print("Feature toggled off")

-- Change dropdown
modeDropdown.SetValue("Rage")
print("Mode set to Rage")

-- Change input
nicknameInput.SetValue("ProPlayer123")
print("Nickname set")

-- Change keybind
aimKey.SetValue("Q")
print("Keybind set to Q")

-- Change color
espColor.SetValue(Color3.fromRGB(0, 255, 0))
print("Color set to Green")

print("--- All tests complete! ---")
