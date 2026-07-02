local Lucidity = {}
Lucidity.__index = Lucidity

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

Lucidity.Theme = {
    Sidebar = Color3.fromRGB(15, 15, 22),         -- Sleeker dark slate
    CardBackground = Color3.fromRGB(30, 30, 40),  -- Slightly brighter card backing for depth
    Text = Color3.fromRGB(255, 255, 255),
    MutedText = Color3.fromRGB(160, 160, 180),
    Accent = Color3.fromRGB(0, 200, 255),         -- Much brighter cyan accent
    ToggleOn = Color3.fromRGB(46, 213, 115),      -- Vibrant neon green
    Font = Enum.Font.GothamMedium
}

local Icons = {
    home = "rbxassetid://10734951102",
    settings = "rbxassetid://10734950309",
    shield = "rbxassetid://10734950181",
    combat = "rbxassetid://10747360634"
}

function Lucidity:CreateWindow(config)
    local config = config or {}
    local titleText = config.Name or "Lucidity OS"
    
    local self = setmetatable({}, Lucidity)
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Lucidity_" .. titleText
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = screenGui

    -- Main Window Frame with increased rounding and subtle glow outline
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 650, 0, 430)
    mainFrame.Position = UDim2.new(0.5, -325, 0.5, -215)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = false -- Allow outline stroke to show
    mainFrame.Parent = screenGui
    self.MainFrame = mainFrame

    -- Premium UI Scaling (For DPI Changes)
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 1
    uiScale.Parent = mainFrame
    self.UIScale = uiScale

    -- Ultra Smooth Corner Rounding (16px)
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame

    -- Premium Glow Outline
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(45, 45, 60)
    stroke.Transparency = 0.5
    stroke.Parent = mainFrame

    -- ✨ BRIGHTENED CANVAS GRADIENT (Saturated Neon Profiles)
    local gradientFrame = Instance.new("Frame")
    gradientFrame.Name = "GradientBackground"
    gradientFrame.Size = UDim2.new(1, 0, 1, 0)
    gradientFrame.BorderSizePixel = 0
    gradientFrame.ClipsDescendants = true
    gradientFrame.Parent = mainFrame
    Instance.new("UICorner", gradientFrame).CornerRadius = UDim.new(0, 16)

    local uiGradient = Instance.new("UIGradient")
    uiGradient.Rotation = 45 
    uiGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 45, 85)),   -- Vibrant Neon Hot Pink/Red
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 230, 0)),  -- Saturated Laser Yellow
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 235, 255)),   -- Electric Light Cyan Blue
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 70, 255))     -- Ultra Deep Electric Blue
    })
    uiGradient.Parent = gradientFrame

    -- Dark sleek overlay tint
    local darkOverlay = Instance.new("Frame")
    darkOverlay.Name = "DarkOverlay"
    darkOverlay.Size = UDim2.new(1, 0, 1, 0)
    darkOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    darkOverlay.BackgroundTransparency = 0.15 -- Kept lighter so the neon gradient really pops
    darkOverlay.BorderSizePixel = 0
    darkOverlay.Parent = gradientFrame

    -- 🖥️ OS TOP BAR
    local topBar = Instance.new("Frame")
    topBar.Name = "OSTopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    self.TopBar = topBar
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 16)
    
    -- Fix topbar bottom rounding overlay
    local topBarFix = Instance.new("Frame")
    topBarFix.Size = UDim2.new(1, 0, 0, 10)
    topBarFix.Position = UDim2.new(0, 0, 1, -10)
    topBarFix.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    topBarFix.BorderSizePixel = 0
    topBarFix.Parent = topBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 18, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🔮 " .. titleText
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    -- Mac Style Controls
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 60, 1, 0)
    controls.Position = UDim2.new(1, -74, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = topBar

    local controlLayout = Instance.new("UIListLayout")
    controlLayout.FillDirection = Enum.FillDirection.Horizontal
    controlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlLayout.Padding = UDim.new(0, 8)
    controlLayout.Parent = controls

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 12, 0, 12)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 85)
    closeBtn.Text = ""
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = controls
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

    closeBtn.MouseButton1Click:Connect(function()
        local outTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        outTween:Play()
        outTween.Completed:Connect(function() screenGui:Destroy() end)
    end)

    -- Left Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 175, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundColor3 = self.Theme.Sidebar
    sidebar.BackgroundTransparency = 0.1
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    self.Sidebar = sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.Parent = sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 10)
    sidebarPadding.Parent = sidebar

    -- Right Content Area
    local mainDisplay = Instance.new("Frame")
    mainDisplay.Size = UDim2.new(1, -175, 1, -40)
    mainDisplay.Position = UDim2.new(0, 175, 0, 40)
    mainDisplay.BackgroundTransparency = 1
    mainDisplay.Parent = mainFrame
    
    self.Pages = Instance.new("Folder")
    self.Pages.Parent = mainDisplay

    self:EnableDragging()
    
    -- ⚙️ MANDATORY INTERNAL SETTINGS TAB INITIALIZATION
    task.spawn(function()
        local Settings = self:CreateTab("Settings", "settings")
        Settings:CreateSection("Engine Configurations")
        
        Settings:CreateDropdown({
            Name = "UI DPI Scaling",
            Options = {"75%", "100%", "125%", "150%"},
            Default = "100%"
        }, function(selected)
            if selected == "75%" then uiScale.Scale = 0.75
            elseif selected == "100%" then uiScale.Scale = 1.0
            elseif selected == "125%" then uiScale.Scale = 1.25
            elseif selected == "150%" then uiScale.Scale = 1.5
            end
        end)
    end)

    return self
end

function Lucidity:EnableDragging()
    local UserInputService = game:GetService("UserInputService")
    local gui = self.MainFrame
    local dragHandle = self.TopBar

    local dragging, dragInput, dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            -- Calculate based on UIScale modifier so dragging doesn't feel floaty or unaligned when scaling changes
            local scaleModifier = self.UIScale.Scale
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (delta.X / scaleModifier), startPos.Y.Scale, startPos.Y.Offset + (delta.Y / scaleModifier))
        end
    end)
end

function Lucidity:CreateTab(tabName, iconName)
    local theme = self.Theme
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "_Tab"
    tabButton.Size = UDim2.new(0, 158, 0, 38)
    tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = ""
    tabButton.BorderSizePixel = 0
    tabButton.Parent = self.Sidebar
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.Parent = tabButton
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.Parent = tabButton

    if iconName and Icons[string.lower(iconName)] then
        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.Size = UDim2.new(0, 18, 0, 18)
        iconImg.BackgroundTransparency = 1
        iconImg.Image = Icons[string.lower(iconName)]
        iconImg.ImageColor3 = theme.MutedText
        iconImg.Parent = tabButton
    end

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "TabText"
    textLabel.Size = UDim2.new(1, -30, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = tabName
    textLabel.TextColor3 = theme.MutedText
    textLabel.Font = theme.Font
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = tabButton

    local pageContainer = Instance.new("ScrollingFrame")
    pageContainer.Size = UDim2.new(1, -24, 1, -24)
    pageContainer.Position = UDim2.new(0, 12, 0, 12)
    pageContainer.BackgroundTransparency = 1
    pageContainer.Visible = false
    pageContainer.ScrollBarThickness = 2
    pageContainer.ScrollBarImageColor3 = theme.Accent
    pageContainer.Parent = self.Pages

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Parent = pageContainer

    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pageContainer.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
    end)

    tabButton.MouseButton1Click:Connect(function()
        for _, page in pairs(self.Pages:GetChildren()) do page.Visible = false end
        for _, btn in pairs(self.Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                if btn:FindFirstChild("TabText") then btn.TabText.TextColor3 = theme.MutedText end
                if btn:FindFirstChild("Icon") then btn.Icon.ImageColor3 = theme.MutedText end
            end
        end
        
        pageContainer.Visible = true
        TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
        textLabel.TextColor3 = theme.Text
        if tabButton:FindFirstChild("Icon") then tabButton.Icon.ImageColor3 = theme.Accent end
    end)

    local tabObject = {}
    
    function tabObject:CreateSection(sectionText)
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Size = UDim2.new(1, 0, 0, 30)
        sectionFrame.BackgroundTransparency = 1
        sectionFrame.Parent = pageContainer

        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.Size = UDim2.new(1, 0, 1, 0)
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = string.upper(sectionText)
        sectionLabel.TextColor3 = theme.Accent
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.TextSize = 11
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Parent = sectionFrame
    end

    function tabObject:CreateButton(config, callback)
        local config = config or {}
        local btnText = config.Name or "Button"
        local btnDesc = config.Interact or "Execute"
        local callback = callback or function() end

        local btnFrame = Instance.new("TextButton")
        btnFrame.Size = UDim2.new(1, 0, 0, 46)
        btnFrame.BackgroundColor3 = theme.CardBackground
        btnFrame.BackgroundTransparency = 0.15
        btnFrame.Text = ""
        btnFrame.BorderSizePixel = 0
        btnFrame.Parent = pageContainer
        Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 8)

        local mainLabel = Instance.new("TextLabel")
        mainLabel.Size = UDim2.new(0.6, 0, 1, 0)
        mainLabel.Position = UDim2.new(0, 14, 0, 0)
        mainLabel.BackgroundTransparency = 1
        mainLabel.Text = btnText
        mainLabel.TextColor3 = theme.Text
        mainLabel.Font = theme.Font
        mainLabel.TextSize = 14
        mainLabel.TextXAlignment = Enum.TextXAlignment.Left
        mainLabel.Parent = btnFrame

        btnFrame.MouseButton1Click:Connect(function() task.spawn(callback) end)
    end

    -- ✨ NEW: PREMIUM DROPDOWN LIST ELEMENT
    function tabObject:CreateDropdown(config, callback)
        local config = config or {}
        local dropName = config.Name or "Dropdown Selection"
        local options = config.Options or {}
        local default = config.Default or options[1] or "Select..."
        local callback = callback or function() end
        
        local selectedValue = default
        local open = false

        local dropFrame = Instance.new("Frame")
        dropFrame.Size = UDim2.new(1, 0, 0, 46)
        dropFrame.BackgroundColor3 = theme.CardBackground
        dropFrame.BackgroundTransparency = 0.15
        dropFrame.ClipsDescendants = true
        dropFrame.Parent = pageContainer
        local cardCorner = Instance.new("UICorner", dropFrame)
        cardCorner.CornerRadius = UDim.new(0, 8)

        local triggerButton = Instance.new("TextButton")
        triggerButton.Size = UDim2.new(1, 0, 0, 46)
        triggerButton.BackgroundTransparency = 1
        triggerButton.Text = ""
        triggerButton.Parent = dropFrame

        local mainLabel = Instance.new("TextLabel")
        mainLabel.Size = UDim2.new(0.5, 0, 0, 46)
        mainLabel.Position = UDim2.new(0, 14, 0, 0)
        mainLabel.BackgroundTransparency = 1
        mainLabel.Text = dropName
        mainLabel.TextColor3 = theme.Text
        mainLabel.Font = theme.Font
        mainLabel.TextSize = 14
        mainLabel.TextXAlignment = Enum.TextXAlignment.Left
        mainLabel.Parent = dropFrame

        local selectedLabel = Instance.new("TextLabel")
        selectedLabel.Size = UDim2.new(0.5, -40, 0, 46)
        selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
        selectedLabel.BackgroundTransparency = 1
        selectedLabel.Text = selectedValue
        selectedLabel.TextColor3 = theme.Accent
        selectedLabel.Font = theme.Font
        selectedLabel.TextSize = 13
        selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
        selectedLabel.Parent = dropFrame

        local indicator = Instance.new("TextLabel")
        indicator.Size = UDim2.new(0, 30, 0, 46)
        indicator.Position = UDim2.new(1, -35, 0, 0)
        indicator.BackgroundTransparency = 1
        indicator.Text = "▼"
        indicator.TextColor3 = theme.MutedText
        indicator.Font = theme.Font
        indicator.TextSize = 12
        indicator.Parent = dropFrame

        -- Options Container Panel
        local listHolder = Instance.new("Frame")
        listHolder.Size = UDim2.new(1, -20, 0, #options * 32)
        listHolder.Position = UDim2.new(0, 10, 0, 46)
        listHolder.BackgroundTransparency = 1
        listHolder.Parent = dropFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 4)
        listLayout.Parent = listHolder

        for _, option in pairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 28)
            optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            optBtn.Text = option
            optBtn.TextColor3 = theme.Text
            optBtn.Font = theme.Font
            optBtn.TextSize = 12
            optBtn.Parent = listHolder
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

            optBtn.MouseButton1Click:Connect(function()
                selectedValue = option
                selectedLabel.Text = option
                open = false
                TweenService:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 46)}):Play()
                indicator.Text = "▼"
                task.spawn(callback, option)
            end)
        end

        triggerButton.MouseButton1Click:Connect(function()
            open = not open
            local targetHeight = open and (46 + (#options * 32) + 10) or 46
            indicator.Text = open and "▲" or "▼"
            TweenService:Create(dropFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
        end)
    end

    return tabObject
end

return Lucidity
