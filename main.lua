-- main.lua
local Lucidity = {}
local Themes = require(script.Parent.themes)
local Elements = require(script.Parent.elements)
local Notifications = require(script.Parent.notifications)

Lucidity.Theme = Themes.Default

function Lucidity:CreateWindow(title)
    -- 1. Create main ScreenGui and Window Frame
    -- 2. Add Topbar + Dragging Logic
    -- 3. Add Sidebar for Tabs
    
    local window = {}
    
    function window:CreateTab(tabName)
        local tabObject = { ComponentCount = 0 }
        -- Create the scrolling frame for this specific page...
        
        -- INJECT THE BUILDERS RIGHT HERE:
        Elements.new(tabObject, pageScrollingFrame, Lucidity.Theme)
        
        return tabObject
    end
    
    return window
end

return Lucidity
