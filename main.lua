--[[
    🔳 Lucidity UI Framework (Complete Production Build)
    Features: Responsive Scaling Engine (75% - 150%), Live Theme Engine,
    Draggable Topbars, Notification Stack, & Automated Configuration Systems.
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Lucidity = {
    ActiveTheme = "Dark Mode",
    Registry = {},
    Themes = {
        ["Dark Mode"] = {
            Background = Color3.fromRGB(20, 20, 20),
            Topbar = Color3.fromRGB(15, 15, 15),
            Border = Color3.fromRGB(40, 40, 40),
            TextPrimary = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(160, 160, 160),
            Accent = Color3.fromRGB(255, 255, 255),
            ComponentBackground = Color3.fromRGB(28, 28, 28)
        },
        ["Light Mode"] = {
            Background = Color3.fromRGB(245, 245, 245),
            Topbar = Color3.fromRGB(255, 255, 255),
            Border = Color3.fromRGB(210, 210, 210),
            TextPrimary = Color3.fromRGB(20, 20, 20),
            TextSecondary = Color3.fromRGB(100, 100, 100),
            Accent = Color3.fromRGB(0, 0, 0),
            ComponentBackground = Color3.fromRGB(235, 235, 235)
        }
    }
}

-- 🛠️ INTERNAL HELPER: Object Theme Registration
local function registerThemeable(instance, propertyMap)
    table.insert(Lucidity.Registry, {
        Instance = instance,
        Properties = propertyMap
    })
    
    -- Initial application of current palette
    local currentPalette = Lucidity.Themes[Lucidity.ActiveTheme]
    for prop, themeKey in pairs(propertyMap) do
        instance[prop] = currentPalette[themeKey]
    end
end

-- 🎨 THEMES ENGINE: Runtime Dynamic Re-skinning
function Lucidity:ApplyTheme(themeName)
    if not self.Themes[themeName] then return end
    self.ActiveTheme = themeName
    local palette = self.Themes[themeName]
    
    for _, entry in ipairs(self.Registry) do
        if entry.Instance and entry.Instance.Parent then
            for prop, themeKey in pairs(entry.Properties) do
                TweenService:Create(entry.Instance, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                    [prop] = palette[themeKey]
                }):Play()
            end
        end
    end
end

-- 🛡️ SECURITY STACK: Authentication Initialization Splashes
function Lucidity:InitiateSecuritySplash(config, successCallback)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Lucidity_SecurityBlock"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999999
    screenGui.Parent = CoreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 320, 0, 180)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    registerThemeable(mainFrame, { BackgroundColor3 = "Background" })
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = 1
    uiStroke.Parent = mainFrame
    registerThemeable(uiStroke, { Color3 = "Border" })
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "AUTHENTICATION REQUIRED"
    title.Font = Enum.Font.Code
    title.TextSize = 14
    title.Parent = mainFrame
    registerThemeable(title, { TextColor3 = "TextPrimary" })
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 260, 0, 36)
    textBox.Position = UDim2.new(0.5, -130, 0.45, 0)
    textBox.PlaceholderText = "Enter Access Key..."
    textBox.Text = ""
    textBox.Font = Enum.Font.Code
    textBox.TextSize = 13
    textBox.BorderSizePixel = 0
    textBox.Parent = mainFrame
    registerThemeable(textBox, { BackgroundColor3 = "ComponentBackground", TextColor3 = "TextPrimary", PlaceholderColor3 = "TextSecondary" })
    
    local submit = Instance.new("TextButton")
    submit.Size = UDim2.new(0, 260, 0, 32)
    submit.Position = UDim2.new(0.5, -130, 0.75, 0)
    submit.Text = "SUBMIT"
    submit.Font = Enum.Font.Code
    submit.TextSize = 12
    submit.BorderSizePixel = 0
    submit.Parent = mainFrame
    registerThemeable(submit, { BackgroundColor3 = "Accent", TextColor3 = "Background" })
    
    submit.MouseButton1Click:Connect(function()
        if textBox.Text == config.Key then
            screenGui:Destroy()
            successCallback()
        else
            textBox.Text = ""
            textBox.PlaceholderText = "INVALID KEY — TRY AGAIN"
        end
    end)
end

-- 📐 WINDOW FACTORY: Initialize Interface Instance
function Lucidity:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "Lucidity Framework"
    config.KeySystem = config.KeySystem or false
    config.Key = config.Key or ""
    
    local windowInstance = {}
    
    local function executeBuild()
        -- Root Screen Layer Setup
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Lucidity_" .. config.Name
        screenGui.ResetOnSpawn = false
        screenGui.Parent = CoreGui
        
        -- High-Performance Responsive Scale Engine Core
        local uiScale = Instance.new("UIScale")
        uiScale.Scale = 1.0
        uiScale.Parent = screenGui
        windowInstance.ScaleObject = uiScale
        
        -- Main Container Construction
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 550, 0, 380)
        mainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
        mainFrame.BorderSizePixel = 0
        mainFrame.Parent = screenGui
        registerThemeable(mainFrame, { BackgroundColor3 = "Background" })
        
        local windowStroke = Instance.new("UIStroke")
        windowStroke.Thickness = 1
        windowStroke.Parent = mainFrame
        registerThemeable(windowStroke, { Color3 = "Border" })
        
        -- Smooth Drag Action Controller
        local topbar = Instance.new("Frame")
        topbar.Size = UDim2.new(1, 0, 0, 35)
        topbar.BorderSizePixel = 0
        topbar.Parent = mainFrame
        registerThemeable(topbar, { BackgroundColor3 = "Topbar" })
        
        local topbarBorder = Instance.new("Frame")
        topbarBorder.Size = UDim2.new(1, 0, 0, 1)
        topbarBorder.Position = UDim2.new(0, 0, 1, -1)
        topbarBorder.BorderSizePixel = 0
        topbarBorder.Parent = topbar
        registerThemeable(topbarBorder, { BackgroundColor3 = "Border" })
        
        local windowTitle = Instance.new("TextLabel")
        windowTitle.Size = UDim2.new(1, -20, 1, 0)
        windowTitle.Position = UDim2.new(0, 15, 0, 0)
        windowTitle.TextXAlignment = Enum.TextXAlignment.Left
        windowTitle.Text = string.upper(config.Name)
        windowTitle.Font = Enum.Font.Code
        windowTitle.TextSize = 13
        windowTitle.Parent = topbar
        registerThemeable(windowTitle, { TextColor3 = "TextPrimary" })
        
        -- Drag Logic Integration
        local dragging, dragInput, dragStart, startPos
        topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        topbar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (delta.X / uiScale.Scale), startPos.Y.Scale, startPos.Y.Offset + (delta.Y / uiScale.Scale))
            end
        end)
        
        -- Structural Layout Framework Split (Navigation Side / Content Deck)
        local sidebar = Instance.new("Frame")
        sidebar.Size = UDim2.new(0, 140, 1, -35)
        sidebar.Position = UDim2.new(0, 0, 0, 35)
        sidebar.BorderSizePixel = 0
        sidebar.Parent = mainFrame
        registerThemeable(sidebar, { BackgroundColor3 = "Topbar" })
        
        local sidebarDivider = Instance.new("Frame")
        sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
        sidebarDivider.Position = UDim2.new(1, -1, 0, 0)
        sidebarDivider.BorderSizePixel = 0
        sidebarDivider.Parent = sidebar
        registerThemeable(sidebarDivider, { BackgroundColor3 = "Border" })
        
        local navLayout = Instance.new("UIListLayout")
        navLayout.SortOrder = Enum.SortOrder.LayoutOrder
        navLayout.Padding = UDim.new(0, 2)
        navLayout.Parent = sidebar
        
        local containerDeck = Instance.new("Frame")
        containerDeck.Size = UDim2.new(1, -140, 1, -35)
        containerDeck.Position = UDim2.new(0, 140, 0, 35)
        containerDeck.BorderSizePixel = 0
        containerDeck.Parent = mainFrame
        registerThemeable(containerDeck, { BackgroundColor3 = "Background" })
        
        windowInstance.Tabs = {}
        
        -- 📑 LAYOUT NODE FACTORY: Create UI Tab Interfaces
        function windowInstance:CreateTab(tabName, icon, forceBottom)
            local tabObj = {
                LayoutCounter = 0 -- Fixes sequence errors by forcing clean linear increments
            }
            
            local navButton = Instance.new("TextButton")
            navButton.Size = UDim2.new(1, 0, 0, 32)
            navButton.Text = "  " .. string.upper(tabName)
            navButton.Font = Enum.Font.Code
            navButton.TextSize = 11
            navButton.TextXAlignment = Enum.TextXAlignment.Left
            navButton.BorderSizePixel = 0
            navButton.LayoutOrder = forceBottom and 9999 or #sidebar:GetChildren()
            navButton.Parent = sidebar
            registerThemeable(navButton, { BackgroundColor3 = "Topbar", TextColor3 = "TextSecondary" })
            
            local pageScroll = Instance.new("ScrollingFrame")
            pageScroll.Size = UDim2.new(1, 0, 1, 0)
            pageScroll.BackgroundTransparency = 1
            pageScroll.BorderSizePixel = 0
            pageScroll.Visible = false
            pageScroll.ScrollBarThickness = 2
            pageScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            pageScroll.Parent = containerDeck
            registerThemeable(pageScroll, { ScrollBarImageColor3 = "Border" })
            
            local pageLayout = Instance.new("UIListLayout")
            pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
            pageLayout.Padding = UDim.new(0, 8)
            pageLayout.Parent = pageScroll
            
            local pagePadding = Instance.new("UIPadding")
            pagePadding.PaddingTop = UDim.new(0, 12)
            pagePadding.PaddingLeft = UDim.new(0, 12)
            pagePadding.PaddingRight = UDim.new(0, 12)
            pagePadding.Parent = pageScroll
            
            pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                pageScroll.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 25)
            end)
            
            local function selectThisTab()
                for _, otherTab in ipairs(windowInstance.Tabs) do
                    otherTab.PageFrame.Visible = false
                    TweenService:Create(otherTab.NavButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                        TextColor3 = Lucidity.Themes[Lucidity.ActiveTheme].TextSecondary
                    }):Play()
                end
                pageScroll.Visible = true
                TweenService:Create(navButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                    TextColor3 = Lucidity.Themes[Lucidity.ActiveTheme].TextPrimary
                }):Play()
            end
            
            navButton.MouseButton1Click:Connect(selectThisTab)
            
            tabObj.NavButton = navButton
            tabObj.PageFrame = pageScroll
            table.insert(windowInstance.Tabs, tabObj)
            
            if #windowInstance.Tabs == 1 then selectThisTab() end
            
            -- 🗃️ COMPONENT GROUP: Context Section Header Layouts
            function tabObj:CreateSection(sectionName)
                tabObj.LayoutCounter = tabObj.LayoutCounter + 1
                
                local sectionFrame = Instance.new("Frame")
                sectionFrame.Size = UDim2.new(1, 0, 0, 20)
                sectionFrame.BackgroundTransparency = 1
                sectionFrame.LayoutOrder = tabObj.LayoutCounter
                sectionFrame.Parent = pageScroll
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = string.upper(sectionName)
                label.Font = Enum.Font.Code
                label.TextSize = 10
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = sectionFrame
                registerThemeable(label, { TextColor3 = "TextSecondary" })
            end
            
            -- 🔘 ACTIONS COMPONENT: Functional Button
            function tabObj:CreateButton(buttonConfig, callback)
                buttonConfig = buttonConfig or {}
                buttonConfig.Name = buttonConfig.Name or "Action Button"
                callback = callback or function() end
                
                tabObj.LayoutCounter = tabObj.LayoutCounter + 1
                
                local btnFrame = Instance.new("TextButton")
                btnFrame.Size = UDim2.new(1, 0, 0, 36)
                btnFrame.Text = ""
                btnFrame.BorderSizePixel = 0
                btnFrame.LayoutOrder = tabObj.LayoutCounter
                btnFrame.Parent = pageScroll
                registerThemeable(btnFrame, { BackgroundColor3 = "ComponentBackground" })
                
                local btnStroke = Instance.new("UIStroke")
                btnStroke.Thickness = 1
                btnStroke.Parent = btnFrame
                registerThemeable(btnStroke, { Color3 = "Border" })
                
                local btnLabel = Instance.new("TextLabel")
                btnLabel.Size = UDim2.new(1, -15, 1, 0)
                btnLabel.Position = UDim2.new(0, 12, 0, 0)
                btnLabel.Text = buttonConfig.Name
                btnLabel.Font = Enum.Font.Code
                btnLabel.TextSize = 12
                btnLabel.TextXAlignment = Enum.TextXAlignment.Left
                btnLabel.BackgroundTransparency = 1
                btnLabel.Parent = btnFrame
                registerThemeable(btnLabel, { TextColor3 = "TextPrimary" })
                
                btnFrame.MouseButton1Down:Connect(function()
                    TweenService:Create(btnFrame, TweenInfo.new(0.05, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Lucidity.Themes[Lucidity.ActiveTheme].Border
                    }):Play()
                end)
                
                btnFrame.MouseButton1Up:Connect(function()
                    TweenService:Create(btnFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Lucidity.Themes[Lucidity.ActiveTheme].ComponentBackground
                    }):Play()
                end)
                
                btnFrame.MouseButton1Click:Connect(function()
                    task.spawn(callback)
                end)
            end
            
            -- 🔽 SELECTORS COMPONENT: Compressing Layout Single Dropdowns
            function tabObj:CreateDropdown(dropdownConfig, callback)
                dropdownConfig = dropdownConfig or {}
                dropdownConfig.Name = dropdownConfig.Name or "Selection Menu"
                dropdownConfig.Options = dropdownConfig.Options or {}
                callback = callback or function() end
                
                tabObj.LayoutCounter = tabObj.LayoutCounter + 1
                local isExpanded = false
                
                local dropContainer = Instance.new("Frame")
                dropContainer.Size = UDim2.new(1, 0, 0, 36)
                dropContainer.BorderSizePixel = 0
                dropContainer.ClipsDescendants = true
                dropContainer.LayoutOrder = tabObj.LayoutCounter
                dropContainer.Parent = pageScroll
                registerThemeable(dropContainer, { BackgroundColor3 = "ComponentBackground" })
                
                local dropStroke = Instance.new("UIStroke")
                dropStroke.Thickness = 1
                dropStroke.Parent = dropContainer
                registerThemeable(dropStroke, { Color3 = "Border" })
                
                local headerButton = Instance.new("TextButton")
                headerButton.Size = UDim2.new(1, 0, 0, 36)
                headerButton.Text = ""
                headerButton.BackgroundTransparency = 1
                headerButton.Parent = dropContainer
                
                local titleLabel = Instance.new("TextLabel")
                titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                titleLabel.Position = UDim2.new(0, 12, 0, 0)
                titleLabel.Text = dropdownConfig.Name
                titleLabel.Font = Enum.Font.Code
                titleLabel.TextSize = 12
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.BackgroundTransparency = 1
                titleLabel.Parent = headerButton
                registerThemeable(titleLabel, { TextColor3 = "TextPrimary" })
                
                local indicator = Instance.new("TextLabel")
                indicator.Size = UDim2.new(0, 30, 1, 0)
                indicator.Position = UDim2.new(1, -40, 0, 0)
                indicator.Text = "[+]"
                indicator.Font = Enum.Font.Code
                indicator.TextSize = 12
                indicator.TextXAlignment = Enum.TextXAlignment.Right
                indicator.BackgroundTransparency = 1
                indicator.Parent = headerButton
                registerThemeable(indicator, { TextColor3 = "TextSecondary" })
                
                local optionsList = Instance.new("Frame")
                optionsList.Size = UDim2.new(1, 0, 0, 0)
                optionsList.Position = UDim2.new(0, 0, 0, 36)
                optionsList.BackgroundTransparency = 1
                optionsList.Parent = dropContainer
                
                local listLayout = Instance.new("UIListLayout")
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                listLayout.Parent = optionsList
                
                for idx, optionText in ipairs(dropdownConfig.Options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1, 0, 0, 28)
                    optBtn.Text = "     " .. optionText
                    optBtn.Font = Enum.Font.Code
                    optBtn.TextSize = 11
                    optBtn.TextXAlignment = Enum.TextXAlignment.Left
                    optBtn.BorderSizePixel = 0
                    optBtn.LayoutOrder = idx
                    optBtn.Parent = optionsList
                    registerThemeable(optBtn, { BackgroundColor3 = "ComponentBackground", TextColor3 = "TextSecondary" })
                    
                    optBtn.MouseButton1Click:Connect(function()
                        titleLabel.Text = dropdownConfig.Name .. " : " .. optionText
                        isExpanded = false
                        indicator.Text = "[+]"
                        TweenService:Create(dropContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Size = UDim2.new(1, 0, 0, 36) }):Play()
                        task.spawn(callback, optionText)
                    end)
                end
                
                headerButton.MouseButton1Click:Connect(function()
                    isExpanded = not isExpanded
                    local targetHeight = isExpanded and (36 + listLayout.AbsoluteContentSize.Y) or 36
                    indicator.Text = isExpanded and "[-]" or "[+]"
                    TweenService:Create(dropContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Size = UDim2.new(1, 0, 0, targetHeight) }):Play()
                end)
            end
            
            return tabObj
        end
        
        -- ✨ APP APPLICATION FRAMEWORK SEED INITIALIZATION
        task.spawn(function()
            local Settings = windowInstance:CreateTab("Settings", "settings", true)
            Settings:CreateSection("Client Configurations")
            
            -- UI Scale Dropdown Engine Interface Node (75% - 150%)
            Settings:CreateDropdown({
                Name = "Interface UI Scale Profile",
                Options = {"75%", "100%", "125%", "150%"}
            }, function(selected)
                local cleanPercent = string.gsub(selected, "%%", "")
                local numericScale = tonumber(cleanPercent)
                if numericScale then
                    uiScale.Scale = numericScale / 100
                end
            end)
            
            -- Dynamic Live-Theme Swapping Dropdown Engine UI Element
            Settings:CreateDropdown({
                Name = "Interface Theme Palette",
                Options = {"Dark Mode", "Light Mode"}
            }, function(selectedTheme)
                Lucidity:ApplyTheme(selectedTheme)
            end)
        end)
    end
    
    if config.KeySystem then
        self:InitiateSecuritySplash(config, executeBuild)
    else
        executeBuild()
    end
    
    return windowInstance
end

-- 🔔 ALERT SYSTEMS: Thread-Safe Notification Engine
function Lucidity:Notify(noticeConfig)
    noticeConfig = noticeConfig or {}
    noticeConfig.Title = noticeConfig.Title or "Notification"
    noticeConfig.Content = noticeConfig.Content or ""
    noticeConfig.Duration = noticeConfig.Duration or 3
    
    local toastGui = CoreGui:FindFirstChild("Lucidity_NotificationDeck")
    if not toastGui then
        toastGui = Instance.new("ScreenGui")
        toastGui.Name = "Lucidity_NotificationDeck"
        toastGui.Parent = CoreGui
        
        local layoutContainer = Instance.new("Frame")
        layoutContainer.Name = "DeckFrame"
        layoutContainer.Size = UDim2.new(0, 280, 1, -40)
        layoutContainer.Position = UDim2.new(1, -300, 0, 20)
        layoutContainer.BackgroundTransparency = 1
        layoutContainer.Parent = toastGui
        
        local deckLayout = Instance.new("UIListLayout")
        deckLayout.SortOrder = Enum.SortOrder.LayoutOrder
        deckLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        deckLayout.Padding = UDim.new(0, 6)
        deckLayout.Parent = layoutContainer
    end
    
    local container = toastGui.DeckFrame
    
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 70)
    card.BorderSizePixel = 0
    card.BackgroundTransparency = 1
    card.Parent = container
    registerThemeable(card, { BackgroundColor3 = "Background" })
    
    local cardStroke = Instance.new("UIStroke")
    cardStroke.Thickness = 1
    cardStroke.Transparency = 1
    cardStroke.Parent = card
    registerThemeable(cardStroke, { Color3 = "Border" })
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 25)
    title.Position = UDim2.new(0, 12, 0, 4)
    title.Text = string.upper(noticeConfig.Title)
    title.Font = Enum.Font.Code
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.TextTransparency = 1
    title.Parent = card
    registerThemeable(title, { TextColor3 = "TextPrimary" })
    
    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -24, 1, -32)
    body.Position = UDim2.new(0, 12, 0, 26)
    body.Text = noticeConfig.Content
    body.Font = Enum.Font.Code
    body.TextSize = 11
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.TextWrapped = true
    body.BackgroundTransparency = 1
    body.TextTransparency = 1
    body.Parent = card
    registerThemeable(body, { TextColor3 = "TextSecondary" })
    
    -- Animation Phase Transitions
    TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { BackgroundTransparency = 0 }):Play()
    TweenService:Create(cardStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Transparency = 0 }):Play()
    TweenService:Create(title, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { TextTransparency = 0 }):Play()
    TweenService:Create(body, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { TextTransparency = 0 }):Play()
    
    task.delay(noticeConfig.Duration, function()
        TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(cardStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Transparency = 1 }):Play()
        TweenService:Create(title, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { TextTransparency = 1 }):Play()
        TweenService:Create(body, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { TextTransparency = 1 }):Play()
        task.wait(0.22)
        card:Destroy()
    end)
end

return Lucidity
