-- elements.lua
local Elements = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function Elements.new(tabObject, pageContainer, theme)
    
    -- ====================================================================
    -- 1. SECTION
    -- ====================================================================
    function tabObject:CreateSection(sectionText)
        self.ComponentCount = self.ComponentCount + 1
        
        local sLabel = Instance.new("TextLabel")
        sLabel.Size = UDim2.new(1, 0, 0, 24)
        sLabel.BackgroundTransparency = 1
        sLabel.Text = string.upper(sectionText)
        sLabel.TextColor3 = theme.MutedText
        sLabel.Font = theme.Font or Enum.Font.GothamBold
        sLabel.TextSize = 10
        sLabel.TextXAlignment = Enum.TextXAlignment.Left
        sLabel.LayoutOrder = self.ComponentCount
        sLabel.Parent = pageContainer
        
        local padding = Instance.new("UIPadding", sLabel)
        padding.PaddingLeft = UDim.new(0, 4)
        
        return sLabel
    end

    -- ====================================================================
    -- 2. BUTTON
    -- ====================================================================
    function tabObject:CreateButton(config, callback)
        self.ComponentCount = self.ComponentCount + 1
        
        local btnFrame = Instance.new("TextButton")
        btnFrame.Size = UDim2.new(1, 0, 0, 40)
        btnFrame.BackgroundColor3 = theme.CardBackground
        btnFrame.Text = ""
        btnFrame.LayoutOrder = self.ComponentCount
        btnFrame.Parent = pageContainer
        
        local corner = Instance.new("UICorner", btnFrame)
        corner.CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", btnFrame)
        stroke.Color = theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -24, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = config.Name or "Button"
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font or Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = btnFrame

        -- Click Interaction
        btnFrame.MouseButton1Click:Connect(function()
            task.spawn(callback or function() end)
        end)
        
        return btnFrame
    end

    -- ====================================================================
    -- 3. TOGGLE
    -- ====================================================================
    function tabObject:CreateToggle(config, callback)
        self.ComponentCount = self.ComponentCount + 1
        local state = config.Default or false
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 40)
        toggleFrame.BackgroundColor3 = theme.CardBackground
        toggleFrame.LayoutOrder = self.ComponentCount
        toggleFrame.Parent = pageContainer
        
        local corner = Instance.new("UICorner", toggleFrame)
        corner.CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", toggleFrame)
        stroke.Color = theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = config.Name or "Toggle"
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font or Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = toggleFrame

        local switch = Instance.new("TextButton")
        switch.Size = UDim2.new(0, 36, 0, 20)
        switch.Position = UDim2.new(1, -48, 0.5, -10)
        switch.BackgroundColor3 = state and theme.Active or theme.WindowBg
        switch.Text = ""
        switch.Parent = toggleFrame
        
        local sCorner = Instance.new("UICorner", switch)
        sCorner.CornerRadius = UDim.new(1, 0)
        local sStroke = Instance.new("UIStroke", switch)
        sStroke.Color = theme.Border

        switch.MouseButton1Click:Connect(function()
            state = not state
            switch.BackgroundColor3 = state and theme.Active or theme.WindowBg
            task.spawn(callback or function() end, state)
        end)
        
        return toggleFrame
    end

    -- ====================================================================
    -- 4. SLIDER
    -- ====================================================================
    function tabObject:CreateSlider(config, callback)
        self.ComponentCount = self.ComponentCount + 1
        local min = config.Min or 0
        local max = config.Max or 100
        local default = config.Default or min
        local value = math.clamp(default, min, max)

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.BackgroundColor3 = theme.CardBackground
        sliderFrame.LayoutOrder = self.ComponentCount
        sliderFrame.Parent = pageContainer
        
        local corner = Instance.new("UICorner", sliderFrame)
        corner.CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", sliderFrame)
        stroke.Color = theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -24, 0, 26)
        lbl.Position = UDim2.new(0, 12, 0, 4)
        lbl.BackgroundTransparency = 1
        lbl.Text = config.Name or "Slider"
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font or Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = sliderFrame

        local valueLbl = Instance.new("TextLabel")
        valueLbl.Size = UDim2.new(0, 50, 0, 26)
        valueLbl.Position = UDim2.new(1, -62, 0, 4)
        valueLbl.BackgroundTransparency = 1
        valueLbl.Text = tostring(value)
        valueLbl.TextColor3 = theme.MutedText
        valueLbl.Font = theme.Font or Enum.Font.Gotham
        valueLbl.TextSize = 12
        valueLbl.TextXAlignment = Enum.TextXAlignment.Right
        valueLbl.Parent = sliderFrame

        local track = Instance.new("TextButton")
        track.Size = UDim2.new(1, -24, 0, 6)
        track.Position = UDim2.new(0, 12, 1, -14)
        track.BackgroundColor3 = theme.WindowBg
        track.Text = ""
        track.Parent = sliderFrame
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = theme.Active
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local isDragging = false

        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (pos * (max - min)))
            fill.Size = UDim2.new(pos, 0, 1, 0)
            valueLbl.Text = tostring(value)
            task.spawn(callback or function() end, value)
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true
                updateSlider(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)
        
        return sliderFrame
    end

    -- ====================================================================
    -- 5. INPUT
    -- ====================================================================
    function tabObject:CreateInput(config, callback)
        self.ComponentCount = self.ComponentCount + 1
        
        local inputFrame = Instance.new("Frame")
        inputFrame.Size = UDim2.new(1, 0, 0, 40)
        inputFrame.BackgroundColor3 = theme.CardBackground
        inputFrame.LayoutOrder = self.ComponentCount
        inputFrame.Parent = pageContainer
        
        local corner = Instance.new("UICorner", inputFrame)
        corner.CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", inputFrame)
        stroke.Color = theme.Border

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = config.Name or "Input"
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font or Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = inputFrame

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.4, 0, 0, 24)
        box.Position = UDim2.new(1, -172, 0.5, -12)
        box.BackgroundColor3 = theme.WindowBg
        box.Text = ""
        box.PlaceholderText = config.Placeholder or "Type here..."
        box.TextColor3 = theme.Text
        box.PlaceholderColor3 = theme.MutedText
        box.Font = theme.Font or Enum.Font.Gotham
        box.TextSize = 12
        box.ClearTextOnFocus = false
        box.Parent = inputFrame
        
        local bCorner = Instance.new("UICorner", box)
        bCorner.CornerRadius = UDim.new(0, 6)
        local bStroke = Instance.new("UIStroke", box)
        bStroke.Color = theme.Border

        box.FocusLost:Connect(function(enterPressed)
            task.spawn(callback or function() end, box.Text, enterPressed)
        end)
        
        return inputFrame
    end

    -- ====================================================================
    -- 6. DROPDOWN
    -- ====================================================================
    function tabObject:CreateDropdown(config, callback)
        self.ComponentCount = self.ComponentCount + 1
        local options = config.Options or {}
        local isOpen = false
        
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(1, 0, 0, 40) -- Changes height dynamically when open
        dropdownFrame.BackgroundColor3 = theme.CardBackground
        dropdownFrame.ClipsDescendants = true
        dropdownFrame.LayoutOrder = self.ComponentCount
        dropdownFrame.Parent = pageContainer
        
        local corner = Instance.new("UICorner", dropdownFrame)
        corner.CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", dropdownFrame)
        stroke.Color = theme.Border

        local headerBtn = Instance.new("TextButton")
        headerBtn.Size = UDim2.new(1, 0, 0, 40)
        headerBtn.BackgroundTransparency = 1
        headerBtn.Text = ""
        headerBtn.Parent = dropdownFrame

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = config.Name or "Dropdown"
        lbl.TextColor3 = theme.Text
        lbl.Font = theme.Font or Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = headerBtn

        local indicator = Instance.new("TextLabel")
        indicator.Size = UDim2.new(0, 24, 0, 24)
        indicator.Position = UDim2.new(1, -36, 0.5, -12)
        indicator.BackgroundTransparency = 1
        indicator.Text = "▼"
        indicator.TextColor3 = theme.MutedText
        indicator.Font = Enum.Font.Gotham
        indicator.TextSize = 10
        indicator.Parent = headerBtn

        local optionContainer = Instance.new("Frame")
        optionContainer.Size = UDim2.new(1, -24, 0, #options * 30)
        optionContainer.Position = UDim2.new(0, 12, 0, 40)
        optionContainer.BackgroundTransparency = 1
        optionContainer.Parent = dropdownFrame
        
        local oLayout = Instance.new("UIListLayout", optionContainer)
        oLayout.SortOrder = Enum.SortOrder.LayoutOrder
        oLayout.Padding = UDim.new(0, 4)

        for i, optionName in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 26)
            optBtn.BackgroundColor3 = theme.WindowBg
            optBtn.Text = optionName
            optBtn.TextColor3 = theme.Text
            optBtn.Font = theme.Font or Enum.Font.Gotham
            optBtn.TextSize = 11
            optBtn.LayoutOrder = i
            optBtn.Parent = optionContainer
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)
            
            optBtn.MouseButton1Click:Connect(function()
                isOpen = false
                dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
                indicator.Text = "▼"
                lbl.Text = (config.Name or "Dropdown") .. " (" .. optionName .. ")"
                task.spawn(callback or function() end, optionName)
            end)
        end

        headerBtn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            if isOpen then
                dropdownFrame.Size = UDim2.new(1, 0, 0, 45 + (#options * 30))
                indicator.Text = "▲"
            else
                dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
                indicator.Text = "▼"
            end
        end)
        
        return dropdownFrame
    end

end

return Elements
