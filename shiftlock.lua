local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-------------------------------------------------
-- GUI SETUP
-------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "KeyPicker"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,160,0,160)
frame.Position = UDim2.new(0.05,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)

-- Display label
local label = Instance.new("TextLabel")
label.Parent = frame
label.Size = UDim2.new(1,-10,1,-40)
label.Position = UDim2.new(0,5,0,35)
label.BackgroundTransparency = 1
label.TextScaled = true
label.TextWrapped = true
label.TextColor3 = Color3.new(1,1,1)
label.Text = "Press any key..."

-- Title bar
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,-30,0,30)
title.Position = UDim2.new(0,5,0,0)
title.BackgroundTransparency = 1
title.Text = "Key Picker"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

-- Minimize button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Parent = frame
minimizeBtn.Size = UDim2.new(0,25,0,25)
minimizeBtn.Position = UDim2.new(1,-28,0,3)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

local miniCorner = Instance.new("UICorner", minimizeBtn)

-------------------------------------------------
-- MINIMIZE LOGIC
-------------------------------------------------
local minimized = false
local normalSize = frame.Size
local normalChildren = {}

local function setChildrenVisible(state)
	for _,obj in pairs(frame:GetChildren()) do
		if obj ~= minimizeBtn and obj:IsA("GuiObject") then
			obj.Visible = state
		end
	end
end

minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	
	if minimized then
		setChildrenVisible(false)
		frame.Size = UDim2.new(0,40,0,40)
		minimizeBtn.Text = "+"
		minimizeBtn.Size = UDim2.new(1,-6,1,-6)
		minimizeBtn.Position = UDim2.new(0,3,0,3)
	else
		frame.Size = normalSize
		setChildrenVisible(true)
		minimizeBtn.Text = "-"
		minimizeBtn.Size = UDim2.new(0,25,0,25)
		minimizeBtn.Position = UDim2.new(1,-28,0,3)
	end
end)

-------------------------------------------------
-- KEY DETECTION
-------------------------------------------------
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if minimized then return end
	
	if input.UserInputType == Enum.UserInputType.Keyboard then
		label.Text = "Enum.KeyCode." .. input.KeyCode.Name
	end
end)
