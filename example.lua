local Lucidity = loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/main.lua"))()

local Hub = Lucidity:CreateWindow({
    Name = "Lucidity Minimal"
})

local Combat = Hub:CreateTab("Combat", "combat")
local Player = Hub:CreateTab("Player", "home")

Combat:CreateSection("Target Settings")
Combat:CreateToggle({ Name = "Silent Aim Assist", Default = false }, function(state)
    print("Aim state: ", state)
end)

Player:CreateSection("Physical Attributes")
Player:CreateSlider({
    Name = "WalkSpeed Modifier",
    Min = 16,
    Max = 150,
    Default = 16,
    Suffix = " studs"
}, function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)
