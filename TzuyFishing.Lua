--// TZUY HUB - PART 1
--// GUI + VISUAL / PERFORMANCE
--// Dùng LocalScript trong game của bạn

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local Config = {
    RemoveFog = false,
    RemoveClouds = false,
    RemoveParticles = false,
    RemoveTrails = false,
    RemoveBeams = false,
    RemoveBlur = false,
    RemoveColorCorrection = false,
    RemoveBloom = false,
    RemoveSunRays = false,
    RemoveAtmosphere = false,
    DisableShadows = false,
    Fullbright = false,
    LowGraphics = false,
    RemoveTextures = false,
    RemoveSmoke = false,
    RemoveFire = false,
    RemoveSparkles = false,
}

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TzuyHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 55, 0, 55)
OpenButton.Position = UDim2.new(0, 20, 0.5, -25)
OpenButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenButton.Image = "rbxassetid://120210404674531"
OpenButton.ScaleType = Enum.ScaleType.Fit
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(55, 55, 65)
Stroke.Thickness = 1
Stroke.Parent = Main

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 45)
Title.Position = UDim2.new(0, 20, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "Tzuy Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 23
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -70, 0, 20)
SubTitle.Position = UDim2.new(0, 21, 0, 37)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "TLS • Visual / Performance"
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 160)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Main

--==================================================
-- CLOSE
--==================================================

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -45, 0, 10)
Close.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 22
Close.Font = Enum.Font.GothamBold
Close.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

--==================================================
-- DRAG MAIN
--==================================================

local UIS = game:GetService("UserInputService")

local dragging = false
local dragStart
local startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and
        (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--==================================================
-- TAB BAR
--==================================================

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 130, 1, -75)
TabBar.Position = UDim2.new(0, 10, 0, 65)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
TabBar.BorderSizePixel = 0
TabBar.Parent = Main

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 10)
TabCorner.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 5)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
TabLayout.Parent = TabBar

--==================================================
-- PAGE
--==================================================

local Page = Instance.new("ScrollingFrame")
Page.Size = UDim2.new(1, -155, 1, -75)
Page.Position = UDim2.new(0, 145, 0, 65)
Page.BackgroundTransparency = 1
Page.BorderSizePixel = 0
Page.ScrollBarThickness = 3
Page.CanvasSize = UDim2.new(0, 0, 0, 0)
Page.Parent = Main

local PageLayout = Instance.new("UIListLayout")
PageLayout.Padding = UDim.new(0, 7)
PageLayout.Parent = Page

PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Page.CanvasSize = UDim2.new(
        0,
        0,
        0,
        PageLayout.AbsoluteContentSize.Y + 10
    )
end)

--==================================================
-- HELPERS
--==================================================

local function Notification(text)
    local Note = Instance.new("TextLabel")
    Note.Size = UDim2.new(0, 250, 0, 40)
    Note.Position = UDim2.new(1, -270, 1, -60)
    Note.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Note.TextColor3 = Color3.fromRGB(255, 255, 255)
    Note.Text = text
    Note.TextSize = 13
    Note.Font = Enum.Font.GothamMedium
    Note.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Note

    task.delay(2, function()
        if Note then
            Note:Destroy()
        end
    end)
end

local function AddToggle(text, callback)
    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1, -8, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Button.Text = text .. "  [ OFF ]"
    Button.TextColor3 = Color3.fromRGB(230, 230, 235)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = false
    Button.Parent = Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    local enabled = false

    Button.MouseButton1Click:Connect(function()
        enabled = not enabled

        Button.Text = text .. (enabled and "  [ ON ]" or "  [ OFF ]")

        if enabled then
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
        else
            Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        end

        callback(enabled)
    end)

    return Button
end

local function AddTab(name, callback)
    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(220, 220, 225)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = false
    Button.Parent = TabBar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Button

    Button.MouseButton1Click:Connect(callback)

    return Button
end

--==================================================
-- VISUAL FUNCTIONS
--==================================================

local function RemoveFog()
    Lighting.FogStart = 100000
    Lighting.FogEnd = 1000000
end

local function RestoreFog()
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
end

local function RemoveObjects(className)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA(className) then
            obj.Enabled = false
        end
    end
end

local function RestoreObjects(className)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA(className) then
            obj.Enabled = true
        end
    end
end

--==================================================
-- VISUAL TOGGLES
--==================================================

AddToggle("🌫️ Xóa sương mù", function(state)
    Config.RemoveFog = state

    if state then
        RemoveFog()
    else
        RestoreFog()
    end
end)

AddToggle("☁️ Xóa mây", function(state)
    Config.RemoveClouds = state

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Clouds") then
            obj.Enabled = not state
        end
    end
end)

AddToggle("✨ Xóa Particle", function(state)
    Config.RemoveParticles = state

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then
            obj.Enabled = not state
        end
    end
end)

AddToggle("💫 Xóa Trail", function(state)
    Config.RemoveTrails = state

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Trail") then
            obj.Enabled = not state
        end
    end
end)

AddToggle("🔦 Xóa Beam", function(state)
    Config.RemoveBeams = state

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Beam") then
            obj.Enabled = not state
        end
    end
end)

AddToggle("🌪️ Xóa Smoke", function(state)
    Config.RemoveSmoke = state

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Smoke") then
            obj.Enabled = not state
        end
    end
end)

AddToggle("🔥 Xóa Fire", function(state)
    Config.RemoveFire = state

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Fire") then
            obj.Enabled = not state
        end
    end
end)

AddToggle("✨ Xóa Sparkles", function(state)
    Config.RemoveSparkles = state

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Sparkles") then
            obj.Enabled = not state
        end
    end
end)

AddToggle("🌑 Tắt Shadows", function(state)
    Config.DisableShadows = state
    Lighting.GlobalShadows = not state
end)

AddToggle("💡 Fullbright", function(state)
    Config.Fullbright = state

    if state then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1000000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
    end
end)

AddToggle("🌈 Xóa ColorCorrection", function(state)
    Config.RemoveColorCorrection = state

    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("ColorCorrectionEffect") then
            obj.Enabled = not state
        end
    end
end)

AddToggle("💨 Xóa Blur", function(state)
    Config.RemoveBlur = state

    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("BlurEffect") then
            obj.Enabled = not state
        end
    end
end)

AddToggle("✨ Xóa Bloom", function(state)
    Config.RemoveBloom = state

    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("BloomEffect") then
            obj.Enabled = not state
        end
    end
end)

AddToggle("☀️ Xóa SunRays", function(state)
    Config.RemoveSunRays = state

    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("SunRaysEffect") then
            obj.Enabled = not state
        end
    end
end)

AddToggle("🌫️ Xóa Atmosphere", function(state)
    Config.RemoveAtmosphere = state

    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") then
            obj.Density = state and 0 or 0.3
        end
    end
end)

--==================================================
-- LOW GRAPHICS
--==================================================

AddToggle("🚀 Low Graphics", function(state)
    Config.LowGraphics = state

    if state then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false

        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter")
                or obj:IsA("Trail")
                or obj:IsA("Beam") then

                obj.Enabled = false
            end
        end

        Notification("Low Graphics: ON")
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Notification("Low Graphics: OFF")
    end
end)

--==================================================
-- AUTO CLEAN NEW EFFECTS
--==================================================

Workspace.DescendantAdded:Connect(function(obj)

    task.wait()

    if Config.RemoveParticles and obj:IsA("ParticleEmitter") then
        obj.Enabled = false
    end

    if Config.RemoveTrails and obj:IsA("Trail") then
        obj.Enabled = false
    end

    if Config.RemoveBeams and obj:IsA("Beam") then
        obj.Enabled = false
    end

    if Config.RemoveSmoke and obj:IsA("Smoke") then
        obj.Enabled = false
    end

    if Config.RemoveFire and obj:IsA("Fire") then
        obj.Enabled = false
    end

    if Config.RemoveSparkles and obj:IsA("Sparkles") then
        obj.Enabled = false
    end
end)

--==================================================
-- FPS / PING DISPLAY
--==================================================

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(0, 150, 0, 25)
StatsLabel.Position = UDim2.new(0, 15, 1, -35)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
StatsLabel.TextSize = 11
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = Main

local last = tick()
local frames = 0

RunService.RenderStepped:Connect(function()

    frames += 1

    if tick() - last >= 1 then

        local fps = frames
        frames = 0
        last = tick()

        local ping = 0

        pcall(function()
            ping = math.floor(
                Player:GetNetworkPing() * 1000
            )
        end)

        StatsLabel.Text =
            "FPS: " .. fps ..
            "   Ping: " .. ping .. "ms"
    end
end)

--==================================================
-- TAB
--==================================================

AddTab("🎨 Visual", function()
    Notification("Visual đã được tải")
end)

AddTab("⚔️ Farm", function()
    Notification("Farm sẽ nằm ở Part 2")
end)

AddTab("🗺️ Teleport", function()
    Notification("Teleport sẽ nằm ở Part 3")
end)

AddTab("👤 Player", function()
    Notification("Player sẽ nằm ở Part 4")
end)

AddTab("🌐 Server", function()
    Notification("Server sẽ nằm ở Part 5")
end)

AddTab("⚙️ Settings", function()
    Notification("Settings sẽ nằm ở Part 6")
end)

Notification("Tzuy Hub đã khởi động")--// TZUY HUB - PART 2
--// FARM + QUEST SYSTEM
--// Ghép vào PART 1

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

--==================================================
-- FARM CONFIG
--==================================================

local FarmConfig = {
    AutoFarmLevel = false,
    AutoQuest = false,
    AutoFarmNPC = false,
    AutoFarmBoss = false,
    AutoCollect = false,
    AutoChest = false,
    AutoEquip = false,

    TargetNPC = "",
    TargetBoss = "",

    FarmDistance = 8,
    FarmDelay = 0.15
}

local FarmRunning = false
local QuestRunning = false

--==================================================
-- FARM FOLDER
--==================================================

local function GetCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

local function GetRoot()
    local Character = GetCharacter()
    return Character:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    local Character = GetCharacter()
    return Character:FindFirstChildOfClass("Humanoid")
end

--==================================================
-- FIND NPC
--==================================================

local function FindNPC(name)
    if not name or name == "" then
        return nil
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == name then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local root = obj:FindFirstChild("HumanoidRootPart")

            if hum and root and hum.Health > 0 then
                return obj
            end
        end
    end

    return nil
end

--==================================================
-- MOVE TO TARGET
--==================================================

local function MoveToTarget(target)
    local Root = GetRoot()

    if not Root or not target then
        return
    end

    local TargetRoot = target:FindFirstChild("HumanoidRootPart")

    if not TargetRoot then
        return
    end

    Root.CFrame =
        TargetRoot.CFrame *
        CFrame.new(0, 0, FarmConfig.FarmDistance)
end

--==================================================
-- EQUIP TOOL
--==================================================

local function EquipBestTool()

    local Character = GetCharacter()
    local Backpack = Player:FindFirstChildOfClass("Backpack")

    if not Backpack then
        return
    end

    local CurrentTool = Character:FindFirstChildOfClass("Tool")

    if CurrentTool then
        return
    end

    local Tool = Backpack:FindFirstChildOfClass("Tool")

    if Tool then
        local Humanoid = GetHumanoid()

        if Humanoid then
            Humanoid:EquipTool(Tool)
        end
    end
end

--==================================================
-- SIMPLE ATTACK HOOK
--==================================================

local function AttackTarget(target)

    if not target then
        return
    end

    local Tool =
        GetCharacter():FindFirstChildOfClass("Tool")

    if not Tool then
        return
    end

    -- Game của bạn có thể thay phần này
    -- bằng RemoteEvent/BindableEvent combat
    local Handle = Tool:FindFirstChild("Handle")

    if Handle then
        -- Placeholder combat hook
    end
end

--==================================================
-- AUTO FARM NPC
--==================================================

local function FarmNPC()

    while FarmConfig.AutoFarmNPC do

        local Target = FindNPC(
            FarmConfig.TargetNPC
        )

        if Target then

            MoveToTarget(Target)

            if FarmConfig.AutoEquip then
                EquipBestTool()
            end

            AttackTarget(Target)

            task.wait(FarmConfig.FarmDelay)

        else
            task.wait(0.5)
        end
    end
end

--==================================================
-- AUTO FARM BOSS
--==================================================

local function FarmBoss()

    while FarmConfig.AutoFarmBoss do

        local Boss = FindNPC(
            FarmConfig.TargetBoss
        )

        if Boss then

            MoveToTarget(Boss)

            if FarmConfig.AutoEquip then
                EquipBestTool()
            end

            AttackTarget(Boss)

            task.wait(FarmConfig.FarmDelay)

        else
            task.wait(1)
        end
    end
end

--==================================================
-- AUTO COLLECT
--==================================================

local function CollectNearbyDrops()

    local Root = GetRoot()

    if not Root then
        return
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do

        if obj:IsA("BasePart") then

            local Name = string.lower(obj.Name)

            if string.find(Name, "drop")
                or string.find(Name, "coin")
                or string.find(Name, "reward")
                or string.find(Name, "item") then

                if
                    (Root.Position - obj.Position).Magnitude
                    <= 100
                then

                    Root.CFrame =
                        CFrame.new(obj.Position)
                end
            end
        end
    end
end

--==================================================
-- AUTO CHEST
--==================================================

local function FindChest()

    for _, obj in ipairs(Workspace:GetDescendants()) do

        if obj:IsA("Model") then

            local Name =
                string.lower(obj.Name)

            if string.find(Name, "chest") then
                return obj
            end

        elseif obj:IsA("BasePart") then

            local Name =
                string.lower(obj.Name)

            if string.find(Name, "chest") then
                return obj
            end
        end
    end

    return nil
end

local function AutoChestLoop()

    while FarmConfig.AutoChest do

        local Chest = FindChest()

        if Chest then

            local Root = GetRoot()

            if Root then

                local TargetPart =
                    Chest:IsA("BasePart")
                    and Chest
                    or Chest:FindFirstChildWhichIsA(
                        "BasePart",
                        true
                    )

                if TargetPart then

                    Root.CFrame =
                        TargetPart.CFrame *
                        CFrame.new(0, 0, 3)

                end
            end
        end

        task.wait(0.4)
    end
end

--==================================================
-- QUEST SYSTEM
--==================================================

local function FindQuestNPC()

    for _, obj in ipairs(Workspace:GetDescendants()) do

        if obj:IsA("Model") then

            local Name =
                string.lower(obj.Name)

            if
                string.find(Name, "quest")
                or string.find(Name, "questgiver")
                or string.find(Name, "npc")
            then
                return obj
            end
        end
    end

    return nil
end

local function AcceptQuest()

    local QuestNPC = FindQuestNPC()

    if not QuestNPC then
        return
    end

    local Root = GetRoot()

    if not Root then
        return
    end

    local TargetRoot =
        QuestNPC:FindFirstChild("HumanoidRootPart")

    if not TargetRoot then
        return
    end

    Root.CFrame =
        TargetRoot.CFrame *
        CFrame.new(0, 0, 4)

    -- Placeholder:
    -- Nối RemoteEvent/ProximityPrompt của game
end

local function AutoQuestLoop()

    while FarmConfig.AutoQuest do

        AcceptQuest()

        task.wait(1)
    end
end

--==================================================
-- AUTO FARM LEVEL
--==================================================

local function AutoFarmLevelLoop()

    while FarmConfig.AutoFarmLevel do

        -- Tự lấy NPC theo TargetNPC
        local Target =
            FindNPC(FarmConfig.TargetNPC)

        if Target then

            MoveToTarget(Target)

            if FarmConfig.AutoEquip then
                EquipBestTool()
            end

            AttackTarget(Target)

        else
            -- Chưa tìm thấy target
            AcceptQuest()
        end

        task.wait(FarmConfig.FarmDelay)
    end
end

--==================================================
-- AUTO COLLECT LOOP
--==================================================

task.spawn(function()

    while true do

        if FarmConfig.AutoCollect then
            CollectNearbyDrops()
        end

        task.wait(0.5)
    end
end)

--==================================================
-- GUI PAGE
--==================================================

local function AddFarmToggle(Text, Callback)

    -- Dùng AddToggle từ PART 1
    return AddToggle(Text, Callback)
end

AddFarmToggle("⚔️ Auto Farm Level", function(state)

    FarmConfig.AutoFarmLevel = state

    if state then
        task.spawn(AutoFarmLevelLoop)
    end
end)

AddFarmToggle("📜 Auto Quest", function(state)

    FarmConfig.AutoQuest = state

    if state then
        task.spawn(AutoQuestLoop)
    end
end)

AddFarmToggle("👹 Auto Farm NPC", function(state)

    FarmConfig.AutoFarmNPC = state

    if state then
        task.spawn(FarmNPC)
    end
end)

AddFarmToggle("👑 Auto Farm Boss", function(state)

    FarmConfig.AutoFarmBoss = state

    if state then
        task.spawn(FarmBoss)
    end
end)

AddFarmToggle("💰 Auto Collect", function(state)

    FarmConfig.AutoCollect = state
end)

AddFarmToggle("🎁 Auto Chest", function(state)

    FarmConfig.AutoChest = state

    if state then
        task.spawn(AutoChestLoop)
    end
end)

AddFarmToggle("🗡️ Auto Equip Tool", function(state)

    FarmConfig.AutoEquip = state

    if state then
        EquipBestTool()
    end
end)

--==================================================
-- STOP ALL FARM
--==================================================

AddFarmToggle("🛑 Stop All Farm", function(state)

    if state then

        FarmConfig.AutoFarmLevel = false
        FarmConfig.AutoQuest = false
        FarmConfig.AutoFarmNPC = false
        FarmConfig.AutoFarmBoss = false
        FarmConfig.AutoCollect = false
        FarmConfig.AutoChest = false

        Notification("Đã tắt toàn bộ Farm")
    end
end)

print("Tzuy Hub Part 2 Loaded")--// TZUY HUB - PART 3
--// TELEPORT + MOVEMENT
--// Ghép sau PART 1 + PART 2

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local MoveConfig = {
    WalkSpeed = 16,
    JumpPower = 50,

    WalkSpeedEnabled = false,
    JumpPowerEnabled = false,

    InfiniteJump = false,
    NoClip = false,

    TweenSpeed = 100,
    SelectedLocation = nil
}

local SavedPosition = nil

--==================================================
-- CHARACTER
--==================================================

local function Character()
    return Player.Character
end

local function Humanoid()
    local char = Character()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function Root()
    local char = Character()
    return char and char:FindFirstChild("HumanoidRootPart")
end

--==================================================
-- TELEPORT
--==================================================

local function TeleportToCFrame(cf)
    local root = Root()

    if root and cf then
        root.CFrame = cf
    end
end

local function TeleportToPart(part)
    if not part or not part:IsA("BasePart") then
        return
    end

    TeleportToCFrame(
        part.CFrame + Vector3.new(0, 3, 0)
    )
end

local function TweenToPart(part)

    local root = Root()

    if not root or not part then
        return
    end

    local distance =
        (root.Position - part.Position).Magnitude

    local duration =
        math.max(distance / MoveConfig.TweenSpeed, 0.05)

    local TweenService =
        game:GetService("TweenService")

    local tween = TweenService:Create(
        root,
        TweenInfo.new(
            duration,
            Enum.EasingStyle.Linear
        ),
        {
            CFrame =
                part.CFrame +
                Vector3.new(0, 3, 0)
        }
    )

    tween:Play()
end

--==================================================
-- SAVE POSITION
--==================================================

local function SavePosition()

    local root = Root()

    if root then
        SavedPosition = root.CFrame
        Notification("Đã lưu vị trí")
    end
end

local function ReturnPosition()

    if SavedPosition then
        TeleportToCFrame(SavedPosition)
        Notification("Đã quay lại vị trí")
    else
        Notification("Chưa có vị trí được lưu")
    end
end

--==================================================
-- WALK SPEED
--==================================================

local function ApplyWalkSpeed()

    local hum = Humanoid()

    if not hum then
        return
    end

    if MoveConfig.WalkSpeedEnabled then
        hum.WalkSpeed = MoveConfig.WalkSpeed
    else
        hum.WalkSpeed = 16
    end
end

--==================================================
-- JUMP POWER
--==================================================

local function ApplyJumpPower()

    local hum = Humanoid()

    if not hum then
        return
    end

    if MoveConfig.JumpPowerEnabled then
        hum.UseJumpPower = true
        hum.JumpPower = MoveConfig.JumpPower
    else
        hum.UseJumpPower = true
        hum.JumpPower = 50
    end
end

--==================================================
-- INFINITE JUMP
--==================================================

UserInputService.JumpRequest:Connect(function()

    if not MoveConfig.InfiniteJump then
        return
    end

    local hum = Humanoid()

    if hum then
        hum:ChangeState(
            Enum.HumanoidStateType.Jumping
        )
    end
end)

--==================================================
-- NOCLIP
--==================================================

RunService.Stepped:Connect(function()

    if not MoveConfig.NoClip then
        return
    end

    local char = Character()

    if not char then
        return
    end

    for _, obj in ipairs(char:GetDescendants()) do

        if obj:IsA("BasePart") then
            obj.CanCollide = false
        end

    end
end)

--==================================================
-- RESPAWN SUPPORT
--==================================================

Player.CharacterAdded:Connect(function()

    task.wait(1)

    ApplyWalkSpeed()
    ApplyJumpPower()
end)

--==================================================
-- FIND LOCATIONS
--==================================================

local function GetLocationParts()

    local result = {}

    for _, obj in ipairs(Workspace:GetDescendants()) do

        if obj:IsA("BasePart") then

            local name =
                string.lower(obj.Name)

            if
                string.find(name, "spawn")
                or string.find(name, "island")
                or string.find(name, "town")
                or string.find(name, "city")
                or string.find(name, "port")
                or string.find(name, "village")
                or string.find(name, "castle")
                or string.find(name, "sea")
            then

                table.insert(
                    result,
                    obj
                )

            end
        end
    end

    return result
end

--==================================================
-- TELEPORT BY NAME
--==================================================

local function FindLocation(name)

    if not name then
        return nil
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do

        if obj:IsA("BasePart")
            and string.lower(obj.Name)
                == string.lower(name) then

            return obj
        end
    end

    return nil
end

--==================================================
-- GUI
--==================================================

local function AddMoveToggle(text, callback)

    return AddToggle(
        text,
        callback
    )
end

AddMoveToggle("🏃 WalkSpeed", function(state)

    MoveConfig.WalkSpeedEnabled = state
    ApplyWalkSpeed()

end)

AddMoveToggle("🦘 JumpPower", function(state)

    MoveConfig.JumpPowerEnabled = state
    ApplyJumpPower()

end)

AddMoveToggle("♾️ Infinite Jump", function(state)

    MoveConfig.InfiniteJump = state

    Notification(
        state
        and "Infinite Jump: ON"
        or "Infinite Jump: OFF"
    )

end)

AddMoveToggle("👻 NoClip", function(state)

    MoveConfig.NoClip = state

    if state then
        Notification("NoClip: ON")
    else
        Notification("NoClip: OFF")
    end

end)

--==================================================
-- SAVE / RETURN
--==================================================

AddMoveToggle("📍 Save Position", function(state)

    if state then
        SavePosition()
    end

end)

AddMoveToggle("↩️ Return Position", function(state)

    if state then
        ReturnPosition()
    end

end)

--==================================================
-- TELEPORT TO SPAWN
--==================================================

AddMoveToggle("🏠 Teleport Spawn", function(state)

    if not state then
        return
    end

    local spawn =
        Workspace:FindFirstChildWhichIsA(
            "SpawnLocation",
            true
        )

    if spawn then
        TeleportToPart(spawn)
        Notification("Đã teleport Spawn")
    else
        Notification("Không tìm thấy Spawn")
    end

end)

--==================================================
-- TELEPORT TO SELECTED
--==================================================

AddMoveToggle("📌 Teleport Selected", function(state)

    if not state then
        return
    end

    if not MoveConfig.SelectedLocation then
        Notification("Chưa chọn địa điểm")
        return
    end

    local target =
        FindLocation(
            MoveConfig.SelectedLocation
        )

    if target then

        TeleportToPart(target)

        Notification(
            "Đã tới: "
            .. MoveConfig.SelectedLocation
        )

    else

        Notification(
            "Không tìm thấy: "
            .. MoveConfig.SelectedLocation
        )

    end

end)

--==================================================
-- REFRESH LOCATION LIST
--==================================================

local function BuildLocationList()

    local locations = {}

    for _, part in ipairs(
        GetLocationParts()
    ) do

        if not locations[part.Name] then
            locations[part.Name] = part
        end

    end

    return locations
end

--==================================================
-- SIMPLE LOCATION PICKER
--==================================================

local locationList =
    BuildLocationList()

for name, part in pairs(locationList) do

    local button =
        AddToggle(
            "📍 " .. name,
            function(state)

                if state then

                    MoveConfig.SelectedLocation =
                        name

                    Notification(
                        "Đã chọn: "
                        .. name
                    )

                end
            end
        )

end

--==================================================
-- SETTINGS
--==================================================

local speedValue = 16

AddToggle("⚡ Speed x2", function(state)

    if state then
        MoveConfig.WalkSpeed = 32
    else
        MoveConfig.WalkSpeed = 16
    end

    ApplyWalkSpeed()

end)

AddToggle("🚀 Speed x4", function(state)

    if state then
        MoveConfig.WalkSpeed = 64
    else
        MoveConfig.WalkSpeed = 16
    end

    ApplyWalkSpeed()

end)

AddToggle("🦘 Jump x2", function(state)

    if state then
        MoveConfig.JumpPower = 100
    else
        MoveConfig.JumpPower = 50
    end

    ApplyJumpPower()

end)

print("Tzuy Hub Part 3 Loaded")--// TZUY HUB - PART 4
--// PLAYER + ESP SYSTEM
--// Ghép sau PART 1 + PART 2 + PART 3

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- ESP CONFIG
--==================================================

local ESPConfig = {
    Player = false,
    NPC = false,
    Boss = false,
    Chest = false,

    Name = true,
    Distance = true,
    Health = true,
    Highlight = true,

    MaxDistance = 1500
}

local ESPObjects = {}

--==================================================
-- CREATE BILLBOARD
--==================================================

local function CreateESP(part, title, kind)

    if not part or not part:IsA("BasePart") then
        return
    end

    if ESPObjects[part] then
        return
    end

    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "TzuyESP"
    Billboard.Size = UDim2.new(0, 180, 0, 60)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    Billboard.AlwaysOnTop = true
    Billboard.MaxDistance = ESPConfig.MaxDistance
    Billboard.Adornee = part
    Billboard.Parent = part

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextStrokeTransparency = 0.4
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamBold
    Label.Text = title
    Label.Parent = Billboard

    local Highlight

    if ESPConfig.Highlight then

        Highlight = Instance.new("Highlight")
        Highlight.Name = "TzuyHighlight"
        Highlight.FillTransparency = 0.75
        Highlight.OutlineTransparency = 0
        Highlight.Adornee =
            part.Parent:IsA("Model")
            and part.Parent
            or part
        Highlight.Parent = part.Parent

    end

    ESPObjects[part] = {
        Billboard = Billboard,
        Label = Label,
        Highlight = Highlight,
        Kind = kind
    }
end

--==================================================
-- REMOVE ESP
--==================================================

local function RemoveESP(part)

    local data = ESPObjects[part]

    if not data then
        return
    end

    if data.Billboard then
        data.Billboard:Destroy()
    end

    if data.Highlight then
        data.Highlight:Destroy()
    end

    ESPObjects[part] = nil
end

local function ClearAllESP()

    for part in pairs(ESPObjects) do
        RemoveESP(part)
    end

    table.clear(ESPObjects)
end

--==================================================
-- GET ROOT
--==================================================

local function GetRoot(model)

    if not model then
        return nil
    end

    return model:FindFirstChild(
        "HumanoidRootPart"
    )
    or model:FindFirstChild(
        "PrimaryPart"
    )
end

--==================================================
-- CLASSIFY NPC
--==================================================

local function IsBoss(model)

    local name =
        string.lower(model.Name)

    return
        string.find(name, "boss")
        or string.find(name, "king")
        or string.find(name, "lord")
        or string.find(name, "elite")
end

local function IsNPC(model)

    if not model:IsA("Model") then
        return false
    end

    if Players:GetPlayerFromCharacter(model) then
        return false
    end

    return model:FindFirstChildOfClass(
        "Humanoid"
    ) ~= nil
end

--==================================================
-- CHEST DETECTION
--==================================================

local function IsChest(obj)

    local name =
        string.lower(obj.Name)

    return
        string.find(name, "chest")
        or string.find(name, "treasure")
        or string.find(name, "crate")
end

--==================================================
-- PLAYER ESP
--==================================================

local function ScanPlayers()

    if not ESPConfig.Player then
        return
    end

    for _, player in ipairs(
        Players:GetPlayers()
    ) do

        if player ~= LocalPlayer then

            local character =
                player.Character

            local root =
                GetRoot(character)

            if root then

                CreateESP(
                    root,
                    player.Name,
                    "Player"
                )

            end
        end
    end
end

--==================================================
-- NPC / BOSS ESP
--==================================================

local function ScanNPCs()

    if
        not ESPConfig.NPC
        and not ESPConfig.Boss
    then
        return
    end

    for _, obj in ipairs(
        Workspace:GetDescendants()
    ) do

        if obj:IsA("Model")
            and IsNPC(obj) then

            local root =
                GetRoot(obj)

            if root then

                local boss =
                    IsBoss(obj)

                if boss
                    and ESPConfig.Boss then

                    CreateESP(
                        root,
                        "BOSS: "
                            .. obj.Name,
                        "Boss"
                    )

                elseif
                    not boss
                    and ESPConfig.NPC then

                    CreateESP(
                        root,
                        obj.Name,
                        "NPC"
                    )
                end
            end
        end
    end
end

--==================================================
-- CHEST ESP
--==================================================

local function ScanChests()

    if not ESPConfig.Chest then
        return
    end

    for _, obj in ipairs(
        Workspace:GetDescendants()
    ) do

        if
            (obj:IsA("Model")
            or obj:IsA("BasePart"))
            and IsChest(obj)
        then

            local part

            if obj:IsA("BasePart") then
                part = obj
            else
                part =
                    obj:FindFirstChildWhichIsA(
                        "BasePart",
                        true
                    )
            end

            if part then

                CreateESP(
                    part,
                    "CHEST",
                    "Chest"
                )

            end
        end
    end
end

--==================================================
-- UPDATE ESP
--==================================================

RunService.RenderStepped:Connect(function()

    local localRoot =
        GetRoot(LocalPlayer.Character)

    if not localRoot then
        return
    end

    for part, data in pairs(ESPObjects) do

        if not part
            or not part.Parent then

            RemoveESP(part)

        else

            local distance =
                (
                    localRoot.Position
                    - part.Position
                ).Magnitude

            if distance >
                ESPConfig.MaxDistance then

                data.Billboard.Enabled = false

                if data.Highlight then
                    data.Highlight.Enabled = false
                end

            else

                data.Billboard.Enabled = true

                if data.Highlight then
                    data.Highlight.Enabled = true
                end

                local text = ""

                if ESPConfig.Name then
                    text = text .. part.Parent.Name
                end

                if ESPConfig.Distance then

                    text =
                        text
                        .. "\n["
                        .. math.floor(distance)
                        .. "m]"

                end

                local model =
                    part.Parent

                local hum =
                    model:FindFirstChildOfClass(
                        "Humanoid"
                    )

                if
                    ESPConfig.Health
                    and hum
                then

                    text =
                        text
                        .. "\nHP: "
                        .. math.floor(hum.Health)
                        .. "/"
                        .. math.floor(hum.MaxHealth)

                end

                data.Label.Text = text
            end
        end
    end
end)

--==================================================
-- AUTO SCAN
--==================================================

task.spawn(function()

    while true do

        ScanPlayers()
        ScanNPCs()
        ScanChests()

        task.wait(2)
    end
end)

--==================================================
-- GUI TOGGLES
--==================================================

AddToggle(
    "👤 ESP Player",
    function(state)

        ESPConfig.Player = state

        if not state then

            for part, data in pairs(
                ESPObjects
            ) do

                if data.Kind == "Player" then
                    RemoveESP(part)
                end

            end
        end
    end
)

AddToggle(
    "👹 ESP NPC",
    function(state)

        ESPConfig.NPC = state

        if not state then

            for part, data in pairs(
                ESPObjects
            ) do

                if data.Kind == "NPC" then
                    RemoveESP(part)
                end

            end
        end
    end
)

AddToggle(
    "👑 ESP Boss",
    function(state)

        ESPConfig.Boss = state

        if not state then

            for part, data in pairs(
                ESPObjects
            ) do

                if data.Kind == "Boss" then
                    RemoveESP(part)
                end

            end
        end
    end
)

AddToggle(
    "🎁 ESP Chest",
    function(state)

        ESPConfig.Chest = state

        if not state then

            for part, data in pairs(
                ESPObjects
            ) do

                if data.Kind == "Chest" then
                    RemoveESP(part)
                end

            end
        end
    end
)

AddToggle(
    "🏷️ ESP Name",
    function(state)

        ESPConfig.Name = state
    end
)

AddToggle(
    "📏 ESP Distance",
    function(state)

        ESPConfig.Distance = state
    end
)

AddToggle(
    "❤️ ESP Health",
    function(state)

        ESPConfig.Health = state
    end
)

AddToggle(
    "🔲 ESP Highlight",
    function(state)

        ESPConfig.Highlight = state

        for _, data in pairs(
            ESPObjects
        ) do

            if data.Highlight then
                data.Highlight.Enabled = state
            end

        end
    end
)

--==================================================
-- MAX DISTANCE
--==================================================

AddToggle(
    "🔭 ESP 3000 Distance",
    function(state)

        if state then
            ESPConfig.MaxDistance = 3000
        else
            ESPConfig.MaxDistance = 1500
        end
    end
)

--==================================================
-- CLEAR ESP
--==================================================

AddToggle(
    "🧹 Clear ESP",
    function(state)

        if state then
            ClearAllESP()
            Notification("Đã xóa toàn bộ ESP")
        end
    end
)

print("Tzuy Hub Part 4 Loaded")--// TZUY HUB - PART 5
--// SERVER SYSTEM
--// Ghép sau PART 1 + PART 2 + PART 3 + PART 4

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

--==================================================
-- SERVER CONFIG
--==================================================

local ServerConfig = {
    AutoRejoin = false,
    RejoinDelay = 5,
    MaxPlayers = 0,
    TargetServer = nil
}

local PlaceId = game.PlaceId
local JobId = game.JobId

--==================================================
-- GET SERVER INFO
--==================================================

local function GetServerInfo()

    local playerCount =
        #Players:GetPlayers()

    local maxPlayers =
        Players.MaxPlayers

    return {
        PlaceId = PlaceId,
        JobId = JobId,
        Players = playerCount,
        MaxPlayers = maxPlayers
    }
end

--==================================================
-- SERVER INFO NOTIFICATION
--==================================================

local function ShowServerInfo()

    local info = GetServerInfo()

    Notification(
        "Players: "
        .. info.Players
        .. "/"
        .. info.MaxPlayers
    )

    print(
        "========== TZUY HUB SERVER =========="
    )

    print(
        "PlaceId:",
        info.PlaceId
    )

    print(
        "JobId:",
        info.JobId
    )

    print(
        "Players:",
        info.Players
        .. "/"
        .. info.MaxPlayers
    )

end

--==================================================
-- REJOIN
--==================================================

local function RejoinServer()

    Notification("Đang Rejoin...")

    task.wait(0.5)

    TeleportService:Teleport(
        PlaceId,
        Player
    )
end

--==================================================
-- SERVER TELEPORT
--==================================================

local function TeleportToServer(jobId)

    if not jobId or jobId == "" then
        return false
    end

    if jobId == game.JobId then

        Notification(
            "Đây là server hiện tại"
        )

        return false
    end

    local success, err =
        pcall(function()

            TeleportService:TeleportToPlaceInstance(
                PlaceId,
                jobId,
                Player
            )

        end)

    if not success then

        warn(
            "Teleport Server Error:",
            err
        )

        Notification(
            "Không thể chuyển server"
        )

        return false
    end

    return true
end

--==================================================
-- RANDOM SERVER
--==================================================

local function RandomServer()

    -- Roblox không cung cấp một API client
    -- đáng tin cậy để tự lấy toàn bộ public server.
    -- Chức năng này để làm hook cho hệ thống
    -- server-list của game bạn.

    Notification(
        "Random Server cần server-list"
    )
end

--==================================================
-- AUTO REJOIN
--==================================================

local function StartAutoRejoin()

    task.spawn(function()

        while ServerConfig.AutoRejoin do

            task.wait(
                ServerConfig.RejoinDelay
            )

            if #Players:GetPlayers() <= 0 then
                break
            end
        end
    end)
end

--==================================================
-- COPY JOB ID
--==================================================

local function CopyJobId()

    if setclipboard then

        setclipboard(
            tostring(game.JobId)
        )

        Notification(
            "Đã copy Job ID"
        )

    else

        print(
            "Job ID:",
            game.JobId
        )

        Notification(
            "Job ID đã được in ra Console"
        )
    end
end

--==================================================
-- COPY PLACE ID
--==================================================

local function CopyPlaceId()

    if setclipboard then

        setclipboard(
            tostring(game.PlaceId)
        )

        Notification(
            "Đã copy Place ID"
        )

    else

        print(
            "Place ID:",
            game.PlaceId
        )

        Notification(
            "Place ID đã được in ra Console"
        )
    end
end

--==================================================
-- GUI
--==================================================

AddToggle(
    "🔄 Rejoin Server",
    function(state)

        if state then
            RejoinServer()
        end

    end
)

AddToggle(
    "📋 Server Info",
    function(state)

        if state then
            ShowServerInfo()
        end

    end
)

AddToggle(
    "📑 Copy Job ID",
    function(state)

        if state then
            CopyJobId()
        end

    end
)

AddToggle(
    "🆔 Copy Place ID",
    function(state)

        if state then
            CopyPlaceId()
        end

    end
)

AddToggle(
    "🎲 Random Server",
    function(state)

        if state then
            RandomServer()
        end

    end
)

AddToggle(
    "♻️ Auto Rejoin",
    function(state)

        ServerConfig.AutoRejoin = state

        if state then
            StartAutoRejoin()
        end

        Notification(
            state
            and "Auto Rejoin: ON"
            or "Auto Rejoin: OFF"
        )

    end
)

--==================================================
-- JOB ID INPUT
--==================================================

local function CreateJobIdBox()

    local Box = Instance.new("TextBox")

    Box.Size =
        UDim2.new(
            1,
            -8,
            0,
            40
        )

    Box.BackgroundColor3 =
        Color3.fromRGB(
            25,
            25,
            30
        )

    Box.PlaceholderText =
        "Nhập Job ID..."

    Box.Text = ""

    Box.TextColor3 =
        Color3.fromRGB(
            235,
            235,
            235
        )

    Box.PlaceholderColor3 =
        Color3.fromRGB(
            120,
            120,
            130
        )

    Box.TextSize = 13

    Box.Font =
        Enum.Font.Gotham

    Box.Parent = Page

    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0, 8)

    Corner.Parent = Box

    return Box
end

local JobBox =
    CreateJobIdBox()

AddToggle(
    "🚪 Join Job ID",
    function(state)

        if not state then
            return
        end

        if JobBox.Text == "" then

            Notification(
                "Chưa nhập Job ID"
            )

            return
        end

        TeleportToServer(
            JobBox.Text
        )

    end
)

--==================================================
-- SERVER PLAYER COUNTER
--==================================================

local ServerCounter =
    Instance.new("TextLabel")

ServerCounter.Size =
    UDim2.new(1, -8, 0, 25)

ServerCounter.BackgroundTransparency =
    1

ServerCounter.TextColor3 =
    Color3.fromRGB(
        170,
        170,
        180
    )

ServerCounter.TextSize = 12

ServerCounter.Font =
    Enum.Font.Gotham

ServerCounter.TextXAlignment =
    Enum.TextXAlignment.Left

ServerCounter.Parent = Page

task.spawn(function()

    while task.wait(1) do

        ServerCounter.Text =
            "👥 Server: "
            .. #Players:GetPlayers()
            .. "/"
            .. Players.MaxPlayers
    end
end)

print("Tzuy Hub Part 5 Loaded")--// TZUY HUB - PART 6
--// SETTINGS + UI SYSTEM
--// Ghép sau PART 1 -> PART 5

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

--==================================================
-- SETTINGS
--==================================================

local TzuySettings = {
    HubVisible = true,
    Notifications = true,
    ToggleKey = Enum.KeyCode.RightShift,
    CompactMode = false
}

--==================================================
-- NOTIFICATION OVERRIDE
--==================================================

local OldNotification = Notification

function Notification(text)

    if not TzuySettings.Notifications then
        return
    end

    OldNotification(text)
end

--==================================================
-- SHOW / HIDE HUB
--==================================================

local function SetHubVisible(state)

    TzuySettings.HubVisible = state

    if Main then
        Main.Visible = state
    end

    if OpenButton then
        OpenButton.Visible = not state
    end
end

--==================================================
-- TOGGLE KEY
--==================================================

UserInputService.InputBegan:Connect(function(
    input,
    gameProcessed
)

    if gameProcessed then
        return
    end

    if input.KeyCode ==
        TzuySettings.ToggleKey then

        local state =
            not Main.Visible

        Main.Visible = state
        OpenButton.Visible = not state

    end
end)

--==================================================
-- RESET CONFIG
--==================================================

local function ResetSettings()

    -- Visual
    if Config then

        for key in pairs(Config) do

            if typeof(Config[key]) == "boolean" then
                Config[key] = false
            end

        end

    end

    -- Farm
    if FarmConfig then

        for key in pairs(FarmConfig) do

            if typeof(FarmConfig[key]) == "boolean" then
                FarmConfig[key] = false
            end

        end

    end

    -- Movement
    if MoveConfig then

        MoveConfig.WalkSpeedEnabled = false
        MoveConfig.JumpPowerEnabled = false
        MoveConfig.InfiniteJump = false
        MoveConfig.NoClip = false
        MoveConfig.WalkSpeed = 16
        MoveConfig.JumpPower = 50

    end

    -- ESP
    if ESPConfig then

        ESPConfig.Player = false
        ESPConfig.NPC = false
        ESPConfig.Boss = false
        ESPConfig.Chest = false

    end

    ClearAllESP()

    Notification(
        "Đã reset toàn bộ Settings"
    )
end

--==================================================
-- DEFAULT SETTINGS
--==================================================

local function RestoreDefaults()

    TzuySettings.Notifications = true
    TzuySettings.CompactMode = false
    TzuySettings.ToggleKey =
        Enum.KeyCode.RightShift

    Notification(
        "Đã khôi phục mặc định"
    )
end

--==================================================
-- COMPACT MODE
--==================================================

local NormalSize =
    UDim2.new(0, 520, 0, 360)

local CompactSize =
    UDim2.new(0, 420, 0, 300)

local function SetCompact(state)

    TzuySettings.CompactMode = state

    if not Main then
        return
    end

    if state then

        Main.Size = CompactSize

    else

        Main.Size = NormalSize

    end
end

--==================================================
-- NOTIFICATION TOGGLE
--==================================================

AddToggle(
    "🔔 Notifications",
    function(state)

        TzuySettings.Notifications =
            state

    end
)

--==================================================
-- COMPACT MODE
--==================================================

AddToggle(
    "📱 Compact Mode",
    function(state)

        SetCompact(state)

    end
)

--==================================================
-- RESET
--==================================================

AddToggle(
    "🧹 Reset All Settings",
    function(state)

        if state then
            ResetSettings()
        end

    end
)

--==================================================
-- DEFAULT
--==================================================

AddToggle(
    "↩️ Restore Defaults",
    function(state)

        if state then
            RestoreDefaults()
        end

    end
)

--==================================================
-- CLOSE BUTTON
--==================================================

AddToggle(
    "👁️ Hide Hub",
    function(state)

        if state then
            SetHubVisible(false)
        end

    end
)

--==================================================
-- REOPEN BUTTON
--==================================================

OpenButton.MouseButton1Click:Connect(
    function()

        Main.Visible = true
        OpenButton.Visible = false

    end
)

--==================================================
-- PLAYER INFO
--==================================================

local InfoLabel =
    Instance.new("TextLabel")

InfoLabel.Size =
    UDim2.new(
        1,
        -8,
        0,
        60
    )

InfoLabel.BackgroundTransparency = 1

InfoLabel.TextColor3 =
    Color3.fromRGB(
        170,
        170,
        180
    )

InfoLabel.TextSize = 12

InfoLabel.Font =
    Enum.Font.Gotham

InfoLabel.TextXAlignment =
    Enum.TextXAlignment.Left

InfoLabel.TextYAlignment =
    Enum.TextYAlignment.Top

InfoLabel.Parent = Page

task.spawn(function()

    while task.wait(1) do

        local levelText = "N/A"

        local leaderstats =
            Player:FindFirstChild(
                "leaderstats"
            )

        if leaderstats then

            local level =
                leaderstats:FindFirstChild(
                    "Level"
                )

            if level then
                levelText =
                    tostring(level.Value)
            end

        end

        InfoLabel.Text =
            "👤 Player: "
            .. Player.Name
            .. "\n"
            .. "⭐ Level: "
            .. levelText
            .. "\n"
            .. "🆔 UserId: "
            .. Player.UserId

    end
end)

--==================================================
-- VERSION
--==================================================

local Version =
    Instance.new("TextLabel")

Version.Size =
    UDim2.new(
        1,
        -8,
        0,
        25
    )

Version.BackgroundTransparency = 1

Version.Text =
    "Tzuy Hub • TLS • v1.0"

Version.TextColor3 =
    Color3.fromRGB(
        100,
        100,
        110
    )

Version.TextSize = 11

Version.Font =
    Enum.Font.Gotham

Version.TextXAlignment =
    Enum.TextXAlignment.Left

Version.Parent = Page

print(
    "Tzuy Hub Part 6 Loaded"
)--// TZUY HUB - PART 7
--// MISC + FPS + PERFORMANCE
--// Ghép sau PART 1 -> PART 6

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local MiscConfig = {
    AntiAFK = false,
    FPSMonitor = true,
    PingMonitor = true,
    PerformanceMode = false,
    CleanEffects = false,
    DisablePostEffects = false
}

--==================================================
-- ANTI AFK
--==================================================

local VirtualUser

pcall(function()
    VirtualUser =
        game:GetService("VirtualUser")
end)

Player.Idled:Connect(function()

    if not MiscConfig.AntiAFK then
        return
    end

    if VirtualUser then

        VirtualUser:CaptureController()

        VirtualUser:ClickButton2(
            Vector2.new(0, 0)
        )

    end
end)

--==================================================
-- PERFORMANCE MODE
--==================================================

local function PerformanceMode(state)

    MiscConfig.PerformanceMode = state

    if state then

        Lighting.GlobalShadows = false
        Lighting.Brightness = 1

        for _, obj in ipairs(
            Workspace:GetDescendants()
        ) do

            if obj:IsA("ParticleEmitter")
                or obj:IsA("Trail")
                or obj:IsA("Beam")
                or obj:IsA("Smoke")
                or obj:IsA("Fire")
                or obj:IsA("Sparkles") then

                obj.Enabled = false
            end

        end

        Notification(
            "⚡ Performance Mode: ON"
        )

    else

        Lighting.GlobalShadows = true

        Notification(
            "⚡ Performance Mode: OFF"
        )

    end
end

--==================================================
-- CLEAN EFFECTS
--==================================================

local function CleanEffects()

    local count = 0

    for _, obj in ipairs(
        Workspace:GetDescendants()
    ) do

        if obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam")
            or obj:IsA("Smoke")
            or obj:IsA("Fire")
            or obj:IsA("Sparkles") then

            obj.Enabled = false
            count += 1
        end
    end

    Notification(
        "🧹 Đã dọn "
        .. count
        .. " hiệu ứng"
    )
end

--==================================================
-- POST EFFECTS
--==================================================

local function DisablePostEffects(state)

    MiscConfig.DisablePostEffects =
        state

    for _, obj in ipairs(
        Lighting:GetChildren()
    ) do

        if obj:IsA("BloomEffect")
            or obj:IsA("BlurEffect")
            or obj:IsA("ColorCorrectionEffect")
            or obj:IsA("SunRaysEffect")
            or obj:IsA("DepthOfFieldEffect") then

            obj.Enabled = not state
        end

    end
end

--==================================================
-- FPS DISPLAY
--==================================================

local FPS = 0
local frames = 0
local lastTime = tick()

local FPSLabel =
    Instance.new("TextLabel")

FPSLabel.Size =
    UDim2.new(0, 180, 0, 25)

FPSLabel.Position =
    UDim2.new(1, -195, 0, 10)

FPSLabel.BackgroundColor3 =
    Color3.fromRGB(20, 20, 24)

FPSLabel.BackgroundTransparency =
    0.15

FPSLabel.TextColor3 =
    Color3.fromRGB(235, 235, 240)

FPSLabel.TextSize = 12

FPSLabel.Font =
    Enum.Font.GothamBold

FPSLabel.Text =
    "FPS: -- | Ping: --"

FPSLabel.Visible = true
FPSLabel.Parent = ScreenGui

local FPSCorner =
    Instance.new("UICorner")

FPSCorner.CornerRadius =
    UDim.new(0, 8)

FPSCorner.Parent = FPSLabel

RunService.RenderStepped:Connect(
    function()

        frames += 1

        if tick() - lastTime >= 1 then

            FPS = frames
            frames = 0
            lastTime = tick()

            local ping = 0

            pcall(function()
                ping =
                    math.floor(
                        Player:GetNetworkPing()
                        * 1000
                    )
            end)

            if MiscConfig.FPSMonitor
                or MiscConfig.PingMonitor then

                local text = ""

                if MiscConfig.FPSMonitor then
                    text =
                        text
                        .. "FPS: "
                        .. FPS
                end

                if MiscConfig.PingMonitor then

                    if text ~= "" then
                        text = text .. " | "
                    end

                    text =
                        text
                        .. "Ping: "
                        .. ping
                        .. "ms"
                end

                FPSLabel.Text = text

            else

                FPSLabel.Text = ""

            end
        end
    end
)

--==================================================
-- TOGGLES
--==================================================

AddToggle(
    "🛡️ Anti-AFK",
    function(state)

        MiscConfig.AntiAFK = state

        Notification(
            state
            and "Anti-AFK: ON"
            or "Anti-AFK: OFF"
        )

    end
)

AddToggle(
    "📊 FPS Monitor",
    function(state)

        MiscConfig.FPSMonitor = state
        FPSLabel.Visible = state
            or MiscConfig.PingMonitor

    end
)

AddToggle(
    "📶 Ping Monitor",
    function(state)

        MiscConfig.PingMonitor = state
        FPSLabel.Visible = state
            or MiscConfig.FPSMonitor

    end
)

AddToggle(
    "⚡ Performance Mode",
    function(state)

        PerformanceMode(state)

    end
)

AddToggle(
    "🧹 Clean Effects",
    function(state)

        if state then
            CleanEffects()
        end

    end
)

AddToggle(
    "🎞️ Disable Post Effects",
    function(state)

        DisablePostEffects(state)

    end
)

--==================================================
-- AUTO CLEAN NEW EFFECTS
--==================================================

Workspace.DescendantAdded:Connect(
    function(obj)

        if not MiscConfig.CleanEffects then
            return
        end

        task.wait()

        if obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam")
            or obj:IsA("Smoke")
            or obj:IsA("Fire")
            or obj:IsA("Sparkles") then

            obj.Enabled = false
        end

    end
)

AddToggle(
    "♻️ Auto Clean Effects",
    function(state)

        MiscConfig.CleanEffects = state

        Notification(
            state
            and "Auto Clean: ON"
            or "Auto Clean: OFF"
        )

    end
)

--==================================================
-- HIDE FPS PANEL
--==================================================

AddToggle(
    "👁️ Hide FPS Panel",
    function(state)

        FPSLabel.Visible = not state

    end
)

--==================================================
-- RESET CHARACTER
--==================================================

AddToggle(
    "🔄 Reset Character",
    function(state)

        if not state then
            return
        end

        local Character =
            Player.Character

        local Humanoid =
            Character
            and Character:FindFirstChildOfClass(
                "Humanoid"
            )

        if Humanoid then
            Humanoid.Health = 0
        end

    end
)

--==================================================
-- REFRESH CHARACTER
--==================================================

Player.CharacterAdded:Connect(
    function()

        task.wait(1)

        if MiscConfig.PerformanceMode then
            PerformanceMode(true)
        end

        if MiscConfig.CleanEffects then
            CleanEffects()
        end

    end
)

print(
    "Tzuy Hub Part 7 Loaded"
)--// TZUY HUB - PART 8
--// MASTER CONTROLLER
--// Final Part

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

--==================================================
-- MASTER CONFIG
--==================================================

local MasterConfig = {
    Loaded = true,
    Notifications = true,
    AutoSave = false,
    Unloaded = false
}

--==================================================
-- HUB STATUS
--==================================================

local StatusLabel = Instance.new("TextLabel")

StatusLabel.Size = UDim2.new(1, -8, 0, 35)
StatusLabel.BackgroundColor3 =
    Color3.fromRGB(20, 20, 24)

StatusLabel.TextColor3 =
    Color3.fromRGB(210, 210, 215)

StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Text = "● Tzuy Hub: Loaded"
StatusLabel.Parent = Page

local StatusCorner =
    Instance.new("UICorner")

StatusCorner.CornerRadius =
    UDim.new(0, 8)

StatusCorner.Parent = StatusLabel

--==================================================
-- STOP EVERYTHING
--==================================================

local function StopEverything()

    -- Farm
    if FarmConfig then
        FarmConfig.AutoFarmLevel = false
        FarmConfig.AutoQuest = false
        FarmConfig.AutoFarmNPC = false
        FarmConfig.AutoFarmBoss = false
        FarmConfig.AutoCollect = false
        FarmConfig.AutoChest = false
    end

    -- Movement
    if MoveConfig then
        MoveConfig.WalkSpeedEnabled = false
        MoveConfig.JumpPowerEnabled = false
        MoveConfig.InfiniteJump = false
        MoveConfig.NoClip = false
    end

    -- ESP
    if ESPConfig then
        ESPConfig.Player = false
        ESPConfig.NPC = false
        ESPConfig.Boss = false
        ESPConfig.Chest = false
    end

    -- Misc
    if MiscConfig then
        MiscConfig.AntiAFK = false
        MiscConfig.PerformanceMode = false
        MiscConfig.CleanEffects = false
        MiscConfig.DisablePostEffects = false
    end

    -- Reset movement
    local Character =
        Player.Character

    local Humanoid =
        Character
        and Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if Humanoid then
        Humanoid.WalkSpeed = 16
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = 50
    end

    -- Clear ESP
    if ClearAllESP then
        ClearAllESP()
    end

    Notification(
        "🛑 Đã dừng toàn bộ chức năng"
    )
end

--==================================================
-- UNLOAD HUB
--==================================================

local function UnloadHub()

    if MasterConfig.Unloaded then
        return
    end

    MasterConfig.Unloaded = true
    MasterConfig.Loaded = false

    -- Stop systems
    StopEverything()

    -- Destroy GUI
    if ScreenGui then
        ScreenGui:Destroy()
    end

    print(
        "Tzuy Hub đã Unload."
    )
end

--==================================================
-- RELOAD UI
--==================================================

local function ReloadInfo()

    if MasterConfig.Unloaded then
        return
    end

    Notification(
        "Tzuy Hub đang hoạt động"
    )
end

--==================================================
-- MASTER BUTTONS
--==================================================

AddToggle(
    "🛑 Stop All",
    function(state)

        if state then
            StopEverything()
        end

    end
)

AddToggle(
    "🔄 Hub Status",
    function(state)

        if state then
            ReloadInfo()
        end

    end
)

AddToggle(
    "💥 Unload Hub",
    function(state)

        if state then
            UnloadHub()
        end

    end
)

--==================================================
-- VERSION INFO
--==================================================

local FinalInfo =
    Instance.new("TextLabel")

FinalInfo.Size =
    UDim2.new(1, -8, 0, 65)

FinalInfo.BackgroundTransparency = 1

FinalInfo.Text =
    "Tzuy Hub\n"
    .. "TLS • Full Build\n"
    .. "Parts 1-8 Loaded"

FinalInfo.TextColor3 =
    Color3.fromRGB(
        130,
        130,
        140
    )

FinalInfo.TextSize = 11
FinalInfo.Font = Enum.Font.Gotham

FinalInfo.TextXAlignment =
    Enum.TextXAlignment.Left

FinalInfo.TextYAlignment =
    Enum.TextYAlignment.Top

FinalInfo.Parent = Page

--==================================================
-- LOADED MESSAGE
--==================================================

task.delay(1, function()

    if not MasterConfig.Unloaded then

        Notification(
            "✅ Tzuy Hub Full Build Loaded"
        )

        print(
            "================================"
        )

        print(
            "       TZUY HUB • TLS"
        )

        print(
            "       FULL BUILD"
        )

        print(
            "       PART 1 - 8"
        )

        print(
            "================================"
        )

    end
end)

print(
    "Tzuy Hub Part 8 Loaded"
)
