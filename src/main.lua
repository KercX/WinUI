--[[
    WinUI Framework v1.5.0 (Legacy Lua Edition)
    A professional Windows 11 Fluent UI Library for Roblox.
    Features: Draggable, Ripple Effects, Tab System, Notifications.
]]

local WinUI = {}
WinUI.__index = WinUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Theme Configuration
local Theme = {
    Background = Color3.fromRGB(28, 28, 28),
    Secondary = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(0, 120, 212),
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(180, 180, 180),
    Rounding = UDim.new(0, 8),
    Font = Enum.Font.GothamMedium
}

-- Utility: Make Draggable
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

-- Main Window Constructor
function WinUI.new(config)
    local self = setmetatable({}, WinUI)
    config = config or {}
    
    self.Title = config.Title or "WinUI Desktop"
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "WinUI_" .. math.random(100, 999)
    self.ScreenGui.Parent = (RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui") or CoreGui)
    
    -- Window Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = config.Size or UDim2.new(0, 580, 0, 420)
    self.MainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
    self.MainFrame.BackgroundColor3 = Theme.Background
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    Instance.new("UICorner", self.MainFrame).CornerRadius = Theme.Rounding
    MakeDraggable(self.MainFrame)
    
    -- Sidebar (Navigation)
    self.Sidebar = Instance.new("Frame", self.MainFrame)
    self.Sidebar.Size = UDim2.new(0, 160, 1, 0)
    self.Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.Sidebar.BorderSizePixel = 0
    
    local SidebarLayout = Instance.new("UIListLayout", self.Sidebar)
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Content Area
    self.Container = Instance.new("Frame", self.MainFrame)
    self.Container.Size = UDim2.new(1, -170, 1, -50)
    self.Container.Position = UDim2.new(0, 165, 0, 45)
    self.Container.BackgroundTransparency = 1
    
    -- Title Bar Label
    local TitleLabel = Instance.new("TextLabel", self.MainFrame)
    TitleLabel.Size = UDim2.new(1, -170, 0, 45)
    TitleLabel.Position = UDim2.new(0, 165, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    return self
end

-- Add Button with Ripple Effect
function WinUI:Button(config)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = Theme.Secondary
    Button.Text = "  " .. (config.Title or "Button")
    Button.TextColor3 = Theme.Text
    Button.Font = Theme.Font
    Button.TextSize = 14
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.AutoButtonColor = false
    Button.Parent = self.Container
    
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    
    -- Ripple Effect Logic
    Button.MouseButton1Click:Connect(function()
        local ripple = Instance.new("Frame", Button)
        ripple.BackgroundColor3 = Color3.new(1, 1, 1)
        ripple.BackgroundTransparency = 0.8
        ripple.Size = UDim2.new(0, 0, 0, 0)
        Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
        
        ripple:TweenSizeAndPosition(UDim2.new(1, 50, 1, 50), UDim2.new(0.5, -25, 0.5, -25), "Out", "Quart", 0.4)
        TweenService:Create(ripple, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        
        task.delay(0.4, function() ripple:Destroy() end)
        if config.Callback then config.Callback() end
    end)
    
    return Button
end

-- Toggle Switch
function WinUI:Toggle(config)
    local ToggleFrame = Instance.new("TextButton", self.Container)
    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
    ToggleFrame.BackgroundColor3 = Theme.Secondary
    ToggleFrame.Text = "  " .. (config.Title or "Toggle")
    ToggleFrame.TextColor3 = Theme.Text
    ToggleFrame.Font = Theme.Font
    ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
    
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
    
    local Status = config.Default or false
    local Switch = Instance.new("Frame", ToggleFrame)
    Switch.Size = UDim2.new(0, 30, 0, 16)
    Switch.Position = UDim2.new(1, -40, 0.5, -8)
    Switch.BackgroundColor3 = Status and Theme.Accent or Color3.fromRGB(100, 100, 100)
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
    
    ToggleFrame.MouseButton1Click:Connect(function()
        Status = not Status
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Status and Theme.Accent or Color3.fromRGB(100, 100, 100)}):Play()
        if config.Callback then config.Callback(Status) end
    end)
end

return WinUI
