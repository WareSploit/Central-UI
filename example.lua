-- Central UI Library - Example Script
-- Demonstrates all available elements and features

local CentralUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Central-UI/main/main.lua?v=1"))()

-- Create tabs with custom images
local MainTab = CentralUI:CreateTab("Main", "rbxassetid://10723407389")
local SettingsTab = CentralUI:CreateTab("Settings", "rbxassetid://10734950309")
local TeleportTab = CentralUI:CreateTab("Teleport", "rbxassetid://10734934347")
local AboutTab = CentralUI:CreateTab("About", "rbxassetid://10723415903")

-- ==========================================
-- MAIN TAB EXAMPLES
-- ==========================================

CentralUI:CreateSection(MainTab, "General")

-- Button
CentralUI:CreateButton(MainTab, "Click Me", function()
    CentralUI:Notify("Button Clicked", "You clicked the button!", 3)
end)

-- Toggle with flag
local toggle1 = CentralUI:CreateToggle(MainTab, "Enable Feature", true, function(enabled)
    print("Feature enabled:", enabled)
end, "feature_enabled")

-- Toggle without flag
CentralUI:CreateToggle(MainTab, "Auto Save", false, function(enabled)
    print("Auto save:", enabled)
end)

-- Slider with flag
local speedSlider = CentralUI:CreateSlider(MainTab, "Speed", 0, 100, 50, function(value)
    print("Speed changed to:", value)
end, "speed_value")

-- Input field
local nicknameInput = CentralUI:CreateInput(MainTab, "Nickname", "Enter your nickname...", "", function(value)
    print("Nickname set to:", value)
end, "nickname")

-- Dropdown
local modeDropdown = CentralUI:CreateDropdown(MainTab, "Select Mode", {"Alpha", "Beta", "Gamma", "Delta"}, "Alpha", function(selected)
    print("Mode selected:", selected)
end, "game_mode")

-- Keybind
local aimKeybind = CentralUI:CreateKeybind(MainTab, "Toggle Aim", "Q", function(key)
    print("Aim key set to:", key)
end, "aim_key")

-- Color Picker
local colorPicker = CentralUI:CreateColorPicker(MainTab, "Highlight Color", Color3.fromRGB(181, 181, 181), function(color)
    print("Color changed to:", color)
end, "highlight_color")

CentralUI:CreateLabel(MainTab, "Just a static label")

CentralUI:CreateSection(MainTab, "Info")

CentralUI:CreateParagraph(MainTab, "About", "This is a paragraph. Long text wraps here.")

-- ==========================================
-- SETTINGS TAB EXAMPLES
-- ==========================================

CentralUI:CreateSection(SettingsTab, "Config")

CentralUI:CreateButton(SettingsTab, "Save Config", function()
    CentralUI:Notify("Config Saved", "Your configuration has been saved successfully!", 3)
end)

CentralUI:CreateButton(SettingsTab, "Load Config", function()
    CentralUI:Notify("Config Loaded", "Configuration loaded from storage!", 3)
end)

CentralUI:CreateButton(SettingsTab, "Reset", function()
    CentralUI:Notify("Reset Complete", "All settings have been reset to default.", 3)
end)

CentralUI:CreateToggle(SettingsTab, "Notifications", true, function(enabled)
    print("Notifications:", enabled)
end, "notifications_enabled")

-- ==========================================
-- TELEPORT TAB EXAMPLES
-- ==========================================

CentralUI:CreateSection(TeleportTab, "Places")

CentralUI:CreateButton(TeleportTab, "Lobby", function()
    CentralUI:Notify("Teleporting", "Teleporting to Lobby...", 2)
    -- game:GetService("TeleportService"):Teleport(placeId)
end)

CentralUI:CreateButton(TeleportTab, "Arena", function()
    CentralUI:Notify("Teleporting", "Teleporting to Arena...", 2)
end)

CentralUI:CreateButton(TeleportTab, "Safe Zone", function()
    CentralUI:Notify("Teleporting", "Teleporting to Safe Zone...", 2)
end)

-- ==========================================
-- ABOUT TAB EXAMPLES
-- ==========================================

CentralUI:CreateSection(AboutTab, "Central UI")

CentralUI:CreateParagraph(AboutTab, "Version", "v1.0.0")
CentralUI:CreateParagraph(AboutTab, "Author", "by WareSploit")

CentralUI:CreateButton(AboutTab, "Copy Discord", function()
    CentralUI:Notify("Copied!", "Discord invite copied to clipboard!", 3)
end)

-- ==========================================
-- DEMONSTRATE FLAGS SYSTEM
-- ==========================================

task.wait(2)
print("\n=== Current Flags ===")
for flag, value in pairs(CentralUI.Flags) do
    print(flag .. ":", tostring(value))
end

-- ==========================================
-- DEMONSTRATE NOTIFICATIONS
-- ==========================================

task.wait(3)
CentralUI:Notify("Welcome!", "Central UI has been loaded successfully!", 5)

task.wait(2)
CentralUI:Notify("Tip", "Press RightCtrl or LeftCtrl to toggle the UI!", 4)

-- ==========================================
-- CREATE WATERMARK
-- ==========================================

task.wait(2)
CentralUI:CreateWatermark("Central UI")

-- ==========================================
-- DYNAMICALLY CHANGE VALUES
-- ==========================================

task.wait(3)
print("\n=== Changing values dynamically ===")

-- Change slider value
speedSlider.SetValue(75)
print("Speed set to 75")

-- Change toggle state
toggle1.SetValue(false)
print("Feature toggled off")

-- Change dropdown selection
modeDropdown.SetValue("Gamma")
print("Mode changed to Gamma")

-- Change input value
nicknameInput.SetValue("ProPlayer")
print("Nickname changed to ProPlayer")

-- Change keybind
aimKeybind.SetValue("E")
print("Aim key changed to E")

-- Change color
colorPicker.SetValue(Color3.fromRGB(255, 128, 0))
print("Color changed to orange")

print("\n=== All demonstrations complete! ===")
