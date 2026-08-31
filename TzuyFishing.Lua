local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local buffLuck = ReplicatedStorage:WaitForChild("BuffLuck")

local gui = Instance.new("ScreenGui")
gui.Name = "LuckMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Nút mở menu
local open = Instance.new("TextButton")
open.Size = UDim2.fromOffset(55, 55)
open.Position = UDim2.new(0, 20, 0.5, -30)
open.Text = "🍀"
open.TextSize = 25
open.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
open.TextColor3 = Color3.new(1,1,1)
open.Parent = gui

-- Menu
local menu = Instance.new("Frame")
menu.Size = UDim2.fromOffset(250, 150)
menu.Position = UDim2.new(0.5, -125, 0.5, -75)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
menu.Visible = false
menu.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "Tzuy Hub • Luck"
title.TextSize = 20
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Parent = menu

local luck = Instance.new("TextButton")
luck.Size = UDim2.new(1, -30, 0, 55)
luck.Position = UDim2.fromOffset(15, 65)
luck.Text = "🍀 BUFF LUCK 100%"
luck.TextSize = 18
luck.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
luck.TextColor3 = Color3.new(1,1,1)
luck.Parent = menu

open.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

luck.MouseButton1Click:Connect(function()
	buffLuck:FireServer()
	luck.Text = "✅ LUCK: 100%"
end)
