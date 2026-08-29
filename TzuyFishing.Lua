--[[
    Script: longhihiv2 - Auto Fish & Auto Chest for Blox Fruits
    Hỗ trợ: Synapse X, KRNL, Fluxus, ...
    Chức năng:
    - Tự động giật cần khi cá cắn và bắt cá ngay lập tức (bỏ qua minigame)
    - Tự động bắt rương khi câu được
    - Giao diện menu hiện đại, kéo thả, thu gọn
]]

-- ==================== CẤU HÌNH ====================
local SETTINGS = {
    autoFish = false,        -- Tự động bắt cá
    autoChest = false,       -- Tự động bắt rương
    scanDelay = 0.2,         -- Độ trễ quét remote (giây)
    fishRemoteKeywords = {"bite", "reel", "catch", "fish", "hook", "minigame", "result"},
    chestRemoteKeywords = {"chest", "openchest", "getchest"}
}
-- ==================================================

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- ==================== TẠO MENU GUI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "longhihiv2"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 140)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -70)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Tiêu đề
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "longhihiv2"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Nút thu gọn
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -30, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "—"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 20
minimizeButton.Parent = titleBar

-- Nút đóng
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -60, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = titleBar

-- Nút Auto Fish
local autoFishButton = Instance.new("TextButton")
autoFishButton.Name = "AutoFishButton"
autoFishButton.Size = UDim2.new(1, -20, 0, 30)
autoFishButton.Position = UDim2.new(0, 10, 0, 40)
autoFishButton.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
autoFishButton.BorderSizePixel = 0
autoFishButton.Text = "Auto Fish: OFF"
autoFishButton.TextColor3 = Color3.new(1, 1, 1)
autoFishButton.Font = Enum.Font.SourceSans
autoFishButton.TextSize = 14
autoFishButton.AutoButtonColor = false
autoFishButton.Parent = mainFrame

-- Nút Auto Chest
local autoChestButton = Instance.new("TextButton")
autoChestButton.Name = "AutoChestButton"
autoChestButton.Size = UDim2.new(1, -20, 0, 30)
autoChestButton.Position = UDim2.new(0, 10, 0, 80)
autoChestButton.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
autoChestButton.BorderSizePixel = 0
autoChestButton.Text = "Auto Catch Chest: OFF"
autoChestButton.TextColor3 = Color3.new(1, 1, 1)
autoChestButton.Font = Enum.Font.SourceSans
autoChestButton.TextSize = 14
autoChestButton.AutoButtonColor = false
autoChestButton.Parent = mainFrame

-- Nút trạng thái (debug)
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 115)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Trạng thái: Đang chờ..."
statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- ==================== CHỨC NĂNG KÉO THẢ ====================
local dragging = false
local dragStartPos = nil
local frameStartPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStartPos = input.Position
        frameStartPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

userInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartPos
        mainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
    end
end)

-- Thu gọn / Mở rộng
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    mainFrame.Size = minimized and UDim2.new(0, 220, 0, 30) or UDim2.new(0, 220, 0, 140)
    minimizeButton.Text = minimized and "+" or "—"
end)

-- Đóng menu
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ==================== QUẢN LÝ REMOTE ====================
local allRemotes = {}
local function scanRemotes()
    allRemotes = {}
    for _, obj in ipairs(replicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(allRemotes, obj)
        end
    end
end

-- Tìm remote theo danh sách từ khóa
local function findRemoteByKeywords(keywords)
    for _, remote in ipairs(allRemotes) do
        local name = remote.Name:lower()
        for _, kw in ipairs(keywords) do
            if name:find(kw:lower()) then
                return remote
            end
        end
    end
    return nil
end

-- Khởi tạo remote
scanRemotes()
local fishRemote = findRemoteByKeywords(SETTINGS.fishRemoteKeywords)
local chestRemote = findRemoteByKeywords(SETTINGS.chestRemoteKeywords)

-- Nếu không tìm thấy, quét lại sau mỗi vài giây
spawn(function()
    while wait(5) do
        if not fishRemote or not chestRemote then
            scanRemotes()
            fishRemote = fishRemote or findRemoteByKeywords(SETTINGS.fishRemoteKeywords)
            chestRemote = chestRemote or findRemoteByKeywords(SETTINGS.chestRemoteKeywords)
            if fishRemote then statusLabel.Text = "Đã tìm thấy fish remote: " .. fishRemote.Name end
            if chestRemote then statusLabel.Text = "Đã tìm thấy chest remote: " .. chestRemote.Name end
        end
    end
end)

-- ==================== LOGIC AUTO FISH ====================
local function fireRemote(remote, ...)
    if not remote then return end
    if remote:IsA("RemoteEvent") then
        remote:FireServer(...)
    elseif remote:IsA("RemoteFunction") then
        remote:InvokeServer(...)
    end
end

-- Hàm bắt cá ngay lập tức
local function instantCatch()
    if fishRemote then
        -- Thử bắn các tham số phổ biến (true, 1, "success", "catch")
        fireRemote(fishRemote, true)
        wait(0.05)
        fireRemote(fishRemote, 1)
        wait(0.05)
        fireRemote(fishRemote, "success")
        wait(0.05)
        fireRemote(fishRemote)
    else
        statusLabel.Text = "Không tìm thấy remote câu cá!"
    end
end

-- Kiểm tra cá cắn câu qua GUI hoặc vị trí bobber
local function isFishBiting()
    -- Cách 1: Tìm trong PlayerGui các chữ "Bite", "!", "Cắn", "!"
    local playerGui = player:WaitForChild("PlayerGui")
    for _, gui in ipairs(playerGui:GetDescendants()) do
        if gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("ImageLabel") then
            local text = ""
            if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                text = gui.Text:lower()
            end
            if text:find("!") or text:find("bite") or text:find("cắn") then
                return true
            end
        end
    end
    -- Cách 2: Kiểm tra bobber chìm (tùy chỉnh tên và ngưỡng Y)
    local bobber = workspace:FindFirstChild("Bobber") or workspace:FindFirstChild("FishingBobber") or workspace:FindFirstChild("BobberModel")
    if bobber then
        local waterLevel = 0 -- Thay đổi theo map
        if bobber.Position.Y < waterLevel + 0.5 then
            return true
        end
    end
    return false
end

-- Vòng lặp auto fish
runService.Heartbeat:Connect(function()
    if not SETTINGS.autoFish then return end
    local character = player.Character
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and (tool.Name:lower():find("rod") or tool.Name:lower():find("cần")) then
        if isFishBiting() then
            instantCatch()
            wait(0.3)
        end
    end
end)

-- ==================== LOGIC AUTO CHEST ====================
local function instantCatchChest()
    if chestRemote then
        fireRemote(chestRemote, true)
        wait(0.05)
        fireRemote(chestRemote, 1)
        wait(0.05)
        fireRemote(chestRemote)
    else
        statusLabel.Text = "Không tìm thấy remote chest!"
    end
end

runService.Heartbeat:Connect(function()
    if not SETTINGS.autoChest then return end
    local character = player.Character
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and (tool.Name:lower():find("rod") or tool.Name:lower():find("cần")) then
        -- Có thể kiểm tra riêng biệt nếu rương cắn, nhưng tạm thời dùng chung isFishBiting
        if isFishBiting() then
            instantCatchChest()
            wait(0.3)
        end
    end
end)

-- ==================== XỬ LÝ NÚT BẬT/TẮT ====================
local function updateButtonVisual(button, enabled)
    button.BackgroundColor3 = enabled and Color3.fromRGB(30, 120, 30) or Color3.fromRGB(120, 30, 30)
end

autoFishButton.MouseButton1Click:Connect(function()
    SETTINGS.autoFish = not SETTINGS.autoFish
    autoFishButton.Text = "Auto Fish: " .. (SETTINGS.autoFish and "ON" or "OFF")
    updateButtonVisual(autoFishButton, SETTINGS.autoFish)
    statusLabel.Text = SETTINGS.autoFish and "Auto Fish đã bật" or "Auto Fish đã tắt"
end)

autoChestButton.MouseButton1Click:Connect(function()
    SETTINGS.autoChest = not SETTINGS.autoChest
    autoChestButton.Text = "Auto Catch Chest: " .. (SETTINGS.autoChest and "ON" or "OFF")
    updateButtonVisual(autoChestButton, SETTINGS.autoChest)
    statusLabel.Text = SETTINGS.autoChest and "Auto Chest đã bật" or "Auto Chest đã tắt"
end)

-- ==================== IN THÔNG TIN DEBUG ====================
print("=== longhihiv2 Script Loaded ===")
print("Fish Remote:", fishRemote and fishRemote.Name or "Not Found")
print("Chest Remote:", chestRemote and chestRemote.Name or "Not Found")
print("Hãy bật Auto Fish và cầm cần câu để sử dụng.")
