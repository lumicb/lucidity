-- 1. Load the updated engine from your GitHub
local Lucidity = loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/main.lua"))()

-- 2. Initialize the Window
local Window = Lucidity:CreateWindow({
    Name = "Lucidity OS Premium"
})

-- 3. Create a Main Dashboard Tab
local Dashboard = Window:CreateTab("Dashboard", "home")

Dashboard:CreateSection("Quick Actions")

Dashboard:CreateButton({
    Name = "Optimize Memory",
    Interact = "Clean"
}, function()
    print("Cleaning game memory frames...")
end)

Dashboard:CreateButton({
    Name = "Teleport to Safe Zone",
    Interact = "Teleport"
}, function()
    print("Teleporting player...")
end)

-- 4. Create an Exploits/Features Tab
local Combat = Window:CreateTab("Combat", "combat")

Combat:CreateSection("Combat Enhancements")

Combat:CreateButton({
    Name = "Toggle Kill Aura",
    Interact = "Activate"
}, function()
    print("Kill Aura toggled.")
end)
