local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")

local player = Players.LocalPlayer

-------------------------------------------------
-- CONFIG (DEFAULT KEY)
-------------------------------------------------
local currentKey = Enum.KeyCode.G
local waitingForKey = false

-------------------------------------------------
-- GET MOUSELOCK CONTROLLER
-------------------------------------------------
local function getMouseLockController()
	local ps = player:WaitForChild("PlayerScripts")
	local pm = require(ps:WaitForChild("PlayerModule"))
	local cam = pm:GetCameras()
	return cam.activeMouseLockController or cam.MouseLockController
end

local mouseLock
repeat
	task.wait()
	mouseLock = getMouseLockController()
until mouseLock

-------------------------------------------------
-- BLOCK SHIFT COMPLETELY
-------------------------------------------------
CAS:BindAction(
	"BlockShiftLock",
	function()
		return Enum.ContextActionResult.Sink
	end,
	false,
	Enum.KeyCode.LeftShift,
	Enum.KeyCode.RightShift
)

-------------------------------------------------
-- CUSTOM TOGGLE FUNCTION
-------------------------------------------------
local function toggleShiftLock()
	if mouseLock then
		mouseLock:ToggleMouseLock()
	end
end

local function bindCustomKey()
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

bindCustomKey()

-------------------------------------------------
-- GUI
-------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,120,0,120)
frame.Position = UDim2.new(0.05,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1,-10,1,-40)
label.Position = UDim2.new(0,5,0,35)
label.BackgroundTransparency = 1
label.TextScaled = true
label.TextWrapped = true
label.TextColor3 = Color3.new(1,1,1)
label.Text = "ShiftLock\nKey:\n"..currentKey.Name

local bindBtn = Instance.new("TextButton", frame)
bindBtn.Size = UDim2.new(1,-10,0,30)
bindBtn.Position = UDim2.new(0,5,0,5)
bindBtn.Text = "Change Key"
bindBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", bindBtn)

-------------------------------------------------
-- MINIMIZE BUTTON
-------------------------------------------------
local minimized = false
local miniBtn = Instance.new("TextButton", frame)
miniBtn.Size = UDim2.new(0,25,0,25)
miniBtn.Position = UDim2.new(1,-28,1,-28)
miniBtn.Text = "-"
miniBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
Instance.new("UICorner", miniBtn)

miniBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		label.Visible = false
		bindBtn.Visible = false
		frame.Size = UDim2.new(0,40,0,40)
		miniBtn.Text = "+"
		miniBtn.Position = UDim2.new(0,7,0,7)
	else
		label.Visible = true
		bindBtn.Visible = true
		frame.Size = UDim2.new(0,120,0,120)
		miniBtn.Text = "-"
		miniBtn.Position = UDim2.new(1,-28,1,-28)
	end
end)

-------------------------------------------------
-- KEY REBIND LOGIC
-------------------------------------------------
bindBtn.MouseButton1Click:Connect(function()
	waitingForKey = true
	label.Text = "Press any key..."
end)

UIS.InputBegan:Connect(function(input, gp)
	if gp or not waitingForKey then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

	waitingForKey = false
	currentKey = input.KeyCode
	label.Text = "ShiftLock\nKey:\n"..currentKey.Name
	bindCustomKey()
end)
