_G.Reach = 20
_G.HighCap = 100
_G.LowCap = 0
_G.ReachOff = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "SeedHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 140)
Frame.Position = UDim2.new(0, 20, 0.8, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "Seed Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0, 25)
Status.BackgroundTransparency = 1
Status.Text = "Status: ON"
Status.TextColor3 = Color3.fromRGB(0, 255, 0)
Status.Font = Enum.Font.Gotham
Status.TextSize = 14
Status.Parent = Frame

local SliderBackground = Instance.new("Frame")
SliderBackground.Size = UDim2.new(0.9, 0, 0, 8)
SliderBackground.Position = UDim2.new(0.05, 0, 0, 60)
SliderBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderBackground.BorderSizePixel = 0
SliderBackground.Parent = Frame

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((_G.Reach - _G.LowCap)/(_G.HighCap - _G.LowCap), 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBackground

local SliderDot = Instance.new("Frame")
SliderDot.Size = UDim2.new(0, 10, 0, 10)
SliderDot.AnchorPoint = Vector2.new(0.5, 0.5)
SliderDot.Position = UDim2.new(SliderFill.Size.X.Scale, 0, 0.5, 0)
SliderDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
SliderDot.BorderSizePixel = 0
SliderDot.Parent = SliderBackground

local UICornerDot = Instance.new("UICorner", SliderDot)
UICornerDot.CornerRadius = UDim.new(1, 0)

local ValueLabel = Instance.new("TextLabel")
ValueLabel.Size = UDim2.new(1, 0, 0, 20)
ValueLabel.Position = UDim2.new(0, 0, 0, 75)
ValueLabel.BackgroundTransparency = 1
ValueLabel.Text = "Reach: " .. tostring(_G.Reach)
ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ValueLabel.Font = Enum.Font.Gotham
ValueLabel.TextSize = 14
ValueLabel.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.9, 0, 0, 25)
ToggleButton.Position = UDim2.new(0.05, 0, 0, 105)
ToggleButton.Text = "Toggle Reach"
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.TextSize = 14
ToggleButton.Parent = Frame

local UICornerBtn = Instance.new("UICorner", ToggleButton)
UICornerBtn.CornerRadius = UDim.new(0, 4)

local function updateSlider(percent)
    percent = math.clamp(percent, 0, 1)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderDot.Position = UDim2.new(percent, 0, 0.5, 0)
    _G.Reach = math.floor((_G.HighCap - _G.LowCap) * percent + _G.LowCap + 0.5)
    ValueLabel.Text = "Reach: " .. tostring(_G.Reach)
end

SliderBackground.InputBegan:Connect(function(input)
    if _G.ReachOff then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                conn:Disconnect()
                return
            end
            local mouse = game:GetService("UserInputService"):GetMouseLocation()
            local relX = (mouse.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X
            updateSlider(relX)
        end)
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    _G.ReachOff = not _G.ReachOff
    if _G.ReachOff then
        Status.Text = "Status: OFF"
        Status.TextColor3 = Color3.fromRGB(255, 80, 80)
        SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        SliderDot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    else
        Status.Text = "Status: ON"
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        SliderDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

RunService.Stepped:Connect(function()
    if _G.ReachOff then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Torso") then
            local torso = player.Character.Torso
            if (hrp.Position - torso.Position).Magnitude <= _G.Reach then
                for _, limbName in pairs({"Left Arm", "Left Leg", "Right Leg"}) do
                    local limb = player.Character:FindFirstChild(limbName)
                    if limb then
                        limb:BreakJoints()
                        limb.Transparency = 1
                        limb.CanCollide = false
                        limb.CFrame = hrp.CFrame * CFrame.new(1, 0, -3.5)
                    end
                end
            end
        end
    end
end)
