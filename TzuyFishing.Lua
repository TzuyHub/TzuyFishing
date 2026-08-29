-- Blox Fruits Auto Fishing Hub - TzuyFishing (Fixed Video Logic)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cấu hình trạng thái tính năng
local _GConfig = {
    AutoFish = false,    -- Tự động câu cá hoàn hảo theo video
    CatchChest = false,  -- Tự động nhặt rương
}

-- Xóa Menu cũ nếu có để tránh trùng lặp
if playerGui:FindFirstChild("TzuyFishingGui") then
    playerGui.TzuyFishingGui:Destroy()
end

-- Tạo giao diện Menu chính & Khung thông báo
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TzuyFishingGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- === HỆ THỐNG THÔNG BÁO GÓC TRÊN TRÁI ===
local notifFrame = Instance.new("Frame")
notifFrame.Name = "NotificationFrame"
notifFrame.Size = UDim2.new(0, 260, 0, 50)
notifFrame.Position = UDim2.new(0, -280, 0, 20)
notifFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
notifFrame.BorderSizePixel = 0
notifFrame.Parent = screenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notifFrame

local notifTitle = Instance.new("TextLabel")
notifTitle.Size = UDim2.new(1, -15, 0, 20)
notifTitle.Position = UDim2.new(0, 12, 0, 5)
notifTitle.BackgroundTransparency = 1
notifTitle.Text = "TzuyFishing Hub"
notifTitle.TextColor3 = Color3.fromRGB(0, 200, 120)
notifTitle.TextSize = 12
notifTitle.Font = Enum.Font.GothamBold
notifTitle.TextXAlignment = Enum.TextXAlignment.Left
notifTitle.Parent = notifFrame

local notifText = Instance.new("TextLabel")
notifText.Size = UDim2.new(1, -15, 0, 20)
notifText.Position = UDim2.new(0, 12, 0, 23)
notifText.BackgroundTransparency = 1
notifText.Text = "Đang khởi động..."
notifText.TextColor3 = Color3.fromRGB(220, 220, 220)
notifText.TextSize = 11
notifText.Font = Enum.Font.Gotham
notifText.TextXAlignment = Enum.TextXAlignment.Left
notifText.Parent = notifFrame

local function showNotification(title, message)
    notifTitle.Text = title
    notifText.Text = message
    
    local tweenIn = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 20, 0, 20)})
    tweenIn:Play()
    
    task.spawn(function()
        task.wait(2.5)
        local tweenOut = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0, -280, 0, 20)})
        tweenOut:Play()
    end)
end

-- === MENU CHÍNH ===
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

createToggle("Tự Động Câu Cá (Auto Fish)", 50, function(state)
    _GConfig.AutoFish = state
    if state then
        showNotification("Thông Báo", "Đã Bật: Tự Động Câu Cá!")
    else
        showNotification("Thông Báo", "Đã Tắt: Tự Động Câu Cá!")
    end
end)

createToggle("Tự Động Nhặt Rương (Catch Chest)", 105, function(state)
    _GConfig.CatchChest = state
    if state then
        showNotification("Thông Báo", "Đã Bật: Tự Động Nhặt Rương!")
    else
        showNotification("Thông Báo", "Đã Tắt: Tự Động Nhặt Rương!")
    end
end)

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

-- Vòng lặp Nhặt Rương
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

-- Vòng lặp Tự Động Câu Cá chuẩn khớp trạng thái game
task.spawn(function()
    while true do
        task.wait(0.5)
        if _GConfig.AutoFish then
            pcall(function()
                local character = player.Character
                if not character then return end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid then return end

                -- Tự động lấy cần câu trong balo nếu chưa cầm
                local tool = character:FindFirstChildOfClass("Tool")
                if not tool or not (tool.Name:find("Fishing") or tool.Name:find("Rod")) then
                    local backpack = player:FindFirstChildOfClass("Backpack")
                    if backpack then
                        for _, item in ipairs(backpack:GetChildren()) do
                            if item.Name:find("Fishing") or item.Name:find("Rod") then
                                humanoid:EquipTool(item)
                                task.wait(0.2)
                                tool = item
                            end
                        end
                    end
                end

                -- Nếu đang cầm cần, kích hoạt liên tục để thực hiện quăng và giật cá hoàn hảo
                if tool and (tool.Name:find("Fishing") or tool.Name:find("Rod")) then
                    tool:Activate()
                    -- Kiểm tra và tương tác trực tiếp với các sự kiện hoặc minigame UI nếu có trên màn hình
                    for _, gui in ipairs(playerGui:GetChildren()) do
                        if gui:IsA("ScreenGui") then
                            for _, desc in ipairs(gui:GetDescendants()) do
                                if desc:IsA("TextButton") and (desc.Text:lower():find("reel") or desc.Text:lower():find("catch") or desc.Text:lower():find("fish")) then
                                    local vim = game:GetService("VirtualInputManager")
                                    -- Kích hoạt giả lập nhấn cực kỳ nhẹ vào nút trong game để qua minigame hoàn hảo
                                    if vim then
                                        vim:SendMouseButtonEvent(desc.AbsolutePosition.X + 10, desc.AbsolutePosition.Y + 10, 0, true, game, 0)
                                        task.wait(0.05)
                                        vim:SendMouseButtonEvent(desc.AbsolutePosition.X + 10, desc.AbsolutePosition.Y + 10, 0, false, game, 0)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    task.wait(0.5)
    showNotification("TzuyFishing Hub", "Đã tải thành công script!")
end)
