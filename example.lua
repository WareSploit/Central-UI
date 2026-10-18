-- Central UI Library - Example Script
-- Make sure to use v=7 to bypass cache
local CentralUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Central-UI/main/main.lua?v=7"))()

-- Change window title
CentralUI:SetTitle("WareSploit Hub")

-- Create tabs
local MainTab = CentralUI:CreateTab("Main", "rbxassetid://10723407389")
local SettingsTab = CentralUI:CreateTab("Settings", "rbxassetid://10734950309")

-- Show Watermark (Executor + Version)
CentralUI:CreateWatermark()

-- ==========================================
-- MAIN TAB
-- ==========================================
CentralUI:CreateSection(MainTab, "General")

CentralUI:CreateButton(MainTab, "Click Me", function()
    CentralUI:Notify("Button Clicked", "You clicked the button!", 3)
end)

CentralUI:CreateDropdown(MainTab, "Select Mode", {"Alpha", "Beta", "Gamma", "Delta"}, "Alpha", function(selected)
    print("Mode selected:", selected)
end, "game_mode")

-- ==========================================
-- SETTINGS TAB
-- ==========================================
CentralUI:CreateSection(SettingsTab, "Tab Management")

CentralUI:CreateButton(SettingsTab, "Change Main Icon", function()
    MainTab:SetIcon("rbxassetid://10734934347")
    CentralUI:Notify("Tab", "Main icon changed!", 2)
end)

CentralUI:CreateButton(SettingsTab, "Rename Main Tab", function()
    MainTab:SetName("Renamed Main")
    CentralUI:Notify("Tab", "Main tab renamed!", 2)
end)

CentralUI:CreateButton(SettingsTab, "Remove This Tab", function()
    CentralUI:RemoveTab(SettingsTab)
    CentralUI:Notify("Tab", "Settings tab removed!", 2)
end)

-- Dynamically create a new tab after 3 seconds
task.delay(3, function()
    local NewTab = CentralUI:CreateTab("Dynamic", "rbxassetid://10723415903")
    CentralUI:CreateSection(NewTab, "New Tab")
    CentralUI:CreateLabel(NewTab, "This tab was added dynamically!")
    CentralUI:Notify("Info", "A new tab was added dynamically!", 3)
end)
