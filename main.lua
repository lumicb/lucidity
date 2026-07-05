local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

local Lucidity = {
    Registry = {},
    Signals = {},
    Toasts = nil
}

-- ==========================================
-- DESIGN SYSTEM & CORE PALETTE
-- ==========================================
Lucidity.Theme = {
    WindowBg = Color3.fromRGB(15, 15, 18),
    TopBarBg = Color3.fromRGB(20, 20, 25),
    SidebarBg = Color3.fromRGB(18, 18, 22),
    SectionBg = Color3.fromRGB(22, 22, 28),
    ElementBg = Color3.fromRGB(28, 28, 36),
    ElementHover = Color3.fromRGB(36, 36, 46),
    Border = Color3.fromRGB(42, 42, 52),
    BorderFocus = Color3.fromRGB(0, 162, 255),
    Text = Color3.fromRGB(245, 245, 248),
    MutedText = Color3.fromRGB(135, 135, 150),
    Accent = Color3.fromRGB(0, 162, 255),
    AccentDim = Color3.fromRGB(0, 110, 185),
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold
}

-- Safe asset delivery map for internal systems
local Assets = {
    chevron = "rbxassetid://10131432414",
    check = "rbxassetid://9886659406",
    alert = "rbxassetid://10131448651"
}

-- Pure execution wrapper for smooth interface feedback
local function animate(instance, duration, properties, style)
    local t = TweenService:Create(instance, TweenInfo.new(duration, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    t:Play()
    return t
end

-- ==========================================
-- VIEWPORT NOTIFICATION TOAST SUB-SYSTEM
-- ==========================================
local function InitializeNotificationEngine(screenGui)
    if Lucidity.Toasts then return end
    
    local toastContainer = Instance.new("Frame")
    toastContainer.Name = "NotificationFrame"
    toastContainer.Size = UDim2.new(0, 280, 1, -40)
    toastContainer.Position = UDim2.new(1, -300, 0, 20)
    toastContainer.BackgroundTransparency = 1
    toastContainer.ZIndex = 100
    toastContainer.Parent = screenGui

    local layout = Instance.new("UIListLayout")
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Padding = UDim.new(0, 8)
    layout.Parent = toastContainer
    
    Lucidity.Toasts = toastContainer
end

function Lucidity.Notify(title, message, duration)
    if not Lucidity.Toasts then return end
    duration = duration or 4

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0) -- Starts at 0 to animate insertion height smoothly
    card.BackgroundColor3 = Lucidity.Theme.TopBarBg
    card.ClipsDescendants = true
    card.Parent = Lucidity.Toasts

    local corner = Instance.new("UICorner", card)
    corner.CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Lucidity.Theme.Border

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, 0)
    accentBar.BackgroundColor3 = Lucidity.Theme.Accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, -24, 0, 20)
    tLbl.Position = UDim2.new(0, 12, 0, 6)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title or "Notification"
    tLbl.TextColor3 = Lucidity.Theme.Text
    tLbl.Font = Lucidity.Theme.FontBold
    tLbl.TextSize = 12
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local mLbl = Instance.new("TextLabel")
    mLbl.Size = UDim2.new(1, -24, 1, -32)
    mLbl.Position = UDim2.new(0, 12, 0, 24)
    mLbl.BackgroundTransparency = 1
    mLbl.Text = message or ""
    mLbl.TextColor3 = Lucidity.Theme.MutedText
    mLbl.Font = Lucidity.Theme.Font
    mLbl.TextSize = 11
    mLbl.TextWrapped = true
    mLbl.TextXAlignment = Enum.TextXAlignment.Left
    mLbl.TextYAlignment = Enum.TextYAlignment.Top
    mLbl.Parent = card

    -- Smooth entrance layout sequence
    local entryTween = animate(card, 0.25, {Size = UDim2.new(1, 0, 0, 64)})
    
    task.delay(duration, function()
        local exitTween = animate(card, 0.25, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        animate(stroke, 0.25, {Transparency = 1})
        animate(tLbl, 0.25, {TextTransparency = 1})
        animate(mLbl, 0.25, {TextTransparency = 1})
        animate(accentBar, 0.25, {BackgroundTransparency = 1})
        
        exitTween.Completed:Connect(function()
            card:Destroy()
        end)
    end)
end

-- ==========================================
-- WINDOW ENGINE INITIALIZER
-- ==========================================
function Lucidity.CreateWindow(windowTitle, parentGui)
    windowTitle = windowTitle or "Lucidity Framework"
    
    local windowSelf = {
        Tabs = {},
        ActiveTab = nil,
        Connections = {},
        Closed = false
    }

    -- Root Interface Initialization
    local screenGui = parentGui or Instance.new("ScreenGui")
    if not parentGui then
        screenGui.Name = "Lucidity_Runtime"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local success, _ = pcall(function()
            screenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui
        end)
        if not success then
            screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end
    end
    
    InitializeNotificationEngine(screenGui)

    -- Master Layout Base
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 580, 0, 440)
    mainFrame.Position = UDim2.new(0.5, -290, 0.5, -220)
    mainFrame.BackgroundColor3 = Lucidity.Theme.WindowBg
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
    local outerStroke = Instance.new("UIStroke", mainFrame)
    outerStroke.Color = Lucidity.Theme.Border

    -- Top Header Utility Bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 42)
    topBar.BackgroundColor3 = Lucidity.Theme.TopBarBg
    topBar.Parent = mainFrame
    
    local topBarDivider = Instance.new("Frame")
    topBarDivider.Size = UDim2.new(1, 0, 0, 1)
    topBarDivider.Position = UDim2.new(0, 0, 1, -1)
    topBarDivider.BackgroundColor3 = Lucidity.Theme.Border
    topBarDivider.BorderSizePixel = 0
    topBarDivider.Parent = topBar

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 16, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = windowTitle
    titleText.TextColor3 = Lucidity.Theme.Text
    titleText.Font = Lucidity.Theme.FontBold
    titleText.TextSize = 14
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = topBar

    -- Native Drag Logic Core
    local isDragging, dragInput, dragStartOffset, initialPosition
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStartOffset = input.Position
            initialPosition = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then isDragging = false end
            end)
        end
    end)
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    table.insert(windowSelf.Connections, UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and isDragging then
            local delta = input.Position - dragStartOffset
            mainFrame.Position = UDim2.new(initialPosition.X.Scale, initialPosition.X.Offset + delta.X, initialPosition.Y.Scale, initialPosition.Y.Offset + delta.Y)
        end
    end))

    -- Left Navigation Panel
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 145, 1, -42)
    sidebar.Position = UDim2.new(0, 0, 0, 42)
    sidebar.BackgroundColor3 = Lucidity.Theme.SidebarBg
    sidebar.Parent = mainFrame

    local sidebarDivider = Instance.new("Frame")
    sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    sidebarDivider.Position = UDim2.new(1, -1, 0, 0)
    sidebarDivider.BackgroundColor3 = Lucidity.Theme.Border
    sidebarDivider.BorderSizePixel = 0
    sidebarDivider.Parent = sidebar

    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Size = UDim2.new(1, -10, 1, -16)
    sidebarScroll.Position = UDim2.new(0, 5, 0, 8)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebarScroll.ScrollBarThickness = 0
    sidebarScroll.Parent = sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 5)
    sidebarLayout.Parent = sidebarScroll

    -- Main Page Viewport Container
    local viewport = Instance.new("Frame")
    viewport.Size = UDim2.new(1, -145, 1, -42)
    viewport.Position = UDim2.new(0, 145, 0, 42)
    viewport.BackgroundTransparency = 1
    viewport.Parent = mainFrame

    -- ==========================================
    -- TAB COMPONENT FACTORY
    -- ==========================================
    function windowSelf:CreateTab(tabName)
        tabName = tabName or "Workspace"
        local tabSelf = { Sections = {} }

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 34)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = "    " .. tabName
        tabBtn.TextColor3 = Lucidity.Theme.MutedText
        tabBtn.Font = Lucidity.Theme.Font
        tabBtn.TextSize = 13
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = sidebarScroll
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

        local tabCanvas = Instance.new("ScrollingFrame")
        tabCanvas.Size = UDim2.new(1, 0, 1, 0)
        tabCanvas.BackgroundTransparency = 1
        tabCanvas.ScrollBarThickness = 4
        tabCanvas.ScrollBarImageColor3 = Lucidity.Theme.Border
        tabCanvas.Visible = false
        tabCanvas.Parent = viewport

        local tabLayout = Instance.new("UIListLayout")
        tabLayout.Padding = UDim.new(0, 12)
        tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        tabLayout.Parent = tabCanvas

        local tabPadding = Instance.new("UIPadding")
        tabPadding.PaddingTop = UDim.new(0, 14)
        tabPadding.PaddingBottom = UDim.new(0, 14)
        tabPadding.PaddingLeft = UDim.new(0, 14)
        tabPadding.PaddingRight = UDim.new(0, 14)
        tabPadding.Parent = tabCanvas

        -- Reactive canvas bounds updating
        local function recalculateCanvas()
            tabCanvas.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 28)
        end
        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(recalculateCanvas)
        sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y)
        end)

        table.insert(windowSelf.Tabs, {Button = tabBtn, Engine = tabCanvas})

        if #windowSelf.Tabs == 1 then
            windowSelf.ActiveTab = tabSelf
            tabBtn.BackgroundColor3 = Lucidity.Theme.ElementBg
            tabBtn.TextColor3 = Lucidity.Theme.Text
            tabCanvas.Visible = true
        end

        tabBtn.MouseButton1Click:Connect(function()
            for _, item in pairs(windowSelf.Tabs) do
                item.Button.BackgroundTransparency = 1
                item.Button.TextColor3 = Lucidity.Theme.MutedText
                item.Engine.Visible = false
            end
            tabBtn.BackgroundTransparency = 0
            tabBtn.BackgroundColor3 = Lucidity.Theme.ElementBg
            tabBtn.TextColor3 = Lucidity.Theme.Text
            tabCanvas.Visible = true
        end)

        -- ==========================================
        -- SECTION COMPONENT FACTORY
        -- ==========================================
        function tabSelf:CreateSection(sectionName)
            sectionName = sectionName or "Group"
            local sectionSelf = {}

            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 50)
            sectionFrame.BackgroundColor3 = Lucidity.Theme.SectionBg
            sectionFrame.Parent = tabCanvas

            Instance.new("UICorner", sectionFrame).CornerRadius = UDim.new(0, 7)
            local sectionStroke = Instance.new("UIStroke", sectionFrame)
            sectionStroke.Color = Lucidity.Theme.Border

            local secLayout = Instance.new("UIListLayout")
            secLayout.Padding = UDim.new(0, 6)
            secLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            secLayout.Parent = sectionFrame

            local secPadding = Instance.new("UIPadding")
            secPadding.PaddingTop = UDim.new(0, 34)
            secPadding.PaddingBottom = UDim.new(0, 10)
            secPadding.PaddingLeft = UDim.new(0, 10)
            secPadding.PaddingRight = UDim.new(0, 10)
            secPadding.Parent = sectionFrame

            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, 0, 0, 24)
            sectionLabel.Position = UDim2.new(0, 12, 0, 6)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = string.upper(sectionName)
            sectionLabel.TextColor3 = Lucidity.Theme.MutedText
            sectionLabel.Font = Lucidity.Theme.FontBold
            sectionLabel.TextSize = 10
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = sectionFrame

            -- Mathematical synchronization framework to completely eliminate layout overlap bugs
            secLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionFrame.Size = UDim2.new(1, 0, 0, secLayout.AbsoluteContentSize.Y + 44)
                recalculateCanvas()
            end)

            -- ==========================================
            -- SUB-ELEMENT: CORE BUTTON
            -- ==========================================
            function sectionSelf:CreateButton(text, callback)
                callback = callback or function() end
                
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 34)
                btn.BackgroundColor3 = Lucidity.Theme.ElementBg
                btn.Text = ""
                btn.AutoButtonColor = false
                btn.Parent = sectionFrame

                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
                local s = Instance.new("UIStroke", btn)
                s.Color = Lucidity.Theme.Border

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = text or "Action Button"
                label.TextColor3 = Lucidity.Theme.Text
                label.Font = Lucidity.Theme.Font
                label.TextSize = 13
                label.Parent = btn

                btn.MouseEnter:Connect(function() animate(btn, 0.1, {BackgroundColor3 = Lucidity.Theme.ElementHover}) end)
                btn.MouseLeave:Connect(function() animate(btn, 0.1, {BackgroundColor3 = Lucidity.Theme.ElementBg}) end)
                btn.MouseButton1Click:Connect(function()
                    task.spawn(callback)
                    btn.BackgroundColor3 = Lucidity.Theme.Border
                    animate(btn, 0.12, {BackgroundColor3 = Lucidity.Theme.ElementHover})
                end)
            end

            -- ==========================================
            -- SUB-ELEMENT: STATE TOGGLE
            -- ==========================================
            function sectionSelf:CreateToggle(text, default, callback)
                local state = default or false
                callback = callback or function() end

                local tog = Instance.new("TextButton")
                tog.Size = UDim2.new(1, 0, 0, 34)
                tog.BackgroundColor3 = Lucidity.Theme.ElementBg
                tog.Text = ""
                tog.AutoButtonColor = false
                tog.Parent = sectionFrame

                Instance.new("UICorner", tog).CornerRadius = UDim.new(0, 6)
                local ts = Instance.new("UIStroke", tog)
                ts.Color = Lucidity.Theme.Border

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -60, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = text or "Toggle Parameter"
                label.TextColor3 = Lucidity.Theme.Text
                label.Font = Lucidity.Theme.Font
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = tog

                local slot = Instance.new("Frame")
                slot.Size = UDim2.new(0, 36, 0, 18)
                slot.Position = UDim2.new(1, -48, 0.5, -9)
                slot.BackgroundColor3 = state and Lucidity.Theme.Accent or Lucidity.Theme.WindowBg
                slot.Parent = tog
                Instance.new("UICorner", slot).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", slot).Color = Lucidity.Theme.Border

                local dot = Instance.new("Frame")
                dot.Size = UDim2.new(0, 12, 0, 12)
                dot.Position = UDim2.new(0, state and 21 or 3, 0.5, -6)
                dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dot.Parent = slot
                Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

                tog.MouseButton1Click:Connect(function()
                    state = not state
                    animate(slot, 0.12, {BackgroundColor3 = state and Lucidity.Theme.Accent or Lucidity.Theme.WindowBg})
                    animate(dot, 0.12, {Position = UDim2.new(0, state and 21 or 3, 0.5, -6)})
                    task.spawn(callback, state)
                end)
            end

            -- ==========================================
            -- SUB-ELEMENT: COMPANION SLIDER
            -- ==========================================
            function sectionSelf:CreateSlider(text, min, max, default, callback)
                local value = default or min
                callback = callback or function() end

                local slider = Instance.new("Frame")
                slider.Size = UDim2.new(1, 0, 0, 52)
                slider.BackgroundColor3 = Lucidity.Theme.ElementBg
                slider.Parent = sectionFrame

                Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 6)
                local ss = Instance.new("UIStroke", slider)
                ss.Color = Lucidity.Theme.Border

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -80, 0, 24)
                label.Position = UDim2.new(0, 12, 0, 4)
                label.BackgroundTransparency = 1
                label.Text = text or "Slider Variable"
                label.TextColor3 = Lucidity.Theme.Text
                label.Font = Lucidity.Theme.Font
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = slider

                local valLabel = Instance.new("TextLabel")
                valLabel.Size = UDim2.new(0, 60, 0, 24)
                valLabel.Position = UDim2.new(1, -72, 0, 4)
                valLabel.BackgroundTransparency = 1
                valLabel.Text = tostring(value)
                valLabel.TextColor3 = Lucidity.Theme.MutedText
                valLabel.Font = Lucidity.Theme.Font
                valLabel.TextSize = 13
                valLabel.TextXAlignment = Enum.TextXAlignment.Right
                valLabel.Parent = slider

                local track = Instance.new("TextButton")
                track.Size = UDim2.new(1, -24, 0, 6)
                track.Position = UDim2.new(0, 12, 0, 34)
                track.BackgroundColor3 = Lucidity.Theme.WindowBg
                track.Text = ""
                track.AutoButtonColor = false
                track.Parent = slider
                Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                fill.BackgroundColor3 = Lucidity.Theme.Accent
                fill.Parent = track
                Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

                local internalDrag = false
                local function updateSlider(input)
                    local percentage = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * percentage)
                    valLabel.Text = tostring(value)
                    animate(fill, 0.05, {Size = UDim2.new(percentage, 0, 1, 0)})
                    task.spawn(callback, value)
                end

                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        internalDrag = true
                        updateSlider(input)
                    end
                end)
                table.insert(windowSelf.Connections, UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        internalDrag = false
                    end
                end))
                table.insert(windowSelf.Connections, UserInputService.InputChanged:Connect(function(input)
                    if internalDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end))
            end

            -- ==========================================
            -- SUB-ELEMENT: TEXT INPUT UTILITY
            -- ==========================================
            function sectionSelf:CreateTextBox(placeholder, callback)
                callback = callback or function() end

                local box = Instance.new("Frame")
                box.Size = UDim2.new(1, 0, 0, 36)
                box.BackgroundColor3 = Lucidity.Theme.ElementBg
                box.Parent = sectionFrame

                Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
                local bs = Instance.new("UIStroke", box)
                bs.Color = Lucidity.Theme.Border

                local entry = Instance.new("TextBox")
                entry.Size = UDim2.new(1, -24, 1, 0)
                entry.Position = UDim2.new(0, 12, 0, 0)
                entry.BackgroundTransparency = 1
                entry.PlaceholderText = placeholder or "Input text..."
                entry.PlaceholderColor3 = Lucidity.Theme.MutedText
                entry.Text = ""
                entry.TextColor3 = Lucidity.Theme.Text
                entry.Font = Lucidity.Theme.Font
                entry.TextSize = 13
                entry.TextXAlignment = Enum.TextXAlignment.Left
                entry.ClearTextOnFocus = false
                entry.Parent = box

                entry.Focused:Connect(function() animate(bs, 0.1, {Color = Lucidity.Theme.BorderFocus}) end)
                entry.FocusLost:Connect(function(enter)
                    animate(bs, 0.1, {Color = Lucidity.Theme.Border})
                    task.spawn(callback, entry.Text, enter)
                end)
            end

            -- ==========================================
            -- SUB-ELEMENT: DDYNAMIC STANDARD DROPDOWN
            -- ==========================================
            function sectionSelf:CreateDropdown(name, items, callback)
                local open = false
                items = items or {}
                callback = callback or function() end

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, 36)
                frame.BackgroundColor3 = Lucidity.Theme.ElementBg
                frame.ClipsDescendants = true
                frame.Parent = sectionFrame
                
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
                local fs = Instance.new("UIStroke", frame)
                fs.Color = Lucidity.Theme.Border

                local trigger = Instance.new("TextButton")
                trigger.Size = UDim2.new(1, 0, 0, 36)
                trigger.BackgroundTransparency = 1
                trigger.Text = ""
                trigger.Parent = frame

                local mainLabel = Instance.new("TextLabel")
                mainLabel.Size = UDim2.new(1, -40, 1, 0)
                mainLabel.Position = UDim2.new(0, 12, 0, 0)
                mainLabel.BackgroundTransparency = 1
                mainLabel.Text = name or "Select Option"
                mainLabel.TextColor3 = Lucidity.Theme.Text
                mainLabel.Font = Lucidity.Theme.Font
                mainLabel.TextSize = 13
                mainLabel.TextXAlignment = Enum.TextXAlignment.Left
                mainLabel.Parent = trigger

                local arrow = Instance.new("ImageLabel")
                arrow.Size = UDim2.new(0, 14, 0, 14)
                arrow.Position = UDim2.new(1, -26, 0.5, -7)
                arrow.BackgroundTransparency = 1
                arrow.Image = Assets.chevron
                arrow.ImageColor3 = Lucidity.Theme.MutedText
                arrow.Parent = trigger

                local optionList = Instance.new("Frame")
                optionList.Size = UDim2.new(1, -24, 0, #items * 28)
                optionList.Position = UDim2.new(0, 12, 0, 38)
                optionList.BackgroundTransparency = 1
                optionList.Parent = frame

                local listLayout = Instance.new("UIListLayout")
                listLayout.Padding = UDim.new(0, 4)
                listLayout.Parent = optionList

                for _, val in pairs(items) do
                    local opt = Instance.new("TextButton")
                    opt.Size = UDim2.new(1, 0, 0, 24)
                    opt.BackgroundColor3 = Lucidity.Theme.WindowBg
                    opt.Text = val
                    opt.TextColor3 = Lucidity.Theme.MutedText
                    opt.Font = Lucidity.Theme.Font
                    opt.TextSize = 12
                    opt.AutoButtonColor = false
                    opt.Parent = optionList
                    
                    Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 4)
                    Instance.new("UIStroke", opt).Color = Lucidity.Theme.Border

                    opt.MouseEnter:Connect(function() animate(opt, 0.08, {TextColor3 = Lucidity.Theme.Text, BackgroundColor3 = Lucidity.Theme.ElementBg}) end)
                    opt.MouseLeave:Connect(function() animate(opt, 0.08, {TextColor3 = Lucidity.Theme.MutedText, BackgroundColor3 = Lucidity.Theme.WindowBg}) end)
                    opt.MouseButton1Click:Connect(function()
                        mainLabel.Text = name .. " [" .. val .. "]"
                        open = false
                        animate(frame, 0.15, {Size = UDim2.new(1, 0, 0, 36)})
                        animate(arrow, 0.15, {Rotation = 0})
                        task.spawn(callback, val)
                    end)
                end

                trigger.MouseButton1Click:Connect(function()
                    open = not open
                    local targetHeight = open and (42 + (#items * 28)) or 36
                    local t = animate(frame, 0.15, {Size = UDim2.new(1, 0, 0, targetHeight)})
                    animate(arrow, 0.15, {Rotation = open and 180 or 0})
                    
                    local activeConnection
                    activeConnection = frame:GetPropertyChangedSignal("Size"):Connect(function()
                        sectionFrame.Size = UDim2.new(1, 0, 0, secLayout.AbsoluteContentSize.Y + 44)
                        recalculateCanvas()
                    end)
                    t.Completed:Connect(function()
                        if activeConnection then activeConnection:Disconnect() end
                        sectionFrame.Size = UDim2.new(1, 0, 0, secLayout.AbsoluteContentSize.Y + 44)
                        recalculateCanvas()
                    end)
                end)
            end

            -- ==========================================
            -- EXPANSION: MULTI-SELECT DROPDOWN
            -- ==========================================
            function sectionSelf:CreateMultiDropdown(name, items, defaultSelection, callback)
                local open = false
                local selected = {}
                items = items or {}
                callback = callback or function() end
                
                for _, def in pairs(defaultSelection or {}) do selected[def] = true end

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, 36)
                frame.BackgroundColor3 = Lucidity.Theme.ElementBg
                frame.ClipsDescendants = true
                frame.Parent = sectionFrame
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
                local fs = Instance.new("UIStroke", frame)
                fs.Color = Lucidity.Theme.Border

                local trigger = Instance.new("TextButton")
                trigger.Size = UDim2.new(1, 0, 0, 36)
                trigger.BackgroundTransparency = 1
                trigger.Text = ""
                trigger.Parent = frame

                local mainLabel = Instance.new("TextLabel")
                mainLabel.Size = UDim2.new(1, -40, 1, 0)
                mainLabel.Position = UDim2.new(0, 12, 0, 0)
                mainLabel.BackgroundTransparency = 1
                mainLabel.Text = name .. " (...)"
                mainLabel.TextColor3 = Lucidity.Theme.Text
                mainLabel.Font = Lucidity.Theme.Font
                mainLabel.TextSize = 13
                mainLabel.TextXAlignment = Enum.TextXAlignment.Left
                mainLabel.Parent = trigger

                local arrow = Instance.new("ImageLabel")
                arrow.Size = UDim2.new(0, 14, 0, 14)
                arrow.Position = UDim2.new(1, -26, 0.5, -7)
                arrow.BackgroundTransparency = 1
                arrow.Image = Assets.chevron
                arrow.ImageColor3 = Lucidity.Theme.MutedText
                arrow.Parent = trigger

                local optionList = Instance.new("Frame")
                optionList.Size = UDim2.new(1, -24, 0, #items * 28)
                optionList.Position = UDim2.new(0, 12, 0, 38)
                optionList.BackgroundTransparency = 1
                optionList.Parent = frame

                local listLayout = Instance.new("UIListLayout")
                listLayout.Padding = UDim.new(0, 4)
                listLayout.Parent = optionList

                local function refreshLabel()
                    local registry = {}
                    for k, v in pairs(selected) do if v then table.insert(registry, k) end end
                    if #registry == 0 then mainLabel.Text = name .. " [None]"
                    else mainLabel.Text = name .. " [" .. table.concat(registry, ", ") .. "]" end
                end
                refreshLabel()

                for _, val in pairs(items) do
                    local opt = Instance.new("TextButton")
                    opt.Size = UDim2.new(1, 0, 0, 24)
                    opt.BackgroundColor3 = selected[val] and Lucidity.Theme.AccentDim or Lucidity.Theme.WindowBg
                    opt.Text = "   " .. val
                    opt.TextColor3 = selected[val] and Lucidity.Theme.Text or Lucidity.Theme.MutedText
                    opt.Font = Lucidity.Theme.Font
                    opt.TextSize = 12
                    opt.TextXAlignment = Enum.TextXAlignment.Left
                    opt.AutoButtonColor = false
                    opt.Parent = optionList
                    Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 4)
                    local os = Instance.new("UIStroke", opt)
                    os.Color = Lucidity.Theme.Border

                    opt.MouseButton1Click:Connect(function()
                        selected[val] = not selected[val]
                        animate(opt, 0.1, {
                            BackgroundColor3 = selected[val] and Lucidity.Theme.AccentDim or Lucidity.Theme.WindowBg,
                            TextColor3 = selected[val] and Lucidity.Theme.Text or Lucidity.Theme.MutedText
                        })
                        refreshLabel()
                        task.spawn(callback, selected)
                    end)
                end

                trigger.MouseButton1Click:Connect(function()
                    open = not open
                    local targetHeight = open and (42 + (#items * 28)) or 36
                    local t = animate(frame, 0.15, {Size = UDim2.new(1, 0, 0, targetHeight)})
                    animate(arrow, 0.15, {Rotation = open and 180 or 0})
                    
                    local activeConnection
                    activeConnection = frame:GetPropertyChangedSignal("Size"):Connect(function()
                        sectionFrame.Size = UDim2.new(1, 0, 0, secLayout.AbsoluteContentSize.Y + 44)
                        recalculateCanvas()
                    end)
                    t.Completed:Connect(function()
                        if activeConnection then activeConnection:Disconnect() end
                        sectionFrame.Size = UDim2.new(1, 0, 0, secLayout.AbsoluteContentSize.Y + 44)
                        recalculateCanvas()
                    end)
                end)
            end

            -- ==========================================
            -- EXPANSION: RUNTIME MECHANICAL KEYBIND
            -- ==========================================
            function sectionSelf:CreateKeybind(text, defaultKey, callback)
                local currentKey = defaultKey or Enum.KeyCode.F
                local listening = false
                callback = callback or function() end

                local bindFrame = Instance.new("Frame")
                bindFrame.Size = UDim2.new(1, 0, 0, 34)
                bindFrame.BackgroundColor3 = Lucidity.Theme.ElementBg
                bindFrame.Parent = sectionFrame
                Instance.new("UICorner", bindFrame).CornerRadius = UDim.new(0, 6)
                local bs = Instance.new("UIStroke", bindFrame)
                bs.Color = Lucidity.Theme.Border

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -100, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = text or "Keybind Trigger"
                label.TextColor3 = Lucidity.Theme.Text
                label.Font = Lucidity.Theme.Font
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = bindFrame

                local button = Instance.new("TextButton")
                button.Size = UDim2.new(0, 70, 0, 22)
                button.Position = UDim2.new(1, -82, 0.5, -11)
                button.BackgroundColor3 = Lucidity.Theme.WindowBg
                button.Text = currentKey.Name
                button.TextColor3 = Lucidity.Theme.Accent
                button.Font = Lucidity.Theme.FontBold
                button.TextSize = 11
                button.Parent = bindFrame
                Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)
                Instance.new("UIStroke", button).Color = Lucidity.Theme.Border

                button.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    button.Text = "..."
                    button.TextColor3 = Lucidity.Theme.MutedText
                end)

                table.insert(windowSelf.Connections, UserInputService.InputBegan:Connect(function(input, processed)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        currentKey = input.KeyCode
                        button.Text = currentKey.Name
                        button.TextColor3 = Lucidity.Theme.Accent
                    elseif not processed and input.KeyCode == currentKey then
                        task.spawn(callback, currentKey)
                    end
                end))
            end

            -- ==========================================
            -- EXPANSION: HSV RGB MATRIX COLOR PICKER
            -- ==========================================
            function sectionSelf:CreateColorPicker(text, defaultColor, callback)
                local open = false
                local color = defaultColor or Color3.fromRGB(0, 162, 255)
                local h, s, v = color:ToHSV()
                callback = callback or function() end

                local pickerFrame = Instance.new("Frame")
                pickerFrame.Size = UDim2.new(1, 0, 0, 34)
                pickerFrame.BackgroundColor3 = Lucidity.Theme.ElementBg
                pickerFrame.ClipsDescendants = true
                pickerFrame.Parent = sectionFrame
                Instance.new("UICorner", pickerFrame).CornerRadius = UDim.new(0, 6)
                local ps = Instance.new("UIStroke", pickerFrame)
                ps.Color = Lucidity.Theme.Border

                local trigger = Instance.new("TextButton")
                trigger.Size = UDim2.new(1, 0, 0, 34)
                trigger.BackgroundTransparency = 1
                trigger.Text = ""
                trigger.Parent = pickerFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -60, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = text or "Color Matrix"
                label.TextColor3 = Lucidity.Theme.Text
                label.Font = Lucidity.Theme.Font
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = trigger

                local displayBox = Instance.new("Frame")
                displayBox.Size = UDim2.new(0, 24, 0, 16)
                displayBox.Position = UDim2.new(1, -36, 0.5, -8)
                displayBox.BackgroundColor3 = color
                displayBox.Parent = trigger
                Instance.new("UICorner", displayBox).CornerRadius = UDim.new(0, 3)
                Instance.new("UIStroke", displayBox).Color = Lucidity.Theme.Border

                -- Saturated HSV Color Canvas Assembly
                local satCanvas = Instance.new("ImageButton")
                satCanvas.Size = UDim2.new(0, 150, 0, 100)
                satCanvas.Position = UDim2.new(0, 12, 0, 42)
                satCanvas.Image = "rbxassetid://4155801251" -- Engine canvas gradient string asset
                satCanvas.Parent = pickerFrame

                local cursor = Instance.new("Frame")
                cursor.Size = UDim2.new(0, 6, 0, 6)
                cursor.Position = UDim2.new(s, -3, 1 - v, -3)
                cursor.BackgroundColor3 = Color3.new(1, 1, 1)
                cursor.Parent = satCanvas
                Instance.new("UICorner", cursor).CornerRadius = UDim.new(1, 0)

                -- Dynamic Rainbow Spectrum Hue Rail
                local hueSlider = Instance.new("ImageButton")
                hueSlider.Size = UDim2.new(1, -190, 0, 100)
                hueSlider.Position = UDim2.new(0, 174, 0, 42)
                hueSlider.Image = "rbxassetid://3641079629"
                hueSlider.Parent = pickerFrame

                local hueBar = Instance.new("Frame")
                hueBar.Size = UDim2.new(1, 0, 0, 2)
                hueBar.Position = UDim2.new(0, 0, h, 0)
                hueBar.BackgroundColor3 = Color3.new(1, 1, 1)
                hueBar.BorderSizePixel = 0
                hueBar.Parent = hueSlider

                local draggingHue = false
                local draggingSat = false

                local function updateColor()
                    color = Color3.fromHSV(h, s, v)
                    displayBox.BackgroundColor3 = color
                    task.spawn(callback, color)
                end

                hueSlider.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = true end
                end)
                satCanvas.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSat = true end
                end)

                table.insert(windowSelf.Connections, UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingHue = false
                        draggingSat = false
                    end
                end))

                table.insert(windowSelf.Connections, UserInputService.InputChanged:Connect(function(i)
                    if draggingHue and i.UserInputType == Enum.UserInputType.MouseMovement then
                        h = math.clamp((i.Position.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
                        hueBar.Position = UDim2.new(0, 0, h, 0)
                        updateColor()
                    elseif draggingSat and i.UserInputType == Enum.UserInputType.MouseMovement then
                        s = math.clamp((i.Position.X - satCanvas.AbsolutePosition.X) / satCanvas.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp((i.Position.Y - satCanvas.AbsolutePosition.Y) / satCanvas.AbsoluteSize.Y, 0, 1)
                        cursor.Position = UDim2.new(s, -3, 1 - v, -3)
                        updateColor()
                    end
                end))

                trigger.MouseButton1Click:Connect(function()
                    open = not open
                    local targetHeight = open and 152 or 34
                    local t = animate(pickerFrame, 0.15, {Size = UDim2.new(1, 0, 0, targetHeight)})
                    
                    local pickerConnection
                    pickerConnection = pickerFrame:GetPropertyChangedSignal("Size"):Connect(function()
                        sectionFrame.Size = UDim2.new(1, 0, 0, secLayout.AbsoluteContentSize.Y + 44)
                        recalculateCanvas()
                    end)
                    t.Completed:Connect(function()
                        if pickerConnection then pickerConnection:Disconnect() end
                        sectionFrame.Size = UDim2.new(1, 0, 0, secLayout.AbsoluteContentSize.Y + 44)
                        recalculateCanvas()
                    end)
                end)
            end

            return sectionSelf
        end

        return tabSelf
    end

    -- Complete Module Memory Cleanup Lifecycle
    function windowSelf:Destroy()
        if windowSelf.Closed then return end
        windowSelf.Closed = true
        for _, c in pairs(windowSelf.Connections) do if c then c:Disconnect() end end
        screenGui:Destroy()
    end

    return windowSelf
end

return Lucidity
