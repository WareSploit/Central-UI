local CentralUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Central-UI/main/main.lua?v=16"))()

CentralUI:SetTitle("WareSploit Hub")
CentralUI:CreateWatermark()

local MainTab = CentralUI:CreateTab("Main", "rbxassetid://10723407389")
local SettingsTab = CentralUI:CreateTab("Settings", "rbxassetid://10734950309")

CentralUI:CreateSection(MainTab, "General")

local toggle1 = CentralUI:CreateToggle(MainTab, "Enable Feature", true, function(state)
    print("Feature enabled:", state)
end, "feature_toggle")

local speedSlider = CentralUI:CreateSlider(MainTab, "WalkSpeed", 16, 100, 16, function(val)
    print("Speed set to:", val)
end, "speed_slider")

local modeDropdown = CentralUI:CreateDropdown(MainTab, "Select Mode", {"Alpha", "Beta", "Gamma", "Delta"}, "Alpha", function(selected)
    print("Mode selected:", selected)
end, "game_mode")

CentralUI:CreateButton(MainTab, "Click Me", function()
    CentralUI:Notify("Action", "You clicked the button!", 3)
end)

CentralUI:CreateSection(SettingsTab, "Config")
CentralUI:CreateButton(SettingsTab, "Save Config", function()
    CentralUI:Notify("Config Saved", "Your configuration has been saved!", 3)
end)

-- Dynamic management demonstration
task.delay(5, function()
    speedSlider.SetValue(75)
    toggle1.SetValue(false)
    modeDropdown.SetValue("Gamma")
    CentralUI:Notify("Scripting", "Elements updated dynamically!", 4)
    
    local ExtraTab = CentralUI:CreateTab("Extra", "rbxassetid://10723415903")
    CentralUI:CreateSection(ExtraTab, "Dynamic Content")
    
    task.wait(5)
    CentralUI:RemoveTab(ExtraTab)
    CentralUI:Notify("Scripting", "Tab 'Extra' was removed!", 3)
end)
