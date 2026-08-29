-- Blox Fruits Auto Fishing & Chest Script Hub
-- Menu Name: TzuyFishing

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cấu hình trạng thái tính năng
local _GConfig = {
    AutoFish = false,        -- Tự động trang bị cần và thả cần
    PerfectCatch = false,    -- Tự động làm hoàn hảo mini-game giật cần
    CatchChest = false,      -- Tự động nhặt rương
}

-- Xóa Menu cũ nếu có để tránh bị trùng lặp giao diện
if playerGui:FindFirstChild("TzuyFishingGui") then
    playerGui.TzuyFishingGui:Destroy()
end

-- Tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TzuyFishingGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Tạo Frame chính của Menu (Thu gọn lại kích thước chuẩn để không tràn màn hình điện thoại)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 360, 0, 260)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Thanh tiêu đề
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
titleLabel.Text = "  BLOX FRUITS - TzuyFishing"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

-- Nút Thu Nhỏ/Ẩn Menu (-)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 16
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- Hàm tạo Toggle Button cân đối, không bị tràn viền
local function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 38)
    btn.Position = UDim2.new(0.04, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = "  " .. name .. ": [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = mainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = "  " .. name .. ": [ON]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Text = "  " .. name .. ": [OFF]"
        end
        callback(enabled)
    end)
end

-- Thêm các tính năng vào Menu với khoảng cách (posY) chuẩn xác
createToggle("Tự Động Câu Cá (Auto Equip & Cast)", 50, function(state)
    _GConfig.AutoFish = state
end)

createToggle("Câu Hoàn Hảo & Lên Cá 1 Phát", 98, function(state)
    _GConfig.PerfectCatch = state
end)

createToggle("Tự Động Nhặt Rương (Catch Chest)", 146, function(state)
    _GConfig.CatchChest = state
end)

-- Nút nổi Mở/Tắt Menu khi ẩn
local floatingToggleBtn = Instance.new("TextButton")
floatingToggleBtn.Size = UDim2.new(0, 100, 0, 32)
floatingToggleBtn.Position = UDim2.new(0, 15, 0, 15)
floatingToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
floatingToggleBtn.Text = "Mở/Tắt Menu"
floatingToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingToggleBtn.TextSize = 11
floatingToggleBtn.Font = Enum.Font.GothamBold
floatingToggleBtn.Visible = false
floatingToggleBtn.Parent = screenGui

local fCorner = Instance.new("UICorner")
fCorner.CornerRadius = UDim.new(0, 6)
fCorner.Parent = floatingToggleBtn

-- Xử lý ẩn hiện Menu
local menuVisible = true
local function toggleMenuState()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
    floatingToggleBtn.Visible = not menuVisible
end

minimizeBtn.MouseButton1Click:Connect(toggleMenuState)
floatingToggleBtn.MouseButton1Click:Connect(toggleMenuState)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        toggleMenuState()
    end
end)

-- Vòng lặp xử lý chính siêu tốc
RunService.Stepped:Connect(function()
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- 1. Tự động Nhặt Rương (Catch Chest)
    if _GConfig.CatchChest then
        pcall(function()
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name:find("Chest") and obj:FindFirstChild("HumanoidRootPart") then
                    firetouchinterest(humanoidRootPart, obj.HumanoidRootPart, 0)
                    firetouchinterest(humanoidRootPart, obj.HumanoidRootPart, 1)
                end
            end
        end)
    end

    -- 2. Tự động câu cá & câu hoàn hảo
    if _GConfig.AutoFish or _GConfig.PerfectCatch then
        pcall(function()
            local tool = character:FindFirstChildOfClass("Tool")
            
            -- Nếu chưa cầm cần câu, tự động tìm và trang bị từ balo
            if not tool or not (tool.Name:find("Fishing") or tool.Name:find("Rod")) then
                local backpack = player:FindFirstChildOfClass("Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item.Name:find("Fishing") or item.Name:find("Rod") then
                            humanoidRootPart.Parent.Humanoid:EquipTool(item)
                        end
                    end
                end
            end

            -- Đã cầm cần câu: Tự động thả cần
            if tool and (tool.Name:find("Fishing") or tool.Name:find("Rod")) and _GConfig.AutoFish then
                if tool:FindFirstChild("RemoteEvent") then
                    tool.RemoteEvent:FireServer("Cast")
                end
            end

            -- Can thiệp mini-game để giật cá hoàn hảo 1 phát ăn ngay
            if _GConfig.PerfectCatch then
                for _, gui in ipairs(playerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") and (gui.Name:find("Fish") or gui.Name:find("Mini") or gui.Name:find("UI") or gui.Name:find("Progress")) then
                        for _, v in ipairs(gui:GetDescendants()) do
                            if v:IsA("TextButton") or v:IsA("ImageButton") or v.Name:find("Button") then
                                v.Position = UDim2.new(0.5, 0, 0.5, 0)
                            end
                            if v:IsA("Frame") and (v.Name:find("Bar") or v.Name:find("Progress") or v.Name:find("Fill")) then
                                v.Size = UDim2.new(1, 0, v.Size.Y.Scale, v.Size.Y.Offset)
                            end
                        end
                    end
                end
            end
        end)
    end
end)
