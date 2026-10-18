--!nolint UndefinedVariable
--[=[
    Central UI Library
    Monochrome Dark Theme
    Author: WareSploit
    Repository: https://github.com/WareSploit/Central-UI
]=]

local CentralUI = {}
CentralUI.__index = CentralUI

local CONFIG = {
    Colors = {
        Background = Color3.fromRGB(16, 16, 18),
        Topbar = Color3.fromRGB(23, 23, 25),
        Element = Color3.fromRGB(31, 31, 34),
        Accent = Color3.fromRGB(221, 221, 226),
        Text = Color3.fromRGB(241, 241, 241),
        Subtext = Color3.fromRGB(151, 151, 151),
        Stroke = Color3.fromRGB(61, 61, 66),
        Line = Color3.fromRGB(46, 46, 49),
        Danger = Color3.fromRGB(200, 60, 60)
    },
    Fonts = {
        Regular = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        Medium = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        Bold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    },
    LogoID = "rbxassetid://10442402750",
    Version = "v1.0.0"
}

CentralUI.Flags = {}

local function GetExecutor()
    local executor = "Unknown"
    if identifyexecutor then
        local success, result = pcall(identifyexecutor)
        if success and type(result) == "string" then executor = result end
    elseif syn then executor = "Synapse X"
    elseif KRNL_LOADED then executor = "Krnl"
    elseif fluxus then executor = "Fluxus"
    end
    return executor
end

local function TweenProperty(instance, property, goal, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(duration or 0.25, easingStyle or Enum.EasingStyle.Back, easingDirection or Enum.EasingDirection.Out)
    return game:GetService("TweenService"):Create(instance, tweenInfo, {[property] = goal})
end

local function CreateInstance(class, parent, properties)
    local instance = Instance.new(class)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then instance[prop] = value end
    end
    instance.Parent = parent
    return instance
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CentralUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100
ScreenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Welcomer (Loading Screen)
local WelcomerFrame = CreateInstance("Frame", ScreenGui, {
    BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(11, 11, 13), Size = UDim2.new(0.46719, 0, 0.39769, 0), Position = UDim2.new(0.27489, 0, 0.31732, 0), Name = "WelcomerFrame"
})
CreateInstance("UICorner", WelcomerFrame, {CornerRadius = UDim.new(0, 6)})
CreateInstance("UIStroke", WelcomerFrame, {Transparency = 0.5, Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})

local WelcomerContent = CreateInstance("Frame", WelcomerFrame, {Size = UDim2.new(0, 420, 0, 200), Position = UDim2.new(0.5, -210, 0.5, -100), Name = "Content", BackgroundTransparency = 1})
CreateInstance("ImageLabel", WelcomerContent, {Image = CONFIG.LogoID, Size = UDim2.new(0, 107, 0, 74), BackgroundTransparency = 1, Name = "MAIN-SVG", Position = UDim2.new(0.37046, 0, -0.06682, 0)})
CreateInstance("TextLabel", WelcomerContent, {TextSize = 34, FontFace = CONFIG.Fonts.Bold, TextColor3 = CONFIG.Colors.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 46), Text = "Central UI", Name = "Title", Position = UDim2.new(0, 0, 0, 36)})
CreateInstance("TextLabel", WelcomerContent, {TextSize = 13, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Subtext, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Text = "Loading, please wait...", Name = "Subtitle", Position = UDim2.new(0, 0, 0, 82)})

local ProgressBar = CreateInstance("Frame", WelcomerContent, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Element, Size = UDim2.new(0.7, 0, 0, 3), Position = UDim2.new(0.15, 0, 0, 130), Name = "ProgressBar"})
CreateInstance("UICorner", ProgressBar, {CornerRadius = UDim.new(0, 2)})
local ProgressFill = CreateInstance("Frame", ProgressBar, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Accent, Size = UDim2.new(0, 0, 1, 0), Name = "Fill"})
CreateInstance("UICorner", ProgressFill, {CornerRadius = UDim.new(0, 2)})

local PercentText = CreateInstance("TextLabel", WelcomerContent, {TextSize = 11, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Subtext, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), Text = "0%", Name = "Percent", Position = UDim2.new(0, 0, 0, 145)})
CreateInstance("TextLabel", WelcomerFrame, {TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Subtext, BackgroundTransparency = 1, Size = UDim2.new(0, 80, 0, 18), Text = CONFIG.Version, Name = "Version", Position = UDim2.new(1, -90, 1, -28)})

-- Main Window
local MainWindow = CreateInstance("Frame", ScreenGui, {
    Visible = false, BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Background, ClipsDescendants = true, Size = UDim2.new(0, 540, 0, 380), Position = UDim2.new(0.5, -270, 0.5, -190), Name = "MainWindow"
})
CreateInstance("UICorner", MainWindow, {CornerRadius = UDim.new(0, 6)})
CreateInstance("UIStroke", MainWindow, {Transparency = 0.5, Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})

local WindowScale = Instance.new("UIScale")
WindowScale.Scale = 0.9
WindowScale.Parent = MainWindow

-- Loading Animation
task.spawn(function()
    for i = 0, 100, 2 do
        task.wait(0.02)
        ProgressFill.Size = UDim2.new(i / 100, 0, 1, 0)
        PercentText.Text = i .. "%"
    end
    TweenProperty(WelcomerFrame, "BackgroundTransparency", 1, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
    for _, child in pairs(WelcomerFrame:GetDescendants()) do
        if child:IsA("TextLabel") then TweenProperty(child, "TextTransparency", 1, 0.5):Play()
        elseif child:IsA("ImageLabel") then TweenProperty(child, "ImageTransparency", 1, 0.5):Play()
        elseif child:IsA("Frame") then TweenProperty(child, "BackgroundTransparency", 1, 0.5):Play()
        elseif child:IsA("UIStroke") then TweenProperty(child, "Transparency", 1, 0.5):Play() end
    end
    task.wait(0.5)
    WelcomerFrame.Visible = false
    MainWindow.Visible = true
    TweenProperty(WindowScale, "Scale", 1, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
end)

-- Topbar
local Topbar = CreateInstance("Frame", MainWindow, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Topbar, Size = UDim2.new(1, 0, 0, 46), Name = "Topbar"})
CreateInstance("UICorner", Topbar, {CornerRadius = UDim.new(0, 6)})
CreateInstance("Frame", Topbar, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Stroke, Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1)})

local TitleLabel = CreateInstance("TextLabel", Topbar, {TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Medium, TextColor3 = CONFIG.Colors.Text, BackgroundTransparency = 1, Size = UDim2.new(0.91481, -120, 1, 0), Text = "Central UI", Position = UDim2.new(0, 62, 0, 0)})
CreateInstance("ImageLabel", Topbar, {Image = CONFIG.LogoID, Size = UDim2.new(0, 62, 0, 55), BackgroundTransparency = 1, Name = "MAIN-SVG", Position = UDim2.new(0, 0, -0.1087, 0)})

local MinBtn = CreateInstance("TextButton", Topbar, {
    BorderSizePixel = 0, TextSize = 14, AutoButtonColor = false, TextColor3 = CONFIG.Colors.Subtext, BackgroundColor3 = CONFIG.Colors.Element, FontFace = CONFIG.Fonts.Bold, Size = UDim2.new(0, 28, 0, 28), Text = "—", Name = "MinBtn", Position = UDim2.new(1, -76, 0.5, -14), ZIndex = 10
})
CreateInstance("UICorner", MinBtn, {CornerRadius = UDim.new(0, 4)})
CreateInstance("UIStroke", MinBtn, {Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})

local CloseBtn = CreateInstance("TextButton", Topbar, {
    BorderSizePixel = 0, TextSize = 12, AutoButtonColor = false, TextColor3 = CONFIG.Colors.Subtext, BackgroundColor3 = CONFIG.Colors.Element, FontFace = CONFIG.Fonts.Bold, Size = UDim2.new(0, 28, 0, 28), Text = "✕", Name = "CloseBtn", Position = UDim2.new(1, -42, 0.5, -14), ZIndex = 10
})
CreateInstance("UICorner", CloseBtn, {CornerRadius = UDim.new(0, 4)})
CreateInstance("UIStroke", CloseBtn, {Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})

-- Tab Holder & Content Holder
local TabHolder = CreateInstance("Frame", MainWindow, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Background, Size = UDim2.new(0, 140, 1, -46), Position = UDim2.new(0, 0, 0, 46), Name = "TabHolder"})
local TabScroll = CreateInstance("ScrollingFrame", TabHolder, {BorderSizePixel = 0, Name = "TabScroll", AutomaticCanvasSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 1, 0), ScrollBarImageColor3 = CONFIG.Colors.Subtext, ScrollBarThickness = 2, BackgroundTransparency = 1})
CreateInstance("UIPadding", TabScroll, {PaddingTop = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8)})
CreateInstance("UIListLayout", TabScroll, {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})

local ContentHolder = CreateInstance("Frame", MainWindow, {ClipsDescendants = true, Size = UDim2.new(1, -140, 1, -46), Position = UDim2.new(0, 140, 0, 46), Name = "ContentHolder", BackgroundTransparency = 1})

-- ==========================================
-- SMOOTH DRAGGING LOGIC (FIXED)
-- ==========================================
local dragging = false
local dragStart, startPos, targetX, targetY = nil, nil, 0, 0

Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        
        -- Фиксируем текущую позицию в Offset (пикселях), чтобы окно не прыгало
        local absPos = MainWindow.AbsolutePosition
        startPos = UDim2.new(0, absPos.X, 0, absPos.Y)
        
        -- Мгновенно применяем Offset, чтобы избежать конфликта Scale
        MainWindow.Position = startPos
        
        targetX = absPos.X
        targetY = absPos.Y
    end
end)

Topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            targetX = startPos.X.Offset + delta.X
            targetY = startPos.Y.Offset + delta.Y
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Плавный Lerp
RunService.RenderStepped:Connect(function(dt)
    if dragging then
        local cx = MainWindow.Position.X.Offset
        local cy = MainWindow.Position.Y.Offset
        local nx = cx + (targetX - cx) * math.min(dt * 25, 1)
        local ny = cy + (targetY - cy) * math.min(dt * 25, 1)
        MainWindow.Position = UDim2.new(0, nx, 0, ny)
    end
end)

-- ==========================================
-- MINIMIZE LOGIC
-- ==========================================
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TabHolder.Visible = false
        ContentHolder.Visible = false
        TweenProperty(MainWindow, "Size", UDim2.new(0, 540, 0, 46), 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
    else
        TabHolder.Visible = true
        ContentHolder.Visible = true
        TweenProperty(MainWindow, "Size", UDim2.new(0, 540, 0, 380), 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
    end
end)

-- ==========================================
-- CLOSE CONFIRMATION LOGIC
-- ==========================================
local ConfirmOverlay = CreateInstance("Frame", ScreenGui, {
    Visible = false, BorderSizePixel = 0, BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.5, Size = UDim2.new(1,0,1,0), ZIndex = 50
})

local ConfirmDialog = CreateInstance("Frame", ConfirmOverlay, {
    Size = UDim2.new(0, 300, 0, 150), Position = UDim2.new(0.5, -150, 0.5, -75), BackgroundColor3 = CONFIG.Colors.Background, BorderSizePixel = 0, ZIndex = 51
})
CreateInstance("UICorner", ConfirmDialog, {CornerRadius = UDim.new(0, 6)})
CreateInstance("UIStroke", ConfirmDialog, {Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})

CreateInstance("TextLabel", ConfirmDialog, {
    Text = "Are you sure you want to close?", TextSize = 15, FontFace = CONFIG.Fonts.Medium, TextColor3 = CONFIG.Colors.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 30), ZIndex = 52
})

local YesBtn = CreateInstance("TextButton", ConfirmDialog, {
    Text = "Yes", TextSize = 13, FontFace = CONFIG.Fonts.Medium, AutoButtonColor = false, TextColor3 = CONFIG.Colors.Text, BackgroundColor3 = CONFIG.Colors.Danger, Size = UDim2.new(0, 100, 0, 30), Position = UDim2.new(0.5, -110, 1, -50), ZIndex = 52
})
CreateInstance("UICorner", YesBtn, {CornerRadius = UDim.new(0, 4)})

local NoBtn = CreateInstance("TextButton", ConfirmDialog, {
    Text = "No", TextSize = 13, FontFace = CONFIG.Fonts.Medium, AutoButtonColor = false, TextColor3 = CONFIG.Colors.Text, BackgroundColor3 = CONFIG.Colors.Element, Size = UDim2.new(0, 100, 0, 30), Position = UDim2.new(0.5, 10, 1, -50), ZIndex = 52
})
CreateInstance("UICorner", NoBtn, {CornerRadius = UDim.new(0, 4)})
CreateInstance("UIStroke", NoBtn, {Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})

CloseBtn.MouseButton1Click:Connect(function() ConfirmOverlay.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmOverlay.Visible = false end)
YesBtn.MouseButton1Click:Connect(function()
    ConfirmOverlay.Visible = false
    local tween = game:GetService("TweenService"):Create(WindowScale, TweenInfo.new(0.3), {Scale = 0})
    tween:Play()
    tween.Completed:Wait()
    ScreenGui:Destroy()
end)

-- Toggle UI Visibility (Ctrl)
local isOpen = true
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.LeftControl then
        isOpen = not isOpen
        MainWindow.Visible = isOpen
        if isOpen then TweenProperty(WindowScale, "Scale", 1, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play() end
    end
end)

-- ==========================================
-- TAB MANAGEMENT
-- ==========================================
local Tabs = {}
local CurrentTab = nil

function CentralUI:SetTitle(newTitle) TitleLabel.Text = newTitle end

function CentralUI:CreateTab(name, imageId)
    local tabData = {}
    local tabBtn = CreateInstance("TextButton", TabScroll, {
        BorderSizePixel = 0, TextSize = 13, AutoButtonColor = false, TextColor3 = CONFIG.Colors.Subtext, BackgroundColor3 = CONFIG.Colors.Background, FontFace = CONFIG.Fonts.Medium, Size = UDim2.new(1, 0, 0, 32), LayoutOrder = #Tabs + 1, Text = name
    })
    CreateInstance("UICorner", tabBtn, {CornerRadius = UDim.new(0, 6)})
    CreateInstance("UIStroke", tabBtn, {Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    
    local iconLabel = nil
    if imageId then
        iconLabel = CreateInstance("ImageLabel", tabBtn, {Image = imageId, Size = UDim2.new(0, 20, 0, 19), BackgroundTransparency = 1, Name = "USER-IMAGE", Position = UDim2.new(0.10484, 0, 0.1875, 0)})
    end
    
    local contentFrame = CreateInstance("ScrollingFrame", ContentHolder, {
        Visible = false, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 1, 0), ScrollBarImageColor3 = CONFIG.Colors.Stroke, ScrollBarThickness = 3, BackgroundTransparency = 1
    })
    CreateInstance("UIPadding", contentFrame, {PaddingTop = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8)})
    CreateInstance("UIListLayout", contentFrame, {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Button.TextColor3 = CONFIG.Colors.Subtext
            tab.Button.BackgroundColor3 = CONFIG.Colors.Background
            tab.Content.Visible = false
        end
        tabBtn.TextColor3 = CONFIG.Colors.Text
        tabBtn.BackgroundColor3 = CONFIG.Colors.Element
        contentFrame.Visible = true
        CurrentTab = tabData
    end)
    
    tabData.Button = tabBtn; tabData.Content = contentFrame; tabData.Name = name
    
    function tabData:SetIcon(newImageId)
        if iconLabel then iconLabel.Image = newImageId
        else iconLabel = CreateInstance("ImageLabel", tabBtn, {Image = newImageId, Size = UDim2.new(0, 20, 0, 19), BackgroundTransparency = 1, Name = "USER-IMAGE", Position = UDim2.new(0.10484, 0, 0.1875, 0)}) end
    end
    function tabData:SetName(newName) tabBtn.Text = newName; tabData.Name = newName end
    
    table.insert(Tabs, tabData)
    if #Tabs == 1 then
        tabBtn.TextColor3 = CONFIG.Colors.Text
        tabBtn.BackgroundColor3 = CONFIG.Colors.Element
        contentFrame.Visible = true
        CurrentTab = tabData
    end
    return tabData
end

function CentralUI:RemoveTab(tabData)
    if not tabData then return end
    tabData.Button:Destroy(); tabData.Content:Destroy()
    for i, t in ipairs(Tabs) do if t == tabData then table.remove(Tabs, i) break end end
    if CurrentTab == tabData then
        if #Tabs > 0 then
            for _, tab in pairs(Tabs) do tab.Button.TextColor3 = CONFIG.Colors.Subtext; tab.Button.BackgroundColor3 = CONFIG.Colors.Background; tab.Content.Visible = false end
            Tabs[1].Button.TextColor3 = CONFIG.Colors.Text; Tabs[1].Button.BackgroundColor3 = CONFIG.Colors.Element; Tabs[1].Content.Visible = true
            CurrentTab = Tabs[1]
        else CurrentTab = nil end
    end
end

-- ==========================================
-- UI ELEMENTS
-- ==========================================
function CentralUI:CreateSection(tab, title)
    local section = CreateInstance("Frame", tab.Content, {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1})
    CreateInstance("TextLabel", section, {TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Medium, TextColor3 = CONFIG.Colors.Subtext, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Text = title:upper()})
    CreateInstance("Frame", section, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Line, Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 20)})
    return section
end

function CentralUI:CreateButton(tab, text, callback)
    local element = CreateInstance("Frame", tab.Content, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Element, Size = UDim2.new(1, 0, 0, 34)})
    CreateInstance("UICorner", element, {CornerRadius = UDim.new(0, 6)})
    CreateInstance("UIStroke", element, {Transparency = 0.6, Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    local btn = CreateInstance("TextButton", element, {TextSize = 13, AutoButtonColor = false, TextColor3 = CONFIG.Colors.Text, FontFace = CONFIG.Fonts.Regular, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = text})
    btn.MouseEnter:Connect(function() TweenProperty(element, "BackgroundColor3", Color3.fromRGB(36, 36, 39), 0.15):Play() end)
    btn.MouseLeave:Connect(function() TweenProperty(element, "BackgroundColor3", CONFIG.Colors.Element, 0.15):Play() end)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    return btn
end

function CentralUI:CreateToggle(tab, text, default, callback, flag)
    local enabled = default or false
    if flag then CentralUI.Flags[flag] = enabled end
    local element = CreateInstance("Frame", tab.Content, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Element, Size = UDim2.new(1, 0, 0, 34)})
    CreateInstance("UICorner", element, {CornerRadius = UDim.new(0, 6)})
    CreateInstance("UIStroke", element, {Transparency = 0.6, Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    CreateInstance("TextLabel", element, {TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -60, 1, 0), Text = text, Position = UDim2.new(0, 12, 0, 0)})
    local toggleBg = CreateInstance("Frame", element, {BorderSizePixel = 0, BackgroundColor3 = enabled and CONFIG.Colors.Accent or CONFIG.Colors.Line, Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -48, 0.5, -9)})
    CreateInstance("UICorner", toggleBg, {CornerRadius = UDim.new(0, 9)})
    if not enabled then CreateInstance("UIStroke", toggleBg, {Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}) end
    local toggleKnob = CreateInstance("Frame", toggleBg, {BorderSizePixel = 0, BackgroundColor3 = enabled and CONFIG.Colors.Background or CONFIG.Colors.Subtext, Size = UDim2.new(0, 14, 0, 14), Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
    CreateInstance("UICorner", toggleKnob, {CornerRadius = UDim.new(0, 7)})
    
    local function updateToggle()
        enabled = not enabled
        if flag then CentralUI.Flags[flag] = enabled end
        if enabled then
            TweenProperty(toggleBg, "BackgroundColor3", CONFIG.Colors.Accent, 0.2):Play()
            TweenProperty(toggleKnob, "Position", UDim2.new(1, -16, 0.5, -7), 0.2):Play()
            TweenProperty(toggleKnob, "BackgroundColor3", CONFIG.Colors.Background, 0.2):Play()
            for _, child in pairs(toggleBg:GetChildren()) do if child:IsA("UIStroke") then child:Destroy() end end
        else
            TweenProperty(toggleBg, "BackgroundColor3", CONFIG.Colors.Line, 0.2):Play()
            TweenProperty(toggleKnob, "Position", UDim2.new(0, 2, 0.5, -7), 0.2):Play()
            TweenProperty(toggleKnob, "BackgroundColor3", CONFIG.Colors.Subtext, 0.2):Play()
            if not toggleBg:FindFirstChild("UIStroke") then CreateInstance("UIStroke", toggleBg, {Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}) end
        end
        if callback then callback(enabled) end
    end
    element.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then updateToggle() end end)
    return {GetValue = function() return enabled end, SetValue = function(val) if enabled ~= val then updateToggle() end end}
end

function CentralUI:CreateSlider(tab, text, min, max, default, callback, flag)
    local value = default or min
    if flag then CentralUI.Flags[flag] = value end
    local element = CreateInstance("Frame", tab.Content, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Element, Size = UDim2.new(1, 0, 0, 56)})
    CreateInstance("UICorner", element, {CornerRadius = UDim.new(0, 6)})
    CreateInstance("UIStroke", element, {Transparency = 0.6, Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    CreateInstance("TextLabel", element, {TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -70, 0, 20), Text = text, Position = UDim2.new(0, 12, 0, 6)})
    local valueText = CreateInstance("TextLabel", element, {TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, FontFace = CONFIG.Fonts.Medium, TextColor3 = CONFIG.Colors.Accent, BackgroundTransparency = 1, Size = UDim2.new(0, 60, 0, 20), Text = tostring(value), Position = UDim2.new(1, -72, 0, 6)})
    local sliderBg = CreateInstance("Frame", element, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Line, Size = UDim2.new(1, -24, 0, 4), Position = UDim2.new(0, 12, 1, -14)})
    CreateInstance("UICorner", sliderBg, {CornerRadius = UDim.new(0, 2)})
    local sliderFill = CreateInstance("Frame", sliderBg, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Accent, Size = UDim2.new((value - min) / (max - min), 0, 1, 0)})
    CreateInstance("UICorner", sliderFill, {CornerRadius = UDim.new(0, 2)})
    local sliderKnob = CreateInstance("Frame", sliderBg, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Background, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6)})
    CreateInstance("UICorner", sliderKnob, {CornerRadius = UDim.new(0, 6)})
    CreateInstance("UIStroke", sliderKnob, {Thickness = 2, Color = CONFIG.Colors.Accent, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    
    local dragging = false
    local function updateSlider(input)
        local percent = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * percent + 0.5)
        if flag then CentralUI.Flags[flag] = value end
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percent, -6, 0.5, -6)
        valueText.Text = tostring(value)
        if callback then callback(value) end
    end
    sliderBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then updateSlider(input); dragging = true end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    return {GetValue = function() return value end, SetValue = function(val) value = math.clamp(val, min, max); if flag then CentralUI.Flags[flag] = value end; local percent = (value - min) / (max - min); sliderFill.Size = UDim2.new(percent, 0, 1, 0); sliderKnob.Position = UDim2.new(percent, -6, 0.5, -6); valueText.Text = tostring(value); if callback then callback(value) end end}
end

function CentralUI:CreateDropdown(tab, text, options, default, callback, flag)
    local selected = default or options[1] or "None"
    if flag then CentralUI.Flags[flag] = selected end
    local expanded = false
    local element = CreateInstance("Frame", tab.Content, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Element, Size = UDim2.new(1, 0, 0, 34), ClipsDescendants = true})
    CreateInstance("UICorner", element, {CornerRadius = UDim.new(0, 6)})
    CreateInstance("UIStroke", element, {Transparency = 0.6, Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    
    local headerBtn = CreateInstance("TextButton", element, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), Text = "", ZIndex = 2})
    CreateInstance("TextLabel", headerBtn, {TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -100, 1, 0), Text = text, Position = UDim2.new(0, 12, 0, 0)})
    local selectedText = CreateInstance("TextLabel", headerBtn, {TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Accent, BackgroundTransparency = 1, Size = UDim2.new(0, 70, 1, 0), Text = tostring(selected), Position = UDim2.new(0.98438, -90, 0, 0)})
    local arrow = CreateInstance("TextLabel", headerBtn, {TextSize = 9, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Subtext, BackgroundTransparency = 1, Size = UDim2.new(0, 20, 0, 20), Text = "▼", Position = UDim2.new(1, -26, 0.5, -10)})
    
    local dropdownList = CreateInstance("Frame", element, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Element, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 34), Visible = false, ZIndex = 1})
    CreateInstance("UIListLayout", dropdownList, {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
    
    for i, option in ipairs(options) do
        local optionBtn = CreateInstance("TextButton", dropdownList, {BorderSizePixel = 0, TextSize = 12, AutoButtonColor = false, TextColor3 = CONFIG.Colors.Text, BackgroundColor3 = CONFIG.Colors.Background, FontFace = CONFIG.Fonts.Regular, Size = UDim2.new(1, 0, 0, 28), Text = option, LayoutOrder = i})
        optionBtn.MouseButton1Click:Connect(function()
            selected = option; if flag then CentralUI.Flags[flag] = selected end; selectedText.Text = tostring(selected)
            expanded = false; dropdownList.Visible = false; TweenProperty(element, "Size", UDim2.new(1, 0, 0, 34), 0.2):Play(); arrow.Text = "▼"
            if callback then callback(selected) end
        end)
        optionBtn.MouseEnter:Connect(function() TweenProperty(optionBtn, "BackgroundColor3", Color3.fromRGB(36, 36, 39), 0.15):Play() end)
        optionBtn.MouseLeave:Connect(function() TweenProperty(optionBtn, "BackgroundColor3", CONFIG.Colors.Background, 0.15):Play() end)
    end
    
    headerBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            TweenProperty(element, "Size", UDim2.new(1, 0, 0, 34 + (#options * 30)), 0.2):Play(); dropdownList.Visible = true; arrow.Text = "▲"
        else
            TweenProperty(element, "Size", UDim2.new(1, 0, 0, 34), 0.2):Play(); dropdownList.Visible = false; arrow.Text = "▼"
        end
    end)
    return {GetValue = function() return selected end, SetValue = function(val) selected = val; if flag then CentralUI.Flags[flag] = selected end; selectedText.Text = tostring(selected) end}
end

function CentralUI:CreateInput(tab, text, placeholder, default, callback, flag)
    local value = default or ""
    if flag then CentralUI.Flags[flag] = value end
    local element = CreateInstance("Frame", tab.Content, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Element, Size = UDim2.new(1, 0, 0, 56)})
    CreateInstance("UICorner", element, {CornerRadius = UDim.new(0, 6)})
    CreateInstance("UIStroke", element, {Transparency = 0.6, Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    CreateInstance("TextLabel", element, {TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -24, 0, 20), Text = text, Position = UDim2.new(0, 12, 0, 6)})
    local inputBox = CreateInstance("TextBox", element, {PlaceholderColor3 = CONFIG.Colors.Subtext, BorderSizePixel = 0, TextSize = 13, TextColor3 = CONFIG.Colors.Text, BackgroundColor3 = CONFIG.Colors.Topbar, FontFace = CONFIG.Fonts.Regular, ClearTextOnFocus = false, PlaceholderText = placeholder or "Enter text...", Size = UDim2.new(1, -24, 0, 24), Position = UDim2.new(0, 12, 0, 26), Text = value})
    CreateInstance("UICorner", inputBox, {CornerRadius = UDim.new(0, 4)})
    CreateInstance("UIStroke", inputBox, {Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    inputBox.FocusLost:Connect(function(enterPressed) value = inputBox.Text; if flag then CentralUI.Flags[flag] = value end; if callback then callback(value, enterPressed) end end)
    return {GetValue = function() return inputBox.Text end, SetValue = function(val) inputBox.Text = val; value = val; if flag then CentralUI.Flags[flag] = value end end}
end

function CentralUI:CreateKeybind(tab, text, defaultKey, callback, flag)
    local currentKey = defaultKey or "None"
    if flag then CentralUI.Flags[flag] = currentKey end
    local listening = false
    local element = CreateInstance("Frame", tab.Content, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Element, Size = UDim2.new(1, 0, 0, 34)})
    CreateInstance("UICorner", element, {CornerRadius = UDim.new(0, 6)})
    CreateInstance("UIStroke", element, {Transparency = 0.6, Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    CreateInstance("TextLabel", element, {TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -100, 1, 0), Text = text, Position = UDim2.new(0, 12, 0, 0)})
    local keyBtn = CreateInstance("TextButton", element, {BorderSizePixel = 0, TextSize = 12, AutoButtonColor = false, TextColor3 = CONFIG.Colors.Accent, BackgroundColor3 = CONFIG.Colors.Topbar, FontFace = CONFIG.Fonts.Medium, Size = UDim2.new(0, 70, 0, 22), Text = currentKey, Position = UDim2.new(1, -80, 0.5, -11)})
    CreateInstance("UICorner", keyBtn, {CornerRadius = UDim.new(0, 4)})
    CreateInstance("UIStroke", keyBtn, {Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    keyBtn.MouseButton1Click:Connect(function()
        if not listening then
            listening = true; keyBtn.Text = "..."
            local connection
            connection = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode.Name; if flag then CentralUI.Flags[flag] = currentKey end; keyBtn.Text = currentKey; listening = false; connection:Disconnect(); if callback then callback(currentKey) end
                end
            end)
        end
    end)
    return {GetValue = function() return currentKey end, SetValue = function(val) currentKey = val; if flag then CentralUI.Flags[flag] = currentKey end; keyBtn.Text = currentKey end}
end

function CentralUI:CreateColorPicker(tab, text, defaultColor, callback, flag)
    local color = defaultColor or Color3.fromRGB(181, 181, 181)
    if flag then CentralUI.Flags[flag] = color end
    local element = CreateInstance("Frame", tab.Content, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Element, Size = UDim2.new(1, 0, 0, 80)})
    CreateInstance("UICorner", element, {CornerRadius = UDim.new(0, 6)})
    CreateInstance("UIStroke", element, {Transparency = 0.6, Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    CreateInstance("TextLabel", element, {TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -60, 0, 20), Text = text, Position = UDim2.new(0, 12, 0, 6)})
    local colorPreview = CreateInstance("Frame", element, {BorderSizePixel = 0, BackgroundColor3 = color, Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -38, 0, 6)})
    CreateInstance("UICorner", colorPreview, {CornerRadius = UDim.new(0, 4)})
    CreateInstance("UIStroke", colorPreview, {Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    
    local rBg = CreateInstance("Frame", element, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Line, Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 40)})
    CreateInstance("UICorner", rBg, {CornerRadius = UDim.new(0, 2)})
    local rFill = CreateInstance("Frame", rBg, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Accent, Size = UDim2.new(color.R, 0, 1, 0)})
    CreateInstance("UICorner", rFill, {CornerRadius = UDim.new(0, 2)})
    
    local gBg = CreateInstance("Frame", element, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Line, Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 52)})
    CreateInstance("UICorner", gBg, {CornerRadius = UDim.new(0, 2)})
    local gFill = CreateInstance("Frame", gBg, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Accent, Size = UDim2.new(color.G, 0, 1, 0)})
    CreateInstance("UICorner", gFill, {CornerRadius = UDim.new(0, 2)})
    
    local bBg = CreateInstance("Frame", element, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Line, Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 64)})
    CreateInstance("UICorner", bBg, {CornerRadius = UDim.new(0, 2)})
    local bFill = CreateInstance("Frame", bBg, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Accent, Size = UDim2.new(color.B, 0, 1, 0)})
    CreateInstance("UICorner", bFill, {CornerRadius = UDim.new(0, 2)})
    
    local function updateColor(r, g, b)
        color = Color3.fromRGB(r, g, b); if flag then CentralUI.Flags[flag] = color end; colorPreview.BackgroundColor3 = color
        rFill.Size = UDim2.new(r / 255, 0, 1, 0); gFill.Size = UDim2.new(g / 255, 0, 1, 0); bFill.Size = UDim2.new(b / 255, 0, 1, 0)
        if callback then callback(color) end
    end
    rBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then updateColor(math.floor(math.clamp((input.Position.X - rBg.AbsolutePosition.X) / rBg.AbsoluteSize.X, 0, 1) * 255), math.floor(color.G * 255), math.floor(color.B * 255)) end end)
    gBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then updateColor(math.floor(color.R * 255), math.floor(math.clamp((input.Position.X - gBg.AbsolutePosition.X) / gBg.AbsoluteSize.X, 0, 1) * 255), math.floor(color.B * 255)) end end)
    bBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then updateColor(math.floor(color.R * 255), math.floor(color.G * 255), math.floor(math.clamp((input.Position.X - bBg.AbsolutePosition.X) / bBg.AbsoluteSize.X, 0, 1) * 255)) end end)
    return {GetValue = function() return color end, SetValue = function(val) color = val; if flag then CentralUI.Flags[flag] = color end; updateColor(math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)) end}
end

function CentralUI:CreateLabel(tab, text)
    return CreateInstance("TextLabel", tab.Content, {TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Text = text})
end

function CentralUI:CreateParagraph(tab, title, description)
    local paragraph = CreateInstance("Frame", tab.Content, {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1})
    CreateInstance("TextLabel", paragraph, {TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Medium, TextColor3 = CONFIG.Colors.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Text = title})
    CreateInstance("TextLabel", paragraph, {TextWrapped = true, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Subtext, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Text = description, Position = UDim2.new(0, 0, 0, 20)})
    return paragraph
end

-- Notification System
local NotificationContainer = CreateInstance("Frame", ScreenGui, {Size = UDim2.new(0, 300, 1, 0), Position = UDim2.new(1, -320, 0, 0), BackgroundTransparency = 1, Name = "NotificationContainer"})
CreateInstance("UIListLayout", NotificationContainer, {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom})

function CentralUI:Notify(title, text, duration)
    duration = duration or 5
    local notif = CreateInstance("Frame", NotificationContainer, {BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Topbar, ClipsDescendants = true, Size = UDim2.new(0, 300, 0, 0)})
    CreateInstance("UICorner", notif, {CornerRadius = UDim.new(0, 6)})
    CreateInstance("UIStroke", notif, {Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    local notifScale = Instance.new("UIScale"); notifScale.Scale = 0; notifScale.Parent = notif
    CreateInstance("TextLabel", notif, {TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Medium, TextColor3 = CONFIG.Colors.Text, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 20), Text = title, Position = UDim2.new(0, 12, 0, 8)})
    CreateInstance("TextLabel", notif, {TextWrapped = true, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, FontFace = CONFIG.Fonts.Regular, TextColor3 = CONFIG.Colors.Subtext, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 28), Text = text, Position = UDim2.new(0, 12, 0, 28)})
    TweenProperty(notif, "Size", UDim2.new(0, 300, 0, 60), 0.3):Play()
    TweenProperty(notifScale, "Scale", 1, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
    task.delay(duration, function() TweenProperty(notif, "Size", UDim2.new(0, 300, 0, 0), 0.3):Play(); TweenProperty(notifScale, "Scale", 0, 0.3):Play(); task.wait(0.3); notif:Destroy() end)
end

-- Watermark
local Watermark = CreateInstance("Frame", ScreenGui, {Visible = false, BorderSizePixel = 0, BackgroundColor3 = CONFIG.Colors.Background, Size = UDim2.new(0, 280, 0, 28), Position = UDim2.new(1, -300, 0, 20), Name = "Watermark"})
CreateInstance("UICorner", Watermark, {CornerRadius = UDim.new(0, 6)})
CreateInstance("UIStroke", Watermark, {Color = CONFIG.Colors.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
local watermarkText = CreateInstance("TextLabel", Watermark, {TextSize = 12, FontFace = CONFIG.Fonts.Medium, TextColor3 = CONFIG.Colors.Subtext, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 1, 0), Text = "", Position = UDim2.new(0, 12, 0, 0)})

function CentralUI:CreateWatermark(customText)
    Watermark.Visible = true
    local executor = GetExecutor()
    if customText then watermarkText.Text = customText .. " | " .. executor .. " | " .. LocalPlayer.Name
    else watermarkText.Text = "Central UI " .. CONFIG.Version .. " | " .. executor .. " | " .. LocalPlayer.Name end
end

return CentralUI
