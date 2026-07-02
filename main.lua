local Lucidity = {}
Lucidity.__index = Lucidity

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

-- ✨ NEW BRIGHT, TRANSLUCENT VIBRANT THEME
Lucidity.Theme = {
    Sidebar = Color3.fromRGB(245, 247, 255),       -- Clean, soft off-white
    CardBackground = Color3.fromRGB(255, 255, 255),-- Pure white card backing for depth
    Text = Color3.fromRGB(40, 44, 55),            -- Deep sleek slate for premium readability
    MutedText = Color3.fromRGB(120, 125, 145),
    Accent = Color3.fromRGB(0, 180, 255),          -- Bright sky cyan
    Font = Enum.Font.GothamMedium
}

local Icons = {
    home = "rbxassetid://10734951102",
    settings = "rbxassetid://10734950309",
    combat = "rbxassetid://10747360634",
    search = "rbxassetid://10734950791"
}

function Lucidity:CreateWindow(config)
    local config = config or {}
    local titleText = config.Name or "Lucidity"
    
    local self = setmetatable({}, Lucidity)
    self.Elements = {} -- Store all searchable elements
    self.IsMinimized = false
    
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Lucidity_" .. titleText
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = screenGui

    -- 🔴 / 🟡 CREATE THE DESKTOP/MOBILE RESTORE BUTTON (Hidden initially)
    local restoreBtn = Instance.new("TextButton")
    restoreBtn.Name = "LucidityRestoreBtn"
    restoreBtn.Size = UDim2.new(0, 50, 0, 50)
    restoreBtn.Position = UDim2.new(0, 20, 0.5, -25)
    restoreBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    restoreBtn.Text = "🔮"
    restoreBtn.TextSize = 22
    restoreBtn.Visible = false
    restoreBtn.ZIndex = 10
    restoreBtn.Parent = screenGui
    Instance.new("UICorner", restoreBtn).CornerRadius = UDim.new(1, 0)
    local btnStroke = Instance.new("UIStroke", restoreBtn)
    btnStroke.Color = Color3.fromRGB(0, 200, 255)
    btnStroke.Thickness = 2

    -- Main Window Frame (With premium 24px corner rounding)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 680, 0, 460)
    mainFrame.Position = UDim2.new(0.5, -340, 0.5, -230)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    self.MainFrame = mainFrame

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 24)
    mainCorner.Parent = mainFrame

    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 1
    uiScale.Parent = mainFrame
    self.UIScale = uiScale

    -- Premium shadow stroke boundary
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(230, 235, 250)
    stroke.Parent = mainFrame

    -- 🌸 HYPER-VIBRANT BACKGROUND DUAL GRADIENT
    local gradientFrame = Instance.new("Frame")
    gradientFrame.Size = UDim2.new(1, 0, 1, 0)
    gradientFrame.BorderSizePixel = 0
    gradientFrame.ClipsDescendants = true
    gradientFrame.Parent = mainFrame
    Instance.new("UICorner", gradientFrame).CornerRadius = UDim.new(0, 24)

    local uiGradient = Instance.new("UIGradient")
    uiGradient.Rotation = 35
    uiGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 110, 180)), -- Dreamy Vibrant Pink
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 90, 255)),  -- Radiant Electric Violet
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 220, 255))    -- Ultra Vibrant Sky Blue
    })
    uiGradient.Parent = gradientFrame

    -- Clean Bright Glass Overlap Tint (Removes the muddy dark feeling)
    local glassTint = Instance.new("Frame")
    glassTint.Size = UDim2.new(1, 0, 1, 0)
    glassTint.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glassTint.BackgroundTransparency = 0.45 
    glassTint.BorderSizePixel = 0
    glassTint.Parent = gradientFrame

    -- 🖥️ TOP WINDOW PANEL (Mac Style OS Management)
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 46)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainFrame
    self.TopBar = topBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.4, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 24, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🔮 " .. titleText
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    -- 🛠️ WINDOW CONTROLS (Red & Yellow Buttons)
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 60, 1, 0)
    controls.Position = UDim2.new(1, -84, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = topBar

    local controlLayout = Instance.new("UIListLayout")
    controlLayout.FillDirection = Enum.FillDirection.Horizontal
    controlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlLayout.Padding = UDim.new(0, 10)
    controlLayout.Parent = controls

    local miniBtn = Instance.new("TextButton")
    miniBtn.Size = UDim2.new(0, 14, 0, 14)
    miniBtn.BackgroundColor3 = Color3.fromRGB(255, 190, 60) -- Yellow Minimize Button
    miniBtn.Text = ""
    miniBtn.BorderSizePixel = 0
    miniBtn.Parent = controls
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 14, 0, 14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 90) -- Red Close Button
    closeBtn.Text = ""
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = controls
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

    -- Toggle Window System Function
    local function setWindowVisible(state)
        self.IsMinimized = not state
        mainFrame.Visible = state
        restoreBtn.Visible = not state
    end

    closeBtn.MouseButton1Click:Connect(function()
        local t = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1})
        t:Play() t.Completed:Connect(function() screenGui:Destroy() end)
    end)

    miniBtn.MouseButton1Click:Connect(function()
        setWindowVisible(false)
    end)

    restoreBtn.MouseButton1Click:Connect(function()
        setWindowVisible(true)
    end)

    -- Desktop Keybind Engine ('P')
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.P then
            setWindowVisible(self.IsMinimized)
        end
    end)

    -- Clean Rounded Sidebar Left Frame
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 190, 1, -66)
    sidebar.Position = UDim2.new(0, 12, 0, 54)
    sidebar.BackgroundColor3 = self.Theme.Sidebar
    sidebar.BackgroundTransparency = 0.25
    sidebar.Parent = mainFrame
    self.Sidebar = sidebar
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 18)

    -- 🔍 GLOBAL REAL-TIME SEARCH BAR ENGINE
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.new(0, 166, 0, 34)
    searchFrame.Position = UDim2.new(0, 12, 0, 12)
    searchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    searchFrame.Parent = sidebar
    Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", searchFrame).Color = Color3.fromRGB(230, 235, 250)

    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Size = UDim2.new(0, 14, 0, 14)
    searchIcon.Position = UDim2.new(0, 10, 0.5, -7)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = Icons.search
    searchIcon.ImageColor3 = self.Theme.MutedText
    searchIcon.Parent = searchFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -34, 1, 0)
    searchBox.Position = UDim2.new(0, 30, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.PlaceholderText = "Search features..."
    searchBox.Text = ""
    searchBox.TextColor3 = self.Theme.Text
    searchBox.PlaceholderColor3 = self.Theme.MutedText
    searchBox.Font = self.Theme.Font
    searchBox.TextSize = 12
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchFrame

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.Parent = sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 56) -- Space below search box
    sidebarPadding.Parent = sidebar

    -- Content Frame Panel
    local mainDisplay = Instance.new("Frame")
    mainDisplay.Size = UDim2.new(1, -226, 1, -66)
    mainDisplay.Position = UDim2.new(0, 214, 0, 54)
    mainDisplay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainDisplay.BackgroundTransparency = 0.3
    mainDisplay.Parent = mainFrame
    Instance.new("UICorner", mainDisplay).CornerRadius = UDim.new(0, 18)
    
    self.Pages = Instance.new("Folder")
    self.Pages.Parent = mainDisplay

    self:EnableDragging()

    -- Real-time Filtering Engine Callback logic
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(searchBox.Text)
        for _, item in pairs(self.Elements) do
            if query == "" then
                item.Instance.Visible = true
            else
                local match = string.find(string.lower(item.Name), query)
                item.Instance.Visible = (match ~= nil)
                -- Automatically jump open to tab containing match if found
                if match and item.TabButton then
                    item.TabButton:FireClick()
                end
            end
        end
    end)

    -- Mandatory Settings Generator
    task.spawn(function()
        local Settings = self:CreateTab("Settings", "settings")
        Settings:CreateDropdown({
            Name = "UI DPI Scaling",
            Options = {"100%", "125%", "150%"},
            Default = "100%"
        }, function(selected)
            if selected == "100%" then uiScale.Scale = 1.0
            elseif selected == "125%" then uiScale.Scale = 1.25
            elseif selected == "150%" then uiScale.Scale = 1.5
            end
        end)
    end)

    return self
end

function Lucidity:EnableDragging()
    local dragHandle = self.TopBar
    local gui = self.MainFrame
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local scaleModifier = self.UIScale.Scale
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (delta.X / scaleModifier), startPos.Y.Scale, startPos.Y.Offset + (delta.Y / scaleModifier))
        end
    end)
end

function Lucidity:CreateTab(tabName, iconName)
    local theme = self.Theme
    
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 166, 0, 36)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = ""
    tabButton.BorderSizePixel = 0
    tabButton.Parent = self.Sidebar
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 10)

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.Parent = tabButton
    Instance.new("UIPadding", tabButton).PaddingLeft = UDim.new(0, 12)

    if iconName and Icons[string.lower(iconName)] then
        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.Size = UDim2.new(0, 16, 0, 16)
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
    pageContainer.Size = UDim2.new(1, -20, 1, -20)
    pageContainer.Position = UDim2.new(0, 10, 0, 10)
    pageContainer.BackgroundTransparency = 1
    pageContainer.Visible = false
    pageContainer.ScrollBarThickness = 2
    pageContainer.ScrollBarImageColor3 = theme.Accent
    pageContainer.Parent = self.Pages

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.Parent = pageContainer
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pageContainer.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
    end)

    local function activateTab()
        for _, page in pairs(self.Pages:GetChildren()) do page.Visible = false end
        for _, btn in pairs(self.Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                if btn:FindFirstChild("TabText") then btn.TabText.TextColor3 = theme.MutedText end
                if btn:FindFirstChild("Icon") then btn.Icon.ImageColor3 = theme.MutedText end
            end
        end
        pageContainer.Visible = true
        TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
        textLabel.TextColor3 = theme.Text
        if tabButton:FindFirstChild("Icon") then tabButton.Icon.ImageColor3 = theme.Accent end
    end

    tabButton.MouseButton1Click:Connect(activateTab)
    
    local tabObject = { FireClick = activateTab }
    local windowSelf = self

    function tabObject:CreateSection(sectionText)
        local sLabel = Instance.new("TextLabel")
        sLabel.Size = UDim2.new(1, 0, 0, 24)
        sLabel.BackgroundTransparency = 1
        sLabel.Text = string.upper(sectionText)
        sLabel.TextColor3 = theme.Accent
        sLabel.Font = Enum.Font.GothamBold
        sLabel.TextSize = 11
        sLabel.TextXAlignment = Enum.TextXAlignment.Left
        sLabel.Parent = pageContainer
    end

    function tabObject:CreateButton(config, callback)
        local btnText = config.Name or "Button"
        local callback = callback or function() end

        local btnFrame = Instance.new("TextButton")
        btnFrame.Size = UDim2.new(1, 0, 0, 42)
        btnFrame.BackgroundColor3 = theme.CardBackground
        btnFrame.Text = ""
        btnFrame.Parent = pageContainer
        Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 10)
        Instance.new("UIStroke", btnFrame).Color = Color3.fromRGB(235, 240, 250)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -20, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = btnText
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = btnFrame

        btnFrame.MouseButton1Click:Connect(function()
            TweenService:Create(btnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(240, 245, 255)}):Play()
            task.wait(0.1)
            TweenService:Create(btnFrame, TweenInfo.new(0.1), {BackgroundColor3 = theme.CardBackground}):Play()
            task.spawn(callback)
        end)

        -- Add to indexing global registry for searching
        table.insert(windowSelf.Elements, {Name = btnText, Instance = btnFrame, TabButton = tabObject})
    end

    function tabObject:CreateDropdown(config, callback)
        local dropName = config.Name or "Dropdown"
        local options = config.Options or {}
        local default = config.Default or options[1]
        local callback = callback or function() end
        local open = false

        local dropFrame = Instance.new("Frame")
        dropFrame.Size = UDim2.new(1, 0, 0, 42)
        dropFrame.BackgroundColor3 = theme.CardBackground
        dropFrame.ClipsDescendants = true
        dropFrame.Parent = pageContainer
        Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 10)
        Instance.new("UIStroke", dropFrame).Color = Color3.fromRGB(235, 240, 250)

        local trigger = Instance.new("TextButton")
        trigger.Size = UDim2.new(1, 0, 0, 42)
        trigger.BackgroundTransparency = 1
        trigger.Text = ""
        trigger.Parent = dropFrame

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.5, 0, 0, 42)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = dropName
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = dropFrame

        local selLbl = Instance.new("TextLabel")
        selLbl.Size = UDim2.new(0.5, -30, 0, 42)
        selLbl.Position = UDim2.new(0.5, 0, 0, 0)
        selLbl.BackgroundTransparency = 1
        selLbl.Text = default
        selLbl.TextColor3 = theme.Accent
        selLbl.Font = theme.Font
        selLbl.TextSize = 13
        selLbl.TextXAlignment = Enum.TextXAlignment.Right
        selLbl.Parent = dropFrame

        local listHolder = Instance.new("Frame")
        listHolder.Size = UDim2.new(1, -20, 0, #options * 30)
        listHolder.Position = UDim2.new(0, 10, 0, 42)
        listHolder.BackgroundTransparency = 1
        listHolder.Parent = dropFrame
        Instance.new("UIListLayout", listHolder).Padding = UDim.new(0, 4)

        for _, opt in pairs(options) do
            local oBtn = Instance.new("TextButton")
            oBtn.Size = UDim2.new(1, 0, 0, 26)
            oBtn.BackgroundColor3 = Color3.fromRGB(245, 247, 255)
            oBtn.Text = opt
            oBtn.TextColor3 = theme.Text
            oBtn.Font = theme.Font
            oBtn.TextSize = 12
            oBtn.Parent = listHolder
            Instance.new("UICorner", oBtn).CornerRadius = UDim.new(0, 6)

            oBtn.MouseButton1Click:Connect(function()
                selLbl.Text = opt open = false
                TweenService:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 42)}):Play()
                task.spawn(callback, opt)
            end)
        end

        trigger.MouseButton1Click:Connect(function()
            open = not open
            local th = open and (42 + (#options * 30) + 10) or 42
            TweenService:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, th)}):Play()
        end)

        table.insert(windowSelf.Elements, {Name = dropName, Instance = dropFrame, TabButton = tabObject})
    end

    return tabObject
end

return Lucidity
