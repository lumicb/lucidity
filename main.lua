local Lucidity = {}
Lucidity.__index = Lucidity

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

-- 🔳 PREMIUM RAYFIELD-INSPIRED MONOCHROME THEME
Lucidity.Theme = {
    WindowBg = Color3.fromRGB(18, 19, 22),          -- Deep charcoal canvas background
    Sidebar = Color3.fromRGB(26, 27, 32),           -- Structured sidebar surface
    CardBackground = Color3.fromRGB(32, 33, 40),    -- Elevated panel containers
    Border = Color3.fromRGB(44, 46, 56),            -- Distinct structural grid-lines
    Text = Color3.fromRGB(240, 242, 245),           -- High contrast crisp text
    MutedText = Color3.fromRGB(140, 145, 155),      -- Balanced secondary details
    Active = Color3.fromRGB(255, 255, 255),         -- Pure white interactive highlights
    Font = Enum.Font.GothamMedium
}

local Icons = {
    home = "rbxassetid://10734951102",
    settings = "rbxassetid://10734950309",
    combat = "rbxassetid://10747360634",
    search = "rbxassetid://10734950791",
    window = "rbxassetid://10723343385",
    notify = "rbxassetid://10734951102",
    chevron = "rbxassetid://10734896828"
}

-- 🔔 NOTIFICATION SYSTEM ENGINE
function Lucidity:Notify(config)
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 3
    
    if not self.NotifContainer then
        local notifContainer = Instance.new("Frame")
        notifContainer.Name = "LucidityNotifications"
        notifContainer.Size = UDim2.new(0, 300, 1, -40)
        notifContainer.Position = UDim2.new(1, -320, 0, 20)
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
    lblTitle.Size = UDim2.new(1, -20, 0, 24)
    lblTitle.Position = UDim2.new(0, 10, 0, 6)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = title
    lblTitle.TextColor3 = self.Theme.Text
    lblTitle.Font = Enum.Font.GothamBold
    lblTitle.TextSize = 13
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left
    lblTitle.Parent = card

    local lblContent = Instance.new("TextLabel")
    lblContent.Size = UDim2.new(1, -20, 1, -36)
    lblContent.Position = UDim2.new(0, 10, 0, 30)
    lblContent.BackgroundTransparency = 1
    lblContent.Text = content
    lblContent.TextColor3 = self.Theme.MutedText
    lblContent.Font = self.Theme.Font
    lblContent.TextSize = 12
    lblContent.TextWrapped = true
    lblContent.TextXAlignment = Enum.TextXAlignment.Left
    lblContent.TextYAlignment = Enum.TextYAlignment.Top
    lblContent.Parent = card

    TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 75)}):Play()
    
    task.delay(duration, function()
        local t = TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        t:Play()
        t.Completed:Connect(function() card:Destroy() end)
    end)
end

function Lucidity:CreateWindow(config)
    local config = config or {}
    local windowName = config.Name or "Lucidity Hub"
    local hasKeySystem = config.KeySystem or false
    local validKey = config.Key or ""
    
    local self = setmetatable({}, Lucidity)
    self.Elements = {}
    self.ConfigData = {}
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Lucidity_" .. HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = screenGui

    -- 🔑 BUILT-IN SECURE KEY GATEWAY SYSTEM
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
        kTitle.Text = "Key Authentication Required"
        kTitle.TextColor3 = self.Theme.Text
        kTitle.Font = Enum.Font.GothamBold
        kTitle.TextSize = 14
        kTitle.Parent = keyWindow

        local kInput = Instance.new("TextBox")
        kInput.Size = UDim2.new(1, -40, 0, 36)
        kInput.Position = UDim2.new(0, 20, 0, 55)
        kInput.BackgroundColor3 = self.Theme.CardBackground
        kInput.PlaceholderText = "Enter verification key..."
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
            else
                kInput.Text = ""
                kInput.PlaceholderText = "Incorrect Key! Try again."
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
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)
    
    local uiScale = Instance.new("UIScale")
    uiScale.Parent = mainFrame
    self.UIScale = uiScale
    Instance.new("UIStroke", mainFrame).Color = self.Theme.Border

    -- Drag Execution Bar
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

    -- Sidebar Container
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 180, 1, -66)
    sidebar.Position = UDim2.new(0, 12, 0, 54)
    sidebar.BackgroundColor3 = self.Theme.Sidebar
    sidebar.Parent = mainFrame
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", sidebar).Color = self.Theme.Border

    local sLayout = Instance.new("UIListLayout")
    sLayout.Padding = UDim.new(0, 4)
    sLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sLayout.Parent = sidebar
    Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 12)

    -- Dynamic Dashboard Frame
    local mainDisplay = Instance.new("Frame")
    mainDisplay.Size = UDim2.new(1, -216, 1, -66)
    mainDisplay.Position = UDim2.new(0, 204, 0, 54)
    mainDisplay.BackgroundColor3 = self.Theme.Sidebar
    mainDisplay.Parent = mainFrame
    Instance.new("UICorner", mainDisplay).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", mainDisplay).Color = self.Theme.Border

    self.Pages = Instance.new("Folder", mainDisplay)
    self:EnableDragging()
end

function Lucidity:EnableDragging()
    local dragHandle = self.TopBar
    local gui = self.MainFrame
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = gui.Position
        end
    end)
Normally I can help with things like this, but I don't seem to have access to that content. You can try again or ask me for something else.
