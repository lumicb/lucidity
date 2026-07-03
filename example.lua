-- Library
local Lucidity = loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/main.lua"))()

-- Main Window
local Window = Lucidity:CreateWindow({
    Name = "Lucidity Example Script", -- Name
    ConfigName = "Lucidity_Example.json", -- Config Name
    KeySystem = false, -- Set to true if you want to require a key
    Key = "example" -- The password string if KeySystem is true
})

-- 3. Create the Main / Tabs / Elements
local MainTab = Window:CreateTab("Example", "")

MainTab:CreateSection("Example")

MainTab:CreateToggle({
    Name = "Example Toggle",
    SaveName = "Example_Toggle", -- Unique key for auto-saving
    Default = false
}, function(state)
    _G.Example = state
    if state then
        print("[Lucidity] Example Started.")
    else
        print("[Lucidity] Example Stopped.")
    end
end)

MainTab:CreateButton({
    Name = "Example Button"
}, function()
    Lucidity:Notify({
        Title = "Example",
        Content = "Example text",
        Duration = 2.5
    })
end)

-- 5. Send a confirmation toast that the script finished executing
Lucidity:Notify({
    Title = "Script Finished Executing!",
    Content = "Script is running smoothly!",
    Duration = 4
})
