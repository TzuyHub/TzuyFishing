-- Blox Fruits Priority Chest Hub - TzuyFishing (Clean Config & No Auto Fish)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tên file lưu cấu hình riêng biệt, sạch sẽ
local CONFIG_FILE = "TzuyFishing_ChestConfig.json"

-- Chỉ quản lý duy nhất trạng thái CatchChest
local _GConfig = {
    CatchChest = false,
}

-- Hàm đọc file cấu hình đã lưu trước đó
local function loadConfig()
    if writefile and readfile and isfile and isfile(CONFIG_FILE) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if success and type(data) == "table" then
            if data.CatchChest ~= nil then
                _GConfig.CatchChest = data.CatchChest
            end
        end
    end
end

-- Hàm lưu cài đặt cấu hình ra file JSON
local function saveConfig()
    if writefile then
        pcall(function()
            local cleanData = {
                CatchChest = _GConfig.CatchChest
            }
            local encoded = HttpService:JSONEncode(cleanData)
            writefile(CONFIG_FILE, encoded)
        end)
    end
end

-- Thực hiện load cấu hình ngay khi khởi động script
loadConfig()

-- Xóa Menu cũ nếu có để tránh bị trùng lặp giao diện
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
mainFrame.Size = UDim2.new(0, 360, 0, 180) -- Thu gọn chiều cao tối ưu
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -90)
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

-- Tạo nút tính năng Nhặt Rương duy nhất
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.92, 0, 0, 40)
btn.Position = UDim2.new(0.04, 0, 0, 65)
btn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = btn

-- Hàm cập nhật giao diện màu sắc & chữ của nút dựa theo trạng thái
local function updateButtonVisual(state)
    if state then
        btn.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = "  Tự Động Nhặt Rương (Catch Chest): [ON]"
    else
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Text = "  Tự Động Nhặt Rương (Catch Chest): [OFF]"
    end
end

-- Đồng bộ trạng thái đã lưu vào giao diện ban đầu khi mở menu
updateButtonVisual(_GConfig.CatchChest)

-- Sự kiện bấm nút: thay đổi trạng thái, tự động lưu file config và báo hiệu
btn.MouseButton1Click:Connect(function()
    _GConfig.CatchChest = not _GConfig.CatchChest
    updateButtonVisual(_GConfig.CatchChest)
    saveConfig()
    
    if _GConfig.CatchChest then
        showNotification("Thông Báo", "Đã Bật & Đã Lưu Cài Đặt Rương!")
    else
        showNotification("Thông Báo", "Đã Tắt & Đã Lưu Cài Đặt Rương!")
    end
end)

-- Nút nổi mở lại menu khi ấn thu gọn
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

-- Vòng lặp tối ưu xử lý Nhặt Rương ngay lập tức (1 phát lấy được)
RunService.Stepped:Connect(function()
    if not _GConfig.CatchChest then return end
    
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    pcall(function()
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name:find("Chest") and obj:FindFirstChild("HumanoidRootPart") then
                firetouchinterest(humanoidRootPart, obj.HumanoidRootPart, 0)
                firetouchinterest(humanoidRootPart, obj.HumanoidRootPart, 1)
            end
        end
    end)
end)

task.spawn(function()
    task.wait(0.5)
    showNotification("TzuyFishing Hub", "Tải cấu hình thành công!")
end)
