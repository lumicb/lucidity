-- notifications.lua
local Notifications = {}
local TweenService = game:GetService("TweenService")

local notifGui = Instance.new("ScreenGui")
notifGui.Name = "Lucidity_Notifications"
notifGui.Parent = game:GetService("CoreGui") -- or Players.LocalPlayer.PlayerGui

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 300, 1, -40)
container.Position = UDim2.new(1, -320, 0, 20)
container.BackgroundTransparency = 1
container.Parent = notifGui

local layout = Instance.new("UIListLayout", container)
layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)

function Notifications:Notify(title, text, duration)
    duration = duration or 5
    -- Create your frame, animate it sliding in from the right, 
    -- then use task.delay(duration) to fade it out and :Destroy() it!
end

return Notifications
