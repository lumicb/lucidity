-- main.lua
local Lucidity = {}
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Load Modules
local Themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/themes.lua"))()
local Elements = loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/elements.lua"))()
-- Notifications would go here

Lucidity.Theme = Themes.Default

function Lucidity:CreateWindow(options)
    local config = type(options) == "table" and options or { Name = "LUCIDITY" }
    local theme = Lucidity.Theme

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    screenGui.Name = "Lucidity_Framework"

    -- Window
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 550, 0, 360)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -180)
    mainFrame.BackgroundColor3 = theme.WindowBg
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

    -- Top Bar (Visuals added here)
    local topBar = Instance.new("Frame", mainFrame)
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundTransparency = 1

    local titleLabel = Instance.new("TextLabel", topBar)
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.Name
    titleLabel.TextColor3 = theme.Text
    titleLabel.Font = theme.Font
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Close Button
    local closeBtn = Instance.new("TextButton", topBar)
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = theme.Text
    closeBtn.TextSize = 18
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- Container for Tabs
    local sidebar = Instance.new("Frame", mainFrame)
    sidebar.Size = UDim2.new(0, 150, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundTransparency = 1
    Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 4)

    local displayContainer = Instance.new("Frame", mainFrame)
    displayContainer.Size = UDim2.new(1, -160, 1, -50)
    displayContainer.Position = UDim2.new(0, 150, 0, 40)
    displayContainer.BackgroundTransparency = 1

    local windowObj = { TabCount = 0 }

    function windowObj:CreateTab(tabName)
        windowObj.TabCount += 1
        local tabData = { ComponentCount = 0 }
        
        local navBtn = Instance.new("TextButton", sidebar)
        navBtn.Size = UDim2.new(1, -8, 0, 32)
        navBtn.Text = tabName
        navBtn.TextColor3 = theme.Text
        navBtn.BackgroundColor3 = theme.CardBackground
        Instance.new("UICorner", navBtn).CornerRadius = UDim.new(0, 6)

        local pageScroll = Instance.new("ScrollingFrame", displayContainer)
        pageScroll.Size = UDim2.new(1, 0, 1, 0)
        pageScroll.BackgroundTransparency = 1
        pageScroll.Visible = (windowObj.TabCount == 1)
        Instance.new("UIListLayout", pageScroll).Padding = UDim.new(0, 8)

        -- HERE IS THE FIX: Connecting to the elements module
        Elements.Load(tabData, pageScroll, theme)

        navBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(displayContainer:GetChildren()) do v.Visible = false end
            pageScroll.Visible = true
        end)

        return tabData
    end

    return windowObj
end

return Lucidity
