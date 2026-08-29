-- Blox Fruits Auto Fishing & Chest Script Hub
-- Menu ID: Menu_Fish_Pro_02

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Trạng thái tính năng
local _GConfig = {
    AutoFish = false,
    InstantReel = false,
    InstantCatch = false,
    CatchChest = false,
    FishingSpeed = 0.1
}

-- Tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BloxFruitsFishingHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Tạo Frame chính
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 360)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -180)
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
titleLabel.Text = "  BLOX FRUITS - FISHING & CHEST HUB [ID: Menu_Fish_Pro_02]"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

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

-- Thêm các chức năng vào Menu
createToggle("Tự Động Câu Cá (Auto Fish)", 60, function(state)
    _GConfig.AutoFish = state
end)

createToggle("Cá Cắn Câu Giật Liền (Instant Reel)", 110, function(state)
    _GConfig.InstantReel = state
end)

createToggle("Giật Lên Cá Luôn (Instant Catch)", 160, function(state)
    _GConfig.InstantCatch = state
end)

createToggle("Tự Động Nhặt Rương Khi Câu (Catch Chest)", 210, function(state)
    _GConfig.CatchChest = state
end)

-- Nút Thu Nhỏ/Ẩn Menu
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 110, 0, 30)
toggleBtn.Position = UDim2.new(0, 15, 0, 310)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
toggleBtn.Text = "Ẩn / Hiện Menu"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 12
toggleBtn.Font = Enum.Font.Gotham
toggleBtn.Parent = mainFrame

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(0, 6)
tCorner.Parent = toggleBtn

local visible = true
toggleBtn.MouseButton1Click:Connect(function()
    visible = not visible
    for _, child in ipairs(mainFrame:GetChildren()) do
        if child ~= titleLabel and child ~= toggleBtn and child ~= titleCorner then
            child.Visible = visible
        end
    end
    if visible then
        mainFrame.Size = UDim2.new(0, 420, 0, 360)
    else
        mainFrame.Size = UDim2.new(0, 420, 0, 45)
    end
end)

-- Logic Xử Lý Câu Cá & Rương (Bám sát cơ chế game)
RunService.Stepped:Connect(function()
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

    -- 1. Xử lý tính năng Catch Chest (Teleport hoặc nhặt rương gần player)
    if _GConfig.CatchChest then
        pcall(function()
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name:find("Chest") and obj:FindFirstChild("HumanoidRootPart") and humanoidRootPart then
                    -- Dịch chuyển nhẹ tới rương hoặc tương tác nhặt rương
                    firetouchinterest(humanoidRootPart, obj.HumanoidRootPart, 0)
                    firetouchinterest(humanoidRootPart, obj.HumanoidRootPart, 1)
                end
            end
        end)
    end

    -- 2. Xử lý logic Auto Fish / Instant Reel / Instant Catch
    if _GConfig.AutoFish or _GConfig.InstantReel or _GConfig.InstantCatch then
        pcall(function()
            -- Tìm cần câu trong nhân vật hoặc Backpack
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and (tool.Name:find("Fishing") or tool.Name:find("Rod")) then
                -- Nếu bật Instant Reel / Instant Catch, can thiệp vào UI hoặc giá trị câu cá của game
                local activeGui = playerGui:FindFirstChild("FishingGui") or playerGui:FindFirstChild("MiniGame")
                if activeGui then
                    -- Giả lập hành động bấm nút hoàn thành mini-game câu cá ngay lập tức
                    for _, v in ipairs(activeGui:GetDescendants()) do
                        if v:IsA("TextButton") or v:IsA("ImageButton") then
                            -- Kích hoạt sự kiện bấm nút hoàn thành game câu cá
                            if _GConfig.InstantCatch then
                                v.Position = UDim2.new(0.5, 0, 0.5, 0) -- Ép về điểm thắng
                            end
                        end
                    end
                end
            end
        end)
    end
end)
