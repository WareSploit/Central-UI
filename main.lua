--[[
    ╔══════════════════════════════════════════════════════════╗
    ║   Central UI Library                               v1.0.0 ║
    ║   Dark Monochrome Roblox UI Library                       ║
    ║   GitHub: https://github.com/WareSploit/CentralUI         ║
    ╚══════════════════════════════════════════════════════════╝
]]

local CentralUI = {}
CentralUI.Version = "1.0.0"
CentralUI.Flags = {}

local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local Players      = game:GetService("Players")
local player       = Players.LocalPlayer

local T = {
    BG       = Color3.fromRGB(16, 16, 18),
    Topbar   = Color3.fromRGB(23, 23, 25),
    Element  = Color3.fromRGB(31, 31, 34),
    ElementHover = Color3.fromRGB(41, 41, 44),
    Accent   = Color3.fromRGB(221, 221, 226),
    Text     = Color3.fromRGB(241, 241, 241),
    Sub      = Color3.fromRGB(151, 151, 151),
    Stroke   = Color3.fromRGB(61, 61, 66),
    Divider  = Color3.fromRGB(46, 46, 49),
    Input    = Color3.fromRGB(23, 23, 25),
    Close    = Color3.fromRGB(150, 50, 50),
}
CentralUI.Theme = T

local function font(weight)
    return Font.new("rbxasset://fonts/families/GothamSSm.json",
        weight or Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

local function create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

local function corner(parent, radius)
    return create("UICorner", { CornerRadius = UDim.new(0, radius or 6) }, parent)
end

local function stroke(parent, color, transparency, thickness)
    return create("UIStroke", {
        Color = color or T.Stroke,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function tween(obj, props, dur, style)
    if not obj then return end
    local t = TweenService:Create(obj,
        TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function label(parent, text, size, pos, color, f, tsize, align)
    return create("TextLabel", {
        Text = text,
        Size = size,
        Position = pos or UDim2.new(),
        BackgroundTransparency = 1,
        TextColor3 = color or T.Text,
        FontFace = f or font(),
        TextSize = tsize or 13,
        TextXAlignment = align or Enum.TextXAlignment.Left,
    }, parent)
end

local function getGuiParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    return player:WaitForChild("PlayerGui")
end

local notifGui
local function getNotifGui()
    if notifGui and notifGui.Parent then return notifGui end
    notifGui = create("ScreenGui", {
        Name = "CentralUI_Notifications",
        ResetOnSpawn = false,
        DisplayOrder = 9999,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, getGuiParent())

    local holder = create("Frame", {
        Name = "Holder",
        Size = UDim2.new(0, 300, 1, -40),
        Position = UDim2.new(1, -320, 0, 20),
        BackgroundTransparency = 1,
    }, notifGui)

    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
    }, holder)
    return notifGui
end

function CentralUI:Notify(cfg)
    cfg = cfg or {}
    local holder = getNotifGui().Holder

    local notif = create("Frame", {
        Size = UDim2.new(1, 0, 0, 64),
        BackgroundColor3 = T.Topbar,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, holder)
    corner(notif, 6); stroke(notif, T.Stroke, 0)

    local scale = create("UIScale", { Scale = 0 }, notif)

    label(notif, cfg.Title or "Notification",
        UDim2.new(1, -20, 0, 20), UDim2.new(0, 12, 0, 8),
        T.Text, font(Enum.FontWeight.Medium), 13)

    local content = label(notif, cfg.Content or "",
        UDim2.new(1, -20, 0, 28), UDim2.new(0, 12, 0, 28),
        T.Sub, font(), 12)
    content.TextWrapped = true

    tween(scale, { Scale = 1 }, 0.35, Enum.EasingStyle.Back)

    task.delay(cfg.Duration or 5, function()
        if notif and notif.Parent then
            local t = tween(scale, { Scale = 0 }, 0.2)
            t.Completed:Wait()
            if notif and notif.Parent then notif:Destroy() end
        end
    end)
end

function CentralUI:CreateWatermark(cfg)
    cfg = cfg or {}
    local wmGui = create("ScreenGui", {
        Name = "CentralUI_Watermark",
        ResetOnSpawn = false,
        DisplayOrder = 9998,
        IgnoreGuiInset = true,
    }, getGuiParent())

    local frame = create("Frame", {
        Size = UDim2.new(0, 180, 0, 28),
        Position = UDim2.new(1, -200, 0, 20),
        BackgroundColor3 = T.BG,
        BorderSizePixel = 0,
    }, wmGui)
    corner(frame, 6); stroke(frame, T.Stroke, 0)

    local label_ = label(frame, cfg.Text or ("Central UI | v" .. self.Version),
        UDim2.new(1, -20, 1, 0), UDim2.new(0, 12, 0, 0),
        T.Sub, font(Enum.FontWeight.Medium), 12)

    return {
        Set = function(t) label_.Text = t end,
        Remove = function() wmGui:Destroy() end,
        Frame = frame,
    }
end

local function buildWelcomer(parent, cfg)
    local welcomer = create("Frame", {
        Name = "WelcomerFrame",
        Size = UDim2.new(0.46719, 0, 0.39769, 0),
        Position = UDim2.new(0.27489, 0, 0.31732, 0),
        BackgroundColor3 = Color3.fromRGB(11, 11, 13),
        BorderSizePixel = 0,
    }, parent)
    corner(welcomer, 10); stroke(welcomer, T.Stroke, 0.5)

    local content = create("Frame", {
        Name = "Content",
        Size = UDim2.new(0, 420, 0, 200),
        Position = UDim2.new(0.5, -210, 0.5, -100),
        BackgroundTransparency = 1,
    }, welcomer)

    create("ImageLabel", {
        Name = "MAIN-SVG",
        Image = cfg.Logo or "rbxassetid://10442402750",
        Size = UDim2.new(0, 107, 0, 74),
        Position = UDim2.new(0.37046, 0, -0.06682, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, content)

    label(content, cfg.LoadingTitle or "Central UI",
        UDim2.new(1, 0, 0, 46), UDim2.new(0, 0, 0, 36),
        T.Text, font(Enum.FontWeight.Bold), 34, Enum.TextXAlignment.Center)

    label(content, cfg.LoadingSubtitle or "Loading, please wait...",
        UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 82),
        T.Sub, font(), 13, Enum.TextXAlignment.Center)

    local bar = create("Frame", {
        Name = "ProgressBar",
        Size = UDim2.new(0.7, 0, 0, 3),
        Position = UDim2.new(0.15, 0, 0, 130),
        BackgroundColor3 = T.Element,
        BorderSizePixel = 0,
    }, content)
    corner(bar, 2)

    local fill = create("Frame", {
        Name = "Fill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
    }, bar)
    corner(fill, 2)

    local percent = label(content, "0%",
        UDim2.new(1, 0, 0, 16), UDim2.new(0, 0, 0, 145),
        T.Sub, font(), 11, Enum.TextXAlignment.Center)

    label(welcomer, "v" .. CentralUI.Version,
        UDim2.new(0, 80, 0, 18), UDim2.new(1, -90, 1, -28),
        T.Sub, font(), 11, Enum.TextXAlignment.Right)

    return welcomer, fill, percent
end

local function runWelcomer(welcomer, fill, percent, mainWindow, watermark)
    welcomer.BackgroundTransparency = 1
    tween(welcomer, { BackgroundTransparency = 0 }, 0.4)

    for i = 0, 40 do
        local pct = i / 40
        fill.Size = UDim2.new(pct, 0, 1, 0)
        percent.Text = string.format("%d%%", math.floor(pct * 100))
        task.wait(0.03)
    end
    task.wait(0.3)

    local fadeT = tween(welcomer, { BackgroundTransparency = 1 }, 0.5)
    for _, desc in ipairs(welcomer:GetDescendants()) do
        if desc:IsA("TextLabel") or desc:IsA("TextButton") then
            pcall(function() TweenService:Create(desc, TweenInfo.new(0.5), {TextTransparency = 1}):Play() end)
        elseif desc:IsA("ImageLabel") then
            pcall(function() TweenService:Create(desc, TweenInfo.new(0.5), {ImageTransparency = 1}):Play() end)
        elseif desc:IsA("Frame") then
            pcall(function() TweenService:Create(desc, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play() end)
        elseif desc:IsA("UIStroke") then
            pcall(function() TweenService:Create(desc, TweenInfo.new(0.5), {Transparency = 1}):Play() end)
        end
    end
    fadeT.Completed:Wait()
    welcomer.Visible = false

    mainWindow.Visible = true
    local scale = mainWindow:FindFirstChildOfClass("UIScale")
    if scale then
        scale.Scale = 0
        tween(scale, { Scale = 1 }, 0.45, Enum.EasingStyle.Back)
    end
    if watermark then watermark.Visible = true end
end

function CentralUI:CreateWindow(cfg)
    cfg = cfg or {}
    local parent = getGuiParent()
    local old = parent:FindFirstChild("CentralUI")
    if old then old:Destroy() end

    local sg = create("ScreenGui", {
        Name = "CentralUI",
        ResetOnSpawn = false,
        DisplayOrder = 100,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, parent)

    local window = { Tabs = {}, ActiveTab = nil, Config = cfg, ScreenGui = sg }

    local welcomer, fill, percent
    if cfg.LoadingTitle ~= false then
        welcomer, fill, percent = buildWelcomer(sg, cfg)
    end

    local main = create("Frame", {
        Name = "MainWindow",
        Size = UDim2.new(0, 540, 0, 380),
        Position = UDim2.new(0.5, -270, 0.5, -190),
        BackgroundColor3 = T.BG,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
    }, sg)
    corner(main, 10); stroke(main, T.Stroke, 0.5)
    create("UIScale", { Scale = 1 }, main)

    local topbar = create("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = T.Topbar,
        BorderSizePixel = 0,
    }, main)
    corner(topbar, 10)

    create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = T.Stroke,
        BorderSizePixel = 0,
    }, topbar)

    create("ImageLabel", {
        Name = "MAIN-SVG",
        Image = cfg.Logo or "rbxassetid://10442402750",
        Size = UDim2.new(0, 62, 0, 55),
        Position = UDim2.new(0, 0, -0.1087, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, topbar)

    label(topbar, cfg.Name or "Central UI",
        UDim2.new(0.91481, -120, 1, 0), UDim2.new(0, 62, 0, 0),
        T.Text, font(Enum.FontWeight.Medium), 16)

    local minBtn = create("TextButton", {
        Name = "MinBtn", Text = "—",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -76, 0.5, -14),
        BackgroundColor3 = T.Element, BorderSizePixel = 0,
        TextColor3 = T.Sub, FontFace = font(Enum.FontWeight.Bold),
        TextSize = 14, AutoButtonColor = false,
    }, topbar)
    corner(minBtn, 4); stroke(minBtn, T.Stroke)

    local closeBtn = create("TextButton", {
        Name = "CloseBtn", Text = "✕",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -42, 0.5, -14),
        BackgroundColor3 = T.Element, BorderSizePixel = 0,
        TextColor3 = T.Sub, FontFace = font(Enum.FontWeight.Bold),
        TextSize = 12, AutoButtonColor = false,
    }, topbar)
    corner(closeBtn, 4); stroke(closeBtn, T.Stroke)

    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                      startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    local tabHolder = create("Frame", {
        Name = "TabHolder",
        Size = UDim2.new(0, 140, 1, -46),
        Position = UDim2.new(0, 0, 0, 46),
        BackgroundColor3 = T.BG,
        BorderSizePixel = 0,
    }, main)

    local tabScroll = create("ScrollingFrame", {
        Name = "TabScroll",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Sub,
    }, tabHolder)
    create("UIPadding", {
        PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
    }, tabScroll)
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4),
    }, tabScroll)

    local contentHolder = create("Frame", {
        Name = "ContentHolder",
        Size = UDim2.new(1, -140, 1, -46),
        Position = UDim2.new(0, 140, 0, 46),
        BackgroundTransparency = 1, ClipsDescendants = true,
    }, main)

    local watermark = nil
    if cfg.Watermark ~= false then
        watermark = create("Frame", {
            Name = "Watermark",
            Size = UDim2.new(0, 180, 0, 28),
            Position = UDim2.new(1, -200, 0, 20),
            BackgroundColor3 = T.BG,
            BorderSizePixel = 0,
            Visible = false,
        }, sg)
        corner(watermark, 6); stroke(watermark, T.Stroke)
        label(watermark, "Central UI | " .. player.Name,
            UDim2.new(1, -20, 1, 0), UDim2.new(0, 12, 0, 0),
            T.Sub, font(Enum.FontWeight.Medium), 12)
    end

    closeBtn.MouseButton1Click:Connect(function() window:Toggle(false) end)
    minBtn.MouseButton1Click:Connect(function() window:Toggle(false) end)

    local isOpen = true
    function window:Toggle(force)
        local target = (force ~= nil) and force or (not isOpen)
        if target == isOpen then return end
        isOpen = target
        local scale = main:FindFirstChildOfClass("UIScale")
        if isOpen then
            main.Visible = true
            scale.Scale = 0
            tween(scale, { Scale = 1 }, 0.3, Enum.EasingStyle.Back)
        else
            local t = tween(scale, { Scale = 0 }, 0.15)
            t.Completed:Wait()
            main.Visible = false
        end
    end
    function window:Open()  self:Toggle(true)  end
    function window:Close() self:Toggle(false) end
    function window:Destroy() sg:Destroy() end

    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightControl
        or input.KeyCode == Enum.KeyCode.LeftControl then
            window:Toggle()
        end
    end)

    function window:CreateTab(name, iconId)
        local tab = { Name = name, Elements = {}, _window = window }

        local btn = create("TextButton", {
            Name = "Tab_" .. name, Text = name,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = T.Element, BorderSizePixel = 0,
            TextColor3 = T.Text, FontFace = font(Enum.FontWeight.Medium),
            TextSize = 13, AutoButtonColor = false,
            LayoutOrder = #self.Tabs + 1,
        }, tabScroll)
        corner(btn, 6)

        if iconId then
            create("ImageLabel", {
                Name = "USER-IMAGE", Image = iconId,
                Size = UDim2.new(0, 20, 0, 19),
                Position = UDim2.new(0.10484, 0, 0.1875, 0),
                BackgroundTransparency = 1, BorderSizePixel = 0,
                ImageColor3 = T.Accent,
            }, btn)
        end

        local content = create("ScrollingFrame", {
            Name = "Content_" .. name,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1, BorderSizePixel = 0,
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 3, ScrollBarImageColor3 = T.Stroke,
            Visible = false, LayoutOrder = #self.Tabs + 1,
        }, contentHolder)
        create("UIPadding", {
            PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
        }, content)
        create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6),
        }, content)

        tab.Button = btn; tab.Content = content
        table.insert(self.Tabs, tab)

        btn.MouseButton1Click:Connect(function()
            for _, other in ipairs(window.Tabs) do
                other.Content.Visible = false
                tween(other.Button, { BackgroundColor3 = T.Element }, 0.15)
                other.Button.TextColor3 = T.Sub
            end
            content.Visible = true
            tween(btn, { BackgroundColor3 = T.Accent }, 0.15)
            btn.TextColor3 = T.BG
            window.ActiveTab = tab
        end)

        if #self.Tabs == 1 then
            content.Visible = true
            btn.BackgroundColor3 = T.Accent
            btn.TextColor3 = T.BG
            window.ActiveTab = tab
        else
            btn.TextColor3 = T.Sub
        end

        local order = 0
        local function nextOrder() order = order + 1; return order end

        local function elemFrame(h)
            local f = create("Frame", {
                Name = "Element", Size = UDim2.new(1, 0, 0, h or 34),
                BackgroundColor3 = T.Element, BorderSizePixel = 0,
                LayoutOrder = nextOrder(),
            }, content)
            corner(f, 6); stroke(f, T.Stroke, 0.6)
            return f
        end

        function tab:CreateButton(c)
            local btn_ = {}; local f = elemFrame(34)
            local b = create("TextButton", {
                Text = c.Name or "Button", Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1, TextColor3 = T.Text,
                FontFace = font(), TextSize = 13, AutoButtonColor = false,
            }, f)
            b.MouseEnter:Connect(function() tween(f, { BackgroundColor3 = T.ElementHover }, 0.12) end)
            b.MouseLeave:Connect(function() tween(f, { BackgroundColor3 = T.Element }, 0.12) end)
            b.MouseButton1Click:Connect(function() if c.Callback then task.spawn(c.Callback) end end)
            btn_.Set = function(t) b.Text = t end
            btn_.Remove = function() f:Destroy() end
            btn_.SetVisible = function(v) f.Visible = v end
            return btn_
        end

        function tab:CreateToggle(c)
            local obj = {}; local value = c.CurrentValue == true; local f = elemFrame(34)
            label(f, c.Name or "Toggle", UDim2.new(1, -60, 1, 0), UDim2.new(0, 12, 0, 0), T.Text, font(), 13)
            local track = create("Frame", {
                Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -48, 0.5, -9),
                BackgroundColor3 = value and T.Accent or T.Divider, BorderSizePixel = 0,
            }, f)
            corner(track, 9); if not value then stroke(track, T.Stroke) end
            local knob = create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = value and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = value and T.BG or T.Sub, BorderSizePixel = 0,
            }, track)
            corner(knob, 7)
            local function apply(v, silent)
                value = v; local s = track:FindFirstChildOfClass("UIStroke")
                if v then
                    if s then s:Destroy() end
                    tween(track, { BackgroundColor3 = T.Accent }, 0.15)
                    tween(knob, { Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = T.BG }, 0.15)
                else
                    if not s then stroke(track, T.Stroke) end
                    tween(track, { BackgroundColor3 = T.Divider }, 0.15)
                    tween(knob, { Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = T.Sub }, 0.15)
                end
                if c.Flag then CentralUI.Flags[c.Flag] = v end
                if not silent and c.Callback then task.spawn(c.Callback, v) end
            end
            local clickArea = create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5 }, f)
            clickArea.MouseButton1Click:Connect(function() apply(not value) end)
            if c.Flag and CentralUI.Flags[c.Flag] ~= nil then apply(CentralUI.Flags[c.Flag], true) end
            obj.Set = function(v) apply(v, true) end
            obj.Get = function() return value end
            obj.Remove = function() f:Destroy() end
            obj.SetVisible = function(v) f.Visible = v end
            return obj
        end

        function tab:CreateSlider(c)
            local obj = {}; local rng = c.Range or {0, 100}; local inc = c.Increment or 1
            local value = c.CurrentValue or rng[1]; local f = elemFrame(56)
            label(f, c.Name or "Slider", UDim2.new(1, -70, 0, 20), UDim2.new(0, 12, 0, 6), T.Text, font(), 13)
            local valueLabel = label(f, tostring(value) .. (c.Suffix or ""), UDim2.new(0, 60, 0, 20), UDim2.new(1, -72, 0, 6), T.Accent, font(Enum.FontWeight.Medium), 13, Enum.TextXAlignment.Right)
            local bg = create("Frame", { Size = UDim2.new(1, -24, 0, 4), Position = UDim2.new(0, 12, 1, -14), BackgroundColor3 = T.Divider, BorderSizePixel = 0 }, f)
            corner(bg, 2); local pct = (value - rng[1]) / math.max(1, rng[2] - rng[1])
            local prog = create("Frame", { Size = UDim2.new(pct, 0, 1, 0), BackgroundColor3 = T.Accent, BorderSizePixel = 0 }, bg)
            corner(prog, 2)
            local knob = create("Frame", { Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(pct, -6, 0.5, -6), BackgroundColor3 = T.BG, BorderSizePixel = 0, ZIndex = 2 }, bg)
            corner(knob, 6); stroke(knob, T.Accent, 0, 2)
            local hitbox = create("TextButton", { Size = UDim2.new(1, -24, 0, 24), Position = UDim2.new(0, 12, 1, -26), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5 }, f)
            local dragging = false
            local function setFromX(absX, silent)
                local rel = math.clamp((absX - bg.AbsolutePosition.X) / math.max(1, bg.AbsoluteSize.X), 0, 1)
                local raw = rng[1] + (rng[2] - rng[1]) * rel
                value = math.clamp(math.floor(raw / inc + 0.5) * inc, rng[1], rng[2])
                local p = (value - rng[1]) / math.max(1, rng[2] - rng[1])
                prog.Size = UDim2.new(p, 0, 1, 0); knob.Position = UDim2.new(p, -6, 0.5, -6)
                valueLabel.Text = tostring(value) .. (c.Suffix or "")
                if c.Flag then CentralUI.Flags[c.Flag] = value end
                if not silent and c.Callback then task.spawn(c.Callback, value) end
            end
            hitbox.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; setFromX(input.Position.X) end end)
            UIS.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then setFromX(input.Position.X) end end)
            UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            if c.Flag and CentralUI.Flags[c.Flag] ~= nil then
                value = CentralUI.Flags[c.Flag]; local p = (value - rng[1]) / math.max(1, rng[2] - rng[1])
                prog.Size = UDim2.new(p, 0, 1, 0); knob.Position = UDim2.new(p, -6, 0.5, -6); valueLabel.Text = tostring(value) .. (c.Suffix or "")
            end
            obj.Set = function(v) setFromX(bg.AbsolutePosition.X + (v - rng[1]) / (rng[2] - rng[1]) * bg.AbsoluteSize.X, true) end
            obj.Get = function() return value end
            obj.Remove = function() f:Destroy() end
            obj.SetVisible = function(v) f.Visible = v end
            return obj
        end

        function tab:CreateInput(c)
            local obj = {}; local f = elemFrame(56)
            label(f, c.Name or "Input", UDim2.new(1, -24, 0, 20), UDim2.new(0, 12, 0, 6), T.Text, font(), 13)
            local box = create("TextBox", {
                Size = UDim2.new(1, -24, 0, 24), Position = UDim2.new(0, 12, 0, 26),
                BackgroundColor3 = T.Input, BorderSizePixel = 0, Text = c.CurrentValue or "",
                PlaceholderText = c.PlaceholderText or "", TextColor3 = T.Text,
                PlaceholderColor3 = T.Sub, FontFace = font(), TextSize = 13, ClearTextOnFocus = false,
            }, f)
            corner(box, 4); stroke(box, T.Stroke)
            box.FocusLost:Connect(function()
                if c.Flag then CentralUI.Flags[c.Flag] = box.Text end
                if c.Callback then task.spawn(c.Callback, box.Text) end
                if c.RemoveTextAfterFocusLost then box.Text = "" end
            end)
            if c.Flag and CentralUI.Flags[c.Flag] ~= nil then box.Text = CentralUI.Flags[c.Flag] end
            obj.Set = function(t) box.Text = t end
            obj.Get = function() return box.Text end
            obj.Remove = function() f:Destroy() end
            obj.SetVisible = function(v) f.Visible = v end
            return obj
        end

        function tab:CreateDropdown(c)
            local obj = {}; local options = c.Options or {}; local selected = c.CurrentOption or options[1] or ""
            local expanded = false; local baseHeight = 34; local f = elemFrame(baseHeight)
            f.ClipsDescendants = true
            label(f, c.Name or "Dropdown", UDim2.new(1, -100, 0, 34), UDim2.new(0, 12, 0, 0), T.Text, font(), 13)
            local curLabel = label(f, tostring(selected), UDim2.new(0, 70, 0, 34), UDim2.new(1, -90, 0, 0), T.Accent, font(), 13, Enum.TextXAlignment.Right)
            local arrow = label(f, "▼", UDim2.new(0, 20, 0, 34), UDim2.new(1, -26, 0, 0), T.Sub, font(), 9, Enum.TextXAlignment.Center)
            local optionsContainer = create("Frame", { Name = "OptionsContainer", Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 38), BackgroundTransparency = 1, ClipsDescendants = true }, f)
            create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) }, optionsContainer)
            local function rebuild()
                for _, ch in ipairs(optionsContainer:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
                for i, opt in ipairs(options) do
                    local b = create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = (opt == selected) and T.Accent or T.Input,
                        BorderSizePixel = 0, Text = tostring(opt), TextColor3 = (opt == selected) and T.BG or T.Text,
                        FontFace = font(), TextSize = 13, AutoButtonColor = false, LayoutOrder = i,
                    }, optionsContainer)
                    corner(b, 4); stroke(b, T.Stroke)
                    b.MouseButton1Click:Connect(function()
                        selected = opt; curLabel.Text = tostring(opt)
                        if c.Flag then CentralUI.Flags[c.Flag] = opt end
                        if c.Callback then task.spawn(c.Callback, opt) end
                        expanded = false; updateState(); rebuild()
                    end)
                end
            end
            local function updateState()
                if expanded then
                    arrow.Text = "▲"; local h = #options * 28
                    optionsContainer.Size = UDim2.new(1, -16, 0, h)
                    tween(f, { Size = UDim2.new(1, 0, 0, baseHeight + h + 6) }, 0.2)
                else
                    arrow.Text = "▼"; optionsContainer.Size = UDim2.new(1, -16, 0, 0)
                    tween(f, { Size = UDim2.new(1, 0, 0, baseHeight) }, 0.2)
                end
            end
            local clickArea = create("TextButton", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5 }, f)
            clickArea.MouseButton1Click:Connect(function() expanded = not expanded; updateState() end)
            rebuild()
            if c.Flag and CentralUI.Flags[c.Flag] ~= nil then selected = CentralUI.Flags[c.Flag]; curLabel.Text = tostring(selected); rebuild() end
            obj.Set = function(opt) selected = opt; curLabel.Text = tostring(opt); rebuild() end
            obj.Get = function() return selected end
            obj.Remove = function() f:Destroy() end
            obj.SetVisible = function(v) f.Visible = v end
            return obj
        end

        function tab:CreateKeybind(c)
            local obj = {}; local keyName = c.CurrentKeybind or "Q"
            if typeof(keyName) == "EnumItem" then keyName = keyName.Name end
            local listening = false; local f = elemFrame(34)
            label(f, c.Name or "Keybind", UDim2.new(1, -100, 1, 0), UDim2.new(0, 12, 0, 0), T.Text, font(), 13)
            local btn_ = create("TextButton", {
                Size = UDim2.new(0, 70, 0, 22), Position = UDim2.new(1, -80, 0.5, -11),
                BackgroundColor3 = T.Input, BorderSizePixel = 0, Text = tostring(keyName),
                TextColor3 = T.Accent, FontFace = font(Enum.FontWeight.Medium), TextSize = 12, AutoButtonColor = false,
            }, f)
            corner(btn_, 4); stroke(btn_, T.Stroke)
            btn_.MouseButton1Click:Connect(function() listening = true; btn_.Text = "..."; btn_.TextColor3 = T.Sub end)
            UIS.InputBegan:Connect(function(input, gp)
                if gp then return end
                if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                if listening then
                    keyName = input.KeyCode.Name; listening = false; btn_.Text = keyName; btn_.TextColor3 = T.Accent
                    if c.Flag then CentralUI.Flags[c.Flag] = keyName end
                    if c.Callback then task.spawn(c.Callback, keyName) end
                elseif input.KeyCode.Name == keyName then
                    if c.OnPressed then task.spawn(c.OnPressed) end
                end
            end)
            if c.Flag and CentralUI.Flags[c.Flag] ~= nil then keyName = CentralUI.Flags[c.Flag]; btn_.Text = keyName end
            obj.Set = function(k) keyName = (typeof(k) == "EnumItem") and k.Name or tostring(k); btn_.Text = keyName end
            obj.Get = function() return keyName end
            obj.Remove = function() f:Destroy() end
            obj.SetVisible = function(v) f.Visible = v end
            return obj
        end

        function tab:CreateColorPicker(c)
            local obj = {}; local col = c.Color or Color3.fromRGB(255, 255, 255); local f = elemFrame(80)
            label(f, c.Name or "Color", UDim2.new(1, -60, 0, 20), UDim2.new(0, 12, 0, 6), T.Text, font(), 13)
            local prev = create("Frame", { Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -38, 0, 6), BackgroundColor3 = col, BorderSizePixel = 0 }, f)
            corner(prev, 4); stroke(prev, T.Stroke)
            local bars = {}
            for i, ch in ipairs({"R", "G", "B"}) do
                local bar = create("Frame", { Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 40 + (i - 1) * 12), BackgroundColor3 = T.Divider, BorderSizePixel = 0 }, f)
                corner(bar, 2)
                local prog = create("Frame", { Size = UDim2.new(col[ch] / 255, 0, 1, 0), BackgroundColor3 = T.Accent, BorderSizePixel = 0 }, bar)
                corner(prog, 2); bars[ch] = { bar = bar, prog = prog }
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
            obj.Set = function(color) col = color; prev.BackgroundColor3 = color; for ch, data in pairs(bars) do data.prog.Size = UDim2.new(color[ch] / 255, 0, 1, 0) end end
            obj.Get = function() return col end
            obj.Remove = function() f:Destroy() end
            obj.SetVisible = function(v) f.Visible = v end
            return obj
        end

        function tab:CreateSection(text)
            local obj = {}; local f = create("Frame", { Name = "Section", Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = nextOrder() }, content)
            label(f, text or "Section", UDim2.new(1, 0, 0, 20), UDim2.new(), T.Sub, font(Enum.FontWeight.Medium), 11)
            create("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 20), BackgroundColor3 = T.Divider, BorderSizePixel = 0 }, f)
            obj.Set = function(t) for _, ch in ipairs(f:GetChildren()) do if ch:IsA("TextLabel") then ch.Text = t end end end
            obj.Remove = function() f:Destroy() end
            obj.SetVisible = function(v) f.Visible = v end
            return obj
        end

        function tab:CreateLabel(text)
            local obj = {}; local l = label(content, text or "", UDim2.new(1, 0, 0, 20), UDim2.new(), T.Text, font(), 13)
            l.LayoutOrder = nextOrder()
            obj.Set = function(t) l.Text = t end
            obj.Remove = function() l:Destroy() end
            obj.SetVisible = function(v) l.Visible = v end
            return obj
        end

        function tab:CreateParagraph(c)
            local obj = {}; local f = create("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = nextOrder() }, content)
            label(f, c.Title or "Title", UDim2.new(1, 0, 0, 18), UDim2.new(), T.Text, font(Enum.FontWeight.Medium), 13)
            local body = label(f, c.Content or "", UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 0, 20), T.Sub, font(), 12)
            body.TextWrapped = true
            obj.Set = function(newCfg) for _, ch in ipairs(f:GetChildren()) do if ch:IsA("TextLabel") then if ch.Position.Y.Offset == 0 then ch.Text = newCfg.Title or ch.Text else ch.Text = newCfg.Content or ch.Text end end end end
            obj.Remove = function() f:Destroy() end
            obj.SetVisible = function(v) f.Visible = v end
            return obj
        end

        return tab
    end

    if welcomer then
        task.spawn(function() runWelcomer(welcomer, fill, percent, main, watermark) end)
    else
        main.Visible = true
        if watermark then watermark.Visible = true end
    end

    return window
end

if getgenv then getgenv().CentralUI = CentralUI end
_G.CentralUI = CentralUI
return CentralUI
