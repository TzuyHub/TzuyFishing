local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("BloxFruitHub") then
    CoreGui.BloxFruitHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitHub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "  Blox Fruit Hub - Premium"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

print("Đã tải xong Phần 1: Giao diện cơ bản.")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

getgenv().AutoFarm = false

local function getQuest()
    -- Logic quét NPC nhận nhiệm vụ dựa trên Level
    local level = LocalPlayer.Data.Level.Value
    -- Ví dụ cơ bản nhận quest (tùy chỉnh theo Sea hiện tại)
    print("Đang kiểm tra nhiệm vụ cho cấp độ: " .. level)
end

task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoFarm then
            pcall(function()
                -- Gọi hàm tự động farm ở đây
                getQuest()
            end)
        end
    end
end)

print("Đã tải xong Phần 2: Cơ chế Auto Farm.")
local function createESP(targetPart, color, name)
    if not targetPart:FindFirstChild("Highlight_ESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "Highlight_ESP"
        highlight.Adornee = targetPart
        highlight.FillColor = color
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = targetPart
    end
end

-- Ví dụ quét Fruit trên map
for _, v in pairs(Workspace:GetChildren()) do
    if v:IsA("Tool") and string.find(v.Name, "Fruit") then
        createESP(v, Color3.fromRGB(0, 255, 0), v.Name)
    end
end

print("Đã tải xong Phần 3: Cơ chế ESP.")
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 140, 0, 35)
ToggleButton.Position = UDim2.new(0, 15, 0, 60)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.Text = "Bật Auto Farm"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    getgenv().AutoFarm = not getgenv().AutoFarm
    if getgenv().AutoFarm then
        ToggleButton.Text = "Tắt Auto Farm"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    else
        ToggleButton.Text = "Bật Auto Farm"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end)

print("Hoàn tất toàn bộ mã nguồn Blox Fruit Hub!")
