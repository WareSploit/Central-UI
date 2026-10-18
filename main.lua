--[[
    ╔═══════════════════════════════════════════════════════════════════╗
    ║  Central UI Library (v1.0.0)                                      ║
    ║  Author: WareSploit                                               ║
    ║  GitHub: https://github.com/WareSploit/Central-UI                 ║
    ╚═══════════════════════════════════════════════════════════════════╝
]]

local CentralUI = {
    Version = "1.0.0",
    Author = "WareSploit",
    Flags = {}
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Theme = {
    Background   = Color3.fromRGB(16, 16, 18),
    Topbar       = Color3.fromRGB(23, 23, 25),
    Element      = Color3.fromRGB(31, 31, 34),
    ElementHover = Color3.fromRGB(41, 41, 44),
    Accent       = Color3.fromRGB(221, 221, 226),
    Text         = Color3.fromRGB(241, 241, 241),
    SubText      = Color3.fromRGB(151, 151, 151),
    Stroke       = Color3.fromRGB(61, 61, 66),
    Divider      = Color3.fromRGB(46, 46, 49),
    Input        = Color3.fromRGB(23, 23, 25),
    Close        = Color3.fromRGB(150, 50, 50),
}
CentralUI.Theme = Theme

local function New(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

-- ИСПРАВЛЕНО: Функция переименована в NewFont
local function NewFont(weight)
    return Font.new("rbxasset://fonts/families/GothamSSm.json", weight or Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

local function Corner(parent, radius)
    return New("UICorner", { CornerRadius = UDim.new(0, radius or 6) }, parent)
end

local function Stroke(parent, color, transparency, thickness)
    return New("UIStroke", {
        Color = color or Theme.Stroke, Thickness = thickness or 1,
        Transparency = transparency or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function Tween(obj, props, dur, style)
    if not obj then return end
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function Label(parent, text, size, pos, color, font, tsize, align)
    return New("TextLabel", {
        Text = text, Size = size, Position = pos or UDim2.new(),
        BackgroundTransparency = 1, TextColor3 = color or Theme.Text,
        FontFace = font or NewFont(), TextSize = tsize or 13,
        TextXAlignment = align or Enum.TextXAlignment.Left,
    }, parent)
end

local function GetGuiParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- NOTIFICATIONS
local notifGui
local function GetNotifGui()
    if notifGui and notifGui.Parent then return notifGui end
    notifGui = New("ScreenGui", {
        Name = "CentralUI_Notifications", ResetOnSpawn = false,
        DisplayOrder = 9999, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, GetGuiParent())
    local holder = New("Frame", { Name = "Holder", Size = UDim2.new(0, 300, 1, -40), Position = UDim2.new(1, -320, 0, 20), BackgroundTransparency = 1 }, notifGui)
    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Bottom }, holder)
    return notifGui
end

function CentralUI:Notify(config)
    config = config or {}
    local holder = GetNotifGui().Holder
    local notif = New("Frame", { Size = UDim2.new(1, 0, 0, 64), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, ClipsDescendants = true }, holder)
    Corner(notif, 6); Stroke(notif, Theme.Stroke, 0)
    local scale = New("UIScale", { Scale = 0 }, notif)
    Label(notif, config.Title or "Notification", UDim2.new(1, -20, 0, 20), UDim2.new(0, 12, 0, 8), Theme.Text, NewFont(Enum.FontWeight.Medium), 13)
    local content = Label(notif, config.Content or "", UDim2.new(1, -20, 0, 28), UDim2.new(0, 12, 0, 28), Theme.SubText, NewFont(), 12)
    content.TextWrapped = true
    Tween(scale, { Scale = 1 }, 0.35, Enum.EasingStyle.Back)
    task.delay(config.Duration or 5, function()
        if notif and notif.Parent then
            Tween(scale, { Scale = 0 }, 0.2).Completed:Wait()
            if notif and notif.Parent then notif:Destroy() end
        end
    end)
end

-- WATERMARK
function CentralUI:CreateWatermark(config)
    config = config or {}
    local wmGui = New("ScreenGui", { Name = "CentralUI_Watermark", ResetOnSpawn = false, DisplayOrder = 9998, IgnoreGuiInset = true }, GetGuiParent())
    local frame = New("Frame", { Size = UDim2.new(0, 180, 0, 28), Position = UDim2.new(1, -200, 0, 20), BackgroundColor3 = Theme.Background, BorderSizePixel = 0 }, wmGui)
    Corner(frame, 6); Stroke(frame, Theme.Stroke, 0)
    local lbl = Label(frame, config.Text or ("Central UI | v" .. self.Version), UDim2.new(1, -20, 1, 0), UDim2.new(0, 12, 0, 0), Theme.SubText, NewFont(Enum.FontWeight.Medium), 12)
    return { Set = function(t) lbl.Text = t end, Remove = function() wmGui:Destroy() end, Frame = frame }
end

-- WINDOW
function CentralUI:CreateWindow(config)
    config = config or {}
    local parent = GetGuiParent()
    if parent:FindFirstChild("CentralUI") then parent.CentralUI:Destroy() end
    local sg = New("ScreenGui", { Name = "CentralUI", ResetOnSpawn = false, DisplayOrder = 100, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, parent)
    local window = { Tabs = {}, ActiveTab = nil, Config = config, ScreenGui = sg }

    local welcomer, fill, percent
    if config.LoadingTitle ~= false then
        welcomer = New("Frame", { Name = "WelcomerFrame", Size = UDim2.new(0.467, 0, 0.397, 0), Position = UDim2.new(0.274, 0, 0.317, 0), BackgroundColor3 = Color3.fromRGB(11, 11, 13), BorderSizePixel = 0 }, sg)
        Corner(welcomer, 10); Stroke(welcomer, Theme.Stroke, 0.5)
        local wContent = New("Frame", { Name = "Content", Size = UDim2.new(0, 420, 0, 200), Position = UDim2.new(0.5, -210, 0.5, -100), BackgroundTransparency = 1 }, welcomer)
        New("ImageLabel", { Name = "MAIN-SVG", Image = config.Logo or "rbxassetid://10442402750", Size = UDim2.new(0, 107, 0, 74), Position = UDim2.new(0.370, 0, -0.066, 0), BackgroundTransparency = 1, BorderSizePixel = 0 }, wContent)
        Label(wContent, config.LoadingTitle or "Central UI", UDim2.new(1, 0, 0, 46), UDim2.new(0, 0, 0, 36), Theme.Text, NewFont(Enum.FontWeight.Bold), 34, Enum.TextXAlignment.Center)
        Label(wContent, config.LoadingSubtitle or "Loading, please wait...", UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 82), Theme.SubText, NewFont(), 13, Enum.TextXAlignment.Center)
        local bar = New("Frame", { Name = "ProgressBar", Size = UDim2.new(0.7, 0, 0, 3), Position = UDim2.new(0.15, 0, 0, 130), BackgroundColor3 = Theme.Element, BorderSizePixel = 0 }, wContent)
        Corner(bar, 2)
        fill = New("Frame", { Name = "Fill", Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0 }, bar)
        Corner(fill, 2)
        percent = Label(wContent, "0%", UDim2.new(1, 0, 0, 16), UDim2.new(0, 0, 0, 145), Theme.SubText, NewFont(), 11, Enum.TextXAlignment.Center)
        Label(welcomer, "v" .. self.Version, UDim2.new(0, 80, 0, 18), UDim2.new(1, -90, 1, -28), Theme.SubText, NewFont(), 11, Enum.TextXAlignment.Right)
    end

    local main = New("Frame", { Name = "MainWindow", Size = UDim2.new(0, 540, 0, 380), Position = UDim2.new(0.5, -270, 0.5, -190), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, ClipsDescendants = true, Visible = false }, sg)
    Corner(main, 10); Stroke(main, Theme.Stroke, 0.5)
    local mainScale = New("UIScale", { Scale = 1 }, main)

    local topbar = New("Frame", { Name = "Topbar", Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0 }, main)
    Corner(topbar, 10)
    New("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0 }, topbar)
    New("ImageLabel", { Name = "MAIN-SVG", Image = config.Logo or "rbxassetid://10442402750", Size = UDim2.new(0, 62, 0, 55), Position = UDim2.new(0, 0, -0.108, 0), BackgroundTransparency = 1, BorderSizePixel = 0 }, topbar)
    Label(topbar, config.Name or "Central UI", UDim2.new(0.914, -120, 1, 0), UDim2.new(0, 62, 0, 0), Theme.Text, NewFont(Enum.FontWeight.Medium), 16)

    local minBtn = New("TextButton", { Name = "MinBtn", Text = "—", Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -76, 0.5, -14), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, TextColor3 = Theme.SubText, FontFace = NewFont(Enum.FontWeight.Bold), TextSize = 14, AutoButtonColor = false }, topbar)
    Corner(minBtn, 4); Stroke(minBtn, Theme.Stroke)
    local closeBtn = New("TextButton", { Name = "CloseBtn", Text = "✕", Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -42, 0.5, -14), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, TextColor3 = Theme.SubText, FontFace = NewFont(Enum.FontWeight.Bold), TextSize = 12, AutoButtonColor = false }, topbar)
    Corner(closeBtn, 4); Stroke(closeBtn, Theme.Stroke)

    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    local tabHolder = New("Frame", { Name = "TabHolder", Size = UDim2.new(0, 140, 1, -46), Position = UDim2.new(0, 0, 0, 46), BackgroundColor3 = Theme.Background, BorderSizePixel = 0 }, main)
    local tabScroll = New("ScrollingFrame", { Name = "TabScroll", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.SubText }, tabHolder)
    New("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }, tabScroll)
    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) }, tabScroll)

    local contentHolder = New("Frame", { Name = "ContentHolder", Size = UDim2.new(1, -140, 1, -46), Position = UDim2.new(0, 140, 0, 46), BackgroundTransparency = 1, ClipsDescendants = true }, main)

    local watermark = nil
    if config.Watermark ~= false then
        watermark = New("Frame", { Name = "Watermark", Size = UDim2.new(0, 180, 0, 28), Position = UDim2.new(1, -200, 0, 20), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Visible = false }, sg)
        Corner(watermark, 6); Stroke(watermark, Theme.Stroke)
        Label(watermark, "Central UI | " .. LocalPlayer.Name, UDim2.new(1, -20, 1, 0), UDim2.new(0, 12, 0, 0), Theme.SubText, NewFont(Enum.FontWeight.Medium), 12)
    end

    local isOpen = true
    function window:Toggle(force)
        local target = (force ~= nil) and force or (not isOpen)
        if target == isOpen then return end
        isOpen = target
        if isOpen then
            main.Visible = true; mainScale.Scale = 0; Tween(mainScale, { Scale = 1 }, 0.3, Enum.EasingStyle.Back)
        else
            Tween(mainScale, { Scale = 0 }, 0.15).Completed:Wait(); main.Visible = false
        end
    end
    closeBtn.MouseButton1Click:Connect(function() window:Toggle(false) end)
    minBtn.MouseButton1Click:Connect(function() window:Toggle(false) end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.LeftControl then window:Toggle() end
    end)

    function window:CreateTab(name, iconId)
        local tab = { Name = name, Elements = {}, _window = window }
        local btn = New("TextButton", { Name = "Tab_" .. name, Text = name, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, TextColor3 = Theme.Text, FontFace = NewFont(Enum.FontWeight.Medium), TextSize = 13, AutoButtonColor = false, LayoutOrder = #self.Tabs + 1 }, tabScroll)
        Corner(btn, 6)
        if iconId then New("ImageLabel", { Name = "USER-IMAGE", Image = iconId, Size = UDim2.new(0, 20, 0, 19), Position = UDim2.new(0.104, 0, 0.187, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ImageColor3 = Theme.Accent }, btn) end

        local content = New("ScrollingFrame", { Name = "Content_" .. name, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Stroke, Visible = false, LayoutOrder = #self.Tabs + 1 }, contentHolder)
        New("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }, content)
        New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) }, content)
        tab.Button = btn; tab.Content = content; table.insert(self.Tabs, tab)

        btn.MouseButton1Click:Connect(function()
            for _, other in ipairs(window.Tabs) do other.Content.Visible = false; Tween(other.Button, { BackgroundColor3 = Theme.Element }, 0.15); other.Button.TextColor3 = Theme.SubText end
            content.Visible = true; Tween(btn, { BackgroundColor3 = Theme.Accent }, 0.15); btn.TextColor3 = Theme.Background; window.ActiveTab = tab
        end)
        if #self.Tabs == 1 then content.Visible = true; btn.BackgroundColor3 = Theme.Accent; btn.TextColor3 = Theme.Background; window.ActiveTab = tab
        else btn.TextColor3 = Theme.SubText end

        local order = 0
        local function NextOrder() order = order + 1; return order end
        local function ElemFrame(h)
            local f = New("Frame", { Name = "Element", Size = UDim2.new(1, 0, 0, h or 34), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, LayoutOrder = NextOrder() }, content)
            Corner(f, 6); Stroke(f, Theme.Stroke, 0.6); return f
        end

        function tab:CreateButton(c)
            local f = ElemFrame(34)
            local b = New("TextButton", { Text = c.Name or "Button", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, TextColor3 = Theme.Text, FontFace = NewFont(), TextSize = 13, AutoButtonColor = false }, f)
            b.MouseEnter:Connect(function() Tween(f, { BackgroundColor3 = Theme.ElementHover }, 0.12) end)
            b.MouseLeave:Connect(function() Tween(f, { BackgroundColor3 = Theme.Element }, 0.12) end)
            b.MouseButton1Click:Connect(function() if c.Callback then task.spawn(c.Callback) end end)
            return { Set = function(t) b.Text = t end, Remove = function() f:Destroy() end }
        end

        function tab:CreateToggle(c)
            local value = c.CurrentValue == true
            local f = ElemFrame(34)
            Label(f, c.Name or "Toggle", UDim2.new(1, -60, 1, 0), UDim2.new(0, 12, 0, 0), Theme.Text, NewFont(), 13)
            local track = New("Frame", { Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -48, 0.5, -9), BackgroundColor3 = value and Theme.Accent or Theme.Divider, BorderSizePixel = 0 }, f)
            Corner(track, 9); if not value then Stroke(track, Theme.Stroke) end
            local knob = New("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = value and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = value and Theme.Background or Theme.SubText, BorderSizePixel = 0 }, track)
            Corner(knob, 7)
            local function apply(v, silent)
                value = v; local s = track:FindFirstChildOfClass("UIStroke")
                if v then if s then s:Destroy() end; Tween(track, { BackgroundColor3 = Theme.Accent }, 0.15); Tween(knob, { Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = Theme.Background }, 0.15)
                else if not s then Stroke(track, Theme.Stroke) end; Tween(track, { BackgroundColor3 = Theme.Divider }, 0.15); Tween(knob, { Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Theme.SubText }, 0.15) end
                if c.Flag then CentralUI.Flags[c.Flag] = v end
                if not silent and c.Callback then task.spawn(c.Callback, v) end
            end
            local clickArea = New("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5 }, f)
            clickArea.MouseButton1Click:Connect(function() apply(not value) end)
            if c.Flag and CentralUI.Flags[c.Flag] ~= nil then apply(CentralUI.Flags[c.Flag], true) end
            return { Set = function(v) apply(v, true) end, Get = function() return value end, Remove = function() f:Destroy() end }
        end

        function tab:CreateSlider(c)
            local rng = c.Range or {0, 100}; local inc = c.Increment or 1; local value = c.CurrentValue or rng[1]
            local f = ElemFrame(56)
            Label(f, c.Name or "Slider", UDim2.new(1, -70, 0, 20), UDim2.new(0, 12, 0, 6), Theme.Text, NewFont(), 13)
            local vLabel = Label(f, tostring(value) .. (c.Suffix or ""), UDim2.new(0, 60, 0, 20), UDim2.new(1, -72, 0, 6), Theme.Accent, NewFont(Enum.FontWeight.Medium), 13, Enum.TextXAlignment.Right)
            local bg = New("Frame", { Size = UDim2.new(1, -24, 0, 4), Position = UDim2.new(0, 12, 1, -14), BackgroundColor3 = Theme.Divider, BorderSizePixel = 0 }, f)
            Corner(bg, 2); local pct = (value - rng[1]) / math.max(1, rng[2] - rng[1])
            local prog = New("Frame", { Size = UDim2.new(pct, 0, 1, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0 }, bg)
            Corner(prog, 2)
            local knob = New("Frame", { Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(pct, -6, 0.5, -6), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, ZIndex = 2 }, bg)
            Corner(knob, 6); Stroke(knob, Theme.Accent, 0, 2)
            local hitbox = New("TextButton", { Size = UDim2.new(1, -24, 0, 24), Position = UDim2.new(0, 12, 1, -26), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5 }, f)
            local drag = false
            local function setFromX(absX, silent)
                local rel = math.clamp((absX - bg.AbsolutePosition.X) / math.max(1, bg.AbsoluteSize.X), 0, 1)
                value = math.clamp(math.floor((rng[1] + (rng[2] - rng[1]) * rel) / inc + 0.5) * inc, rng[1], rng[2])
                local p = (value - rng[1]) / math.max(1, rng[2] - rng[1])
                prog.Size = UDim2.new(p, 0, 1, 0); knob.Position = UDim2.new(p, -6, 0.5, -6); vLabel.Text = tostring(value) .. (c.Suffix or "")
                if c.Flag then CentralUI.Flags[c.Flag] = value end
                if not silent and c.Callback then task.spawn(c.Callback, value) end
            end
            hitbox.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true; setFromX(i.Position.X) end end)
            UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then setFromX(i.Position.X) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
            if c.Flag and CentralUI.Flags[c.Flag] ~= nil then value = CentralUI.Flags[c.Flag]; local p = (value - rng[1]) / math.max(1, rng[2] - rng[1]); prog.Size = UDim2.new(p, 0, 1, 0); knob.Position = UDim2.new(p, -6, 0.5, -6); vLabel.Text = tostring(value) .. (c.Suffix or "") end
            return { Set = function(v) setFromX(bg.AbsolutePosition.X + (v - rng[1]) / (rng[2] - rng[1]) * bg.AbsoluteSize.X, true) end, Get = function() return value end, Remove = function() f:Destroy() end }
        end

        function tab:CreateDropdown(c)
            local opts = c.Options or {}; local selected = c.CurrentOption or opts[1] or ""; local expanded = false; local f = ElemFrame(34); f.ClipsDescendants = true
            Label(f, c.Name or "Dropdown", UDim2.new(1, -100, 0, 34), UDim2.new(0, 12, 0, 0), Theme.Text, NewFont(), 13)
            local cLabel = Label(f, tostring(selected), UDim2.new(0, 70, 0, 34), UDim2.new(1, -90, 0, 0), Theme.Accent, NewFont(), 13, Enum.TextXAlignment.Right)
            local arrow = Label(f, "▼", UDim2.new(0, 20, 0, 34), UDim2.new(1, -26, 0, 0), Theme.SubText, NewFont(), 9, Enum.TextXAlignment.Center)
            local oFrame = New("Frame", { Name = "OptionsContainer", Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 38), BackgroundTransparency = 1, ClipsDescendants = true }, f)
            New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) }, oFrame)
            local function rebuild()
                for _, ch in ipairs(oFrame:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
                for i, opt in ipairs(opts) do
                    local b = New("TextButton", { Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = (opt == selected) and Theme.Accent or Theme.Input, BorderSizePixel = 0, Text = tostring(opt), TextColor3 = (opt == selected) and Theme.Background or Theme.Text, FontFace = NewFont(), TextSize = 13, AutoButtonColor = false, LayoutOrder = i }, oFrame)
                    Corner(b, 4); Stroke(b, Theme.Stroke)
                    b.MouseButton1Click:Connect(function()
                        selected = opt; cLabel.Text = tostring(opt); if c.Flag then CentralUI.Flags[c.Flag] = opt end
                        if c.Callback then task.spawn(c.Callback, opt) end; expanded = false; updateState(); rebuild()
                    end)
                end
            end
            local function updateState()
                if expanded then arrow.Text = "▲"; local h = #opts * 28; oFrame.Size = UDim2.new(1, -16, 0, h); Tween(f, { Size = UDim2.new(1, 0, 0, 34 + h + 6) }, 0.2)
                else arrow.Text = "▼"; oFrame.Size = UDim2.new(1, -16, 0, 0); Tween(f, { Size = UDim2.new(1, 0, 0, 34) }, 0.2) end
            end
            local click = New("TextButton", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5 }, f)
            click.MouseButton1Click:Connect(function() expanded = not expanded; updateState() end); rebuild()
            if c.Flag and CentralUI.Flags[c.Flag] ~= nil then selected = CentralUI.Flags[c.Flag]; cLabel.Text = tostring(selected); rebuild() end
            return { Set = function(o) selected = o; cLabel.Text = tostring(o); rebuild() end, Get = function() return selected end, Remove = function() f:Destroy() end }
        end

        function tab:CreateInput(c)
            local f = ElemFrame(56)
            Label(f, c.Name or "Input", UDim2.new(1, -24, 0, 20), UDim2.new(0, 12, 0, 6), Theme.Text, NewFont(), 13)
            local box = New("TextBox", { Size = UDim2.new(1, -24, 0, 24), Position = UDim2.new(0, 12, 0, 26), BackgroundColor3 = Theme.Input, BorderSizePixel = 0, Text = c.CurrentValue or "", PlaceholderText = c.PlaceholderText or "", TextColor3 = Theme.Text, PlaceholderColor3 = Theme.SubText, FontFace = NewFont(), TextSize = 13, ClearTextOnFocus = false }, f)
            Corner(box, 4); Stroke(box, Theme.Stroke)
            box.FocusLost:Connect(function() if c.Flag then CentralUI.Flags[c.Flag] = box.Text end; if c.Callback then task.spawn(c.Callback, box.Text) end; if c.RemoveTextAfterFocusLost then box.Text = "" end end)
            if c.Flag and CentralUI.Flags[c.Flag] ~= nil then box.Text = CentralUI.Flags[c.Flag] end
            return { Set = function(t) box.Text = t end, Get = function() return box.Text end, Remove = function() f:Destroy() end }
        end

        function tab:CreateKeybind(c)
            local k = c.CurrentKeybind or "Q"; if typeof(k) == "EnumItem" then k = k.Name end
            local listen = false; local f = ElemFrame(34)
            Label(f, c.Name or "Keybind", UDim2.new(1, -100, 1, 0), UDim2.new(0, 12, 0, 0), Theme.Text, NewFont(), 13)
            local btn = New("TextButton", { Size = UDim2.new(0, 70, 0, 22), Position = UDim2.new(1, -80, 0.5, -11), BackgroundColor3 = Theme.Input, BorderSizePixel = 0, Text = tostring(k), TextColor3 = Theme.Accent, FontFace = NewFont(Enum.FontWeight.Medium), TextSize = 12, AutoButtonColor = false }, f)
            Corner(btn, 4); Stroke(btn, Theme.Stroke)
            btn.MouseButton1Click:Connect(function() listen = true; btn.Text = "..."; btn.TextColor3 = Theme.SubText end)
            UserInputService.InputBegan:Connect(function(i, gp)
                if gp or i.UserInputType ~= Enum.UserInputType.Keyboard then return end
                if listen then k = i.KeyCode.Name; listen = false; btn.Text = k; btn.TextColor3 = Theme.Accent; if c.Flag then CentralUI.Flags[c.Flag] = k end; if c.Callback then task.spawn(c.Callback, k) end
                elseif i.KeyCode.Name == k and c.OnPressed then task.spawn(c.OnPressed) end
            end)
            return { Set = function(n) k = (typeof(n) == "EnumItem") and n.Name or tostring(n); btn.Text = k end, Get = function() return k end, Remove = function() f:Destroy() end }
        end

        function tab:CreateColorPicker(c)
            local col = c.Color or Color3.fromRGB(255, 255, 255)
            local f = ElemFrame(80)
            Label(f, c.Name or "Color", UDim2.new(1, -60, 0, 20), UDim2.new(0, 12, 0, 6), Theme.Text, NewFont(), 13)
            local prev = New("Frame", { Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -38, 0, 6), BackgroundColor3 = col, BorderSizePixel = 0 }, f)
            Corner(prev, 4); Stroke(prev, Theme.Stroke)
            local bars = {}
            for i, ch in ipairs({"R", "G", "B"}) do
                local bar = New("Frame", { Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 40 + (i - 1) * 12), BackgroundColor3 = Theme.Divider, BorderSizePixel = 0 }, f)
                Corner(bar, 2)
                local prog = New("Frame", { Size = UDim2.new(col[ch] / 255, 0, 1, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0 }, bar)
                Corner(prog, 2); bars[ch] = { bar = bar, prog = prog }
            end
            local function apply(silent)
                local r = math.floor(bars.R.prog.Size.X.Scale * 255 + 0.5)
                local g = math.floor(bars.G.prog.Size.X.Scale * 255 + 0.5)
                local b = math.floor(bars.B.prog.Size.X.Scale * 255 + 0.5)
                col = Color3.fromRGB(r, g, b); prev.BackgroundColor3 = col
                if c.Flag then CentralUI.Flags[c.Flag] = col end
                if not silent and c.Callback then task.spawn(c.Callback, col) end
            end
            for ch, data in pairs(bars) do
                data.bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        local rel = math.clamp((input.Position.X - data.bar.AbsolutePosition.X) / math.max(1, data.bar.AbsoluteSize.X), 0, 1)
                        data.prog.Size = UDim2.new(rel, 0, 1, 0); apply()
                    end
                end)
            end
            return { Set = function(color) col = color; prev.BackgroundColor3 = color; for ch, data in pairs(bars) do data.prog.Size = UDim2.new(color[ch] / 255, 0, 1, 0) end end, Get = function() return col end, Remove = function() f:Destroy() end }
        end

        function tab:CreateSection(text)
            local f = New("Frame", { Name = "Section", Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = NextOrder() }, content)
            Label(f, text or "Section", UDim2.new(1, 0, 0, 20), UDim2.new(), Theme.SubText, NewFont(Enum.FontWeight.Medium), 11)
            New("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 20), BackgroundColor3 = Theme.Divider, BorderSizePixel = 0 }, f)
            return { Remove = function() f:Destroy() end }
        end

        function tab:CreateLabel(text)
            local l = Label(content, text or "", UDim2.new(1, 0, 0, 20), UDim2.new(), Theme.Text, NewFont(), 13); l.LayoutOrder = NextOrder()
            return { Set = function(t) l.Text = t end, Remove = function() l:Destroy() end }
        end

        function tab:CreateParagraph(c)
            local f = New("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = NextOrder() }, content)
            Label(f, c.Title or "Title", UDim2.new(1, 0, 0, 18), UDim2.new(), Theme.Text, NewFont(Enum.FontWeight.Medium), 13)
            local body = Label(f, c.Content or "", UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 20), Theme.SubText, NewFont(), 12)
            body.TextWrapped = true
            return { Remove = function() f:Destroy() end }
        end

        return tab
    end

    if welcomer then
        task.spawn(function()
            welcomer.BackgroundTransparency = 1; Tween(welcomer, { BackgroundTransparency = 0 }, 0.4)
            for i = 0, 40 do fill.Size = UDim2.new(i/40, 0, 1, 0); percent.Text = string.format("%d%%", math.floor(i/40*100)); task.wait(0.03) end
            task.wait(0.3)
            local t = Tween(welcomer, { BackgroundTransparency = 1 }, 0.5)
            for _, d in ipairs(welcomer:GetDescendants()) do
                if d:IsA("TextLabel") then pcall(function() TweenService:Create(d, TweenInfo.new(0.5), {TextTransparency = 1}):Play() end)
                elseif d:IsA("ImageLabel") then pcall(function() TweenService:Create(d, TweenInfo.new(0.5), {ImageTransparency = 1}):Play() end)
                elseif d:IsA("Frame") then pcall(function() TweenService:Create(d, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play() end) end
            end
            t.Completed:Wait(); welcomer.Visible = false
            main.Visible = true; mainScale.Scale = 0; Tween(mainScale, { Scale = 1 }, 0.45, Enum.EasingStyle.Back)
            if watermark then watermark.Visible = true end
        end)
    else
        main.Visible = true
        if watermark then watermark.Visible = true end
    end

    return window
end

if getgenv then getgenv().CentralUI = CentralUI end
_G.CentralUI = CentralUI
return CentralUI
