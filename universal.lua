local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local noclip = false
local flying = false
local flySpeed = 250

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Changed background color
frame.Active = true
frame.Draggable = true
frame.Visible = true -- Ensure visibility
frame.Parent = screenGui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(48, 25, 52)), -- Dark Purple
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(25, 25, 112)), -- Dark Blue
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(139, 0, 0)) -- Dark Red
}
gradient.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 20)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Nexus Scripts"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Changed background color
titleLabel.Font = Enum.Font.GothamSemibold -- Changed font
titleLabel.TextSize = 14 -- Changed text size
titleLabel.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 5)
closeButton.Text = "-"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Changed background color
closeButton.Font = Enum.Font.Gotham -- Changed font
closeButton.TextSize = 14 -- Changed text size
closeButton.Parent = frame

local enableFlyButton = Instance.new("TextButton")
enableFlyButton.Size = UDim2.new(0, 180, 0, 30)
enableFlyButton.Position = UDim2.new(0, 10, 0, 30)
enableFlyButton.Text = "Enable Fly"
enableFlyButton.TextColor3 = Color3.new(1, 1, 1)
enableFlyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Changed background color
enableFlyButton.Font = Enum.Font.Gotham -- Changed font
enableFlyButton.TextSize = 14 -- Changed text size
enableFlyButton.Parent = frame

local enableNoclipButton = Instance.new("TextButton")
enableNoclipButton.Size = UDim2.new(0, 180, 0, 30)
enableNoclipButton.Position = UDim2.new(0, 10, 0, 70)
enableNoclipButton.Text = "Enable Noclip"
enableNoclipButton.TextColor3 = Color3.new(1, 1, 1)
enableNoclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Changed background color
enableNoclipButton.Font = Enum.Font.Gotham -- Changed font
enableNoclipButton.TextSize = 14 -- Changed text size
enableNoclipButton.Parent = frame

local flySpeedTextBox = Instance.new("TextBox")
flySpeedTextBox.Size = UDim2.new(0, 180, 0, 30)
flySpeedTextBox.Position = UDim2.new(0, 10, 0, 110)
flySpeedTextBox.PlaceholderText = "Fly Speed"
flySpeedTextBox.Text = tostring(flySpeed)
flySpeedTextBox.TextColor3 = Color3.new(1, 1, 1)
flySpeedTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Changed background color
flySpeedTextBox.Font = Enum.Font.Gotham -- Changed font
flySpeedTextBox.TextSize = 14 -- Changed text size
flySpeedTextBox.Parent = frame

local function toggleNoclip()
    noclip = not noclip
    if noclip then
        enableNoclipButton.Text = "Disable Noclip"
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    else
        enableNoclipButton.Text = "Enable Noclip"
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function toggleFly()
    flying = not flying
    if flying then
        enableFlyButton.Text = "Disable Fly"
        humanoid.PlatformStand = true
    else
        enableFlyButton.Text = "Enable Fly"
        humanoid.PlatformStand = false
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end
end

local function onStepped()
    if noclip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

local function onRenderStep()
    if flying then
        local moveDirection = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (workspace.CurrentCamera.CFrame.LookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (workspace.CurrentCamera.CFrame.LookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - (workspace.CurrentCamera.CFrame.RightVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + (workspace.CurrentCamera.CFrame.RightVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + (Vector3.new(0, flySpeed, 0))
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - (Vector3.new(0, flySpeed, 0))
        end

        humanoidRootPart.Velocity = moveDirection
    end
end

local function toggleGuiVisibility()
    frame.Visible = not frame.Visible
end

local function updateFlySpeed()
    local newSpeed = tonumber(flySpeedTextBox.Text)
    if newSpeed then
        flySpeed = newSpeed
    else
        flySpeedTextBox.Text = tostring(flySpeed)
    end
end

local function addButtonHoverEffect(button)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Darker color on hover
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Revert to original color on leave
    end)
end

addButtonHoverEffect(enableFlyButton)
addButtonHoverEffect(enableNoclipButton)
addButtonHoverEffect(closeButton)

-- Add hover effect for text box
flySpeedTextBox.MouseEnter:Connect(function()
    flySpeedTextBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Darker color on hover
end)
flySpeedTextBox.MouseLeave:Connect(function()
    flySpeedTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Revert to original color on leave
end)

enableNoclipButton.MouseButton1Click:Connect(toggleNoclip)
enableFlyButton.MouseButton1Click:Connect(toggleFly)
flySpeedTextBox.FocusLost:Connect(updateFlySpeed)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleGuiVisibility()
    end
end)
RunService.Stepped:Connect(onStepped)
RunService.RenderStepped:Connect(onRenderStep)

-- Make frame draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
end)
