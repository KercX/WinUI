--!strict
local WinUI = {}
WinUI.__index = WinUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [ПРОФЕСІЙНА ФУНКЦІЯ: DRAGGING]
local function MakeDraggable(gui)
	local dragging, dragInput, dragStart, startPos
	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
		end
	end)
	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end

function WinUI.new(config)
	local self = setmetatable({}, WinUI)
	
	-- Main Frame з ефектом Acrylic (напівпрозорість)
	self.Main = Instance.new("Frame")
	self.Main.Size = UDim2.new(0, 550, 0, 380)
	self.Main.Position = UDim2.new(0.5, -275, 0.5, -190)
	self.Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	self.Main.BackgroundTransparency = 0.1 -- Ефект скла
	self.Main.Parent = (RunService:IsStudio() and game.Players.LocalPlayer.PlayerGui or game:GetService("CoreGui"))

	-- [ПРОФЕСІЙНО: UIStroke для тонкої рамки Win11]
	local Stroke = Instance.new("UIStroke", self.Main)
	Stroke.Color = Color3.fromRGB(60, 60, 60)
	Stroke.Transparency = 0.5
	
	Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0, 8)
	MakeDraggable(self.Main) -- Робимо вікно рухомим

	-- Sidebar (Вкладки зліва)
	self.Sidebar = Instance.new("Frame", self.Main)
	self.Sidebar.Size = UDim2.new(0, 150, 1, 0)
	self.Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	self.Sidebar.BackgroundTransparency = 0.5
	Instance.new("UICorner", self.Sidebar).CornerRadius = UDim.new(0, 8)

	return self
end

-- [ПРОФЕСІЙНО: Ripple Effect (Ефект хвилі при кліку)]
function WinUI:Ripple(button)
	button.MouseButton1Click:Connect(function()
		local ripple = Instance.new("Frame", button)
		ripple.BackgroundColor3 = Color3.new(1, 1, 1)
		ripple.BackgroundTransparency = 0.8
		ripple.Size = UDim2.new(0, 0, 0, 0)
		Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
		
		ripple:TweenSizeAndPosition(UDim2.new(1, 100, 1, 100), UDim2.new(0.5, -50, 0.5, -50), "Out", "Quart", 0.5)
		TweenService:Create(ripple, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
		task.wait(0.5)
		ripple:Destroy()
	end)
end

return WinUI
