-- theme_manager.lua
local ThemeManager = {}

ThemeManager.Theme = {
    WindowBg = Color3.fromRGB(18, 19, 22),       -- Dark main wrapper background
    Sidebar = Color3.fromRGB(24, 25, 30),        -- Slightly lighter left sidebar panel
    CardBackground = Color3.fromRGB(30, 31, 38), -- Standard component block background 
    Border = Color3.fromRGB(42, 44, 54),         -- Crisp frame outlines
    Text = Color3.fromRGB(242, 244, 247),       -- High-contrast primary text
    MutedText = Color3.fromRGB(138, 143, 154),  -- Secondary/placeholder labels
    Active = Color3.fromRGB(255, 255, 255),     -- Toggled/selected states (pure white)
    Font = Enum.Font.GothamMedium
}

-- Centralized Asset Pipeline (using modern workspace icons)
ThemeManager.Icons = {
    home = "rbxassetid://10734951102",
    settings = "rbxassetid://10734950309",
    combat = "rbxassetid://10747360634",
    search = "rbxassetid://10734950791",
    window = "rbxassetid://10723343385",
    chevron = "rbxassetid://10734896828",
    eye = "rbxassetid://10723345453"
}

return ThemeManager
