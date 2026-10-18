# Central UI

> **Monochrome Dark** UI library for Roblox. Clean API, zero dependencies, fully compatible with `loadstring`.

![Roblox](https://img.shields.io/badge/Platform-Roblox-00A2FF?style=for-the-badge&logo=roblox&logoColor=white)
![Version](https://img.shields.io/badge/version-4.2.0-informational?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)

---

## ✨ Features

- 🎨 **Strict Monochrome Design**: Inspired by Rayfield, but darker and cleaner. No bright colors.
- ⚡ **Zero Dependencies**: Works instantly via `loadstring`.
- 🔄 **Dynamic Tabs**: Add, remove, or update tabs and their icons at runtime.
- 💾 **Config System**: Built-in Save/Load/Delete system with JSON support.
- 🔍 **Executor Detection**: Automatically detects Solara, Xeno, Velocity, etc., in the watermark.
- 🛠️ **Full Control**: Minimize to topbar, drag-and-drop, and Ctrl toggle.

---

## 🚀 Installation

Copy and paste this into your executor:
lua
local CentralUI = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/WareSploit/Central-UI/main/main.lua?v=4"
))()

---

## 📖 Quick Start

```lua
-- 1. Initialize Library
local CentralUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Central-UI/main/main.lua?v=4"))()

-- 2. Customize Window Title
CentralUI:SetTitle("My Custom Hub")

-- 3. Create Tabs (Name, ImageID)
local MainTab = CentralUI:CreateTab("Main", "rbxassetid://10723407389")
local SettingsTab = CentralUI:CreateTab("Settings", "rbxassetid://10734950309")

-- 4. Add Elements
CentralUI:CreateSection(MainTab, "General")

CentralUI:CreateButton(MainTab, "Click Me", function()
    CentralUI:Notify("Success", "Button clicked!", 3)
end)

local speedSlider = CentralUI:CreateSlider(MainTab, "Walk Speed", 16, 100, 16, function(val)
    print("Speed:", val)
end, "walk_speed") -- 'walk_speed' is the Flag name

-- 5. Show Watermark (Auto-detects Executor)
CentralUI:CreateWatermark() 
-- Output: "Central UI v4.2.0 | Solara"
