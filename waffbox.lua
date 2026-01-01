-- WaffBox UI Library
-- Executor Ready | Logic Free

local WaffBox = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- destroy old
pcall(function()
    if game.CoreGui:FindFirstChild("WaffBoxUI") then
        game.CoreGui.WaffBoxUI:Destroy()
    end
end)

-- theme
local Theme = {
    BG = Color3.fromRGB(20,20,20),
    Panel = Color3.fromRGB(28,28,28),
    Accent = Color3.fromRGB(80,150,255),
    Text = Color3.fromRGB(240,240,240),
    Sub = Color3.fromRGB(170,170,170)
}

-- drag
local function drag(frame, top)
    local d, s, p
    top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            d = true
            s = i.Position
            p = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if d and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - s
            frame.Position = UDim2.new(
                p.X.Scale, p.X.Offset + delta.X,
                p.Y.Scale, p.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            d = false
        end
    end)
end

-- window
function WaffBox:CreateWindow(title)
    title = title or "WaffBox UI"

    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "WaffBoxUI"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromOffset(520,420)
    main.Position = UDim2.fromScale(0.5,0.5)
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.BackgroundColor3 = Theme.BG
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

    local top = Instance.new("TextLabel", main)
    top.Size = UDim2.new(1,0,0,40)
    top.BackgroundColor3 = Theme.Panel
    top.Text = "  "..title
    top.TextXAlignment = Left
    top.Font = Enum.Font.GothamBold
    top.TextSize = 14
    top.TextColor3 = Theme.Text
    top.BorderSizePixel = 0
    Instance.new("UICorner", top).CornerRadius = UDim.new(0,14)

    drag(main, top)

    local tabs = Instance.new("Frame", main)
    tabs.Position = UDim2.new(0,10,0,50)
    tabs.Size = UDim2.new(1,-20,0,32)
    tabs.BackgroundTransparency = 1

    local tl = Instance.new("UIListLayout", tabs)
    tl.FillDirection = Horizontal
    tl.Padding = UDim.new(0,8)

    local pages = Instance.new("Frame", main)
    pages.Position = UDim2.new(0,10,0,92)
    pages.Size = UDim2.new(1,-20,1,-102)
    pages.BackgroundTransparency = 1

    local window = {}
    local current

    function window:CreateTab(name)
        local btn = Instance.new("TextButton", tabs)
        btn.Size = UDim2.fromOffset(90,32)
        btn.Text = name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextColor3 = Theme.Sub
        btn.BackgroundColor3 = Theme.Panel
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

        local page = Instance.new("ScrollingFrame", pages)
        page.Size = UDim2.new(1,0,1,0)
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.ScrollBarImageTransparency = 1
        page.Visible = false
        page.BackgroundTransparency = 1

        local lay = Instance.new("UIListLayout", page)
        lay.Padding = UDim.new(0,10)
        lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0,0,0,lay.AbsoluteContentSize.Y + 10)
        end)

        btn.MouseButton1Click:Connect(function()
            if current then
                current.page.Visible = false
                current.btn.TextColor3 = Theme.Sub
            end
            current = {page = page, btn = btn}
            page.Visible = true
            btn.TextColor3 = Theme.Text
        end)

        if not current then btn.MouseButton1Click:Fire() end

        local tab = {}

        function tab:Toggle(text, cb)
            local h = Instance.new("Frame", page)
            h.Size = UDim2.new(1,0,0,46)
            h.BackgroundColor3 = Theme.Panel
            h.BorderSizePixel = 0
            Instance.new("UICorner", h).CornerRadius = UDim.new(0,10)

            local l = Instance.new("TextLabel", h)
            l.Size = UDim2.new(1,-60,1,0)
            l.Position = UDim2.new(0,12,0,0)
            l.Text = text
            l.Font = Enum.Font.Gotham
            l.TextSize = 13
            l.TextXAlignment = Left
            l.TextColor3 = Theme.Text
            l.BackgroundTransparency = 1

            local t = Instance.new("Frame", h)
            t.Size = UDim2.fromOffset(40,20)
            t.Position = UDim2.new(1,-50,0.5,-10)
            t.BackgroundColor3 = Color3.fromRGB(60,60,60)
            Instance.new("UICorner", t).CornerRadius = UDim.new(1,0)

            local k = Instance.new("Frame", t)
            k.Size = UDim2.fromOffset(16,16)
            k.Position = UDim2.new(0,2,0.5,-8)
            k.BackgroundColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", k).CornerRadius = UDim.new(1,0)

            local s = false
            h.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    s = not s
                    TweenService:Create(k, TweenInfo.new(0.2), {
                        Position = s and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
                    }):Play()
                    TweenService:Create(t, TweenInfo.new(0.2), {
                        BackgroundColor3 = s and Theme.Accent or Color3.fromRGB(60,60,60)
                    }):Play()
                    cb(s)
                end
            end)
        end

        return tab
    end

    return window
end

return WaffBox
