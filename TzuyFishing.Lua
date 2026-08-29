--[[
    Script: longhihiv2 - Auto Fish & Auto Chest for Blox Fruits
    Chạy bằng executor (Synapse, KRNL, Fluxus...)
    Tính năng:
    - Tự động giật cần khi cá cắn và bắt cá ngay (1 phát ăn ngay)
    - Tự động bắt rương khi câu được
]]

-- Tạo GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "longhihiv2"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "longhihiv2"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local autoFishToggle = Instance.new("TextButton")
autoFishToggle.Size = UDim2.new(1, -20, 0, 30)
autoFishToggle.Position = UDim2.new(0, 10, 0, 40)
autoFishToggle.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
autoFishToggle.Text = "Auto Fish: OFF"
autoFishToggle.TextColor3 = Color3.new(1, 1, 1)
autoFishToggle.Font = Enum.Font.SourceSans
autoFishToggle.TextSize = 14
autoFishToggle.Parent = frame

local autoChestToggle = Instance.new("TextButton")
autoChestToggle.Size = UDim2.new(1, -20, 0, 30)
autoChestToggle.Position = UDim2.new(0, 10, 0, 80)
autoChestToggle.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
autoChestToggle.Text = "Auto Catch Chest: OFF"
autoChestToggle.TextColor3 = Color3.new(1, 1, 1)
autoChestToggle.Font = Enum.Font.SourceSans
autoChestToggle.TextSize = 14
autoChestToggle.Parent = frame

-- Biến trạng thái
local autoFishEnabled = false
local autoChestEnabled = false

-- Hàm đổi màu nút
local function updateButton(button, enabled)
    if enabled then
        button.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
    else
        button.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
    end
end

-- Xử lý nút bật/tắt
autoFishToggle.MouseButton1Click:Connect(function()
    autoFishEnabled = not autoFishEnabled
    autoFishToggle.Text = "Auto Fish: " .. (autoFishEnabled and "ON" or "OFF")
    updateButton(autoFishToggle, autoFishEnabled)
end)

autoChestToggle.MouseButton1Click:Connect(function()
    autoChestEnabled = not autoChestEnabled
    autoChestToggle.Text = "Auto Catch Chest: " .. (autoChestEnabled and "ON" or "OFF")
    updateButton(autoChestToggle, autoChestEnabled)
end)

-- ==================== LOGIC AUTO FISH ====================
-- Tìm RemoteEvent/RemoteFunction liên quan đến câu cá
local replicatedStorage = game:GetService("ReplicatedStorage")
local remotes = {}

-- Quét tất cả remote trong ReplicatedStorage (có thể nằm sâu trong các folder)
local function scanRemotes(parent)
    for _, obj in ipairs(parent:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(remotes, obj)
        end
    end
end
scanRemotes(replicatedStorage)

-- Hàm tìm remote theo tên chứa từ khóa
local function findRemote(keyword)
    for _, remote in ipairs(remotes) do
        if remote.Name:lower():find(keyword:lower()) then
            return remote
        end
    end
    return nil
end

-- Tìm các remote cần thiết
local biteRemote = findRemote("bite")       -- remote khi cá cắn câu
local reelRemote = findRemote("reel")       -- remote khi giật cần
local catchRemote = findRemote("catch")     -- remote bắt cá (hoàn thành)
local fishRemote = findRemote("fish")       -- remote tổng quát
local hookRemote = findRemote("hook")       -- remote móc câu

-- Hàm bắt cá ngay lập tức
local function instantCatch()
    -- Ưu tiên bắn remote catch (bỏ qua minigame)
    if catchRemote then
        if catchRemote:IsA("RemoteEvent") then
            catchRemote:FireServer()
        else
            catchRemote:InvokeServer()
        end
        return
    end
    -- Nếu không có remote catch, thử reel rồi fish
    if reelRemote then
        if reelRemote:IsA("RemoteEvent") then
            reelRemote:FireServer()
        else
            reelRemote:InvokeServer()
        end
        wait(0.1)
    end
    if fishRemote then
        if fishRemote:IsA("RemoteEvent") then
            fishRemote:FireServer()
        else
            fishRemote:InvokeServer()
        end
    end
end

-- Hàm kiểm tra xem có cá cắn không (dựa vào GUI hoặc thuộc tính)
local function isBiteDetected()
    -- Cách 1: Tìm GUI hiển thị dấu "!" hoặc "Bite"
    local playerGui = player:WaitForChild("PlayerGui")
    for _, gui in ipairs(playerGui:GetDescendants()) do
        if gui:IsA("TextLabel") or gui:IsA("TextButton") then
            local text = gui.Text:lower()
            if text:find("!") or text:find("bite") or text:find("cắn") then
                return true
            end
        end
    end
    -- Cách 2: Kiểm tra sự tồn tại của bobber chìm (nếu biết tên)
    local bobber = workspace:FindFirstChild("Bobber") or workspace:FindFirstChild("FishingBobber")
    if bobber then
        -- Kiểm tra vị trí Y so với mặt nước (giả định nước ở Y=0)
        if bobber.Position.Y < 0.5 then -- ngưỡng tùy chỉnh
            return true
        end
    end
    return false
end

-- Vòng lặp auto fish
game:GetService("RunService").Heartbeat:Connect(function()
    if not autoFishEnabled then return end
    -- Chỉ hoạt động khi đang cầm cần câu
    local character = player.Character
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("rod") or tool and tool.Name:lower():find("cần") then
        if isBiteDetected() then
            instantCatch()
            wait(0.5) -- chờ một chút trước khi kiểm tra lần tiếp
        end
    end
end)

-- ==================== LOGIC AUTO CATCH CHEST ====================
-- Tương tự nhưng ưu tiên remote liên quan đến chest
local chestRemote = findRemote("chest")
local openChestRemote = findRemote("openchest")

local function instantCatchChest()
    if chestRemote then
        if chestRemote:IsA("RemoteEvent") then
            chestRemote:FireServer()
        else
            chestRemote:InvokeServer()
        end
    end
    if openChestRemote then
        if openChestRemote:IsA("RemoteEvent") then
            openChestRemote:FireServer()
        else
            openChestRemote:InvokeServer()
        end
    end
end

-- Vòng lặp auto chest (có thể tái sử dụng detection nhưng thêm kiểm tra rương)
game:GetService("RunService").Heartbeat:Connect(function()
    if not autoChestEnabled then return end
    local character = player.Character
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("rod") or tool and tool.Name:lower():find("cần") then
        if isBiteDetected() then
            instantCatchChest()
            wait(0.5)
        end
    end
end)

-- Cảnh báo khi remote không tìm thấy
if not catchRemote and not fishRemote and not reelRemote then
    warn("[longhihiv2] Không tìm thấy remote câu cá. Cần cập nhật tên remote trong script.")
end
