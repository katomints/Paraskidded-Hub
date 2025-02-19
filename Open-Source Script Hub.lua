--[[
This entire script was made by ChatGPT, due to the owner not able to comprehend basic LUA skills. You can't even call this a script hub. The autofarm is detected, it'll get you banned in an instant.
]]--

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Paradise Hub",
    LoadingTitle = "Loading Paradise Hub",
    LoadingSubtitle = "By Paradise Team",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Paradise Hub"
    },
    Discord = {
        Enabled = true,
        Invite = "WydczBKJ", -- Replaced to Nexus's discord invite, these clowns do not deserve attention whatsoever.
        RememberJoins = true
    },
    KeySystem = false
})

-- Create Tabs
local VehicleTab = Window:CreateTab("Vehicle", 8356815386) 
local TeleportTab = Window:CreateTab("Teleport", 8360954483) 

-- Gravity Toggle
local VehicleSection = VehicleTab:CreateSection("Drift Section")
local gravityEnabled = true
VehicleTab:CreateToggle({
    Name = "Gravity Toggle",
    CurrentValue = gravityEnabled,
    Callback = function(Value)
        gravityEnabled = Value
        if gravityEnabled then
            game.Workspace.Gravity = 200 -- Adjusted gravity to make cars drift
        else
            game.Workspace.Gravity = 50 -- No gravity
        end
    end
})

--Low Grip Wheels
local lowGripEnabled = false
VehicleTab:CreateToggle({
    Name = "Low Grip Wheels",
    Callback = function(state)
        lowGripEnabled = state
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local vehicle = character:FindFirstChildOfClass("Model")
        
        if vehicle then
            for _, wheel in pairs(vehicle:GetDescendants()) do
                if wheel:IsA("Wheel") then
                    wheel.Friction = lowGripEnabled and 0.01 or 0 -- Super slippy for drifting
                    wheel.Elasticity = lowGripEnabled and 1.5 or 2 -- Adds more slide
                end
            end
        end
    end
})

--Car Fly
local defaultCharacterParent 
local flightEnabled = false
local flightSpeed = 3

local function GetVehicleFromDescendant(descendant)
    while descendant and not descendant:IsA("Model") do
        descendant = descendant.Parent
    end
    return descendant
end

RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
LocalPlayer = game:GetService("Players").LocalPlayer

RunService.Stepped:Connect(function()
    local Character = LocalPlayer.Character
    if flightEnabled then
        if Character and typeof(Character) == "Instance" then
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if Humanoid and typeof(Humanoid) == "Instance" then
                local SeatPart = Humanoid.SeatPart
                if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
                    local Vehicle = GetVehicleFromDescendant(SeatPart)
                    if Vehicle and Vehicle:IsA("Model") then
                        Character.Parent = Vehicle
                        if not Vehicle.PrimaryPart then
                            if SeatPart.Parent == Vehicle then
                                Vehicle.PrimaryPart = SeatPart
                            else
                                Vehicle.PrimaryPart = Vehicle:FindFirstChildWhichIsA("BasePart")
                            end
                        end
                        local PrimaryPartCFrame = Vehicle:GetPrimaryPartCFrame()
                        Vehicle:SetPrimaryPartCFrame(CFrame.new(PrimaryPartCFrame.Position, PrimaryPartCFrame.Position + workspace.CurrentCamera.CFrame.LookVector) * (UserInputService:GetFocusedTextBox() and CFrame.new(0, 0, 0) or CFrame.new((UserInputService:IsKeyDown(Enum.KeyCode.D) and flightSpeed) or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -flightSpeed) or 0, (UserInputService:IsKeyDown(Enum.KeyCode.E) and flightSpeed / 2) or (UserInputService:IsKeyDown(Enum.KeyCode.Q) and -flightSpeed / 2) or 0, (UserInputService:IsKeyDown(Enum.KeyCode.S) and flightSpeed) or (UserInputService:IsKeyDown(Enum.KeyCode.W) and -flightSpeed) or 0)))
                        SeatPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        SeatPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end
    else
        if Character and typeof(Character) == "Instance" then
            Character.Parent = defaultCharacterParent or Character.Parent
            defaultCharacterParent = Character.Parent
        end
    end
end)

local VehicleSection = VehicleTab:CreateSection("Car Fly")
VehicleTab:CreateToggle({
    Name = "Car Fly",
    CurrentValue = false,
    Callback = function(Value)
        flightEnabled = Value
        Rayfield:Notify({
            Title = "Car Fly",
            Content = flightEnabled and "Enabled" or "Disabled",
            Duration = 3,
            Image = 4483362458
        })
    end
})

--Show Springs
local VehicleSection = VehicleTab:CreateSection("Springs")
VehicleTab:CreateToggle({
    Name = "Show Springs",
    CurrentValue = false,
    Flag = "ShowSpringsToggle",
    Callback = function(v)
        local Character = LocalPlayer.Character
        if Character and typeof(Character) == "Instance" then
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if Humanoid and typeof(Humanoid) == "Instance" then
                local SeatPart = Humanoid.SeatPart
                if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
                    local Vehicle = GetVehicleFromDescendant(SeatPart)
                    if Vehicle then
                        for _, SpringConstraint in pairs(Vehicle:GetDescendants()) do
                            if SpringConstraint:IsA("SpringConstraint") then
                                SpringConstraint.Visible = v
                            end
                        end
                    end
                end
            end
        end
    end
})

--Autofarm
local FarmingTab = Window:CreateTab("Farming", 8356815386) -- Icon ID
--DTE Farm
local FarmingSection = FarmingTab:CreateSection("Drive To Earn")
local teleportInterval = 5 -- Default interval in seconds
FarmingTab:CreateToggle({
    Name = "DTE Farm (Currently not working. Will be fixed soon!)",
    Default = false,
    Callback = function(state)
        teleportEnabled = state
        if teleportEnabled then
            spawn(function()
                while teleportEnabled do
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local car = nil
                        for _, v in pairs(workspace:GetChildren()) do
                            if v:IsA("Model") and v:FindFirstChild("VehicleSeat") and v.VehicleSeat.Occupant == character:FindFirstChild("Humanoid") then
                                car = v
                                break
                            end
                        end
                        
                        local teleportPosition = CFrame.new(0, 10, 0) -- Change to desired location
                        character.HumanoidRootPart.CFrame = teleportPosition
                        if car then
                            local carPrimary = car.PrimaryPart or car:FindFirstChild("HumanoidRootPart") or car:FindFirstChildWhichIsA("BasePart")
                            if carPrimary then
                                local bodyVelocity = Instance.new("BodyVelocity")
                                bodyVelocity.Velocity = (teleportPosition.Position - carPrimary.Position).unit * 50 -- Adjust speed
                                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                bodyVelocity.Parent = carPrimary
                                
                                wait(1.5) -- Wait for the movement to finish
                                bodyVelocity:Destroy()
                            end
                        end
                    end
                    wait(teleportInterval)
                end
            end)
        end
    end
})

FarmingTab:CreateButton({
    Name = "Teleport", 
    Callback = function()
        local targetPosition = CFrame.new(Vector3.new(50, 10, 50)) -- Modify this as needed
        teleportPlayer(targetPosition) -- Call teleport function with the target position
    end
})
FarmingTab:CreateButton({
    Name = "Show Instructions (Read First)",
    Callback = function()
        Rayfield:Notify({
            Title = "Instructions",
            Content = "Click the Teleport Button, Spawn your car, get in then drive to burgerhous, Enable cruise control at 55mph. Then enable the toggle.",
            Duration = 20, -- Notification stays for 20 seconds
            Actions = { -- Optional: You can add buttons here
                Ignore = {
                    Name = "Dismiss",
                    Callback = function()
                        print("Notification dismissed!")
                    end
                }
            }
        })
    end
})

--Refuel
local VehicleSection = VehicleTab:CreateSection("Fuel Tank")

local rs = game:GetService("ReplicatedStorage")

VehicleTab:CreateButton({
    Name = "Refuel",
    Callback = function()
        rs.Remote.Refuel:FireServer(1, os.time())
    end
})

--Speed Section
local VehicleSection = VehicleTab:CreateSection("Speed")
VehicleTab:CreateButton({
    Name = "Open Speed/Brake Changer",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/ZVwJG52m"))()
    end
})
-- Extra Grip Toggle
local extraGripEnabled = false
VehicleTab:CreateToggle({
    Name = "Extra Grip",
    CurrentValue = extraGripEnabled,
    Callback = function(state)
        extraGripEnabled = state
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local vehicle = character:FindFirstChildOfClass("Model")
        
        if vehicle then
            for _, wheel in pairs(vehicle:GetDescendants()) do
                if wheel:IsA("Wheel") then
                    wheel.Friction = extraGripEnabled and 5 or 1 -- Increases grip for better handling
                    wheel.Elasticity = extraGripEnabled and 0.5 or 1 -- Reduces bounce for better stability
                end
            end
        end
    end
})

--Drivetrain Section
local VehicleSection = VehicleTab:CreateSection("Drivetrain")
local drivetrainOptions = {"AWD", "FWD", "RWD"}

VehicleTab:CreateDropdown({
    Name = "Drivetrain Mode",
    Options = drivetrainOptions,
    Callback = function(selected)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local vehicle = character:FindFirstChildOfClass("Model")
        
        if vehicle then
            for _, wheel in pairs(vehicle:GetDescendants()) do
                if wheel:IsA("Wheel") then
                    if selected == "AWD" then
                        wheel.Torque = 1
                    elseif selected == "FWD" then
                        wheel.Torque = wheel:IsDescendantOf(vehicle.FrontAxle) and 1 or 0
                    elseif selected == "RWD" then
                        wheel.Torque = wheel:IsDescendantOf(vehicle.RearAxle) and 1 or 0
                    end
                end
            end
        end
    end
})

-- Add Teleporter Section
local TeleportSection = TeleportTab:CreateSection("Teleporter")
TeleportTab:CreateButton({
    Name = "Roadmap",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player and player.Character then
            player.Character:SetPrimaryPartCFrame(CFrame.new(Vector3.new(-1584.9815673828125, -71.16507720947266, -11396.05078125))) -- Example Coordinates
        end
    end
})
TeleportTab:CreateButton({
    Name = "Ron Rivers",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player and player.Character then
            player.Character:SetPrimaryPartCFrame(CFrame.new(Vector3.new(-3526.211669921875, -100.32514190673828, -1834.55859375))) -- Example Coordinates
        end
    end
})
TeleportTab:CreateButton({
    Name = "Airport",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player and player.Character then
            player.Character:SetPrimaryPartCFrame(CFrame.new(Vector3.new(6152.7333984375, -70.10242462158203, -10634.7890625))) -- Example Coordinates
        end
    end
})
TeleportTab:CreateButton({
    Name = "Horton",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player and player.Character then
            player.Character:SetPrimaryPartCFrame(CFrame.new(Vector3.new(-1566.75146484375, -97.36862182617188, 4074.514892578125))) -- Example Coordinates
        end
    end
})

--Function for teleport
local function teleportPlayer(destination)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = destination
    end
end

-- Show the UI
Rayfield:LoadConfiguration()
