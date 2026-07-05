local Lucidity = {}
Lucidity.__index = Lucidity

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
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

local LightPalette = {
    WindowBg = Color3.fromRGB(240, 242, 245),
    Sidebar = Color3.fromRGB(225, 228, 232),
    CardBackground = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(200, 205, 212),
    Text = Color3.fromRGB(20, 21, 24),
    MutedText = Color3.fromRGB(100, 105, 115),
    Active = Color3.fromRGB(0, 0, 0)
}

local DarkPalette = {
    WindowBg = Color3.fromRGB(18, 19, 22),
    Sidebar = Color3.fromRGB(24, 25, 30),
    CardBackground = Color3.fromRGB(30, 31, 38),
    Border = Color3.fromRGB(42, 44, 54),
    Text = Color3.fromRGB(242, 244, 247),
    MutedText = Color3.fromRGB(138, 143, 154),
    Active = Color3.fromRGB(255, 255, 255)
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
    
    if not self.ScreenGui then return end
    
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
    local cStroke = Instance.new("UIStroke", card)
    cStroke.Color = self.Theme.Border

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
    
    local instance = setmetatable({}, Lucidity)
    instance.ConfigName = config.ConfigName or "LucidityConfig.json"
    instance.Elements = {}
    instance.ConfigData = {}
    instance.TabCount = 0
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Lucidity_" .. HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    instance.ScreenGui = screenGui

    if hasKeySystem then
        local keyWindow = Instance.new("Frame")
        keyWindow.Size = UDim2.new(0, 340, 0, 180)
        keyWindow.Position = UDim2.new(0.5, -170, 0.5, -90)
        keyWindow.BackgroundColor3 = instance.Theme.WindowBg
        keyWindow.Parent = screenGui
        Instance.new("UICorner", keyWindow).CornerRadius = UDim.new(0, 12)
        Instance.new("UIStroke", keyWindow).Color = instance.Theme.Border

        local kTitle = Instance.new("TextLabel")
        kTitle.Size = UDim2.new(1, 0, 0, 45)
        kTitle.BackgroundTransparency = 1
        kTitle.Text = "Key Validation Required"
        kTitle.TextColor3 = instance.Theme.Text
        kTitle.Font = Enum.Font.GothamBold
        kTitle.TextSize = 13
        kTitle.Parent = keyWindow

        local kInput = Instance.new("TextBox")
        kInput.Size = UDim2.new(1, -40, 0, 36)
        kInput.Position = UDim2.new(0, 20, 0, 55)
        kInput.BackgroundColor3 = instance.Theme.CardBackground
        kInput.PlaceholderText = "Enter key..."
        kInput.Text = ""
        kInput.TextColor3 = instance.Theme.Text
        kInput.PlaceholderColor3 = instance.Theme.MutedText
        kInput.Font = instance.Theme.Font
        kInput.TextSize = 12
        kInput.Parent = keyWindow
        Instance.new("UICorner", kInput).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", kInput).Color = instance.Theme.Border

        local kSubmit = Instance.new("TextButton")
        kSubmit.Size = UDim2.new(1, -40, 0, 36)
        kSubmit.Position = UDim2.new(0, 20, 0, 110)
        kSubmit.BackgroundColor3 = instance.Theme.Active
        kSubmit.Text = "Verify Access"
        kSubmit.TextColor3 = instance.Theme.WindowBg
        kSubmit.Font = Enum.Font.GothamBold
        kSubmit.TextSize = 13
        kSubmit.Parent = keyWindow
        Instance.new("UICorner", kSubmit).CornerRadius = UDim.new(0, 6)

        kSubmit.MouseButton1Click:Connect(function()
            if kInput.Text == validKey then
                keyWindow:Destroy()
                instance:BuildMainInterface(windowName)
                instance:Notify({Title = "Authorized", Content = "Welcome back to Lucidity.", Duration = 3})
            else
                kInput.Text = ""
                kInput.PlaceholderText = "Incorrect key payload. Re-verify."
            end
        end)
        return instance
    else
        instance:BuildMainInterface(windowName)
        return instance
    end
end

function Lucidity:UpdateThemeDisplay(newPalette)
    self.Theme = newPalette
    self.MainFrame.BackgroundColor3 = newPalette.WindowBg
    self.MainFrame.UIStroke.Color = newPalette.Border

    if self.TitleLabel then
        self.TitleLabel.TextColor3 = newPalette.Text
    end

    if self.Sidebar then
        self.Sidebar.BackgroundColor3 = newPalette.Sidebar
        self.Sidebar.UIStroke.Color = newPalette.Border
    end

    if self.MainDisplay then
        self.MainDisplay.BackgroundColor3 = newPalette.Sidebar
        self.MainDisplay.UIStroke.Color = newPalette.Border
    end

    for _, v in pairs(self.ScreenGui:GetDescendants()) do
        if v:IsA("Frame") or v:IsA("TextButton") or v:IsA("TextBox") or v:IsA("ScrollingFrame") then
            if v.Name == "MainFrame" or v.Name == "Sidebar" or v.Name == "MainDisplay" then
                if v:IsA("Frame") then
                    if v.Name == "MainDisplay" then
                        v.BackgroundColor3 = newPalette.Sidebar
                    elseif v.Name == "Sidebar" then
                        v.BackgroundColor3 = newPalette.Sidebar
                    else
                        v.BackgroundColor3 = newPalette.WindowBg
                    end
                end
                if v:FindFirstChildOfClass("UIStroke") then v:FindFirstChildOfClass("UIStroke").Color = newPalette.Border end
            elseif v:IsA("TextButton") and v.Parent and v.Parent.Name == "Sidebar" then
                if v.BackgroundTransparency < 1 then v.BackgroundColor3 = newPalette.CardBackground end
                if v:FindFirstChild("TabText") then v.TabText.TextColor3 = (v.BackgroundTransparency < 1) and newPalette.Text or newPalette.MutedText end
                if v:FindFirstChild("Icon") then v.Icon.ImageColor3 = (v.BackgroundTransparency < 1) and newPalette.Text or newPalette.MutedText end
            elseif v:IsA("UIStroke") then
                v.Color = newPalette.Border
            elseif v:IsA("TextLabel") then
                if v.Name == "SectionHeader" then v.TextColor3 = newPalette.MutedText else v.TextColor3 = newPalette.Text end
            elseif v:IsA("TextBox") or v.Name == "ToggleSwitch" or v.Name == "SliderTrack" then
                v.BackgroundColor3 = newPalette.WindowBg
            elseif v.Parent and v.Parent:IsA("ScrollingFrame") and (v:IsA("Frame") or v:IsA("TextButton")) and v.Name ~= "ToggleSwitch" and v.Name ~= "SliderTrack" then
                v.BackgroundColor3 = newPalette.CardBackground
            elseif v:IsA("ScrollingFrame") then
                v.BackgroundColor3 = newPalette.WindowBg
            end
        end
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
    local mStroke = Instance.new("UIStroke", mainFrame)
    mStroke.Color = self.Theme.Border

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 50)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainFrame
    self.TopBar = topBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 84, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = windowName
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar
    self.TitleLabel = titleLabel

    local controlBar = Instance.new("Frame")
    controlBar.Name = "WindowControls"
    controlBar.Size = UDim2.new(0, 64, 0, 16)
    controlBar.Position = UDim2.new(0, 16, 0, 17)
    controlBar.BackgroundTransparency = 1
    controlBar.Parent = topBar

    local controlColors = {
        Color3.fromRGB(255, 95, 86),
        Color3.fromRGB(255, 189, 46),
        Color3.fromRGB(39, 201, 63)
    }

    for index, color in ipairs(controlColors) do
        local controlBtn = Instance.new("TextButton")
        controlBtn.Name = index == 1 and "CloseButton" or "WindowControlButton"
        controlBtn.Size = UDim2.new(0, 12, 0, 12)
        controlBtn.Position = UDim2.new(0, (index - 1) * 18, 0, 0)
        controlBtn.BackgroundColor3 = color
        controlBtn.Text = ""
        controlBtn.Parent = controlBar
        Instance.new("UICorner", controlBtn).CornerRadius = UDim2.new(1, 0)
        Instance.new("UIStroke", controlBtn).Color = self.Theme.Border

        if index == 1 then
            controlBtn.MouseEnter:Connect(function()
                TweenService:Create(controlBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(232, 64, 64)}):Play()
            end)
            controlBtn.MouseLeave:Connect(function()
                TweenService:Create(controlBtn, TweenInfo.new(0.1), {BackgroundColor3 = color}):Play()
            end)
            controlBtn.MouseButton1Click:Connect(function()
                local fadeTween = TweenService:Create(mainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 650, 0, 430), BackgroundTransparency = 1})
                fadeTween:Play()
                fadeTween.Completed:Connect(function()
                    self.ScreenGui.Enabled = false
                end)
            end)
        end
    end

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
    mainDisplay.Name = "MainDisplay"
    mainDisplay.Size = UDim2.new(1, -216, 1, -66)
    mainDisplay.Position = UDim2.new(0, 204, 0, 54)
    mainDisplay.BackgroundColor3 = self.Theme.Sidebar
    mainDisplay.Parent = mainFrame
    Instance.new("UICorner", mainDisplay).CornerRadius = UDim2.new(0, 10)
    Instance.new("UIStroke", mainDisplay).Color = self.Theme.Border
    self.MainDisplay = mainDisplay

    self.Pages = Instance.new("Folder", mainDisplay)
    self:EnableDragging()
    self:LoadSettingsEngine()
    
    local Settings = self:CreateTab("Settings", "settings", true)
    
    Settings:CreateButton({Name = "Save Current Configurations"}, function()
        if writefile then
            writefile(self.ConfigName, HttpService:JSONEncode(self.ConfigData))
            self:Notify({Title = "System Engine", Content = "Configuration changes saved successfully.", Duration = 2.5})
        end
    end)

    Settings:CreateSection("Client Configurations")
    
    local antiAfkEnabled = true
    LocalPlayer.Idled:Connect(function()
        if antiAfkEnabled then
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)

    Settings:CreateToggle({
        Name = "Anti-AFK Disconnection Shield",
        SaveName = "AntiAfkProfile",
        Default = true
    }, function(state)
        antiAfkEnabled = state
    end)

    antiAfkEnabled = true

    Settings:CreateDropdown({
        Name = "Interface UI Scale Profile",
        Options = {"50%", "75%", "100%", "125%", "150%"}
    }, function(selected)
        local cleanPercent = string.gsub(selected, "%%", "")
        local numericScale = tonumber(cleanPercent)
        if numericScale then uiScale.Scale = numericScale / 100 end
    end)

    Settings:CreateDropdown({
        Name = "Interface Theme Palette",
        Options = {"Dark Mode", "Light Mode"}
    }, function(selectedTheme)
        if selectedTheme == "Light Mode" then
            self:UpdateThemeDisplay(LightPalette)
        else
            self:UpdateThemeDisplay(DarkPalette)
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
    tabButton.LayoutOrder = isSettingsTab and 9999 or windowSelf.TabCount

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
    pageContainer.BackgroundColor3 = windowSelf.Theme.WindowBg
    pageContainer.BackgroundTransparency = 0
    pageContainer.Visible = false
    pageContainer.ScrollBarThickness = 0
    pageContainer.ClipsDescendants = true
    pageContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pageContainer.Parent = windowSelf.Pages

    local pPadding = Instance.new("UIPadding", pageContainer)
    pPadding.PaddingLeft = UDim.new(0, 14) pPadding.PaddingRight = UDim.new(0, 14)
    pPadding.PaddingTop = UDim.new(0, 14) pPadding.PaddingBottom = UDim.new(0, 14)

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 7)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Parent = pageContainer

    local nextLayoutOrder = 0
    local function getNextLayoutOrder()
        nextLayoutOrder = nextLayoutOrder + 1
        return nextLayoutOrder
    end
    
    local function updateCanvas()
        pageContainer.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 28)
    end
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

    local function activateTab()
        for _, page in pairs(windowSelf.Pages:GetChildren()) do page.Visible = false end
        for _, btn in pairs(tabButton.Parent:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
                if btn:FindFirstChild("TabText") then btn.TabText.TextColor3 = windowSelf.Theme.MutedText end
                if btn:FindFirstChild("Icon") then btn.Icon.ImageColor3 = windowSelf.Theme.MutedText end
            end
        end
        pageContainer.Visible = true
        TweenService:Create(tabButton, TweenInfo.new(0.12), {BackgroundTransparency = 0, BackgroundColor3 = windowSelf.Theme.CardBackground}):Play()
        textLabel.TextColor3 = windowSelf.Theme.Text
        if tabButton:FindFirstChild("Icon") then tabButton.Icon.ImageColor3 = windowSelf.Theme.Text end
        updateCanvas()
    end

    tabButton.MouseButton1Click:Connect(activateTab)
    if windowSelf.TabCount == 1 then activateTab() end
    
    local tabObject = {}

    function tabObject:CreateSection(sectionText)
        local sLabel = Instance.new("TextLabel")
        sLabel.LayoutOrder = getNextLayoutOrder()
        sLabel.Name = "SectionHeader"
        sLabel.Size = UDim2.new(1, 0, 0, 24)
        sLabel.BackgroundTransparency = 1
        sLabel.Text = string.upper(sectionText)
        sLabel.TextColor3 = windowSelf.Theme.MutedText
        sLabel.Font = Enum.Font.GothamBold
        sLabel.TextSize = 10
        sLabel.TextXAlignment = Enum.TextXAlignment.Left
        sLabel.Parent = pageContainer
        Instance.new("UIPadding", sLabel).PaddingLeft = UDim.new(0, 4)
    end

    function tabObject:CreateButton(config, callback)
        local btnText = config.Name or "Button Action"
        local callback = callback or function() end

        local btnFrame = Instance.new("TextButton")
        btnFrame.LayoutOrder = getNextLayoutOrder()
        btnFrame.Size = UDim2.new(1, 0, 0, 40)
        btnFrame.BackgroundColor3 = windowSelf.Theme.CardBackground
        btnFrame.Text = ""
        btnFrame.Parent = pageContainer
        Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", btnFrame).Color = windowSelf.Theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -24, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = btnText
        lbl.TextColor3 = windowSelf.Theme.Text
        lbl.Font = windowSelf.Theme.Font
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = btnFrame

        btnFrame.MouseButton1Click:Connect(function()
            TweenService:Create(btnFrame, TweenInfo.new(0.08), {BackgroundColor3 = windowSelf.Theme.Border}):Play()
            task.wait(0.08)
            TweenService:Create(btnFrame, TweenInfo.new(0.08), {BackgroundColor3 = windowSelf.Theme.CardBackground}):Play()
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
        toggleFrame.LayoutOrder = getNextLayoutOrder()
        toggleFrame.Size = UDim2.new(1, 0, 0, 40)
        toggleFrame.BackgroundColor3 = windowSelf.Theme.CardBackground
        toggleFrame.Parent = pageContainer
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", toggleFrame).Color = windowSelf.Theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = toggleName
        lbl.TextColor3 = windowSelf.Theme.Text
        lbl.Font = windowSelf.Theme.Font
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = toggleFrame

        local switch = Instance.new("TextButton")
        switch.Name = "ToggleSwitch"
        switch.Size = UDim2.new(0, 36, 0, 20)
        switch.Position = UDim2.new(1, -48, 0.5, -10)
        switch.BackgroundColor3 = state and windowSelf.Theme.Active or windowSelf.Theme.WindowBg
        switch.Text = ""
        switch.Parent = toggleFrame
        Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", switch).Color = windowSelf.Theme.Border

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.Position = UDim2.new(state and 1 or 0, state and -16 or 2, 0.5, -7)
        dot.BackgroundColor3 = state and windowSelf.Theme.WindowBg or windowSelf.Theme.MutedText
        dot.Parent = switch
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local function updateToggle(fireCallback)
            local targetPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            TweenService:Create(switch, TweenInfo.new(0.12), {BackgroundColor3 = state and windowSelf.Theme.Active or windowSelf.Theme.WindowBg}):Play()
            TweenService:Create(dot, TweenInfo.new(0.12), {Position = targetPos, BackgroundColor3 = state and windowSelf.Theme.WindowBg or windowSelf.Theme.MutedText}):Play()
            if saveName then
                windowSelf.ConfigData[saveName] = state
            end
            if fireCallback then task.spawn(callback, state) end
        end

        switch.MouseButton1Click:Connect(function()
            state = not state
            updateToggle(true)
        end)
        
        updateToggle(true) -- CRITICAL BUGFIX: Now safely runs callback on load structure
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
        sliderFrame.LayoutOrder = getNextLayoutOrder()
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.BackgroundColor3 = windowSelf.Theme.CardBackground
        sliderFrame.Parent = pageContainer
        Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", sliderFrame).Color = windowSelf.Theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.6, 0, 0, 26)
        lbl.Position = UDim2.new(0, 12, 0, 4)
        lbl.BackgroundTransparency = 1
        lbl.Text = sliderName
        lbl.TextColor3 = windowSelf.Theme.Text
        lbl.Font = windowSelf.Theme.Font
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = sliderFrame

        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0.3, 0, 0, 26)
        valLbl.Position = UDim2.new(0.7, -12, 0, 4)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(value) .. suffix
        valLbl.TextColor3 = windowSelf.Theme.MutedText
        valLbl.Font = windowSelf.Theme.Font
        valLbl.TextSize = 11
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.Parent = sliderFrame

        local track = Instance.new("TextButton")
        track.Name = "SliderTrack"
        track.Size = UDim2.new(1, -24, 0, 5)
        track.Position = UDim2.new(0, 12, 1, -14)
        track.BackgroundColor3 = windowSelf.Theme.WindowBg
        track.Text = ""
        track.Parent = sliderFrame
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = windowSelf.Theme.Active
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local handle = Instance.new("Frame")
        handle.Size = UDim2.new(0, 12, 0, 12)
        handle.Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6)
        handle.BackgroundColor3 = windowSelf.Theme.Text
        handle.Parent = track
        Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", handle).Color = windowSelf.Theme.Border

        local holding = false
        local function updateSlider(input)
            local percentage = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            value = math.round(min + (percentage * (max - min)))
            valLbl.Text = tostring(value) .. suffix
            fill.Size = UDim2.new(percentage, 0, 1, 0)
            handle.Position = UDim2.new(percentage, -6, 0.5, -6)
            if saveName then
                windowSelf.ConfigData[saveName] = value
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

        task.spawn(callback, value) -- CRITICAL BUGFIX: Fires callback immediately on layout construction
    end

    function tabObject:CreateInput(config, callback)
        local inputName = config.Name or "Text Field Input"
        local placeholder = config.Placeholder or "Type here..."
        local callback = callback or function() end

        local inputFrame = Instance.new("Frame")
        inputFrame.LayoutOrder = getNextLayoutOrder()
        inputFrame.Size = UDim2.new(1, 0, 0, 40)
        inputFrame.BackgroundColor3 = windowSelf.Theme.CardBackground
        inputFrame.Parent = pageContainer
        Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", inputFrame).Color = windowSelf.Theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = inputName
        lbl.TextColor3 = windowSelf.Theme.Text
        lbl.Font = windowSelf.Theme.Font
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = inputFrame

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0, 150, 0, 26)
        box.Position = UDim2.new(1, -162, 0.5, -13)
        box.BackgroundColor3 = windowSelf.Theme.WindowBg
        box.Text = ""
        box.PlaceholderText = placeholder
        box.TextColor3 = windowSelf.Theme.Text
        box.PlaceholderColor3 = windowSelf.Theme.MutedText
        box.Font = windowSelf.Theme.Font
        box.TextSize = 11
        box.ClipsDescendants = true
        box.Parent = inputFrame
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
        Instance.new("UIStroke", box).Color = windowSelf.Theme.Border

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
        dropFrame.LayoutOrder = getNextLayoutOrder()
        dropFrame.Size = UDim2.new(1, 0, 0, 40)
        dropFrame.BackgroundColor3 = windowSelf.Theme.CardBackground
        dropFrame.ClipsDescendants = true
        dropFrame.Parent = pageContainer
        Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", dropFrame).Color = windowSelf.Theme.Border

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
        lbl.TextColor3 = windowSelf.Theme.Text
        lbl.Font = windowSelf.Theme.Font
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = headerBtn

        local chev = Instance.new("ImageLabel")
        chev.Size = UDim2.new(0, 14, 0, 14)
        chev.Position = UDim2.new(1, -26, 0.5, -7)
        chev.BackgroundTransparency = 1
        chev.Image = Icons.chevron
        chev.ImageColor3 = windowSelf.Theme.MutedText
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
            optBtn.BackgroundColor3 = windowSelf.Theme.WindowBg
            optBtn.Text = optName
            optBtn.TextColor3 = windowSelf.Theme.MutedText
            optBtn.Font = windowSelf.Theme.Font
            optBtn.TextSize = 11
            optBtn.Parent = listContainer
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 5)
            Instance.new("UIStroke", optBtn).Color = windowSelf.Theme.Border

            optBtn.MouseButton1Click:Connect(function()
                lbl.Text = dropName .. " (" .. optName .. ")"
                expanded = false
                local t = TweenService:Create(dropFrame, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 40)})
                t:Play()
                TweenService:Create(chev, TweenInfo.new(0.15), {Rotation = 0}):Play()
                task.spawn(callback, optName)
                t.Completed:Connect(function() updateCanvas() end)
            end)
        end

        headerBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            local targetSize = expanded and (46 + (#options * 30)) or 40
            local t = TweenService:Create(dropFrame, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, targetSize)})
            t:Play()
            TweenService:Create(chev, TweenInfo.new(0.15), {Rotation = expanded and 180 or 0}):Play()
            
            local animationLoop
            animationLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if t.PlaybackState == Enum.PlaybackState.Playing then
                    updateCanvas()
                else
                    animationLoop:Disconnect()
                    updateCanvas()
                end
            end)
        end)
    end

    return tabObject
end

return Lucidity
