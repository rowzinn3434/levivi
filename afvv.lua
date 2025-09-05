--// NoxLera Hack Menu - Birleştirilmiş Ultra Güvenli Hileler v2
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NoxLeraGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 180, 0, 260)
Frame.Position = UDim2.new(1, -190, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
local corner = Instance.new("UICorner", Frame)
corner.CornerRadius = UDim.new(0, 10)

-- Başlık
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "NoxLeraX"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

-- Layout
local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Buton oluşturma
local function createButton(name, callback)
	local btn = Instance.new("Frame", Frame)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.BorderSizePixel = 0
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel", btn)
	label.Size = UDim2.new(1, -35, 1, 0)
	label.Position = UDim2.new(0, 5, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left

	local box = Instance.new("Frame", btn)
	box.Size = UDim2.new(0, 20, 0, 20)
	box.Position = UDim2.new(1, -25, 0.5, -10)
	box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	local border = Instance.new("UIStroke", box)
	border.Color = Color3.fromRGB(0, 0, 0)
	border.Thickness = 2
	local boxCorner = Instance.new("UICorner", box)
	boxCorner.CornerRadius = UDim.new(0, 4)

	local state = false
	btn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			state = not state
			if state then
				box.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
			else
				box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			end
			callback(state)
		end
	end)
end

----------------------------------------------------------------
-- Hile Fonksiyonları
----------------------------------------------------------------

-- Player ESP (ölünce veya görünmez pelerini takınca kaybolmaz, isimler beyaz)
local espObjects = {}
local function updateESP()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				if not espObjects[plr] then
					local highlight = Instance.new("Highlight")
					highlight.Name = "NoxLera_HL"
					highlight.FillColor = Color3.fromRGB(0,255,0)
					highlight.FillTransparency = 0.7
					highlight.OutlineColor = Color3.fromRGB(0,255,0)
					highlight.Adornee = plr.Character
					highlight.Parent = plr.Character
					espObjects[plr] = highlight
				end
			end
		end
	end
	-- Temizle ölüleri
	for plr, hl in pairs(espObjects) do
		if not plr.Character or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
			if hl then hl:Destroy() end
			espObjects[plr] = nil
		end
	end
end

local espEnabled = false
local espConn
local function toggleESP(state)
	espEnabled = state
	if state then
		espConn = RunService.RenderStepped:Connect(updateESP)
	else
		if espConn then espConn:Disconnect() end
		for _, hl in pairs(espObjects) do
			if hl then hl:Destroy() end
		end
		espObjects = {}
	end
end

-- Speed Hack
local speedEnabled = false
local speedValue = 41
local speedConn
local function toggleSpeed(state)
	speedEnabled = state
	local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if state then
		if humanoid then humanoid.WalkSpeed = speedValue end
		speedConn = RunService.RenderStepped:Connect(function()
			if speedEnabled and humanoid and humanoid.WalkSpeed ~= speedValue then
				humanoid.WalkSpeed = speedValue
			end
		end)
	else
		if humanoid then humanoid.WalkSpeed = 16 end
		if speedConn then speedConn:Disconnect() end
	end
end

-- Infinity Jump (Ultra güvenli, can düşmesini engeller)
local infJumpEnabled = false
local jumpCooldown = false
local function toggleInfJump(state)
	infJumpEnabled = state
end

RunService.RenderStepped:Connect(function()
	if infJumpEnabled and LocalPlayer.Character then
		local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if humanoid and hrp then
			humanoid.Health = math.max(humanoid.Health, 20)
			if hrp.Velocity.Y < -50 then
				hrp.Velocity = Vector3.new(hrp.Velocity.X, -50, hrp.Velocity.Z)
			end
		end
	end
end)

UserInputService.JumpRequest:Connect(function()
	if infJumpEnabled and LocalPlayer.Character and not jumpCooldown then
		jumpCooldown = true
		local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid:ChangeState("Jumping") end
		task.delay(0.25, function() jumpCooldown = false end)
	end
end)

-- Float Hack (korumalı)
local floatEnabled = false
local floatForce
local function toggleFloat(state)
	floatEnabled = state
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if state and hrp then
		floatForce = Instance.new("BodyVelocity")
		floatForce.Velocity = Vector3.new(0,7,0)
		floatForce.MaxForce = Vector3.new(0,1e6,0)
		floatForce.P = 1250
		floatForce.Parent = hrp
	elseif floatForce then
		floatForce:Destroy()
		floatForce = nil
	end
end

RunService.RenderStepped:Connect(function()
	if floatEnabled and LocalPlayer.Character then
		local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hrp and humanoid then
			if hrp.Velocity.Y < -10 then
				hrp.Velocity = Vector3.new(hrp.Velocity.X, -10, hrp.Velocity.Z)
			end
			humanoid.Health = math.max(humanoid.Health, 20)
		end
	end
end)

----------------------------------------------------------------
-- Butonlar
----------------------------------------------------------------
createButton("Player ESP", toggleESP)
createButton("Speed Hack", toggleSpeed)
createButton("Infinity Jump", toggleInfJump)
createButton("Float Hack", toggleFloat)

-- Menü aç/kapa (sağ Ctrl)
local hiddenPosition = UDim2.new(1, 0, 0.2, 0)
local shownPosition = UDim2.new(1, -190, 0.2, 0)
Frame.Position = hiddenPosition

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.RightControl then
		if Frame.Position == hiddenPosition then
			TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = shownPosition}):Play()
		else
			TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = hiddenPosition}):Play()
		end
	end
end)