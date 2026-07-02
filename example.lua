local Lucidity = loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/main.lua"))()

local UI = Lucidity:CreateWindow({
    Name = "Lucidity Hub"
})

-- Build out test arrays
local Movement = UI:CreateTab("Movement", "home")
local Combat = UI:CreateTab("Combat", "combat")

Movement:CreateSection("Speeds")
Movement:CreateButton({ Name = "Fly Hack (Toggle)" }, function() print("Flying") end)
Movement:CreateButton({ Name = "Infinite Jump" }, function() print("Jumping") end)

Combat:CreateSection("Targeters")
Combat:CreateButton({ Name = "Silent Aim Assist" }, function() print("Aiming") end)
Combat:CreateButton({ Name = "Kill Aura Trigger" }, function() print("Slaying") end)
