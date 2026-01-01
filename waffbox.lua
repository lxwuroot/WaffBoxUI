--[[
    WaffBox UI Library
    Executor-ready, logic-free UI framework
    Dark modern style inspired by WaffBox

    Usage:
    local WaffBox = loadstring(game:HttpGet("URL"))()
    local Win = WaffBox:CreateWindow("WaffBox Hub | Universal")
    local Player = Win:CreateTab("Player")

    Player:Slider("Walk Speed", 0, 200, 16, function(v)
        print(v)
    end)

    Player:Toggle("Infinite Jump", function(v)
        print(v)
    end)
]]

local WaffBox = {}

-- // Services
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- // Theme
local Theme = {
    Background = Color3.fromRGB(22,22,22),
    Panel = Color3.fromRGB(28,28,28),
    Stroke = Color3.fromRGB(40,40,40),
    Accent = Color3.fromRGB(70,140,255),
    Text = Color3.fromRGB(235,235,235),
    SubText = Color3.fromRGB(170,170,170)
}

-- // Utils
local function round(num, br)
    br = br or 1
    return math.floor(num/br + 0.5) * br
end

local function dragify(frame, top)
    local dragging, dragStart, startPos

    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- // Window
function WaffBox:CreateWindow(title)
    title = title or "WaffBox UI"

    if game.CoreGui:FindFirstChild("WaffBoxUI") then
        game.CoreGui.WaffBoxUI:Destroy()
    end

    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "WaffBoxUI"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromOffset(520, 420)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.BackgroundColor3 = Theme.Background
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1,0,0,42)
    top.BackgroundColor3 = Theme.Panel
    top.BorderSizePixel = 0
    Instance.new("UICorner", top).CornerRadius = UDim.new(0,14)

    local titleLabel = Instance.new("TextLabel", top)
    titleLabel.Size = UDim2.new(1,-20,1,0)
    titleLabel.Position = UDim2.new(0,10,0,0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 15
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextXAlignment = Left

    dragify(main, top)

    local tabBar = Instance.new("Frame", main)
    tabBar.Position = UDim2.new(0,10,0,52)
    tabBar.Size = UDim2.new(1,-20,0,32)
    tabBar.BackgroundTransparency = 1

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Horizontal
    tabLayout.Padding = UDim.new(0,8)

    local pages = Instance.new("Frame", main)
    pages.Position = UDim2.new(0,10,0,92)
    pages.Size = UDim2.new(1,-20,1,-102)
    pages.BackgroundTransparency = 1

    local window = {}
    local currentTab

    function window:CreateTab(name)
        local tabButton = Instance.new("TextButton", tabBar)
        tabButton.Size = UDim2.fromOffset(90,32)
        tabButton.Text = name
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 13
        tabButton.TextColor3 = Theme.SubText
        tabButton.BackgroundColor3 = Theme.Panel
        tabButton.BorderSizePixel = 0
        Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0,10)

        local page = Instance.new("ScrollingFrame", pages)
        page.Size = UDim2.new(1,0,1,0)
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.ScrollBarImageTransparency = 1
        page.Visible = false
        page.BackgroundTransparency = 1

        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0,10)

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
        end)

        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.page.Visible = false
                currentTab.button.TextColor3 = Theme.SubText
            end
            currentTab = {page = page, button = tabButton}
            page.Visible = true
            tabButton.TextColor3 = Theme.Text
        end)

        if not currentTab then
            tabButton.MouseButton1Click:Fire()
        end

        local tab = {}

        function tab:Slider(text, min, max, default, callback)
            default = default or min

            local holder = Instance.new("Frame", page)
            holder.Size = UDim2.new(1,0,0,56)
            holder.BackgroundColor3 = Theme.Panel
            holder.BorderSizePixel = 0
            Instance.new("UICorner", holder).CornerRadius = UDim.new(0,10)

            local lbl = Instance.new("TextLabel", holder)
            lbl.Position = UDim2.new(0,12,0,8)
            lbl.Size = UDim2.new(1,-24,0,16)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 13
            lbl.TextColor3 = Theme.Text
            lbl.TextXAlignment = Left

            local bar = Instance.new("Frame", holder)
            bar.Position = UDim2.new(0,12,0,32)
            bar.Size = UDim2.new(1,-24,0,10)
            bar.BackgroundColor3 = Color3.fromRGB(40,40,40)
            bar.BorderSizePixel = 0
            Instance.new("UICorner", bar).CornerRadius = UDim.new(0,6)

            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
            fill.BackgroundColor3 = Theme.Accent
            fill.BorderSizePixel = 0
            Instance.new("UICorner", fill).CornerRadius = UDim.new(0,6)

            local valLabel = Instance.new("TextLabel", holder)
            valLabel.Position = UDim2.new(1,-60,0,6)
            valLabel.Size = UDim2.fromOffset(48,20)
            valLabel.BackgroundColor3 = Theme.Accent
            valLabel.TextColor3 = Color3.new(1,1,1)
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextSize = 12
            valLabel.Text = tostring(default)
            valLabel.BorderSizePixel = 0
            Instance.new("UICorner", valLabel).CornerRadius = UDim.new(0,8)

            local dragging = false

            bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UIS.InputChanged:Connect(function(i)
                if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local pct = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    local val = round(min + (max-min) * pct)
                    fill.Size = UDim2.new(pct,0,1,0)
                    valLabel.Text = tostring(val)
                    callback(val)
                end
            end)
        end

        function tab:Toggle(text, callback)
            local holder = Instance.new("Frame", page)
            holder.Size = UDim2.new(1,0,0,46)
            holder.BackgroundColor3 = Theme.Panel
            holder.BorderSizePixel = 0
            Instance.new("UICorner", holder).CornerRadius = UDim.new(0,10)

            local lbl = Instance.new("TextLabel", holder)
            lbl.Position = UDim2.new(0,12,0,0)
            lbl.Size = UDim2.new(1,-80,1,0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 13
            lbl.TextColor3 = Theme.Text
            lbl.TextXAlignment = Left

            local toggle = Instance.new("Frame", holder)
            toggle.Position = UDim2.new(1,-52,0.5,-10)
            toggle.Size = UDim2.fromOffset(40,20)
            toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
            toggle.BorderSizePixel = 0
            Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

            local knob = Instance.new("Frame", toggle)
            knob.Size = UDim2.fromOffset(16,16)
            knob.Position = UDim2.new(0,2,0.5,-8)
            knob.BackgroundColor3 = Color3.new(1,1,1)
            knob.BorderSizePixel = 0
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

            local state = false

            holder.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    state = not state
                    TweenService:Create(knob, TweenInfo.new(0.2), {
                        Position = state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
                    }):Play()
                    TweenService:Create(toggle, TweenInfo.new(0.2), {
                        BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50,50,50)
                    }):Play()
                    callback(state)
                end
            end)
        end

        return tab
    end

    return window
end

return WaffBox
