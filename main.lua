local Lucidity = {}
Lucidity.__index = Lucidity

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

-- 🔳 PREMIUM MONOCHROME GLASS ARCHITECTURE
Lucidity.Theme = {
    WindowBg = Color3.fromRGB(248, 249, 250),       -- Pure frosted white/gray slate
    Sidebar = Color3.fromRGB(238, 240, 243),        -- Distinct, soft structural gray
    CardBackground = Color3.fromRGB(255, 255, 255), -- Elevated pure white elements
    Border = Color3.fromRGB(220, 224, 230),         -- Precise, razor-thin minimalist borders
    Text = Color3.fromRGB(25, 28, 36),              -- Ultra-deep charcoal for rich contrast
    MutedText = Color3.fromRGB(130, 136, 148),      -- Medium slate gray
    Active = Color3.fromRGB(15, 17, 23),            -- Deep black accents for interaction
    Font = Enum.Font.GothamMedium
}

local Icons = {
    home = "rbxassetid://10734951102",
    settings = "rbxassetid://10734950309",
    combat = "rbxassetid://10747360634",
    search = "rbxassetid://10734950791",
    window = "rbxassetid://10723343385" -- Sleek vector minimalist icon
}

function Lucidity:CreateWindow(config)
    local config = config or {}
    local titleText = config.Name or "Lucidity"
    
    local self = setmetatable({}, Lucidity)
    self.Elements = {}
    self.IsMinimized = false
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Lucidity_" .. titleText
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = screenGui

    -- 🔳 MINIMALIST FLOATING RESTORE ACTION BUTTON
    local restoreBtn = Instance.new("ImageButton")
    restoreBtn.Name = "LucidityRestoreBtn"
    restoreBtn.Size = UDim2.new(0, 44, 0, 44)
    restoreBtn.Position = UDim2.new(0, 24, 0.5, -22)
    restoreBtn.BackgroundColor3 = self.Theme.CardBackground
    restoreBtn.Image = Icons.window
    restoreBtn.ImageColor3 = self.Theme.Text
    restoreBtn.ScaleType = Enum.ScaleType.Fit
    restoreBtn.Visible = false
    restoreBtn.ZIndex = 10
    restoreBtn.Parent = screenGui
    Instance.new("UICorner", restoreBtn).CornerRadius = UDim.new(0, 12)
    local btnStroke = Instance.new("UIStroke", restoreBtn)
    btnStroke.Color = self.Theme.Border
    btnStroke.Thickness = 1.5

    -- Main Architectural Canvas Frame (24px Ultra-Rounding)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 680, 0, 460)
    mainFrame.Position = UDim2.new(0.5, -340, 0.5, -230)
    mainFrame.BackgroundColor3 = self.Theme.WindowBg
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    self.MainFrame = mainFrame
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 24)

    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 1
    uiScale.Parent = mainFrame
    self.UIScale = uiScale

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = self.Theme.Border
    stroke.Parent = mainFrame

    -- 🖥️ SLICK TOP HEADLINE BAR
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 50)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainFrame
    self.TopBar = topBar

    local titleIcon = Instance.new("ImageLabel")
    titleIcon.Size = UDim2.new(0, 16, 0, 16)
    titleIcon.Position = UDim2.new(0, 24, 0.5, -8)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Image = Icons.window
    titleIcon.ImageColor3 = self.Theme.Text
    titleIcon.Parent = topBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.4, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 48, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleText
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    -- Minimalist Utility Windows Controls
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 60, 1, 0)
    controls.Position = UDim2.new(1, -84, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = topBar

    local controlLayout = Instance.new("UIListLayout")
    controlLayout.FillDirection = Enum.FillDirection.Horizontal
    controlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlLayout.Padding = UDim.new(0, 12)
    controlLayout.Parent = controls

    local miniBtn = Instance.new("TextButton")
    miniBtn.Size = UDim2.new(0, 12, 0, 12)
    miniBtn.BackgroundColor3 = Color3.fromRGB(200, 202, 205) -- Sleek matte gray minimize
    miniBtn.Text = ""
    miniBtn.BorderSizePixel = 0
    miniBtn.Parent = controls
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 12, 0, 12)
    closeBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 45) -- High contrast charcoal close
    closeBtn.Text = ""
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = controls
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

    local function setWindowVisible(state)
        self.IsMinimized = not state
        mainFrame.Visible = state
        restoreBtn.Visible = not state
    end

    closeBtn.MouseButton1Click:Connect(function()
        local t = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1})
        t:Play() t.Completed:Connect(function() screenGui:Destroy() end)
    end)

    miniBtn.MouseButton1Click:Connect(function() setWindowVisible(false) end)
    restoreBtn.MouseButton1Click:Connect(function() setWindowVisible(true) end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.P then
            setWindowVisible(self.IsMinimized)
        end
    end)

    -- Brushed Sidebar Layout Panel
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 190, 1, -66)
    sidebar.Position = UDim2.new(0, 12, 0, 54)
    sidebar.BackgroundColor3 = self.Theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    self.Sidebar = sidebar
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 16)
    Instance.new("UIStroke", sidebar).Color = self.Theme.Border

    -- Minimalist Pure-White Search Interface
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.new(0, 166, 0, 34)
    searchFrame.Position = UDim2.new(0, 12, 0, 12)
    searchFrame.BackgroundColor3 = self.Theme.CardBackground
    searchFrame.Parent = sidebar
    Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", searchFrame).Color = self.Theme.Border

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
    searchBox.PlaceholderText = "Search..."
    searchBox.Text = ""
    searchBox.TextColor3 = self.Theme.Text
    searchBox.PlaceholderColor3 = self.Theme.MutedText
    searchBox.Font = self.Theme.Font
    searchBox.TextSize = 12
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchFrame

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 4)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.Parent = sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 56)
    sidebarPadding.Parent = sidebar

    -- Right Content Dashboard Canvas Panel
    local mainDisplay = Instance.new("Frame")
    mainDisplay.Size = UDim2.new(1, -226, 1, -66)
    mainDisplay.Position = UDim2.new(0, 214, 0, 54)
    mainDisplay.BackgroundColor3 = self.Theme.CardBackground
    mainDisplay.Parent = mainFrame
    Instance.new("UICorner", mainDisplay).CornerRadius = UDim.new(0, 16)
    Instance.new("UIStroke", mainDisplay).Color = self.Theme.Border
    
    self.Pages = Instance.new("Folder")
    self.Pages.Parent = mainDisplay

    self:EnableDragging()

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(searchBox.Text)
        for _, item in pairs(self.Elements) do
            if query == "" then
                item.Instance.Visible = true
            else
                local match = string.find(string.lower(item.Name), query)
                item.Instance.Visible = (match ~= nil)
                if match and item.TabButton then item.TabButton:FireClick() end
            end
        end
    end)

    -- ⚙️ CONFIG DROPDOWN REPLENTISHED TO SLIDER STATS (Locked 50% - 200%)
    task.spawn(function()
        local Settings = self:CreateTab("Settings", "settings")
        Settings:CreateSection("Client Adjustments")
        
        Settings:CreateSlider({
            Name = "DPI Scaling Profile",
            Min = 50,
            Max = 200,
            Default = 100,
            Suffix = "%"
        }, function(value)
            uiScale.Scale = value / 100
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
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)

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
    pageContainer.Size = UDim2.new(1, -24, 1, -24)
    pageContainer.Position = UDim2.new(0, 12, 0, 12)
    pageContainer.BackgroundTransparency = 1
    pageContainer.Visible = false
    pageContainer.ScrollBarThickness = 0
    pageContainer.Parent = self.Pages

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.Parent = pageContainer
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pageContainer.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
    end)

    local function activateTab()
        for _, page in pairs(self.Pages:GetChildren()) do page.Visible = false end
        for _, btn in pairs(self.Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
                if btn:FindFirstChild("TabText") then btn.TabText.TextColor3 = theme.MutedText end
                if btn:FindFirstChild("Icon") then btn.Icon.ImageColor3 = theme.MutedText end
            end
        end
        pageContainer.Visible = true
        TweenService:Create(tabButton, TweenInfo.new(0.15), {BackgroundTransparency = 0, BackgroundColor3 = theme.CardBackground}):Play()
        textLabel.TextColor3 = theme.Text
        if tabButton:FindFirstChild("Icon") then tabButton.Icon.ImageColor3 = theme.Active end
    end

    tabButton.MouseButton1Click:Connect(activateTab)
    
    local tabObject = { FireClick = activateTab }
    local windowSelf = self

    function tabObject:CreateSection(sectionText)
        local sLabel = Instance.new("TextLabel")
        sLabel.Size = UDim2.new(1, 0, 0, 20)
        sLabel.BackgroundTransparency = 1
        sLabel.Text = string.upper(sectionText)
        sLabel.TextColor3 = theme.Text
        sLabel.Font = Enum.Font.GothamBold
        sLabel.TextSize = 11
        sLabel.TextXAlignment = Enum.TextXAlignment.Left
        sLabel.Parent = pageContainer
    end

    function tabObject:CreateButton(config, callback)
        local btnText = config.Name or "Button"
        local callback = callback or function() end

        local btnFrame = Instance.new("TextButton")
        btnFrame.Size = UDim2.new(1, 0, 0, 40)
        btnFrame.BackgroundColor3 = theme.Sidebar
        btnFrame.Text = ""
        btnFrame.Parent = pageContainer
        Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", btnFrame).Color = theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -20, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = btnText
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = btnFrame

        btnFrame.MouseButton1Click:Connect(function()
            TweenService:Create(btnFrame, TweenInfo.new(0.08), {BackgroundColor3 = theme.Border}):Play()
            task.wait(0.08)
            TweenService:Create(btnFrame, TweenInfo.new(0.08), {BackgroundColor3 = theme.Sidebar}):Play()
            task.spawn(callback)
        end)

        table.insert(windowSelf.Elements, {Name = btnText, Instance = btnFrame, TabButton = tabObject})
    end

    -- 🔳 NEW MONOCHROME TOGGLE COMPONENT
    function tabObject:CreateToggle(config, callback)
        local toggleName = config.Name or "Toggle Switch"
        local default = config.Default or false
        local callback = callback or function() end
        local state = default

        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 40)
        toggleFrame.BackgroundColor3 = theme.Sidebar
        toggleFrame.Parent = pageContainer
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", toggleFrame).Color = theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = toggleName
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = toggleFrame

        local switch = Instance.new("TextButton")
        switch.Size = UDim2.new(0, 36, 0, 20)
        switch.Position = UDim2.new(1, -50, 0.5, -10)
        switch.BackgroundColor3 = state and theme.Active or Color3.fromRGB(200, 204, 210)
        switch.Text = ""
        switch.Parent = toggleFrame
        Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

        local sliderDot = Instance.new("Frame")
        sliderDot.Size = UDim2.new(0, 14, 0, 14)
        sliderDot.Position = UDim2.new(state and 0.55 or 0.05, 2, 0.5, -7)
        sliderDot.BackgroundColor3 = theme.CardBackground
        sliderDot.Parent = switch
        Instance.new("UICorner", sliderDot).CornerRadius = UDim.new(1, 0)

        switch.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = state and theme.Active or Color3.fromRGB(200, 204, 210)}):Play()
            TweenService:Create(sliderDot, TweenInfo.new(0.15), {Position = UDim2.new(state and 0.55 or 0.05, 2, 0.5, -7)}):Play()
            task.spawn(callback, state)
        end)

        table.insert(windowSelf.Elements, {Name = toggleName, Instance = toggleFrame, TabButton = tabObject})
    end

    -- 🔳 NEW MATTE SMOOTH SLIDER COMPONENT
    function tabObject:CreateSlider(config, callback)
        local sliderName = config.Name or "Slider Adjust"
        local min = config.Min or 0
        local max = config.Max or 100
        local default = config.Default or min
        local suffix = config.Suffix or ""
        local callback = callback or function() end
        
        local value = math.clamp(default, min, max)

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.BackgroundColor3 = theme.Sidebar
        sliderFrame.Parent = pageContainer
        Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", sliderFrame).Color = theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.6, 0, 0, 26)
        lbl.Position = UDim2.new(0, 14, 0, 2)
        lbl.BackgroundTransparency = 1
        lbl.Text = sliderName
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = sliderFrame

        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0.3, 0, 0, 26)
        valLbl.Position = UDim2.new(0.7, -14, 0, 2)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(value) .. suffix
        valLbl.TextColor3 = theme.MutedText
        valLbl.Font = theme.Font
        valLbl.TextSize = 12
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.Parent = sliderFrame

        local track = Instance.new("TextButton")
        track.Size = UDim2.new(1, -28, 0, 6)
        track.Position = UDim2.new(0, 14, 1, -16)
        track.BackgroundColor3 = Color3.fromRGB(215, 219, 225)
        track.Text = ""
        track.Parent = sliderFrame
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = theme.Active
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local handle = Instance.new("Frame")
        handle.Size = UDim2.new(0, 12, 0, 12)
        handle.Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6)
        handle.BackgroundColor3 = theme.CardBackground
        handle.Parent = track
        Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", handle).Color = theme.Active

        local holding = false

        local function updateSlider(input)
            local percentage = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            value = math.round(min + (percentage * (max - min)))
            valLbl.Text = tostring(value) .. suffix
            fill.Size = UDim2.new(percentage, 0, 1, 0)
            handle.Position = UDim2.new(percentage, -6, 0.5, -6)
            task.spawn(callback, value)
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                holding = true updateSlider(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if holding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                holding = false
            end
        end)

        table.insert(windowSelf.Elements, {Name = sliderName, Instance = sliderFrame, TabButton = tabObject})
    end

    return tabObject
end

return Lucidity
