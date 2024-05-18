local p=game:GetService("Players")
local r=game:GetService("RunService")
local u=game:GetService("UserInputService")

local pl=p.LocalPlayer
local ch=pl.Character or pl.CharacterAdded:Wait()
local h=ch:WaitForChild("Humanoid")
local rp=ch:WaitForChild("HumanoidRootPart")

local n=false
local f=false
local fs=250

local sg=Instance.new("ScreenGui")
sg.Parent=pl:WaitForChild("PlayerGui")

local fr=Instance.new("Frame")
fr.Size=UDim2.new(0,200,0,150)
fr.Position=UDim2.new(0.5,-100,0.5,-75)
fr.BackgroundColor3=Color3.fromRGB(30,30,30)
fr.Active=true
fr.Draggable=true
fr.Visible=true
fr.Parent=sg

local g=Instance.new("UIGradient")
g.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0.00,Color3.fromRGB(48,25,52)),
    ColorSequenceKeypoint.new(0.50,Color3.fromRGB(25,25,112)),
    ColorSequenceKeypoint.new(1.00,Color3.fromRGB(139,0,0))
}
g.Parent=fr

local tl=Instance.new("TextLabel")
tl.Size=UDim2.new(1,0,0,20)
tl.Position=UDim2.new(0,0,0,0)
tl.Text="Nexus Scripts"
tl.TextColor3=Color3.new(1,1,1)
tl.BackgroundColor3=Color3.fromRGB(50,50,50)
tl.Font=Enum.Font.GothamSemibold
tl.TextSize=14
tl.Parent=fr

local cb=Instance.new("TextButton")
cb.Size=UDim2.new(0,20,0,20)
cb.Position=UDim2.new(1,-25,0,5)
cb.Text="-"
cb.TextColor3=Color3.new(1,1,1)
cb.BackgroundColor3=Color3.fromRGB(50,50,50)
cb.Font=Enum.Font.Gotham
cb.TextSize=14
cb.Parent=fr

local efb=Instance.new("TextButton")
efb.Size=UDim2.new(0,180,0,30)
efb.Position=UDim2.new(0,10,0,30)
efb.Text="Enable Fly"
efb.TextColor3=Color3.new(1,1,1)
efb.BackgroundColor3=Color3.fromRGB(60,60,60)
efb.Font=Enum.Font.Gotham
efb.TextSize=14
efb.Parent=fr

local enb=Instance.new("TextButton")
enb.Size=UDim2.new(0,180,0,30)
enb.Position=UDim2.new(0,10,0,70)
enb.Text="Enable Noclip"
enb.TextColor3=Color3.new(1,1,1)
enb.BackgroundColor3=Color3.fromRGB(60,60,60)
enb.Font=Enum.Font.Gotham
enb.TextSize=14
enb.Parent=fr

local fst=Instance.new("TextBox")
fst.Size=UDim2.new(0,180,0,30)
fst.Position=UDim2.new(0,10,0,110)
fst.PlaceholderText="Fly Speed"
fst.Text=tostring(fs)
fst.TextColor3=Color3.new(1,1,1)
fst.BackgroundColor3=Color3.fromRGB(60,60,60)
fst.Font=Enum.Font.Gotham
fst.TextSize=14
fst.Parent=fr

local function tn()
    n=not n
    if n then
        enb.Text="Disable Noclip"
        for _,part in pairs(ch:GetDescendants())do
            if part:IsA("BasePart")and part.CanCollide then
                part.CanCollide=false
            end
        end
    else
        enb.Text="Enable Noclip"
        for _,part in pairs(ch:GetDescendants())do
            if part:IsA("BasePart")then
                part.CanCollide=true
            end
        end
    end
end

local function tf()
    f=not f
    if f then
        efb.Text="Disable Fly"
        h.PlatformStand=true
    else
        efb.Text="Enable Fly"
        rp.Velocity=Vector3.new(0,0,0)
        h.PlatformStand=false
    end
end

local function os()
    if n then
        for _,part in pairs(ch:GetDescendants())do
            if part:IsA("BasePart")and part.CanCollide then
                part.CanCollide=false
            end
        end
    end
end

local function ors()
    if f then
        local md=Vector3.new()
        if u:IsKeyDown(Enum.KeyCode.W)then
            md=md+(workspace.CurrentCamera.CFrame.LookVector*fs)
        end
        if u:IsKeyDown(Enum.KeyCode.S)then
            md=md-(workspace.CurrentCamera.CFrame.LookVector*fs)
        end
        if u:IsKeyDown(Enum.KeyCode.A)then
            md=md-(workspace.CurrentCamera.CFrame.RightVector*fs)
        end
        if u:IsKeyDown(Enum.KeyCode.D)then
            md=md+(workspace.CurrentCamera.CFrame.RightVector*fs)
        end
        if u:IsKeyDown(Enum.KeyCode.Space)then
                        md=md+(Vector3.new(0,fs,0))
        end
        if u:IsKeyDown(Enum.KeyCode.LeftControl)then
            md=md-(Vector3.new(0,fs,0))
        end
        rp.Velocity=md
    end
end

local function tg()
    fr.Visible=not fr.Visible
end

local function uf()
    local ns=tonumber(fst.Text)
    if ns then
        fs=ns
    else
        fst.Text=tostring(fs)
    end
end

local function abhe(b)
    b.MouseEnter:Connect(function()
        b.BackgroundColor3=Color3.fromRGB(70,70,70)
    end)
    b.MouseLeave:Connect(function()
        b.BackgroundColor3=Color3.fromRGB(60,60,60)
    end)
end

abhe(efb)
abhe(enb)
abhe(cb)

fst.MouseEnter:Connect(function()
    fst.BackgroundColor3=Color3.fromRGB(70,70,70)
end)
fst.MouseLeave:Connect(function()
    fst.BackgroundColor3=Color3.fromRGB(60,60,60)
end)

enb.MouseButton1Click:Connect(tn)
efb.MouseButton1Click:Connect(tf)
fst.FocusLost:Connect(uf)

u.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode==Enum.KeyCode.Insert then
        tg()
    end
end)

r.Stepped:Connect(os)
r.RenderStepped:Connect(ors)

fr.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true
        dragStart=input.Position
        startPos=fr.Position
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then
                dragging=false
            end
        end)
    end
end)

fr.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
        dragInput=input
    end
end)

u.InputChanged:Connect(function(input)
    if dragging and input==dragInput then
        local delta=input.Position-dragStart
        fr.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)

cb.MouseButton1Click:Connect(function()
    fr.Visible=false
end)
