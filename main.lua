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
local MainSection = MainTab:CreateSection("Farming")

Rayfield:Notify({
   Title = "you have activated the script",
   Content = "Notification Content",
   Duration = 6.5,
   Image = 4483362458,
})

MainTab:CreateButton({
    Name = "Teleport to guapo",
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

MainTab:CreateSlider({
   Name = "Walkspeed",
   Range = {0, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- Aimbot toggle
AimbotTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
       local Camera = workspace.CurrentCamera
       local Players = game:GetService("Players")
       local RunService = game:GetService("RunService")
       local UserInputService = game:GetService("UserInputService")
       local TweenService = game:GetService("TweenService")
       local LocalPlayer = Players.LocalPlayer
       local Holding = false

       _G.AimbotEnabled = Value
       _G.TeamCheck = false
       _G.AimPart = "Head"
       _G.Sensitivity = 0

       _G.CircleSides = 64
       _G.CircleColor = Color3.fromRGB(255, 255, 255)
       _G.CircleTransparency = 0.7
       _G.CircleRadius = 80
       _G.CircleFilled = false
       _G.CircleVisible = true
       _G.CircleThickness = 0

       local FOVCircle = Drawing.new("Circle")
       FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
       FOVCircle.Radius = _G.CircleRadius
       FOVCircle.Filled = _G.CircleFilled
       FOVCircle.Color = _G.CircleColor
       FOVCircle.Visible = _G.CircleVisible
       FOVCircle.Transparency = _G.CircleTransparency
       FOVCircle.NumSides = _G.CircleSides
       FOVCircle.Thickness = _G.CircleThickness

       local function GetClosestPlayer()
           local MaximumDistance = _G.CircleRadius
           local Target = nil

           for _, v in next, Players:GetPlayers() do
               if v.Name ~= LocalPlayer.Name then
                   if _G.TeamCheck then
                       if v.Team ~= LocalPlayer.Team then
                           if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                               local ScreenPoint = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                               local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                               if VectorDistance < MaximumDistance then
                                   Target = v
                               end
                           end
                       end
                   else
                       if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                           local ScreenPoint = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                           local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                           if VectorDistance < MaximumDistance then
                               Target = v
                           end
                       end
                   end
               end
           end
           return Target
       end

       UserInputService.InputBegan:Connect(function(Input)
           if Input.UserInputType == Enum.UserInputType.MouseButton2 then
               Holding = true
           end
       end)

       UserInputService.InputEnded:Connect(function(Input)
           if Input.UserInputType == Enum.UserInputType.MouseButton2 then
               Holding = false
           end
       end)

       RunService.RenderStepped:Connect(function()
           FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
           FOVCircle.Radius = _G.CircleRadius
           FOVCircle.Filled = _G.CircleFilled
           FOVCircle.Color = _G.CircleColor
           FOVCircle.Visible = _G.CircleVisible
           FOVCircle.Transparency = _G.CircleTransparency
           FOVCircle.NumSides = _G.CircleSides
           FOVCircle.Thickness = _G.CircleThickness

           if Holding and _G.AimbotEnabled then
               local target = GetClosestPlayer()
               if target and target.Character and target.Character:FindFirstChild(_G.AimPart) then
                   TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                       CFrame = CFrame.new(Camera.CFrame.Position, target.Character[_G.AimPart].Position)
                   }):Play()
               end
           end
       end)
   end,
})

-- ESP toggle
ESPTab:CreateToggle({
   Name = "AimbotandEsp",
   CurrentValue = false,
   Flag = "Toggle2",
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
               if OldNametag then
                   OldNametag:Destroy()
               end

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

       local function ApplyHighlight(Player)
           if Player == LocalPlayer then return end

           local function SetupHighlight(Character)
               for _, v in pairs(Character:GetChildren()) do
                   if v:IsA("Highlight") then
                       v:Destroy()
                   end
               end

               local Highlighter = Instance.new("Highlight")
               Highlighter.Parent = Character

               local function UpdateFillColor()
                   local DefaultColor = Color3.fromRGB(255, 48, 51)
                   Highlighter.FillColor = Player.TeamColor and Player.TeamColor.Color or DefaultColor
               end

               UpdateFillColor()
               Player:GetPropertyChangedSignal("TeamColor"):Connect(UpdateFillColor)

               local Humanoid = Character:FindFirstChildOfClass("Humanoid")
               if Humanoid then
                   Humanoid.Died:Connect(function()
                       Highlighter:Destroy()
                   end)
               end
           end

           if Player.Character then
               SetupHighlight(Player.Character)
           end
           Player.CharacterAdded:Connect(SetupHighlight)
       end

       for _, Player in pairs(Players:GetPlayers()) do
           CreateNametag(Player)
           ApplyHighlight(Player)
       end
   end,
})
