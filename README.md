# Central UI

> Dark monochrome UI library for Roblox. Clean API, zero dependencies, works with `loadstring`.

![Version](https://img.shields.io/badge/version-1.0.0-informational)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 🚀 Installation

```lua
local CentralUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YOUR_NAME/CentralUI/main/main.lua"
))()
```

## 📖 Quick Start

```lua
local Win = CentralUI:CreateWindow({
    Name = "My Menu",
    LoadingTitle = "Central UI",
    LoadingSubtitle = "by YourName",
    Logo = "rbxassetid://10442402750",
})

local Tab = Win:CreateTab("Main", "rbxassetid://10723407389")

Tab:CreateButton({
    Name = "Click Me",
    Callback = function() print("Clicked!") end,
})
```

## 🎨 Elements

| Method | Description |
|--------|-------------|
| `Tab:CreateButton({Name, Callback})` | Simple button |
| `Tab:CreateToggle({Name, CurrentValue, Flag, Callback})` | Toggle switch |
| `Tab:CreateSlider({Name, Range, Increment, CurrentValue, Suffix, Flag, Callback})` | Range slider |
| `Tab:CreateInput({Name, PlaceholderText, Flag, Callback})` | Text input |
| `Tab:CreateDropdown({Name, Options, CurrentOption, Flag, Callback})` | Dropdown with inline expand |
| `Tab:CreateKeybind({Name, CurrentKeybind, Flag, OnPressed})` | Keybind picker + listener |
| `Tab:CreateColorPicker({Name, Color, Flag, Callback})` | RGB color picker |
| `Tab:CreateSection(text)` | Section divider |
| `Tab:CreateLabel(text)` | Static label |
| `Tab:CreateParagraph({Title, Content})` | Title + wrapped body |

## 📢 Notifications & Watermark

```lua
CentralUI:Notify({
    Title = "Hello",
    Content = "Welcome!",
    Duration = 5,
})

CentralUI:CreateWatermark({ Text = "Central UI | v1.0.0" })
```

## 🎛️ Window Controls

- **Close / Min** — buttons in topbar
- **Drag** — hold topbar
- **Toggle window** — `RightCtrl` or `LeftCtrl`

## 🔒 Preserved Elements

- `MAIN-SVG` — library logo (`rbxassetid://10442402750`)
- `USER-IMAGE` — per-tab icon, set via `CreateTab(name, iconId)`

## 🧩 Flags

Any element accepting `Flag = "..."` stores its value in `CentralUI.Flags`:

```lua
print(CentralUI.Flags.Speed)   -- 50
print(CentralUI.Flags.Mode)    -- "Alpha"
```

## 📄 License

MIT — free to use, modify, and distribute.
