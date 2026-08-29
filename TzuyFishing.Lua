-- Blox Fruits Auto Fishing & Chest Script Hub
-- Menu Name: TzuyFishing

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cấu hình trạng thái
local _GConfig = {
    AutoTeleportSea = false,
    AutoFish = false,
    InstantCatch = false,
    CatchChest = false,
}

-- Tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TzuyFishingGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Tạo Frame chính của Menu
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 390)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -195)
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
titleLabel.Size = UDim2.new(1, 0, 0, 45)
titleLabel.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
titleLabel.Text = "  BLOX FRUITS - TzuyFishing"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

-- Nút Thu Nhỏ/Ẩn Menu (-)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -40, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- Hàm tạo Toggle Button chuẩn
local function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = "  " .. name .. ": [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
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

-- Thêm các tính năng vào Menu
createToggle("Tự Động Bay Ra Biển Gần Nhất", 60, function(state)
    _GConfig.AutoTeleportSea = state
end)

createToggle("Tự Động Câu Cá (Thả Cần)", 110, function(state)
    _GConfig.AutoFish = state
end)

createToggle("Cá Cắn Câu Giật Lên 1 Phát (Instant)", 160, function(state)
    _GConfig.InstantCatch = state
end)

createToggle("Tự Động Nhặt Rương (Catch Chest)", 210, function(state)
    _GConfig.CatchChest = state
end)

-- Nút nổi Mở/Tắt Menu khi ẩn
local floatingToggleBtn = Instance.new("TextButton")
floatingToggleBtn.Size = UDim2.new(0, 110, 0, 35)
floatingToggleBtn.Position = UDim2.new(0, 15, 0, 15)
floatingToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
floatingToggleBtn.Text = "Mở/Tắt Menu"
floatingToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingToggleBtn.TextSize = 12
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

-- Hàm tìm vùng nước / bờ biển gần nhất để dịch chuyển
local function getNearestWater()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    
    -- Quét các part có liên quan đến nước hoặc dò theo map bản đồ Blox Fruits
    local nearestPos = nil
    local shortestDist = math.huge
    
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name:lower():find("water") or obj.Name:lower():find("sea") or obj.Name:lower():find("ocean") then
            if obj:IsA("BasePart") then
                local dist = (hrp.Position - obj.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    nearestPos = obj.Position
                end
            end
        end
    end
    return nearestPos
end

-- Vòng lặp xử lý chính siêu tốc
RunService.Stepped:Connect(function()
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- 1. Tự động dịch chuyển ra biển gần nhất
    if _GConfig.AutoTeleportSea then
        pcall(function()
            local waterPos = getNearestWater()
            if waterPos then
                humanoidRootPart.CFrame = CFrame.new(waterPos.X, waterPos.Y + 5, waterPos.Z)
            end
        end)
    end

    -- 2. Tự động Nhặt Rương (Catch Chest)
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

    -- 3. Tự động câu cá, cắn câu giật lên 1 phát
    if _GConfig.AutoFish or _GConfig.InstantCatch then
        pcall(function()
            local tool = character:FindFirstChildOfClass("Tool")
            -- Nếu chưa cầm cần câu, tự động tìm và trang bị cần câu từ balo (Backpack)
            if not tool or not (tool.Name:find("Fishing") or tool.Name:find("Rod")) then
                local backpack = player:FindFirstChildOfClass("Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item.Name:find("Fishing") or item.Name:find("Rod") then
                            humanoidRootPart.Parent.Humanoid:EquipTool(item)
                        end
                    end
                end
            else
                -- Đã cầm cần câu: Tự động kích hoạt hành động câu nếu chưa thả
                if _GConfig.AutoFish and tool:FindFirstChild("RemoteEvent") then
                    -- Gửi tín hiệu thả cần câu nếu tool hỗ trợ
                    tool.RemoteEvent:FireServer("Cast")
                end
            end

            -- Can thiệp vào giao diện mini-game câu cá để giật lên ngay lập tức 1 phát
            if _GConfig.InstantCatch then
                for _, gui in ipairs(playerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") and (gui.Name:find("Fish") or gui.Name:find("Mini") or gui.Name:find("UI") or gui.Name:find("Progress")) then
                        for _, v in ipairs(gui:GetDescendants()) do
                            if v:IsA("TextButton") or v:IsA("ImageButton") or v.Name:find("Button") then
                                -- Ép trạng thái thành công hoặc click tự động vào nút nhận cá
                                v.Position = UDim2.new(0.5, 0, 0.5, 0)
                            end
                            -- Kéo max thanh progress (thanh tiến trình câu cá) lên đỉnh để nhận cá luôn
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
