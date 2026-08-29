--[[
    Script tự động câu cá Blox Fruits
    Yêu cầu: Executor hỗ trợ VirtualInputManager, GetMouse, RemoteSpy (nếu cần debug)
    ID menu: 14920583102
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- Biến toàn cục
local autoFishEnabled = false
local autoChestEnabled = true
local fishingRod = nil
local biteSignal = nil

-- Hàm mô phỏng click chuột trái
local function simulateClick()
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    wait(0.05)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

-- Hàm tìm cần câu trong người
local function findFishingRod()
    fishingRod = nil
    -- Tìm trong Backpack
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():find("rod") or item.Name:lower():find("fishing")) then
            fishingRod = item
            return item
        end
    end
    -- Tìm trong Character (đang cầm)
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

-- Hàm kết nối tín hiệu cá cắn
local function connectToBiteSignal()
    local rod = findFishingRod()
    if not rod then return nil end

    -- Tìm RemoteEvent / BindableEvent bên trong tool (thường tên: "RemoteEvent", "FishingEvent", "BiteEvent")
    local possibleEvents = {"RemoteEvent", "FishingEvent", "BiteEvent", "CatchEvent", "Event"}
    for _, eventName in ipairs(possibleEvents) do
        local event = rod:FindFirstChild(eventName)
        if event then
            return event
        end
    end
    return nil
end

-- Hàm kiểm tra nếu có rương trong inventory (sau khi câu xong)
local function checkAndOpenChest()
    if not autoChestEnabled then return end
    wait(1) -- đợi item rơi vào túi
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if item.Name:lower():find("chest") or item.Name:lower():find("treasure") then
            -- Tự động mở rương: thường là dùng tool "Open" hoặc click vào item
            -- Cách đơn giản: trang bị item rồi kích hoạt
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:EquipTool(item)
                wait(0.2)
                -- Giả sử có RemoteEvent "OpenChest" hoặc tương tự trong tool
                local openEvent = item:FindFirstChild("RemoteEvent") or item:FindFirstChild("OpenEvent")
                if openEvent then
                    openEvent:FireServer()
                else
                    -- Fallback: click chuột phải (mở rương bằng chuột phải thường)
                    VIM:SendMouseButtonEvent(0, 0, 1, true, game, 1)
                    wait(0.1)
                    VIM:SendMouseButtonEvent(0, 0, 1, false, game, 1)
                end
            end
            break
        end
    end
end

-- Hàm chính xử lý khi cá cắn
local function onBite()
    if not autoFishEnabled then return end
    -- Giật cần ngay
    simulateClick()
    -- Đợi kéo cá lên, rồi kiểm tra chest
    spawn(checkAndOpenChest)
end

-- Thiết lập kết nối khi có cần câu
local function setupAutoFish()
    local event = connectToBiteSignal()
    if event then
        if biteSignal then
            biteSignal:Disconnect()
        end
        biteSignal = event.OnClientEvent:Connect(function(action)
            -- action có thể là chuỗi "Bite", "Catch", hoặc số
            if action == "Bite" or action == "Catch" or action == 1 then
                onBite()
            end
        end)
    else
        -- Fallback: dùng animation detection (nếu không tìm thấy remote)
        warn("Không tìm thấy remote bite, dùng fallback animation detection")
        RunService.RenderStepped:Connect(function()
            if not autoFishEnabled then return end
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                        if track.Animation and track.Animation.Name:lower():find("bite") then
                            onBite()
                            break
                        end
                    end
                end
            end
        end)
    end
end

-- Tạo UI đơn giản (dùng Drawing hoặc ScreenGui tự tạo)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFishGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.5, -100, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
ToggleFish.Size = UDim2.new(0.9, 0, 0, 30)
ToggleFish.Position = UDim2.new(0.05, 0, 0.3, 0)
ToggleFish.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
ToggleFish.Text = "Auto Fish: OFF"
ToggleFish.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFish.Font = Enum.Font.SourceSansBold
ToggleFish.TextSize = 12
ToggleFish.Parent = Frame

local ToggleChest = Instance.new("TextButton")
ToggleChest.Size = UDim2.new(0.9, 0, 0, 30)
ToggleChest.Position = UDim2.new(0.05, 0, 0.65, 0)
ToggleChest.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
ToggleChest.Text = "Auto Chest: ON"
ToggleChest.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleChest.Font = Enum.Font.SourceSansBold
ToggleChest.TextSize = 12
ToggleChest.Parent = Frame

-- Xử lý nút bấm
ToggleFish.MouseButton1Click:Connect(function()
    autoFishEnabled = not autoFishEnabled
    ToggleFish.Text = autoFishEnabled and "Auto Fish: ON" or "Auto Fish: OFF"
    if autoFishEnabled then
        setupAutoFish()
    end
end)

ToggleChest.MouseButton1Click:Connect(function()
    autoChestEnabled = not autoChestEnabled
    ToggleChest.Text = autoChestEnabled and "Auto Chest: ON" or "Auto Chest: OFF"
end)

-- Khởi tạo ban đầu
findFishingRod()

-- Khi nhặt cần câu mới, cập nhật
LocalPlayer.Backpack.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and (child.Name:lower():find("rod") or child.Name:lower():find("fishing")) then
        fishingRod = child
        if autoFishEnabled then
            setupAutoFish()
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if autoFishEnabled then
        setupAutoFish()
    end
end)

print("Script Auto Fish đã sẵn sàng. Bấm nút để bật.")
