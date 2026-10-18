--[[
    ╔═══════════════════════════════════════════════════════════════════╗
    ║  Central UI - Example Script                                      ║
    ║  This script demonstrates all available UI elements.              ║
    ║  Author: WareSploit                                               ║
    ╚═══════════════════════════════════════════════════════════════════╝
]]

-- ВАЖНО: Используется raw-ссылка с githubusercontent.com
local CentralUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Central-UI/main/main.lua"))()

-- Создание уведомления
CentralUI:Notify({
    Title = "Central UI",
    Content = "Библиотека успешно загружена!",
    Duration = 5
})

-- Создание главного окна
local Window = CentralUI:CreateWindow({
    Name = "WareSploit Menu",
    LoadingTitle = "Central UI",
    LoadingSubtitle = "by WareSploit",
    Logo = "rbxassetid://10442402750", -- MAIN-SVG (иконка окна)
    Watermark = true
})

-- Вкладка 1: Главная (с иконкой USER-IMAGE)
local MainTab = Window:CreateTab("Main", "rbxassetid://10723407389")

MainTab:CreateSection("BUTTONS & TOGGLES")

MainTab:CreateButton({
    Name = "Click Me!",
    Callback = function()
        CentralUI:Notify({
            Title = "Action",
            Content = "Кнопка была нажата.",
            Duration = 3
        })
    end
})

MainTab:CreateToggle({
    Name = "Enable Feature",
    Flag = "FeatureState",
    CurrentValue = true,
    Callback = function(state)
        print("Feature enabled:", state)
    end
})

MainTab:CreateSection("SLIDERS & INPUTS")

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Suffix = " spd",
    Flag = "SpeedSlider",
    Callback = function(val)
        print("Slider value:", val)
    end
})

MainTab:CreateInput({
    Name = "Custom Text",
    PlaceholderText = "Введите текст...",
    Flag = "TextInput",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        print("Input text:", text)
    end
})

MainTab:CreateSection("DROPDOWNS & KEYBINDS")

MainTab:CreateDropdown({
    Name = "Select Mode",
    Options = {"Alpha", "Beta", "Gamma", "Delta", "Epsilon"},
    CurrentOption = "Alpha",
    Flag = "SelectedMode",
    Callback = function(option)
        print("Dropdown selected:", option)
    end
})

MainTab:CreateKeybind({
    Name = "Toggle Aim",
    CurrentKeybind = "Q",
    Flag = "AimKey",
    OnPressed = function()
        print("Keybind pressed!")
    end
})

MainTab:CreateColorPicker({
    Name = "Highlight Color",
    Color = Color3.fromRGB(221, 221, 226),
    Flag = "HighlightColor",
    Callback = function(color)
        print("Color changed:", color)
    end
})

MainTab:CreateSection("INFO")
MainTab:CreateParagraph({
    Title = "About Central UI",
    Content = "A sleek, monochrome UI library created by WareSploit. Fully customizable and easy to use.",
})

-- Вкладка 2: Настройки (с иконкой USER-IMAGE)
local SettingsTab = Window:CreateTab("Settings", "rbxassetid://10734950309")

SettingsTab:CreateSection("CONFIGURATION")
SettingsTab:CreateButton({ Name = "Save Config" })
SettingsTab:CreateButton({ Name = "Load Config" })
SettingsTab:CreateButton({ Name = "Reset Settings" })

SettingsTab:CreateLabel("Central UI v" .. CentralUI.Version)
SettingsTab:CreateLabel("Made by " .. CentralUI.Author)
