-- Script câu cá tối giản, không rườm rà
local player = game.Players.LocalPlayer
local running = true

task.spawn(function()
    while running do
        task.wait(1.5)
        pcall(function()
            local char = player.Character
            if not char then return end
            local tool = char:FindFirstChildOfClass("Tool")
            
            -- Tự động cầm cần nếu chưa cầm
            if not tool or not tool.Name:lower():find("fish") then
                local bp = player.Backpack
                for _, item in ipairs(bp:GetChildren()) do
                    if item.Name:lower():find("fish") or item.Name:lower():find("rod") then
                        char.Humanoid:EquipTool(item)
                    end
                end
            elseif tool and tool:FindFirstChild("RemoteEvent") then
                -- Ném cần trực tiếp qua Remote, không rườm rà
                tool.RemoteEvent:FireServer("Cast")
            end
        end)
    end
end)
