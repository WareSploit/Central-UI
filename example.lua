-- Central UI Library - Example Script
local CentralUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Central-UI/main/main.lua?v=5"))()

-- Смена названия окна
CentralUI:SetTitle("WareSploit Hub")

-- Создание вкладок
local MainTab = CentralUI:CreateTab("Main", "rbxassetid://10723407389")
local SettingsTab = CentralUI:CreateTab("Settings", "rbxassetid://10734950309")

-- Водяной знак (теперь сам покажет экзекьютор и версию)
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
-- SETTINGS TAB (Демонстрация динамических вкладок)
-- ==========================================
CentralUI:CreateSection(SettingsTab, "Tab Management")

CentralUI:CreateButton(SettingsTab, "Change Main Icon", function()
    -- Меняем иконку вкладки Main на лету
    MainTab:SetIcon("rbxassetid://10734934347")
    CentralUI:Notify("Tab", "Main icon changed!", 2)
end)

CentralUI:CreateButton(SettingsTab, "Rename Main Tab", function()
    -- Переименовываем вкладку
    MainTab:SetName("Renamed Main")
    CentralUI:Notify("Tab", "Main tab renamed!", 2)
end)

CentralUI:CreateButton(SettingsTab, "Remove This Tab", function()
    -- Удаляем текущую вкладку (Settings)
    CentralUI:RemoveTab(SettingsTab)
    CentralUI:Notify("Tab", "Settings tab removed!", 2)
end)

-- Создаем третью вкладку через 3 секунды для теста
task.delay(3, function()
    local NewTab = CentralUI:CreateTab("Dynamic", "rbxassetid://10723415903")
    CentralUI:CreateSection(NewTab, "New Tab")
    CentralUI:CreateLabel(NewTab, "This tab was added dynamically!")
    CentralUI:Notify("Info", "A new tab was added dynamically!", 3)
end)
