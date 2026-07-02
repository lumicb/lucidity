local Lucidity = {}
Lucidity.__index = Lucidity

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

-- Global Theme Engine Settings
Lucidity.Theme = {
    Sidebar = Color3.fromRGB(18, 18, 24),          -- Deep obsidian sidebar
    CardBackground = Color3.fromRGB(28, 28, 36),   -- Elevated component containers
    Text = Color3.fromRGB(255, 255, 255),          -- Crisp white
    MutedText = Color3.fromRGB(140, 140, 155),     -- For descriptions and inactive states
    Accent = Color3.fromRGB(0, 162, 255),          -- Light blue accents
    ToggleOn = Color3.fromRGB(46, 204, 113),       -- Active toggle green
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
    
    -- Main Screen Container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Lucidity_" .. titleText
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = screenGui

    -- Main Window Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 640, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    self.MainFrame = mainFrame

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame

    -- ✨ THEME ENGINE: Blended Custom Diagonal Background Gradient (Red -> Yellow -> Light Blue -> Blue)
    local gradientFrame = Instance.new("Frame")
    gradientFrame.Name = "GradientBackground"
    gradientFrame.Size = UDim2.new(1, 0, 1, 0)
    gradientFrame.BorderSizePixel = 0
    gradientFrame.Parent = mainFrame

    local uiGradient = Instance.new("UIGradient")
    uiGradient.Rotation = 45 -- Rotates color profile from bottom-left to top-right
    uiGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(235, 60, 60)),   -- Vibrant Red (Bottom Left)
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(245, 210, 65)), -- Sunny Yellow
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(70, 190, 240)),  -- Light Blue
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(30, 85, 225))    -- Deep Blue (Top Right)
    })
    uiGradient.Parent = gradientFrame

    -- Soft semi-transparent dark overlay so text remains perfectly readable over the gradient
    local darkOverlay = Instance.new("Frame")
    darkOverlay.Name = "DarkOverlay"
    darkOverlay.Size = UDim2.new(1, 0, 1, 0)
    darkOverlay.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    darkOverlay.BackgroundTransparency = 0.25
    darkOverlay.BorderSizePixel = 0
    darkOverlay.Parent = gradientFrame

    -- 🖥️ OS-STYLE TOP BAR
    local topBar = Instance.new("Frame")
    topBar.Name = "OSTopBar"
    topBar.Size = UDim2.new(1, 0, 0, 36)
    topBar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    self.TopBar = topBar
    
    -- Window Title Text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "💻 " .. titleText
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    -- OS Mac/Windows Style Control Buttons Container
    local controls = Instance.new("Frame")
    controls.Name = "WindowControls"
    controls.Size = UDim2.new(0, 60, 1, 0)
    controls.Position = UDim2.new(1, -70, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = topBar

    local controlLayout = Instance.new("UIListLayout")
    controlLayout.FillDirection = Enum.FillDirection.Horizontal
    controlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlLayout.Padding = UDim.new(0, 8)
    controlLayout.Parent = controls

    -- Minimize Button Illusion (Yellow)
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "Minimize"
    minBtn.Size = UDim2.new(0, 12, 0, 12)
    minBtn.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
    minBtn.Text = ""
    minBtn.BorderSizePixel = 0
    minBtn.Parent = controls
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

    -- Close Button (Red)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 12, 0, 12)
    closeBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    closeBtn.Text = ""
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = controls
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

    closeBtn.MouseButton1Click:Connect(function()
        local outTween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        outTween:Play()
        outTween.Completed:Connect(function() screenGui:Destroy() end)
    end)

    -- Left Navigation Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 170, 1, -36)
    sidebar.Position = UDim2.new(0, 0, 0, 36)
    sidebar.BackgroundColor3 = self.Theme.Sidebar
    sidebar.BackgroundTransparency = 0.15 -- Lets a hint of the background glow filter through
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    self.Sidebar = sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.Parent = sidebar

    -- Right Main Display Area
    local mainDisplay = Instance.new("Frame")
    mainDisplay.Name = "MainDisplay"
    mainDisplay.Size = UDim2.new(1, -170, 1, -36)
    mainDisplay.Position = UDim2.new(0, 170, 0, 36)
    mainDisplay.BackgroundTransparency = 1
    mainDisplay.Parent = mainFrame
    
    self.Pages = Instance.new("Folder")
    self.Pages.Name = "Pages"
    self.Pages.Parent = mainDisplay

    self:EnableDragging()

    return self
end

function Lucidity:EnableDragging()
    local UserInputService = game:GetService("UserInputService")
    local gui = self.MainFrame
    local dragHandle = self.TopBar -- Can only drag via the top OS bar!

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
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Lucidity:CreateTab(tabName, iconName)
    local theme = self.Theme
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "_Tab"
    tabButton.Size = UDim2.new(0, 154, 0, 38)
    tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = ""
    tabButton.BorderSizePixel = 0
    tabButton.Parent = self.Sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabButton

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
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = tabButton

    local pageContainer = Instance.new("ScrollingFrame")
    pageContainer.Name = tabName .. "_Page"
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
        for _, page in pairs(self.Pages:GetChildren()) do
            page.Visible = false
        end
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
        sectionFrame.Name = sectionText .. "_Section"
        sectionFrame.Size = UDim2.new(1, 0, 0, 30)
        sectionFrame.BackgroundTransparency = 1
        sectionFrame.Parent = pageContainer

        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.Name = "Title"
        sectionLabel.Size = UDim2.new(1, 0, 1, 0)
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = string.upper(sectionText)
        sectionLabel.TextColor3 = theme.Accent
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.TextSize = 11
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Parent = sectionFrame
        
        local line = Instance.new("Frame")
        line.Name = "Line"
        line.Size = UDim2.new(1, -120, 0, 1)
        line.Position = UDim2.new(0, 105, 0.5, 0)
        line.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        line.BorderSizePixel = 0
        line.Parent = sectionFrame
    end

    function tabObject:CreateButton(config, callback)
        local config = config or {}
        local btnText = config.Name or "Button"
        local btnDesc = config.Interact or "Execute"
        local callback = callback or function() end

        local btnFrame = Instance.new("TextButton")
        btnFrame.Name = btnText .. "_Element"
        btnFrame.Size = UDim2.new(1, 0, 0, 46)
        btnFrame.BackgroundColor3 = theme.CardBackground
        btnFrame.BackgroundTransparency = 0.2 -- Let background peak through cards slightly
        btnFrame.Text = ""
        btnFrame.BorderSizePixel = 0
        btnFrame.Parent = pageContainer

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btnFrame

        local mainLabel = Instance.new("TextLabel")
        mainLabel.Name = "MainText"
        mainLabel.Size = UDim2.new(0.6, 0, 1, 0)
        mainLabel.Position = UDim2.new(0, 14, 0, 0)
        mainLabel.BackgroundTransparency = 1
        mainLabel.Text = btnText
        mainLabel.TextColor3 = theme.Text
        mainLabel.Font = theme.Font
        mainLabel.TextSize = 14
        mainLabel.TextXAlignment = Enum.TextXAlignment.Left
        mainLabel.Parent = btnFrame

        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "SubText"
        descLabel.Size = UDim2.new(0.4, -14, 1, 0)
        descLabel.Position = UDim2.new(0.6, 0, 0, 0)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = btnDesc
        descLabel.TextColor3 = theme.MutedText
        descLabel.Font = theme.Font
        descLabel.TextSize = 12
        descLabel.TextXAlignment = Enum.TextXAlignment.Right
        descLabel.Parent = btnFrame

        btnFrame.MouseEnter:Connect(function()
            TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.05}):Play()
        end)
        btnFrame.MouseLeave:Connect(function()
            TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        end)
        btnFrame.MouseButton1Down:Connect(function()
            TweenService:Create(btnFrame, TweenInfo.new(0.05), {BackgroundTransparency = 0.4}):Play()
        end)
        btnFrame.MouseButton1Up:Connect(function()
            TweenService:Create(btnFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0.05}):Play()
            task.spawn(callback)
        end)
    end

    function tabObject:CreateToggle(config, callback)
        local config = config or {}
        local toggleText = config.Name or "Toggle Switch"
        local defaultState = config.Default or false
        local callback = callback or function() end
        
        local toggled = defaultState

        local toggleFrame = Instance.new("TextButton")
        toggleFrame.Name = toggleText .. "_Toggle"
        toggleFrame.Size = UDim2.new(1, 0, 0, 46)
        toggleFrame.BackgroundColor3 = theme.CardBackground
        toggleFrame.BackgroundTransparency = 0.2
        toggleFrame.Text = ""
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = pageContainer

        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 6)
        frameCorner.Parent = toggleFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 14, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = toggleText
        label.TextColor3 = theme.Text
        label.Font = theme.Font
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame

        local track = Instance.new("Frame")
        track.Name = "Track"
        track.Size = UDim2.new(0, 36, 0, 20)
        track.Position = UDim2.new(1, -50, 0.5, -10)
        track.BackgroundColor3 = toggled and theme.ToggleOn or Color3.fromRGB(60, 60, 75)
        track.BorderSizePixel = 0
        track.Parent = toggleFrame

        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(1, 0)
        trackCorner.Parent = track

        local ball = Instance.new("Frame")
        ball.Name = "Ball"
        ball.Size = UDim2.new(0, 14, 0, 14)
        ball.Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        ball.BackgroundColor3 = Color3.fromRGB(245, 245, 255)
        ball.BorderSizePixel = 0
        ball.Parent = track

        Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)

        toggleFrame.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            local targetPos = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            local targetColor = toggled and theme.ToggleOn or Color3.fromRGB(60, 60, 75)
            
            TweenService:Create(ball, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
            TweenService:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
            
            task.spawn(callback, toggled)
        end)
    end

    return tabObject
end

return Lucidity
