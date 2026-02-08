local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")

local player = Players.LocalPlayer

-------------------------------------------------
-- GUI FIRST (ALWAYS)
-------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ShiftLockRebinder"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,140,0,140)
frame.Position = UDim2.new(0.05,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-10,0,30)
title.Position = UDim2.new(0,5,0,5)
title.BackgroundTransparency = 1
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.Text = "ShiftLock"

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1,-10,0,50)
label.Position = UDim2.new(0,5,0,40)
label.BackgroundTransparency = 1
label.TextWrapped = true
label.TextScaled = true
label.TextColor3 = Color3.new(1,1,1)
label.Text = "Loading..."

local bindBtn = Instance.new("TextButton", frame)
bindBtn.Size = UDim2.new(1,-10,0,30)
bindBtn.Position = UDim2.new(0,5,1,-35)
bindBtn.Text = "Change Key"
bindBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", bindBtn)

-------------------------------------------------
-- MINIMIZE
-------------------------------------------------
local minimized = false
local miniBtn = Instance.new("TextButton", frame)
miniBtn.Size = UDim2.new(0,22,0,22)
miniBtn.Position = UDim2.new(1,-25,0,5)
miniBtn.Text = "-"
miniBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
Instance.new("UICorner", miniBtn)

miniBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	label.Visible = not minimized
	bindBtn.Visible = not minimized
	frame.Size = minimized and UDim2.new(0,40,0,40) or UDim2.new(0,140,0,140)
	miniBtn.Text = minimized and "+" or "-"
	miniBtn.Position = minimized and UDim2.new(0,9,0,9) or UDim2.new(1,-25,0,5)
end)

-------------------------------------------------
-- GET CAMERA + MOUSELOCK (CORRECT WAY)
-------------------------------------------------
local mouseLockController
task.spawn(function()
	local ps = player:WaitForChild("PlayerScripts")
	local pm = require(ps:WaitForChild("PlayerModule"))
	local cameras = pm:GetCameras()

	repeat
		mouseLockController = cameras.activeMouseLockController
		task.wait()
	until mouseLockController

	label.Text = "Key: G"

	-- Block Shift ONLY after success
	CAS:BindAction(
		"BlockShiftLock",
		function()
			return Enum.ContextActionResult.Sink
		end,
		false,
		Enum.KeyCode.LeftShift,
		Enum.KeyCode.RightShift
	)
end)

-------------------------------------------------
-- SHIFT-LOCK TOGGLE (NEW METHOD)
-------------------------------------------------
local shiftLocked = false
local currentKey = Enum.KeyCode.G
local waiting = false

local function toggleShiftLock()
	if not mouseLockController then return end
	shiftLocked = not shiftLocked
	mouseLockController:SetIsMouseLocked(shiftLocked)
end

local function bindKey()
	CAS:UnbindAction("CustomShiftLock")
	CAS:BindAction(
		"CustomShiftLock",
		function(_, state)
			if state == Enum.UserInputState.Begin then
				toggleShiftLock()
			end
		end,
		false,
		currentKey
	)
end

bindKey()

-------------------------------------------------
-- KEY CHANGE
-------------------------------------------------
bindBtn.MouseButton1Click:Connect(function()
	waiting = true
	label.Text = "Press a key..."
end)

UIS.InputBegan:Connect(function(input, gp)
	if gp or not waiting then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

	waiting = false
	currentKey = input.KeyCode
	label.Text = "Key: "..currentKey.Name
	bindKey()
end)
