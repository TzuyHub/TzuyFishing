-- Minimal Auto Fish Script (Tối giản hóa tối đa)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local autoFishRunning = false

-- Hàm bật/tắt tự động câu
local function toggleAutoFish(state)
    autoFishRunning = state
    
    if autoFishRunning then
        task.spawn(function()
            while autoFishRunning do
                task.wait(1)
                pcall(function()
                    local character = player.Character
                    if not character then return end
                    
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    local tool = character:FindFirstChildOfClass("Tool")
                    
                    -- Nếu chưa cầm cần câu thì tìm trong balo rồi lôi ra
                    if not tool or not tool.Name:find("Fishing") then
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
                    
                    -- Nếu đang cầm thì ném cần
                    if tool and tool.Name:find("Fishing") and tool:FindFirstChild("RemoteEvent") then
                        tool.RemoteEvent:FireServer("Cast")
                    end
                end)
            end
        end)
    end
end

-- Cách dùng: Gọi toggleAutoFish(true) để BẬT hoặc toggleAutoFish(false) để TẮT.
