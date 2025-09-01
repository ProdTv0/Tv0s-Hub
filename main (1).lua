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

-- Anti-Ban Functionality (Basic)
local function AntiBan()
   -- Disable certain game events that could trigger bans
   game:GetService("Players").PlayerAdded:Connect(function(player)
      if player.Name == game.Players.LocalPlayer.Name then
         -- Disable the "PlayerAdded" event from affecting the player
         player.OnTeleport = Enum.TeleportState.Started
      end
   end)
   
   -- Mask or hide known functions (this is mostly for obfuscation purposes)
   local Old = game:GetService("Players").LocalPlayer.CharacterAdded
   game:GetService("Players").LocalPlayer.CharacterAdded = function() end

   -- We can also try to avoid calling any major functions that could be flagged
end

-- Call AntiBan at the start
AntiBan()

-- Improved Aimbot toggle
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
       _G.TeamCheck = true  -- Enable Team Check
       _G.AimPart = "Head"
       _G.Sensitivity = 0.1  -- Reduced sensitivity for smoother aiming
       _G.Smoothness = 0.3  -- Smoother aiming towards the target

       _G.CircleSides = 64
       _G.CircleColor = Color3.fromRGB(255, 255, 255)
       _G.CircleTransparency = 0.7
       _G.CircleRadius = 80
       _G.CircleFilled = false
       _G.CircleVisible = true
       _G.CircleThickness = 1

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
                       -- Check if the target is on the opposite team
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
                   local aimPosition = target.Character[_G.AimPart].Position
                   local direction = (aimPosition - Camera.CFrame.Position).unit
                   local smoothPosition = Camera.CFrame.Position + direction * _G.Smoothness
                   
                   TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                       CFrame = CFrame.new(smoothPosition, aimPosition)
                   }):Play()
               end
           end
       end)
   end,
})

-- Improved ESP with Boxes and Lines
ESPTab:CreateToggle({
   Name = "ESP with Boxes and Lines",
   CurrentValue = false,
   Flag = "Toggle2",
   Callback = function(Value)
       local Players = game:GetService("Players")
       local RunService = game:GetService("RunService")
       local LocalPlayer = Players.LocalPlayer

       local function DrawBox(Character)
           local Head = Character:FindFirstChild("Head")
           if not Head then return end

           local Box = Drawing.new("Square")
           Box.Size = Vector2.new(100, 100)  -- Adjust size as needed
           Box.Color = Color3.fromRGB(255, 0, 0)
           Box.Thickness = 2
           Box.Transparency = 0.7
           Box.Visible = true

           local function UpdateBox()
               if Character and Character:FindFirstChild("HumanoidRootPart") then
                   local RootPart = Character.HumanoidRootPart
                   local HeadPos = RootPart.Position
                   local ScreenPos = workspace.CurrentCamera:WorldToScreenPoint(HeadPos)
                   Box.Position = Vector2.new(ScreenPos.X - Box.Size.X / 