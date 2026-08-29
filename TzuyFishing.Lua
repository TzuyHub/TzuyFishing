-- Blox Fruits Auto Fishing & Chest Hub - TzuyFishing (Fixed & Notified)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cấu hình trạng thái tính năng
local _GConfig = {
    AutoFish = false,    -- Tự động trang bị và thực hiện câu cá
    CatchChest = false,  -- Tự động nhặt rương
}

-- Hàm tạo thông báo nổi trong game (Notification)
local function sendNotification(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 2,
        })
    end)
end

-- Xóa Menu cũ nếu có để tránh trùng lặp
if playerGui:FindFirstChild("TzuyFishingGui") then
    playerGui.TzuyFishingGui:Destroy()
end

-- Tạo giao diện Menu chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TzuyFishingGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 360, 0, 230)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -115)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Tiêu đề
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

-- Nút thu nhỏ (-)
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

-- Hàm tạo Toggle Button tích hợp thông báo
local function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 40)
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

-- Tạo 2 nút tính năng chuẩn
createToggle("Tự Động Câu Cá (Auto Fish)", 50, function(state)
    _GConfig.AutoFish = state
    if state then
        sendNotification("TzuyFishing", "Đã Bật: Tự Động Câu Cá!", 2)
    else
        sendNotification("TzuyFishing", "Đã Tắt: Tự Động Câu Cá!", 2)
    end
end)

createToggle("Tự Động Nhặt Rương (Catch Chest)", 105, function(state)
    _GConfig.CatchChest = state
    if state then
        sendNotification("TzuyFishing", "Đã Bật: Tự Động Nhặt Rương!", 2)
    else
        sendNotification("TzuyFishing", "Đã Tắt: Tự Động Nhặt Rương!", 2)
    end
end)

-- Nút nổi mở lại menu khi ẩn
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

local menuVisible = true
local function toggleMenuState()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
    floatingToggleBtn.Visible = not menuVisible
end

minimizeBtn.MouseButton1Click:Connect(toggleMenuState)
floatingToggleBtn.MouseButton1Click:Connect(toggleMenuState)

-- Vòng lặp xử lý Nhặt Rương
RunService.Stepped:Connect(function()
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

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
end)

-- Vòng lặp Tự Động Câu Cá (Ổn định, tự cầm cần và ném cần đúng chức năng)
task.spawn(function()
    while true do
        task.wait(1) -- Thời gian chờ hợp lý giữa các lần ném cần để game không bị lag hoặc lỗi
        if _GConfig.AutoFish then
            pcall(function()
                local character = player.Character
                if not character then return end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not humanoid or not hrp then return end

                -- Tự động lấy cần câu trong balo nếu chưa cầm trên tay
                local tool = character:FindFirstChildOfClass("Tool")
                if not tool or not (tool.Name:find("Fishing") or tool.Name:find("Rod")) then
                    local backpack = player:FindFirstChildOfClass("Backpack")
                    if backpack then
                        for _, item in ipairs(backpack:GetChildren()) do
                            if item.Name:find("Fishing") or item.Name:find("Rod") then
                                humanoid:EquipTool(item)
                                task.wait(0.3)
                                tool = item
                            end
                        end
                    end
                end

                -- Nếu đang cầm cần câu, gửi lệnh ném cần
                if tool and (tool.Name:find("Fishing") or tool.Name:find("Rod")) then
                    if tool:FindFirstChild("RemoteEvent") then
                        tool.RemoteEvent:FireServer("Cast")
                    end
                end
            end)
        end
    end
end)

-- Thông báo khi script load thành công
sendNotification("TzuyFishing Hub", "Đã tải thành công! Nhấn vào nút để sử dụng.", 3)
