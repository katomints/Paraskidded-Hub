local VenyxLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Documantation12/Universal-Vehicle-Script/main/Library.lua"))()
local Venyx = VenyxLibrary.new("Paradise Hub | .gg/removed because im not giving these clowns attention.", 5013109572)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Theme = {
    Background = Color3.fromRGB(0, 0, 0), -- Black background for left & right
    Accent = Color3.fromRGB(0, 0, 0),
    LightContrast = Color3.fromRGB(80, 80, 80), -- Grey contrast
    DarkContrast = Color3.fromRGB(0, 0, 0), -- Black contrast
    TextColor = Color3.fromRGB(255, 255, 255), -- White text
    TitleBar = Color3.fromRGB(0, 0, 0) -- Blue title bar (Top Bar)
}

for index, value in pairs(Theme) do
	pcall(Venyx.setTheme, Venyx, index, value)
end

local function GetVehicleFromDescendant(Descendant)
	return
		Descendant:FindFirstAncestor(LocalPlayer.Name .. "'s Car") or
		(Descendant:FindFirstAncestor("Body") and Descendant:FindFirstAncestor("Body").Parent) or
		(Descendant:FindFirstAncestor("Misc") and Descendant:FindFirstAncestor("Misc").Parent) or
		Descendant:FindFirstAncestorWhichIsA("Model")
end

local function TeleportVehicle(CoordinateFrame: CFrame)
	local Parent = LocalPlayer.Character.Parent
	local Vehicle = GetVehicleFromDescendant(LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").SeatPart)
	LocalPlayer.Character.Parent = Vehicle
	local success, response = pcall(function()
		return Vehicle:SetPrimaryPartCFrame(CoordinateFrame)
	end)
	if not success then
		return Vehicle:MoveTo(CoordinateFrame.Position)
	end
end


local vehiclePage = Venyx:addPage("Vehicle", 8356815386)
local usageSection = vehiclePage:addSection("Usage")
local velocityEnabled = true;
usageSection:addToggle("Keybinds Active", velocityEnabled, function(v) velocityEnabled = v end)
local flightSection = vehiclePage:addSection("Flight")
local flightEnabled = false
local flightSpeed = 1
flightSection:addToggle("Enabled", false, function(v) flightEnabled = v end)
flightSection:addSlider("Speed", 100, 0, 800, function(v) flightSpeed = v / 100 end)
local defaultCharacterParent 
RunService.Stepped:Connect(function()
	local Character = LocalPlayer.Character
	if flightEnabled == true then
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
local speedSection = vehiclePage:addSection("Acceleration")
local velocityMult = 0.025;
speedSection:addSlider("Multiplier (Thousandths)", 25, 0, 50, function(v) velocityMult = v / 1000; end)
local velocityEnabledKeyCode = Enum.KeyCode.W;
speedSection:addKeybind("Velocity Enabled", velocityEnabledKeyCode, function()
	if not velocityEnabled then
		return
	end
	while UserInputService:IsKeyDown(velocityEnabledKeyCode) do
		task.wait(0)
		local Character = LocalPlayer.Character
		if Character and typeof(Character) == "Instance" then
			local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
			if Humanoid and typeof(Humanoid) == "Instance" then
				local SeatPart = Humanoid.SeatPart
				if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
					SeatPart.AssemblyLinearVelocity *= Vector3.new(1 + velocityMult, 1, 1 + velocityMult)
				end
			end
		end
		if not velocityEnabled then
			break
		end
	end
end, function(v) velocityEnabledKeyCode = v.KeyCode end)
local decelerateSelection = vehiclePage:addSection("Deceleration")
local qbEnabledKeyCode = Enum.KeyCode.S
local velocityMult2 = 150e-3
decelerateSelection:addSlider("Brake Force (Thousandths)", velocityMult2*1e3, 0, 300, function(v) velocityMult2 = v / 1000; end)
decelerateSelection:addKeybind("Quick Brake Enabled", qbEnabledKeyCode, function()
	if not velocityEnabled then
		return
	end
	while UserInputService:IsKeyDown(qbEnabledKeyCode) do
		task.wait(0)
		local Character = LocalPlayer.Character
		if Character and typeof(Character) == "Instance" then
			local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
			if Humanoid and typeof(Humanoid) == "Instance" then
				local SeatPart = Humanoid.SeatPart
				if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
					SeatPart.AssemblyLinearVelocity *= Vector3.new(1 - velocityMult2, 1, 1 - velocityMult2)
				end
			end
		end
		if not velocityEnabled then
			break
		end
	end
end, function(v) qbEnabledKeyCode = v.KeyCode end)
decelerateSelection:addKeybind("Stop the Vehicle", Enum.KeyCode.P, function(v)
	if not velocityEnabled then
		return
	end
	local Character = LocalPlayer.Character
	if Character and typeof(Character) == "Instance" then
		local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
		if Humanoid and typeof(Humanoid) == "Instance" then
			local SeatPart = Humanoid.SeatPart
			if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
				SeatPart.AssemblyLinearVelocity *= Vector3.new(0, 0, 0)
				SeatPart.AssemblyAngularVelocity *= Vector3.new(0, 0, 0)
			end
		end
	end
end)
local springSection = vehiclePage:addSection("Springs")
springSection:addToggle("Visible", false, function(v)
	local Character = LocalPlayer.Character
	if Character and typeof(Character) == "Instance" then
		local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
		if Humanoid and typeof(Humanoid) == "Instance" then
			local SeatPart = Humanoid.SeatPart
			if SeatPart and typeof(SeatPart) == "Instance" and SeatPart:IsA("VehicleSeat") then
				local Vehicle = GetVehicleFromDescendant(SeatPart)
				for _, SpringConstraint in pairs(Vehicle:GetDescendants()) do
					if SpringConstraint:IsA("SpringConstraint") then
						SpringConstraint.Visible = v
					end
				end
			end
		end
	end
end)

local suspensionSection = vehiclePage:addSection("Suspension")

-- Default suspension parameters for Greenville
local suspensionStrength = 1
local suspensionMaxDistance = 10 -- Max distance the suspension can travel
local suspensionSpring = 50 -- Suspension stiffness (spring constant)
local suspensionDamping = 0.5 -- Suspension damping
local suspensionRestitution = 0.3 -- Bounciness of suspension (Restitution)

-- Add sliders for suspension parameters
suspensionSection:addSlider("Suspension Strength", 100, 0, 200, function(v)
    suspensionStrength = v / 100
end)

suspensionSection:addSlider("Max Suspension Distance", suspensionMaxDistance, 0, 50, function(v)
    suspensionMaxDistance = v
end)

suspensionSection:addSlider("Suspension Spring", suspensionSpring, 0, 100, function(v)
    suspensionSpring = v
end)

suspensionSection:addSlider("Suspension Damping", suspensionDamping, 0, 2, function(v)
    suspensionDamping = v
end)

suspensionSection:addSlider("Suspension Restitution", suspensionRestitution, 0, 1, function(v)
    suspensionRestitution = v
end)

-- Function to adjust suspension parameters
local function AdjustSuspension()
    local Vehicle = GetVehicleFromDescendant(LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").SeatPart)
    if Vehicle then
        -- Loop through the parts of the vehicle and apply suspension changes
        for _, part in pairs(Vehicle:GetDescendants()) do
            if part:IsA("SpringConstraint") then
                local spring = part
                -- Adjust suspension properties
                spring.Stiffness = suspensionSpring * suspensionStrength
                spring.Damping = suspensionDamping
                spring.Restitution = suspensionRestitution
            end
        end
    end
end

-- Run this function every frame to apply the suspension changes
RunService.Stepped:Connect(function()
    AdjustSuspension()
end)

-- 🚗 Get the Player's Vehicle
local function GetVehicleFromDescendant(Descendant)
    return
        Descendant:FindFirstAncestor(LocalPlayer.Name .. "'s Car") or
        (Descendant:FindFirstAncestor("Body") and Descendant:FindFirstAncestor("Body").Parent) or
        (Descendant:FindFirstAncestor("Misc") and Descendant:FindFirstAncestor("Misc").Parent) or
        Descendant:FindFirstAncestorWhichIsA("Model")
end

-- 🧼 Car Wash Function
local function CleanVehicle()
    local Character = LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
        if Humanoid then
            local SeatPart = Humanoid.SeatPart
            if SeatPart and SeatPart:IsA("VehicleSeat") then
                local Vehicle = GetVehicleFromDescendant(SeatPart)
                if Vehicle and Vehicle:IsA("Model") then
                    for _, Part in pairs(Vehicle:GetDescendants()) do
                        if Part:IsA("BasePart") then
                            Part.Material = Enum.Material.SmoothPlastic
                            Part.Color = Part.Color
                        elseif Part:IsA("Decal") or Part:IsA("Texture") then
                            Part:Destroy()
                        elseif Part:IsA("ParticleEmitter") then
                            Part.Enabled = false
                        end
                    end
                    print("✅ Car has been cleaned!")
                end
            end
        end
    end
end

-- 🚗 Reset Suspension
local function ResetSuspension()
    local Character = LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
        if Humanoid then
            local SeatPart = Humanoid.SeatPart
            if SeatPart and SeatPart:IsA("VehicleSeat") then
                local Vehicle = GetVehicleFromDescendant(SeatPart)
                if Vehicle and Vehicle:IsA("Model") then
                    -- Reset all SpringConstraints in the vehicle
                    for _, constraint in pairs(Vehicle:GetDescendants()) do
                        if constraint:IsA("SpringConstraint") then
                            -- Reset properties of the SpringConstraint (like Restitution, Spring, Damping, etc.)
                            constraint.Restitution = 0.1
                            constraint.Spring = 500
                            constraint.Damping = 10
                            print("✅ Suspension reset for vehicle!")
                        end
                    end
                end
            end
        end
    end
end

local gravitySection = vehiclePage:addSection("Gravity")
local gravityEnabled = true

gravitySection:addToggle("Toggle Gravity", gravityEnabled, function(v)
    gravityEnabled = v
    Workspace.Gravity = gravityEnabled and 196.2 or 50 -- Default is 196.2, reducing it allows for drifting
end)

-- 🛠️ Auto-Farm Function (Auto Driving)
local autoFarmEnabled = false
local autoFarmPath = {
    Vector3.new(233.824, -113.154, -1976.5), -- First point
    Vector3.new(350, -113.154, -2000),      -- Second point
    Vector3.new(394.7141418457031, -113.15401458740234, -2086.81201171875), -- Third point (e.g., Car Wash)
    Vector3.new(-340, 0, -1780)              -- Additional point
}

local function StartAutoFarm()
    autoFarmEnabled = true
    local Character = LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
        if Humanoid then
            local SeatPart = Humanoid.SeatPart
            if SeatPart and SeatPart:IsA("VehicleSeat") then
                local Vehicle = GetVehicleFromDescendant(SeatPart)
                if Vehicle and Vehicle:IsA("Model") then
                    -- Move the vehicle along the path
                    for _, targetPosition in pairs(autoFarmPath) do
                        Vehicle:SetPrimaryPartCFrame(CFrame.new(targetPosition))
                        task.wait(5) -- Wait for the vehicle to "drive" to the next point
                    end
                    print("✅ Auto-Farming route complete!")
                end
            end
        end
    end
end

local function StopAutoFarm()
    autoFarmEnabled = false
    print("✅ Auto-Farming stopped!")
end

-- 🌆 Greenville Section
local greenvillePage = Venyx:addPage("Greenville", 8360925727)
local carWashSection = greenvillePage:addSection("Car Maintenance")
carWashSection:addButton("🧼 Clean Car", function()
    CleanVehicle()
end)
carWashSection:addButton("🔧 Reset Suspension", function()
    ResetSuspension()
end)

-- 🚗 AutoFarm Section
local autoFarmSection = greenvillePage:addSection("AutoFarm")
autoFarmSection:addToggle("Enable Auto-Farm", autoFarmEnabled, function(v)
    if v then
        StartAutoFarm()
    else
        StopAutoFarm()
    end
end)

-- 🗺️ Teleportation Feature
local teleportPage = Venyx:addPage("Teleport", 8360954483)
local teleportSection = teleportPage:addSection("Teleport to Locations")

-- Locations you can teleport to
local locations = {
    ["Ron Rivers"] = Vector3.new(-3530.6806640625, -108.31282043457031, -1824.451171875),
    ["Roadmap"] = Vector3.new(-1598.7572021484375, -70.73762512207031, -11392.33984375),
    ["Airport"] = Vector3.new(6162.04296875, -73.60029602050781, -10575.81640625),
    ["Tires+"] = Vector3.new(4044.387451171875, -74.85147857666016, -11513.2763671875),
    ["Horton"] = Vector3.new(-1569.36572265625, -106.58362579345703, 4074.724853515625)
}

-- Adding the locations to the dropdown menu
local locationNames = {}
for name, _ in pairs(locations) do
    table.insert(locationNames, name)
end

-- Add Dropdown for teleportation
teleportSection:addDropdown("Select Location", locationNames, function(locationName)
    local targetPosition = locations[locationName]
    if targetPosition then
        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
        print("✅ Teleported to: " .. locationName)
    end
end)

local infoPage = Venyx:addPage("Information", 8356778308)
local discordSection = infoPage:addSection("Discord")

discordSection:addButton(syn and "Join the Discord server" or "Copy Discord Link", function()
    if syn then
        syn.request({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Origin"] = "https://discord.com"
            },
            Body = game:GetService("HttpService"):JSONEncode({
                cmd = "INVITE_BROWSER",
                args = { code = "CFmMkx4kE8" },
                nonce = game:GetService("HttpService"):GenerateGUID(false)
            }),
        })
        return
    end
    setclipboard("https://www.discord.com/invite/CFmMkx4kE8")
end)

-- Close UI Button
local closeSection = infoPage:addSection("Close UI")
closeSection:addButton("Close UI", function()
    Venyx:toggle()
end)
