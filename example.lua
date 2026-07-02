-- 1. Grab the factory engine from your GitHub
local Lucidity = loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/main.lua"))()

-- 2. Tell the engine to build your beautiful gradient window!
local Window = Lucidity:CreateWindow({
    Name = "Lucidity Testing"
})

-- 3. Tell the window to make a tab
local MainTab = Window:CreateTab("Main Features", "home")

-- 4. Put a section and a button inside that tab
MainTab:CreateSection("Automation")

MainTab:CreateButton({
    Name = "Test Click Effect",
    Interact = "Press"
}, function()
    print("The button works!")
end)

MainTab:CreateToggle({
    Name = "Test Toggle Switch",
    Default = false
}, function(state)
    print("Toggle is now: ", state)
end)
