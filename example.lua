--[[
    Central UI — Usage Example
]]

local CentralUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/WareSploit/CentralUI/main/main.lua"
))()

-- Watermark
CentralUI:CreateWatermark({ Text = "Central UI | WareSploit" })

-- Welcome + Window
local Win = CentralUI:CreateWindow({
    Name = "WareSploit's Menu",
    LoadingTitle = "Central UI",
    LoadingSubtitle = "by WareSploit",
    Logo = "rbxassetid://10442402750",  -- MAIN-SVG
})

-- Tab "Main"
local Main = Win:CreateTab("Main", "rbxassetid://10723407389")

Main:CreateSection("GENERAL")

Main:CreateButton({
    Name = "Click Me",
    Callback = function()
        CentralUI:Notify({ Title = "Action", Content = "Button clicked!" })
    end,
})

Main:CreateToggle({
    Name = "Enable Feature",
    Flag = "EnableFeature",
    CurrentValue = true,
    Callback = function(v) print("Toggle:", v) end,
})

Main:CreateSlider({
    Name = "Speed",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 50,
    Suffix = "%",
    Flag = "Speed",
    Callback = function(v) print("Speed:", v) end,
})

Main:CreateInput({
    Name = "Nickname",
    PlaceholderText = "Enter nickname...",
    Flag = "Nickname",
})

Main:CreateDropdown({
    Name = "Select Mode",
    Options = {"Alpha", "Beta", "Gamma", "Delta"},
    CurrentOption = "Alpha",
    Flag = "Mode",
    Callback = function(opt) print("Selected:", opt) end,
})

Main:CreateKeybind({
    Name = "Toggle Aim",
    CurrentKeybind = "Q",
    Flag = "AimKey",
    OnPressed = function() print("Aim pressed!") end,
})

Main:CreateColorPicker({
    Name = "Highlight Color",
    Color = Color3.fromRGB(221, 221, 226),
    Flag = "HighlightColor",
})

Main:CreateLabel("Just a static label")
Main:CreateSection("INFO")
Main:CreateParagraph({
    Title = "About",
    Content = "Central UI — dark monochrome library by WareSploit.",
})

CentralUI:Notify({
    Title = "Welcome",
    Content = "Central UI loaded successfully!",
    Duration = 5,
})
