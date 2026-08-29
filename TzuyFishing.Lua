-- Blox Fruits Hub - TzuyFishing (Không Đi Biển, Chạy Liên Tục Khi Bật)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CONFIG_FILE = "TzuyFishing_Config.json"

local _GConfig = {
    CatchChest = false,
    AutoFish = false,
}

local function loadConfig()
    if writefile and readfile and isfile and isfile(CONFIG_FILE) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if success and type(data) == "table" then
            if data.CatchChest ~= nil then
                _GConfig.CatchChest = data.CatchChest
            end
            if data.AutoFish ~= nil then
                _GConfig.AutoFish = data.AutoFish
            end
        end
    end
end

local function saveConfig()
    if writefile then
        pcall(function()
            local cleanData = {
                CatchChest = _GConfig.CatchChest,
                AutoFish = _GConfig.AutoFish,
            }
            local encoded = HttpService:JSONEncode(cleanData)
            writefile(CONFIG_FILE, encoded)
        end)
    end
end

loadConfig()

if playerGui:FindFirstChild("TzuyFishingGui") then
    playerGui.TzuyFishingGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TzuyFishingGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- === HỆ THỐNG THÔNG BÁO ===
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

local btnFish = Instance.new("TextButton")
btnFish.Size = UDim2.new(0.92, 0, 0, 40)
btnFish.Position = UDim2.new(0.04, 0, 0, 65)
btnFish.Parent = mainFrame

local btnFishCorner = Instance.new("UICorner")
btnFishCorner.CornerRadius = UDim.new(0, 6)
btnFishCorner.Parent = btnFish

local btnChest = Instance.new("TextButton")
btnChest.Size = UDim2.new(0.92, 0, 0, 40)
btnChest.Position = UDim2.new(0.04, 0, 0, 120)
btnChest.Parent = mainFrame

local btnChestCorner = Instance.new("UICorner")
btnChestCorner.CornerRadius = UDim.new(0, 6)
btnChestCorner.Parent = btnChest

local function updateFishButtonVisual(state)
    if state then
        btnFish.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
        btnFish.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnFish.Text = "  Auto Fish: [ON]"
    else
        btnFish.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        btnFish.TextColor3 = Color3.fromRGB(200, 200, 200)
        btnFish.Text = "  Auto Fish: [OFF]"
    end
end

local function updateChestButtonVisual(state)
    if state then
        btnChest.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
        btnChest.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnChest.Text = "  Ưu Tiên Bắt Chest Khi Câu: [ON]"
    else
        btnChest.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        btnChest.TextColor3 = Color3.fromRGB(200, 200, 200)
        btnChest.Text = "  Ưu Tiên Bắt Chest Khi Câu: [OFF]"
    end
end

updateFishButtonVisual(_GConfig.AutoFish)
updateChestButtonVisual(_GConfig.CatchChest)

btnFish.MouseButton1Click:Connect(function()
    _GConfig.AutoFish = not _GConfig.AutoFish
    updateFishButtonVisual(_GConfig.AutoFish)
    saveConfig()
    if _GConfig.AutoFish then
        showNotification("Thông Báo", "Đã Bật Auto Fish & Lưu!")
    else
        showNotification("Thông Báo", "Đã Tắt Auto Fish & Lưu!")
    end
end)

btnChest.MouseButton1Click:Connect(function()
    _GConfig.CatchChest = not _GConfig.CatchChest
    updateChestButtonVisual(_GConfig.CatchChest)
    saveConfig()
    if _GConfig.CatchChest then
        showNotification("Thông Báo", "Đã Bật Ưu Tiên Chest & Lưu!")
    else
        showNotification("Thông Báo", "Đã Tắt Ưu Tiên Chest & Lưu!")
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

-- === TỰ ĐỘNG TRANG BỊ CẦN CÂU NẾU CÓ ===
local function equipFishingRod()
    local character = player.Character
    if not character then return end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("fishing") or tool.Name:lower():find("rod")) then
                character.Humanoid:EquipTool(tool)
                return true
            end
        end
    end
    return false
end

local function hasFishingRod()
    local character = player.Character
    if not character then return false end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and (tool.Name:lower():find("fishing") or tool.Name:lower():find("rod")) then
        return true
    end
    return false
end

-- === CÂU CÁ LIÊN TỤC ===
local isFishing = false
local castTime = 0

local function castFishingRod()
    local character = player.Character
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        isFishing = true
        castTime = tick()
    end
end

local function reelFishingRod()
    local character = player.Character
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        isFishing = false
    end
end

local function checkForChest()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    local root = character.HumanoidRootPart
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name:lower():find("chest") and obj:FindFirstChild("HumanoidRootPart") then
            local distance = (obj.HumanoidRootPart.Position - root.Position).Magnitude
            if distance < 50 then
                return true
            end
        end
    end
    return false
end

-- === VÒNG LẶP CHÍNH LUÔN CHẠY KHI BẬT ===
task.spawn(function()
    while true do
        task.wait(0.1) -- Kiểm tra nhanh
        
        if not _GConfig.AutoFish and not _GConfig.CatchChest then
            isFishing = false
            continue
        end
        
        -- Nếu bật AutoFish hoặc CatchChest thì đảm bảo có cần câu
        if _GConfig.AutoFish or _GConfig.CatchChest then
            if not hasFishingRod() then
                equipFishingRod()
            end
        end
        
        -- Chỉ thực hiện câu cá khi bật AutoFish
        if _GConfig.AutoFish then
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                isFishing = false
                continue
            end
            
            -- Thực hiện câu cá ngay tại vị trí hiện tại
            if not isFishing then
                castFishingRod()
                local startTime = tick()
                -- Chờ tối đa 3 giây (đủ nhanh)
                while tick() - startTime < 3 do
                    task.wait(0.05)
                    -- Nếu bật CatchChest và phát hiện chest -> reel ngay
                    if _GConfig.CatchChest and checkForChest() then
                        reelFishingRod()
                        break
                    end
                end
                -- Reel ngay nếu vẫn đang câu
                if isFishing then
                    reelFishingRod()
                end
                -- Nghỉ ngắn 0.2 giây trước lần cast tiếp theo
                task.wait(0.2)
            else
                -- Nếu đang câu quá 5 giây (an toàn)
                if tick() - castTime > 5 then
                    reelFishingRod()
                end
            end
        end
    end
end)

-- Tự động khôi phục khi nhân vật chết
Players.LocalPlayer.CharacterAdded:Connect(function()
    isFishing = false
    showNotification("TzuyFishing Hub", "Nhân vật mới, tiếp tục tự động câu!")
end)

-- Thông báo khởi động
task.spawn(function()
    task.wait(0.5)
    showNotification("TzuyFishing Hub", "Hệ thống sẵn sàng! Bật Auto Fish để chạy liên tục.")
end)
