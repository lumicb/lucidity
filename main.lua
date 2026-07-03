local Lucidity = {}
Lucidity.__index = Lucidity

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

Lucidity.Theme = {
    WindowBg = Color3.fromRGB(18, 19, 22),
    Sidebar = Color3.fromRGB(24, 25, 30),
    CardBackground = Color3.fromRGB(30, 31, 38),
    Border = Color3.fromRGB(42, 44, 54),
    Text = Color3.fromRGB(242, 244, 247),
    MutedText = Color3.fromRGB(138, 143, 154),
    Active = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamMedium
}

local Icons = {
    home = "rbxassetid://10734951102",
    settings = "rbxassetid://10734950309",
    combat = "rbxassetid://10747360634",
    search = "rbxassetid://10734950791",
    window = "rbxassetid://10723343385",
    chevron = "rbxassetid://10734896828",
    eye = "rbxassetid://10723345453"
}

function Lucidity:Notify(config)
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 3
    
    if not self.NotifContainer then
        local notifContainer = Instance.new("Frame")
        notifContainer.Name = "LucidityNotifications"
        notifContainer.Size = UDim2.new(0, 280, 1, -40)
        notifContainer.Position = UDim2.new(1, -300, 0, 20)
        notifContainer.BackgroundTransparency = 1
        notifContainer.Parent = self.ScreenGui
        
        local layout = Instance.new("UIListLayout")
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Padding = UDim.new(0, 10)
        layout.Parent = notifContainer
        self.NotifContainer = notifContainer
    end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.BackgroundColor3 = self.Theme.CardBackground
    card.ClipsDescendants = true
    card.Parent = self.NotifContainer
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = self.Theme.Border

    local lblTitle = Instance.new("TextLabel")
    lblTitle.Size = UDim2.new(1, -24, 0, 24)
    lblTitle.Position = UDim2.new(0, 12, 0, 6)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = title
    lblTitle.TextColor3 = self.Theme.Text
    lblTitle.Font = Enum.Font.GothamBold
    lblTitle.TextSize = 13
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left
    lblTitle.Parent = card

    local lblContent = Instance.new("TextLabel")
    lblContent.Size = UDim2.new(1, -24, 1, -36)
    lblContent.Position = UDim2.new(0, 12, 0, 30)
    lblContent.BackgroundTransparency = 1
    lblContent.Text = content
    lblContent.TextColor3 = self.Theme.MutedText
    lblContent.Font = self.Theme.Font
    lblContent.TextSize = 11
    lblContent.TextWrapped = true
    lblContent.TextXAlignment = Enum.TextXAlignment.Left
    lblContent.TextYAlignment = Enum.TextYAlignment.Top
    lblContent.Parent = card

    TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 75)}):Play()
    
    task.delay(duration, function()
        if card and card.Parent then
            local t = TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
            t:Play()
            t.Completed:Connect(function() card:Destroy() end)
        end
    end)
end

function Lucidity:CreateWindow(config)
    local config = config or {}
    local windowName = config.Name or "Lucidity Hub"
    local hasKeySystem = config.KeySystem or false
    local validKey = config.Key or ""
    self.ConfigName = config.ConfigName or "LucidityConfig.json"
    
    local self = setmetatable({}, Lucidity)
    self.Elements = {}
    self.ConfigData = {}
    self.TabCount = 0
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Lucidity_" .. HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = screenGui

    if hasKeySystem then
        local keyWindow = Instance.new("Frame")
        keyWindow.Size = UDim2.new(0, 340, 0, 180)
        keyWindow.Position = UDim2.new(0.5, -170, 0.5, -90)
        keyWindow.BackgroundColor3 = self.Theme.WindowBg
        keyWindow.Parent = screenGui
        Instance.new("UICorner", keyWindow).CornerRadius = UDim.new(0, 12)
        Instance.new("UIStroke", keyWindow).Color = self.Theme.Border

        local kTitle = Instance.new("TextLabel")
        kTitle.Size = UDim2.new(1, 0, 0, 45)
        kTitle.BackgroundTransparency = 1
        kTitle.Text = "Key Validation Required"
        kTitle.TextColor3 = self.Theme.Text
        kTitle.Font = Enum.Font.GothamBold
        kTitle.TextSize = 13
        kTitle.Parent = keyWindow

        local kInput = Instance.new("TextBox")
        kInput.Size = UDim2.new(1, -40, 0, 36)
        kInput.Position = UDim2.new(0, 20, 0, 55)
        kInput.BackgroundColor3 = self.Theme.CardBackground
        kInput.PlaceholderText = "Enter key..."
        kInput.Text = ""
        kInput.TextColor3 = self.Theme.Text
        kInput.PlaceholderColor3 = self.Theme.MutedText
        kInput.Font = self.Theme.Font
        kInput.TextSize = 12
        kInput.Parent = keyWindow
        Instance.new("UICorner", kInput).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", kInput).Color = self.Theme.Border

        local kSubmit = Instance.new("TextButton")
        kSubmit.Size = UDim2.new(1, -40, 0, 36)
        kSubmit.Position = UDim2.new(0, 20, 0, 110)
        kSubmit.BackgroundColor3 = self.Theme.Active
        kSubmit.Text = "Verify Access"
        kSubmit.TextColor3 = self.Theme.WindowBg
        kSubmit.Font = Enum.Font.GothamBold
        kSubmit.TextSize = 13
        kSubmit.Parent = keyWindow
        Instance.new("UICorner", kSubmit).CornerRadius = UDim.new(0, 6)

        kSubmit.MouseButton1Click:Connect(function()
            if kInput.Text == validKey then
                keyWindow:Destroy()
                self:BuildMainInterface(windowName)
                self:Notify({Title = "Authorized", Content = "Welcome back to Lucidity.", Duration = 3})
            else
                kInput.Text = ""
                kInput.PlaceholderText = "Incorrect key payload. Re-verify."
            end
        end)
        return self
    else
        self:BuildMainInterface(windowName)
        return self
    end
end

function Lucidity:BuildMainInterface(windowName)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 680, 0, 460)
    mainFrame.Position = UDim2.new(0.5, -340, 0.5, -230)
    mainFrame.BackgroundColor3 = self.Theme.WindowBg
    mainFrame.Parent = self.ScreenGui
    self.MainFrame = mainFrame
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
    
    local uiScale = Instance.new("UIScale")
    uiScale.Parent = mainFrame
    self.UIScale = uiScale
    Instance.new("UIStroke", mainFrame).Color = self.Theme.Border

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 50)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainFrame
    self.TopBar = topBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = windowName
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -40, 0.5, -14)
    closeBtn.BackgroundColor3 = self.Theme.CardBackground
    closeBtn.Text = "×" 
    closeBtn.TextColor3 = self.Theme.MutedText
    closeBtn.Font = Enum.Font.GothamMedium
    closeBtn.TextSize = 18
    closeBtn.Parent = topBar
    
    local closeCorner = Instance.new("UICorner", closeBtn)
    closeCorner.CornerRadius = UDim.new(0, 6)
    local closeStroke = Instance.new("UIStroke", closeBtn)
    closeStroke.Color = self.Theme.Border

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.1), {
            TextColor3 = Color3.fromRGB(239, 68, 68),
            BackgroundColor3 = self.Theme.Border
        }):Play()
    end)

    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.1), {
            TextColor3 = self.Theme.MutedText,
            BackgroundColor3 = self.Theme.CardBackground
        }):Play()
    end)

    closeBtn.MouseButton1Click:Connect(function()
        local fadeTween = TweenService:Create(mainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 650, 0, 430),
            BackgroundTransparency = 1
        })
        fadeTween:Play()
        fadeTween.Completed:Connect(function()
            self.ScreenGui:Destroy()
        end)
    end)

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 180, 1, -66)
    sidebar.Position = UDim2.new(0, 12, 0, 54)
    sidebar.BackgroundColor3 = self.Theme.Sidebar
    sidebar.Parent = mainFrame
    self.Sidebar = sidebar
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", sidebar).Color = self.Theme.Border

    local sLayout = Instance.new("UIListLayout")
    sLayout.Padding = UDim.new(0, 4)
    sLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sLayout.Parent = sidebar
    Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 12)

    local mainDisplay = Instance.new("Frame")
    mainDisplay.Size = UDim2.new(1, -216, 1, -66)
    mainDisplay.Position = UDim2.new(0, 204, 0, 54)
    mainDisplay.BackgroundColor3 = self.Theme.Sidebar
    mainDisplay.Parent = mainFrame
    Instance.new("UICorner", mainDisplay).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", mainDisplay).Color = self.Theme.Border

    self.Pages = Instance.new("Folder", mainDisplay)
    self:EnableDragging()
    self:LoadSettingsEngine()
    
    local Settings = self:CreateTab("Settings", "settings", true)
    Settings:CreateSection("Client Configurations")
    
    Settings:CreateDropdown({
        Name = "Interface UI Scale Profile",
        Options = {"50%", "75%", "100%", "125%", "150%"}
    }, function(selected)
        local cleanPercent = string.gsub(selected, "%%", "")
        local numericScale = tonumber(cleanPercent)
        if numericScale then
            uiScale.Scale = numericScale / 100
        end
    end)

    Settings:CreateDropdown({
        Name = "Interface Theme Palette",
        Options = {"Dark Mode", "Light Mode"}
    }, function(selectedTheme)
        if selectedTheme == "Light Mode" then
            print("Switching engine interface to Light Mode rules...")
        else
            print("Restoring default Dark Mode visual configurations...")
        end
    end)
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

function Lucidity:SaveSettingsEngine()
    if writefile then
        writefile(self.ConfigName, HttpService:JSONEncode(self.ConfigData))
    end
end

function Lucidity:LoadSettingsEngine()
    if readfile and isfile and isfile(self.ConfigName) then
        pcall(function()
            self.ConfigData = HttpService:JSONDecode(readfile(self.ConfigName))
        end)
    end
end

function Lucidity:CreateTab(tabName, iconName, isSettingsTab)
    local theme = self.Theme
    local windowSelf = self
    
    windowSelf.TabCount = windowSelf.TabCount + 1

    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 160, 0, 36)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = ""
    tabButton.Parent = windowSelf.Sidebar
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)
    
    if isSettingsTab then
        tabButton.LayoutOrder = 9999
    else
        tabButton.LayoutOrder = windowSelf.TabCount
    end

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
    textLabel.TextSize = 12
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = tabButton

    local pageContainer = Instance.new("ScrollingFrame")
    pageContainer.Size = UDim2.new(1, 0, 1, 0)
    pageContainer.BackgroundTransparency = 1
    pageContainer.Visible = false
    pageContainer.ScrollBarThickness = 0
    pageContainer.Parent = windowSelf.Pages

    local pPadding = Instance.new("UIPadding", pageContainer)
    pPadding.PaddingLeft = UDim.new(0, 14)
    pPadding.PaddingRight = UDim.new(0, 14)
    pPadding.PaddingTop = UDim.new(0, 14)
    pPadding.PaddingBottom = UDim.new(0, 14)

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 7)
    pageLayout.Parent = pageContainer
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pageContainer.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 28)
    end)

    local function activateTab()
        for _, page in pairs(windowSelf.Pages:GetChildren()) do page.Visible = false end
        for _, btn in pairs(tabButton.Parent:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
                if btn:FindFirstChild("TabText") then btn.TabText.TextColor3 = theme.MutedText end
            end
        end
        pageContainer.Visible = true
        TweenService:Create(tabButton, TweenInfo.new(0.12), {BackgroundTransparency = 0, BackgroundColor3 = theme.CardBackground}):Play()
        textLabel.TextColor3 = theme.Text
    end

    tabButton.MouseButton1Click:Connect(activateTab)
    if windowSelf.TabCount == 1 then activateTab() end
    
    local tabObject = {}

    function tabObject:CreateSection(sectionText)
        local sLabel = Instance.new("TextLabel")
        sLabel.Size = UDim2.new(1, 0, 0, 24)
        sLabel.BackgroundTransparency = 1
        sLabel.Text = string.upper(sectionText)
        sLabel.TextColor3 = theme.MutedText
        sLabel.Font = Enum.Font.GothamBold
        sLabel.TextSize = 10
        sLabel.TextXAlignment = Enum.TextXAlignment.Left
        sLabel.Parent = pageContainer
        
        local sPadding = Instance.new("UIPadding", sLabel)
        sPadding.PaddingLeft = UDim.new(0, 4)
    end

    function tabObject:CreateButton(config, callback)
        local btnText = config.Name or "Button Action"
        local callback = callback or function() end

        local btnFrame = Instance.new("TextButton")
        btnFrame.Size = UDim2.new(1, 0, 0, 40)
        btnFrame.BackgroundColor3 = theme.CardBackground
        btnFrame.Text = ""
        btnFrame.Parent = pageContainer
        Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", btnFrame).Color = theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -24, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = btnText
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = btnFrame

        btnFrame.MouseButton1Click:Connect(function()
            TweenService:Create(btnFrame, TweenInfo.new(0.08), {BackgroundColor3 = theme.Border}):Play()
            task.wait(0.08)
            TweenService:Create(btnFrame, TweenInfo.new(0.08), {BackgroundColor3 = theme.CardBackground}):Play()
            task.spawn(callback)
        end)
    end

    function tabObject:CreateToggle(config, callback)
        local toggleName = config.Name or "Toggle Flag"
        local saveName = config.SaveName
        local default = config.Default or false
        local callback = callback or function() end
        
        if saveName and windowSelf.ConfigData[saveName] ~= nil then
            default = windowSelf.ConfigData[saveName]
        end
        local state = default

        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 40)
        toggleFrame.BackgroundColor3 = theme.CardBackground
        toggleFrame.Parent = pageContainer
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", toggleFrame).Color = theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = toggleName
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = toggleFrame

        local switch = Instance.new("TextButton")
        switch.Size = UDim2.new(0, 36, 0, 20)
        switch.Position = UDim2.new(1, -48, 0.5, -10)
        switch.BackgroundColor3 = state and theme.Active or theme.WindowBg
        switch.Text = ""
        switch.Parent = toggleFrame
        Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
        local swStroke = Instance.new("UIStroke", switch)
        swStroke.Color = theme.Border

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.Position = UDim2.new(state and 0.55 or 0.05, 1, 0.5, -7)
        dot.BackgroundColor3 = state and theme.WindowBg or theme.MutedText
        dot.Parent = switch
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local function updateToggle(fireCallback)
            TweenService:Create(switch, TweenInfo.new(0.12), {BackgroundColor3 = state and theme.Active or theme.WindowBg}):Play()
            TweenService:Create(dot, TweenInfo.new(0.12), {Position = UDim2.new(state and 0.52 or 0.05, 1, 0.5, -7), BackgroundColor3 = state and theme.WindowBg or theme.MutedText}):Play()
            if saveName then
                windowSelf.ConfigData[saveName] = state
                windowSelf:SaveSettingsEngine()
            end
            if fireCallback then task.spawn(callback, state) end
        end

        switch.MouseButton1Click:Connect(function()
            state = not state
            updateToggle(true)
        end)
        updateToggle(false)
    end

    function tabObject:CreateSlider(config, callback)
        local sliderName = config.Name or "Slider Metric"
        local min = config.Min or 0
        local max = config.Max or 100
        local default = config.Default or min
        local suffix = config.Suffix or ""
        local saveName = config.SaveName
        local callback = callback or function() end

        if saveName and windowSelf.ConfigData[saveName] ~= nil then
            default = windowSelf.ConfigData[saveName]
        end
        local value = math.clamp(default, min, max)

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.BackgroundColor3 = theme.CardBackground
        sliderFrame.Parent = pageContainer
        Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
        sliderFrame.BorderSizePixel = 0
        local slStroke = Instance.new("UIStroke", sliderFrame)
        slStroke.Color = theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.6, 0, 0, 26)
        lbl.Position = UDim2.new(0, 12, 0, 4)
        lbl.BackgroundTransparency = 1
        lbl.Text = sliderName
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = sliderFrame

        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0.3, 0, 0, 26)
        valLbl.Position = UDim2.new(0.7, -12, 0, 4)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(value) .. suffix
        valLbl.TextColor3 = theme.MutedText
        valLbl.Font = theme.Font
        valLbl.TextSize = 11
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.Parent = sliderFrame

        local track = Instance.new("TextButton")
        track.Size = UDim2.new(1, -24, 0, 5)
        track.Position = UDim2.new(0, 12, 1, -14)
        track.BackgroundColor3 = theme.WindowBg
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
        handle.BackgroundColor3 = theme.Text
        handle.Parent = track
        Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", handle).Color = theme.Border

        local holding = false
        local function updateSlider(input)
            local percentage = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            value = math.round(min + (percentage * (max - min)))
            valLbl.Text = tostring(value) .. suffix
            fill.Size = UDim2.new(percentage, 0, 1, 0)
            handle.Position = UDim2.new(percentage, -6, 0.5, -6)
            if saveName then
                windowSelf.ConfigData[saveName] = value
                windowSelf:SaveSettingsEngine()
            end
            task.spawn(callback, value)
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                holding = true updateSlider(input)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if holding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then holding = false end
        end)
    end

    function tabObject:CreateInput(config, callback)
        local inputName = config.Name or "Text Field Input"
        local placeholder = config.Placeholder or "Type here..."
        local callback = callback or function() end

        local inputFrame = Instance.new("Frame")
        inputFrame.Size = UDim2.new(1, 0, 0, 40)
        inputFrame.BackgroundColor3 = theme.CardBackground
        inputFrame.Parent = pageContainer
        Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", inputFrame).Color = theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = inputName
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = inputFrame

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0, 150, 0, 26)
        box.Position = UDim2.new(1, -162, 0.5, -13)
        box.BackgroundColor3 = theme.WindowBg
        box.Text = ""
        box.PlaceholderText = placeholder
        box.TextColor3 = theme.Text
        box.PlaceholderColor3 = theme.MutedText
        box.Font = theme.Font
        box.TextSize = 11
        box.ClipsDescendants = true
        box.Parent = inputFrame
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
        Instance.new("UIStroke", box).Color = theme.Border

        box.FocusLost:Connect(function(enterPressed)
            task.spawn(callback, box.Text, enterPressed)
        end)
    end

    function tabObject:CreateDropdown(config, callback)
        local dropName = config.Name or "Dropdown Menu"
        local options = config.Options or {}
        local callback = callback or function() end
        local expanded = false

        local dropFrame = Instance.new("Frame")
        dropFrame.Size = UDim2.new(1, 0, 0, 40)
        dropFrame.BackgroundColor3 = theme.CardBackground
        dropFrame.ClipsDescendants = true
        dropFrame.Parent = pageContainer
        Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 8)
        local dropStroke = Instance.new("UIStroke", dropFrame)
        dropStroke.Color = theme.Border

        local headerBtn = Instance.new("TextButton")
        headerBtn.Size = UDim2.new(1, 0, 0, 40)
        headerBtn.BackgroundTransparency = 1
        headerBtn.Text = ""
        headerBtn.Parent = dropFrame

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = dropName
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = headerBtn

        local chev = Instance.new("ImageLabel")
        chev.Size = UDim2.new(0, 14, 0, 14)
        chev.Position = UDim2.new(1, -26, 0.5, -7)
        chev.BackgroundTransparency = 1
        chev.Image = Icons.chevron
        chev.ImageColor3 = theme.MutedText
        chev.Parent = headerBtn

        local listContainer = Instance.new("Frame")
        listContainer.Size = UDim2.new(1, -24, 0, #options * 30)
        listContainer.Position = UDim2.new(0, 12, 0, 40)
        listContainer.BackgroundTransparency = 1
        listContainer.Parent = dropFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 4)
        listLayout.Parent = listContainer

        for _, optName in pairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 26)
            optBtn.BackgroundColor3 = theme.WindowBg
            optBtn.Text = optName
            optBtn.TextColor3 = theme.MutedText
            optBtn.Font = theme.Font
            optBtn.TextSize = 11
            optBtn.Parent = listContainer
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 5)
            Instance.new("UIStroke", optBtn).Color = theme.Border

            optBtn.MouseButton1Click:Connect(function()
                lbl.Text = dropName .. " (" .. optName .. ")"
                expanded = false
                TweenService:Create(dropFrame, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                TweenService:Create(chev, TweenInfo.new(0.15), {Rotation = 0}):Play()
                task.spawn(callback, optName)
            end)
        end

        headerBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            local targetSize = expanded and (46 + (#options * 30)) or 40
            TweenService:Create(dropFrame, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, targetSize)}):Play()
            TweenService:Create(chev, TweenInfo.new(0.15), {Rotation = expanded and 180 or 0}):Play()
        end)
    end

    return tabObject
end

return Lucidity
