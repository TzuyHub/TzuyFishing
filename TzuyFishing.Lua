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

-- Tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TzuyFishingGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Tạo Frame chính của Menu
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
titleLabel.Text = "  BLOX FRUITS - TzuyFishing"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

-- Nút Thu Nhỏ/Ẩn Menu
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

-- Hàm tạo Toggle Button
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

-- Thêm các tính năng vào Menu (theo yêu cầu của bạn)
createToggle("Tự Động Câu Cá (Auto Equip & Cast)", 60, function(state)
    _GConfig.AutoFish = state
end)

createToggle("Câu Hoàn Hảo & Lên Cá 1 Phát (Perfect Catch)", 110, function(state)
    _GConfig.PerfectCatch = state
end)

createToggle("Tự Động Nhặt Rương (Catch Chest)", 160, function(state)
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

    -- 2. Tự động câu cá, cắn câu giật lên 1 phát (Hoàn Hảo)
    if _GConfig.AutoFish or _GConfig.PerfectCatch then
        pcall(function()
            local tool = character:FindFirstChildOfClass("Tool")
            
            -- Nếu chưa cầm cần câu, tự động tìm và trang bị
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

            -- Đã cầm cần câu: Tự động thả cần (Cast) nếu chưa thả
            if tool and (tool.Name:find("Fishing") or tool.Name:find("Rod")) and _GConfig.AutoFish then
                -- Kiểm tra xem có đang không câu không (thường dựa vào animation hoặc state trên tool)
                -- Nếu tool có remote event "Cast", gọi nó
                if tool:FindFirstChild("RemoteEvent") then
                    tool.RemoteEvent:FireServer("Cast")
                end
            end

            -- Can thiệp vào mini-game để giật lên ngay lập tức 1 phát (Perfect Catch)
            if _GConfig.PerfectCatch then
                for _, gui in ipairs(playerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") and (gui.Name:find("Fish") or gui.Name:find("Mini") or gui.Name:find("UI") or gui.Name:find("Progress")) then
                        for _, v in ipairs(gui:GetDescendants()) do
                            -- Click vào nút "Giật" hoặc "Nhận Cá" ngay lập tức
                            if v:IsA("TextButton") or v:IsA("ImageButton") or v.Name:find("Button") then
                                -- Ép vị trí để giả lập tương tác trúng điểm hoàn hảo
                                v.Position = UDim2.new(0.5, 0, 0.5, 0) -- Giả lập click vào trung tâm
                            end
                            -- Kéo thanh progress (thanh câu cá) lên max để hoàn thành
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
