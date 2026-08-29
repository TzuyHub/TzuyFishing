--[[
    Blox Fruits Auto Fish Script
    ID menu: 14920583102
    Chức năng:
    - Tự động phát hiện cá cắn (qua RemoteEvent)
    - Giật cần ngay lập tức (click chuột trái)
    - Tự động giữ chuột để kéo cá lên
    - Tự động mở rương (chest) nếu có
    - Menu UI đơn giản có nút bật/tắt
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- Biến toàn cục
local autoFishEnabled = false
local autoChestEnabled = true
local fishingRod = nil
local biteConnection = nil
local isPulling = false

-- ================== HÀM TIỆN ÍCH ==================
local function simulateClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

local function simulateHoldClick(duration)
    duration = duration or 2
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    wait(duration)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

-- Tìm cần câu trong người
local function findFishingRod()
    -- Tìm trong Backpack trước
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():find("rod") or item.Name:lower():find("fishing")) then
            fishingRod = item
            return item
        end
    end
    -- Tìm trên tay (đang cầm)
    if LocalPlayer.Character then
        for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
            if item:IsA("Tool") and (item.Name:lower():find("rod") or item.Name:lower():find("fishing")) then
                fishingRod = item
                return item
            end
        end
    end
    return nil
end

-- Kết nối tới RemoteEvent của cần câu để bắt tín hiệu cá cắn
local function connectToBiteSignal()
    local rod = findFishingRod()
    if not rod then return nil end

    -- Duyệt tất cả RemoteEvent trong tool (kể cả con)
    for _, desc in ipairs(rod:GetDescendants()) do
        if desc:IsA("RemoteEvent") then
            -- Ngắt kết nối cũ nếu có
            if biteConnection then
                biteConnection:Disconnect()
            end
            -- Kết nối mới
            biteConnection = desc.OnClientEvent:Connect(function(...)
                if not autoFishEnabled then return end
                local args = {...}
                -- Kiểm tra các tín hiệu thường gặp
                for _, arg in pairs(args) do
                    if type(arg) == "string" then
                        local lowerArg = arg:lower()
                        if lowerArg:find("bite") or lowerArg:find("catch") or lowerArg:find("fish") then
                            onBiteDetected()
                            return
                        end
                    elseif type(arg) == "boolean" and arg == true then
                        onBiteDetected()
                        return
                    elseif type(arg) == "number" and (arg == 1 or arg == 2) then
                        onBiteDetected()
                        return
                    end
                end
            end)
            print("[AutoFish] Đã kết nối tới RemoteEvent:", desc:GetFullName())
            return desc
        end
    end
    warn("[AutoFish] Không tìm thấy RemoteEvent trong cần câu. Dùng fallback animation detection.")
    return nil
end

-- Hàm xử lý khi phát hiện cá cắn
function onBiteDetected()
    if not autoFishEnabled or isPulling then return end
    isPulling = true
    
    -- Bước 1: Giật cần ngay lập tức
    simulateClick()
    
    -- Bước 2: Giữ chuột để kéo cá lên (thời gian có thể tùy chỉnh)
    wait(0.2)
    simulateHoldClick(2.5)
    
    -- Bước 3: Kiểm tra và mở rương nếu có
    spawn(function()
        wait(1.5)
        tryOpenChest()
        isPulling = false
    end)
end

-- Hàm mở rương (chest) nếu có trong inventory
function tryOpenChest()
    if not autoChestEnabled then return end
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():find("chest") or item.Name:lower():find("treasure")) then
            -- Trang bị chest lên tay
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:EquipTool(item)
                wait(0.3)
                -- Kích hoạt tool (thường là click chuột trái)
                simulateClick()
                print("[AutoFish] Đã mở rương:", item.Name)
            end
            break
        end
    end
end

-- ================== GIAO DIỆN UI ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFishGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui") -- dùng CoreGui để không bị xóa khi respawn

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 140)
Frame.Position = UDim2.new(0.5, -110, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Auto Fish - ID: 14920583102"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.Parent = Frame

local ToggleFish = Instance.new("TextButton")
ToggleFish.Size = UDim2.new(0.9, 0, 0, 35)
ToggleFish.Position = UDim2.new(0.05, 0, 0.3, 0)
ToggleFish.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
ToggleFish.Text = "Auto Fish: OFF"
ToggleFish.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFish.Font = Enum.Font.SourceSansBold
ToggleFish.TextSize = 13
ToggleFish.Parent = Frame

local ToggleChest = Instance.new("TextButton")
ToggleChest.Size = UDim2.new(0.9, 0, 0, 35)
ToggleChest.Position = UDim2.new(0.05, 0, 0.65, 0)
ToggleChest.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
ToggleChest.Text = "Auto Chest: ON"
ToggleChest.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleChest.Font = Enum.Font.SourceSansBold
ToggleChest.TextSize = 13
ToggleChest.Parent = Frame

-- Xử lý nút
ToggleFish.MouseButton1Click:Connect(function()
    autoFishEnabled = not autoFishEnabled
    ToggleFish.Text = autoFishEnabled and "Auto Fish: ON" or "Auto Fish: OFF"
    if autoFishEnabled then
        connectToBiteSignal()
    end
end)

ToggleChest.MouseButton1Click:Connect(function()
    autoChestEnabled = not autoChestEnabled
    ToggleChest.Text = autoChestEnabled and "Auto Chest: ON" or "Auto Chest: OFF"
end)

-- ================== TỰ ĐỘNG CẬP NHẬT KHI CẦN CÂU THAY ĐỔI ==================
LocalPlayer.Backpack.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and (child.Name:lower():find("rod") or child.Name:lower():find("fishing")) then
        fishingRod = child
        print("[AutoFish] Phát hiện cần câu mới:", child.Name)
        if autoFishEnabled then
            connectToBiteSignal()
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if autoFishEnabled then
        connectToBiteSignal()
    end
end)

-- Khởi tạo
findFishingRod()
print("[AutoFish] Script đã sẵn sàng. Bấm nút để bật.")
