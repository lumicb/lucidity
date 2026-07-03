-- main.lua
local Lucidity = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- ====================================================================
-- DYNAMIC MODULE LOADING (GitHub Integration)
-- ====================================================================
local success, result

-- Load Themes
success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/themes.lua"))()
end)
local Themes = success and result or {
    Default = {
        WindowBg = Color3.fromRGB(20, 21, 26),
        CardBackground = Color3.fromRGB(30, 31, 38),
        Active = Color3.fromRGB(138, 180, 248),
        Border = Color3.fromRGB(45, 47, 56),
        Text = Color3.fromRGB(240, 240, 240),
        MutedText = Color3.fromRGB(150, 155, 170),
        Font = Enum.Font.Gotham
    }
}

-- Load Elements Factory
success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/elements.lua"))()
end)
local ElementsFactory = success and result or nil

-- Load Notifications System
success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/notifications.lua"))()
end)
local Notifications = success and result or nil

-- Set the active theme configuration
Lucidity.Theme = Themes.Default
Lucidity.Notifications = Notifications

-- ====================================================================
-- CORE DRAGGING LOGIC FUNCTION
-- ====================================================================
local function makeDraggable(windowFrame, dragBar)
    local dragging = false
    local dragInput, dragStart, startPos

    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = windowFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            windowFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ====================================================================
-- MAIN WINDOW CREATION
-- ====================================================================
function Lucidity:CreateWindow(titleText)
    titleText = titleText or "LUCIDITY"
    local theme = self.Theme

    -- Main GUI Canvas
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Lucidity_Framework"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Safety execution check for standard CoreGui access
    local targetParent = game:GetService("CoreGui") or Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Parent = targetParent

    -- Base Window Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 550, 0, 360)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -180)
    mainFrame.BackgroundColor3 = theme.WindowBg
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", mainFrame).Color = theme.Border

    -- Top Header Bar (Acts as the drag anchor)
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainFrame
    makeDraggable(mainFrame, topBar)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleText
    titleLabel.TextColor3 = theme.Text
    titleLabel.Font = theme.Font or Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    -- Sidebar Container (For Tab Navigation)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 150, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundTransparency = 1
    sidebar.Parent = mainFrame

    local sLayout = Instance.new("UIListLayout", sidebar)
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sLayout.Padding = UDim.new(0, 4)
    Instance.new("UIPadding", sidebar).PaddingLeft = UDim.new(0, 8)

    -- Right Side Content Container (Where pages go)
    local displayContainer = Instance.new("Frame")
    displayContainer.Size = UDim2.new(1, -160, 1, -50)
    displayContainer.Position = UDim2.new(0, 150, 0, 40)
    displayContainer.BackgroundTransparency = 1
    displayContainer.Parent = mainFrame

    -- Tracker data structures
    local windowObj = {
        CurrentTab = nil,
        TabsList = {},
        TabCount = 0
    }

    -- ====================================================================
    -- TAB MANIPULATION METHODS
    -- ====================================================================
    function windowObj:CreateTab(tabName)
        self.TabCount = self.TabCount + 1
        local tabId = self.TabCount
        
        -- 1. Create the Sidebar Navigation Button
        local navBtn = Instance.new("TextButton")
        navBtn.Size = UDim2.new(1, -8, 0, 32)
        navBtn.BackgroundColor3 = (tabId == 1) and theme.CardBackground or Color3.fromRGB(0,0,0)
        navBtn.BackgroundTransparency = (tabId == 1) and 0 or 1
        navBtn.Text = tabName
        navBtn.TextColor3 = (tabId == 1) and theme.Text or theme.MutedText
        navBtn.Font = theme.Font or Enum.Font.Gotham
        navBtn.TextSize = 12
        navBtn.LayoutOrder = tabId
        navBtn.Parent = sidebar
        Instance.new("UICorner", navBtn).CornerRadius = UDim.new(0, 6)

        -- 2. Create the scrolling canvas container for this specific page
        local pageScroll = Instance.new("ScrollingFrame")
        pageScroll.Size = UDim2.new(1, 0, 1, 0)
        pageScroll.BackgroundTransparency = 1
        pageScroll.BorderSizePixel = 0
        pageScroll.ScrollBarThickness = 3
        pageScroll.ScrollBarImageColor3 = theme.Border
        pageScroll.Visible = (tabId == 1)
        pageScroll.Parent = displayContainer

        local pLayout = Instance.new("UIListLayout", pageScroll)
        pLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pLayout.Padding = UDim.new(0, 8)
        Instance.new("UIPadding", pageScroll).PaddingRight = UDim.new(0, 8)

        -- Dynamic canvas resizer so scrolling never cuts off elements
        pLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            pageScroll.CanvasSize = UDim2.new(0, 0, 0, pLayout.AbsoluteContentSize.Y + 10)
        end)

        -- Instanced unique track data for elements.lua components
        local tabData = {
            ComponentCount = 0,
            NavButton = navBtn,
            PageFrame = pageScroll
        }

        -- Inject the element creators directly into this tab via the online file
        if ElementsFactory and ElementsFactory.new then
            ElementsFactory.new(tabData, pageScroll, theme)
        end

        -- Navigation Swap Event Handler
        navBtn.MouseButton1Click:Connect(function()
            for _, existingTab in pairs(windowObj.TabsList) do
                existingTab.PageFrame.Visible = false
                existingTab.NavButton.BackgroundTransparency = 1
                existingTab.NavButton.TextColor3 = theme.MutedText
            end
            pageScroll.Visible = true
            navBtn.BackgroundTransparency = 0
            navBtn.BackgroundColor3 = theme.CardBackground
            navBtn.TextColor3 = theme.Text
        end)

        table.insert(windowObj.TabsList, tabData)
        return tabData
    end

    return windowObj
end

return Lucidity
