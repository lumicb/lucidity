-- notifications.lua
local TweenService = game:GetService("TweenService")

local NotificationEngine = {}
NotificationEngine.__index = NotificationEngine

-- Helper configuration that links back to your core design architecture
local Theme = {
    CardBackground = Color3.fromRGB(30, 31, 38),
    Border = Color3.fromRGB(42, 44, 54),
    Text = Color3.fromRGB(242, 244, 247),
    MutedText = Color3.fromRGB(138, 143, 154),
}

function NotificationEngine.new(screenGui)
    local self = setmetatable({}, NotificationEngine)
    self.ScreenGui = screenGui
    self.NotifContainer = nil
    return self
end

function NotificationEngine:Notify(config)
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 3
    
    -- Lazily instantiate container only when a notification is triggered
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

    -- Create Toast Frame (Initial Height 0 for entrance slide/grow effect)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.BackgroundColor3 = Theme.CardBackground
    card.ClipsDescendants = true
    card.Parent = self.NotifContainer
    
    local corner = Instance.new("UICorner", card)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Theme.Border

    -- Toast Components
    local lblTitle = Instance.new("TextLabel")
    lblTitle.Size = UDim2.new(1, -24, 0, 24)
    lblTitle.Position = UDim2.new(0, 12, 0, 6)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = title
    lblTitle.TextColor3 = Theme.Text
    lblTitle.Font = Enum.Font.GothamBold
    lblTitle.TextSize = 13
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left
    lblTitle.Parent = card

    local lblContent = Instance.new("TextLabel")
    lblContent.Size = UDim2.new(1, -24, 1, -36)
    lblContent.Position = UDim2.new(0, 12, 0, 30)
    lblContent.BackgroundTransparency = 1
    lblContent.Text = content
    lblContent.TextColor3 = Theme.MutedText
    lblContent.Font = Enum.Font.GothamMedium
    lblContent.TextSize = 11
    lblContent.TextWrapped = true
    lblContent.TextXAlignment = Enum.TextXAlignment.Left
    lblContent.TextYAlignment = Enum.TextYAlignment.Top
    lblContent.Parent = card

    -- Smooth Entrance Animation
    TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 75)
    }):Play()
    
    -- Non-blocking thread handling the lifecycle cleanup
    task.delay(duration, function()
        if card and card.Parent then
            local fadeOut = TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(1, 0, 0, 0), 
                BackgroundTransparency = 1
            })
            fadeOut:Play()
            fadeOut.Completed:Connect(function() 
                card:Destroy() 
            end)
        end
    end)
end

return NotificationEngine
