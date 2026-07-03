# Lucidity
A Library focused on helping you setup your script in a nice modern UI!                                      
You can change the DPI (GUI Size) in the settings tab!                            
Themes soon 👀                                                                      
                                                              
Mobile Support aswell!

## How to set up Lucidity UI

### 1. Importing the library                                                                            
   you can use this loadstring bellow, and put it into your compiler/executor and it will load the library
``` lua
local Lucidity = loadstring(game:HttpGet("https://raw.githubusercontent.com/lumicb/lucidity/refs/heads/main/main.lua"))()
```

### 2. Window Setup                                                                                      
   To set up the window you first need to paste the block of code below into your compiler/executor
   This will load the UI with no tabs other than the settings tab.
```lua
local Window = Lucidity:CreateWindow({
    Name = "Lucidity Example Script",
    ConfigName = "Lucidity_Example.json",
    KeySystem = true,
    Key = "example"
})
```
### 3. Tabs / Sections                                                                                              
   To make a new tab you have to add the block of code bellow to your current
   ```lua
local MainTab = Window:CreateTab("ExampleTab", "")
   ```
   The current icons do not work ( sorry :< )

   To make a new section for your tab you need to include this:
  ```lua
ExampleTab:CreateSection("Example")
  ```

### 4. Elements

Lucidity currently supports the following UI elements:

* **Buttons** — Run code when clicked
* **Toggles** — Enable or disable features
* **Sliders** — Select a value between a minimum and maximum
* **Inputs** — Let users type text
* **Dropdowns** — Choose from a list of options

Each element can be created using the examples below.

---

### Buttons

Buttons execute code when clicked.

```lua
MainTab:CreateButton({
    Name = "Example Button"
}, function()
    Lucidity:Notify({
        Title = "Example",
        Content = "Example text",
        Duration = 2.5
    })
end)
```

---

### Toggles

Toggles allow users to turn features on or off.

```lua
MainTab:CreateToggle({
    Name = "Example Toggle",
    SaveName = "Example_Toggle", -- Unique key for auto-saving
    Default = false
}, function(state)
    _G.Example = state

    if state then
        print("[Lucidity] Example started.")
    else
        print("[Lucidity] Example stopped.")
    end
end)
```

The callback returns a boolean:

* `true` = enabled
* `false` = disabled

---

### Sliders

Sliders let users select a numeric value within a range.

```lua
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Min = 0,
    Max = 100,
    Default = 16
}, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```

The callback returns the selected number.

---

### Inputs

Inputs allow users to enter text.

```lua
MainTab:CreateInput({
    Name = "Target Player",
    Placeholder = "Enter username..."
}, function(text)
    print("User typed: " .. text)
end)
```

The callback returns the entered text.

---

### Dropdowns

Dropdowns let users choose one option from a list.

```lua
MainTab:CreateDropdown({
    Name = "Example Dropdown",
    Options = {"Example1", "Example2", "Example3", "Example4"}
}, function(selectedOption)
    print("Selected option: " .. selectedOption)
end)
```

The callback returns the selected option as a string.
