local Lucidity = loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/main.lua"))()

-- Initializing layout with a functional configuration and verification key
local Hub = Lucidity:CreateWindow({
    Name = "Lucidity Custom System",
    KeySystem = true,
    Key = "lucidity123",
    ConfigName = "LucidityProfile.json"
})

local Combat = Hub:CreateTab("Combat", "combat")

Combat:CreateSection("Interactive Modules")

Combat:CreateButton({ Name = "Execute Instakill Hitbox" }, function()
    -- Fire a finished task notification cleanly
    Hub:Notify({
        Title = "Module Fired",
        Content = "Hitbox expansion sequence compiled successfully.",
        Duration = 4
    })
end)

Combat:CreateToggle({ Name = "Auto-Parry Active", Default = false, SaveName = "Parry_State" }, function(state)
    print("Parry toggle state updated: ", state)
end)

Combat:CreateSlider({ Name = "Proximity Limit Reach", Min = 5, Max = 50, Default = 15, Suffix = " studs", SaveName = "Prox_Limit" }, function(val)
    print("Slider value shifted: ", val)
end)

Combat:CreateInput({ Name = "Webhook Status Target", Placeholder = "URL Destination..." }, function(text, enterPressed)
    if enterPressed then
        print("Target dynamic text updated: ", text)
    end
end)

Combat:CreateDropdown({ Name = "Target Scan Selection", Options = {"Nearest Distance", "Lowest Health", "Priority Hostile"} }, function(selected)
    print("Dropdown choice picked: ", selected)
end)
