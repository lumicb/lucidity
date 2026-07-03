-- Load Library
local Lucidity = loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/main.lua"))()

-- Create Window
local Window = Lucidity:CreateWindow({
    Name = "Lucidity Example Script",
    ConfigName = "Lucidity_Example.json",
    KeySystem = false,
    Key = "example"
})

-- Create Tab
local MainTab = Window:CreateTab("Main", "")

-- Create Section
MainTab:CreateSection("Examples")

--------------------------------------------------
-- Toggle Example
--------------------------------------------------
MainTab:CreateToggle({
    Name = "Example Toggle",
    SaveName = "Example_Toggle",
    Default = false
}, function(state)
    _G.ExampleToggle = state

    if state then
        print("[Lucidity] Toggle enabled.")
    else
        print("[Lucidity] Toggle disabled.")
    end
end)

--------------------------------------------------
-- Button Example
--------------------------------------------------
MainTab:CreateButton({
    Name = "Example Button"
}, function()
    Lucidity:Notify({
        Title = "Button Clicked",
        Content = "You clicked the example button!",
        Duration = 2.5
    })
end)

--------------------------------------------------
-- Slider Example
--------------------------------------------------
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Min = 0,
    Max = 100,
    Default = 16
}, function(value)
    local player = game.Players.LocalPlayer
    local character = player.Character

    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = value
    end
end)

--------------------------------------------------
-- Input Example
--------------------------------------------------
MainTab:CreateInput({
    Name = "Target Player",
    Placeholder = "Enter username..."
}, function(text)
    print("[Lucidity] Input:", text)
end)

--------------------------------------------------
-- Dropdown Example
--------------------------------------------------
MainTab:CreateDropdown({
    Name = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3"}
}, function(selected)
    print("[Lucidity] Selected:", selected)
end)

-- Final Notification
Lucidity:Notify({
    Title = "Lucidity Loaded",
    Content = "Example script loaded successfully!",
    Duration = 4
})
