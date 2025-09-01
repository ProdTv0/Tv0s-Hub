local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Arsenal Script✔🤑",
   Icon = 0,
   LoadingTitle = "Tv0 hub",
   LoadingSubtitle = "by Tv0",
   ShowText = "Rayfield",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Tv0 Hub"
   },
   Discord = {
      Enabled = true,
      Invite = "X7PcFpmf",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-- Create tabs
local MainTab = Window:CreateTab("🏡 Home", 4483362458)
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local ESPTab = Window:CreateTab("ESP", 4483362458)

-- Home section
local MainSection = MainTab:CreateSection("Controls")

Rayfield:Notify({
   Title = "Script Activated",
   Content = "Welcome to Tv0 Hub!",
   Duration = 6.5,
   Image = 4483362458,
})

-- Teleport to Guapo button
MainTab:CreateButton({
    Name = "Teleport to Guapo",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local guapo = workspace:FindFirstChild("Guapo")
        if guapo and guapo:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = guapo.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        else
            warn("Guapo not found in workspace.")
        end
    end
})

-- Walkspeed slider
MainTab:CreateSlider({
   Name = "Walkspeed",
   Range = {0, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
       local character = game.Players.LocalPlayer.Character
       if character and character:FindFirstChild("Humanoid") then
           character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Aimbot Configurations
_G.AimbotEnabled = false
_G.TeamCheck = true  -- Default to true for team check
_G.AimPart = "Head"
_G.Sensitivity = 0.15

_G.CircleSides = 64
_G.CircleColor = Color3.fromRGB(255, 255, 255)
_G.CircleTransparency = 0.7
_G.CircleRadius = 80
_G.CircleFilled = false
_G.CircleVisible = true
_G.CircleThickness = 1

-- Aimbot State
local HoldingRightClick = false

-- Create FOV circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

-- Function to get closest target inside FOV circle near mouse and in front of the player
local function GetClosestPlayer()
    local maxDist = _G.CircleRadius
    local target = nil
    local mousePos = UserInputService:GetMouseLocation()
    local character = LocalPlayer.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if not rootPart then return nil end

    -- Get the character's facing direction
    local lookVector = rootPart.CFrame.LookVector

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                if not _G.TeamCheck or (player.Team ~= LocalPlayer.Team) then
                    local screenPos, onScreen = Camera:WorldToScreenPoint(player.Character[_G.AimPart].Position)
                    if onScreen then
                        -- Check if the target is in front of the player using dot product
                        local targetDirection = (player.Character[_G.AimPart].Position - rootPart.Position).unit
                        local dotProduct = lookVector:Dot(targetDirection)
                        if dotProduct > 0.5 then  -- Only target players in front of the character (adjust the value as needed)
                            local distance = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                            if distance <= maxDist then
                                maxDist = distance
                                target = player
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end

-- Input connections for holding right click
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        HoldingRightClick = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        HoldingRightClick = false
    end
end)

-- Smooth Camera Movement with TweenService
local function SmoothCameraMove(targetPosition)
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
    
    -- Smooth movement using TweenService
    TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        CFrame = targetCFrame
    }):Play()
end

-- Main RenderStepped loop to update circle and aimbot
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()

    -- Update FOV circle position & properties
    FOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness

    -- Aimbot logic
    if HoldingRightClick and _G.AimbotEnabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(_G.AimPart) then
            SmoothCameraMove(target.Character[_G.AimPart].Position)
        end
    end
end)

-- Aimbot toggle callback just enables/disables aimbot
AimbotTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
       _G.AimbotEnabled = Value
   end,
})

-- ESP toggle with basic nametag functionality
ESPTab:CreateToggle({
   Name = "Enable ESP",
   CurrentValue = false,
   Flag = "ESPEnabled",
   Callback = function(Value)
       local Players = game:GetService("Players")
       local RunService = game:GetService("RunService")
       local LocalPlayer = Players.LocalPlayer
       local MaxDistance = 400.5

       local NametagsEnabled = Value

       local function CreateNametag(Player)
           if Player == LocalPlayer then return end

           local function SetupNametag(Character)
               local Head = Character:FindFirstChild("Head")
               if not Head then return end

               local OldNametag = Head:FindFirstChild("Nametag")
               if OldNametag then OldNametag:Destroy() end

               local BillboardGui = Instance.new("BillboardGui")
               BillboardGui.Name = "Nametag"
               BillboardGui.Adornee = Head
               BillboardGui.Size = UDim2.new(0, 75, 0, 150)
               BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
               BillboardGui.AlwaysOnTop = true

               local TextLabel = Instance.new("TextLabel")
               TextLabel.Size = UDim2.new(1, 0, 1, 0)
               TextLabel.Text = Player.Name
               TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
               TextLabel.BackgroundTransparency = 1
               TextLabel.TextStrokeTransparency = 0.75
               TextLabel.Font = Enum.Font.Code
               TextLabel.TextScaled = true
               TextLabel.Parent = BillboardGui

               BillboardGui.Parent = Head

               local function UpdateVisibility()
                   if NametagsEnabled and Player.Character and Player.Character:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                       local Distance = (Player.Character.Head.Position - LocalPlayer.Character.Head.Position).Magnitude
                       BillboardGui.Enabled = (Distance <= MaxDistance)
                   else
                       BillboardGui.Enabled = false
                   end
               end

               local Connection
               Connection = RunService.Heartbeat:Connect(function()
                   if Player.Character and Player.Character:FindFirstChild("Head") then
                       UpdateVisibility()
                   else
                       BillboardGui:Destroy()
                       Connection:Disconnect()
                   end
               end)
           end

           if Player.Character then
               SetupNametag(Player.Character)
           end
           Player.CharacterAdded:Connect(SetupNametag)
       end

       for _, Player in pairs(Players:GetPlayers()) do
           CreateNametag(Player)
       end
   end,
})
