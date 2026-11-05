-- The Strongest Battlegrounds - Halloween Ultimate Tween & Stealth Farm
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

if CoreGui:FindFirstChild("TSBHalloweenTweenMasterGui") then
    CoreGui.TSBHalloweenTweenMasterGui:Destroy()
end

-- Chống AFK
player.Idled:Connect(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSBHalloweenTweenMasterGui"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 150)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
toggleBtn.Text = "🎃"
toggleBtn.TextSize = 26
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Parent = screenGui

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(1, 0)
cornerBtn.Parent = toggleBtn

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 260)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = false
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "Halloween Tween Master Farm"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 11
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

local isInteracting = false
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isInteracting = true
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isInteracting = false
    end
end)

RunService.RenderStepped:Connect(function()
    if isInteracting and mainFrame.Visible then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local settings = {
    autoCandy = false,
    autoDoor = false
}

local function createFeatureToggle(name, posY, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name .. ": [TẮT]"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        settings[key] = not settings[key]
        if settings[key] then
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = name .. "[BẬT]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
            btn.Text = name .. "[TẮT]"
        end
    end)
end

createFeatureToggle("Auto Nhặt Kẹo (Tween Nằm Ngửa)", 50, "autoCandy")
createFeatureToggle("Auto Gõ Cửa (Tween Vào Gốc Cây)", 105, "autoDoor")

local validCandies = {
    ["DarkOrangeCandy1"] = true,
    ["DarkOrangeCandy2"] = true,
    ["DarkOrangeCandy3"] = true,
    ["DarkOrangeCandy4"] = true,
    ["OrangeCandy1"] = true,
    ["OrangeCandy2"] = true,
    ["OrangeCandy3"] = true,
    ["OrangeCandy4"] = true,
    ["MrBloxBar"] = true,
    ["BloxRoll"] = true,
    ["Chocoblox"] = true,
    ["BloxyDrops"] = true
}

local openedDoors = {}
local isTweening = false

-- Cố định trạng thái noclip vĩnh viễn và đóng băng trọng lực để cơ thể không bị rơi
RunService.Stepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.05)
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and not isTweening then
            local hrp = char.HumanoidRootPart
            
            -- 1. AUTO NHẶT KẸO (Tween lướt cực nhanh, chìm dưới đất, nằm ngửa mặt lên trời nhặt cụm đông nhất)
            if settings.autoCandy then
                local bestCandyCenter = nil
                local maxCandiesInCluster = 0
                local allCandies = {}
                
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and validCandies[obj.Name] and obj.Position.Y > -10 then
                        local pos = obj.Position
                        local isForbiddenArea = (pos.X > 500 and pos.X < 800 and pos.Z > -200 and pos.Z < 100)
                        if not isForbiddenArea then
                            table.insert(allCandies, obj)
                        end
                    end
                end
                
                for _, candy in ipairs(allCandies) do
                    local count = 0
                    for _, other in ipairs(allCandies) do
                        if (candy.Position - other.Position).Magnitude <= 30 then
                            count = count + 1
                        end
                    end
                    if count > maxCandiesInCluster then
                        maxCandiesInCluster = count
                        bestCandyCenter = candy
                    end
                end
                
                if not bestCandyCenter and #allCandies > 0 then
                    local minDist = math.huge
                    for _, candy in ipairs(allCandies) do
                        local dist = (candy.Position - hrp.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            bestCandyCenter = candy
                        end
                    end
                end
                
                if bestCandyCenter then
                    isTweening = true
                    -- Vị đích: Chìm xuống dưới viên kẹo 2 studs, xoay nằm ngửa mặt lên trời (trục X -90 độ)
                    local targetCFrame = bestCandyCenter.CFrame * CFrame.new(0, -2, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    local distance = (hrp.Position - bestCandyCenter.Position).Magnitude
                    -- Tốc độ cực cao (tính theo thời gian tween ngắn dần theo khoảng cách, gần như dịch chuyển)
                    local tweenSpeed = math.clamp(distance / 450, 0.05, 0.25)
                    
                    local tweenInfo = TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
                    tween:Play()
                    
                    tween.Completed:Wait()
                    isTweening = false
                    continue
                end
            end
            
            -- 2. AUTO GÕ CỬA (Tween lướt mượt vào chính giữa đằng sau cánh cửa/gốc cây, đứng thẳng lên và mở tức thì)
            if settings.autoDoor then
                local foundDoor = false
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "DOOR 1 NEW" and not openedDoors[obj] then
                        local prompt = nil
                        for _, p in pairs(obj:GetDescendants()) do
                            if p:IsA("ProximityPrompt") then
                                prompt = p
                                break
                            end
                        end
                        
                        if not prompt or not obj.Parent then
                            openedDoors[obj] = true
                        else
                            local targetPart = obj:FindFirstChild("Right Door") or obj:FindFirstChild("RightDoor") or obj:FindFirstChild("Left Door") or obj:FindFirstChildOfClass("BasePart")
                            if targetPart then
                                isTweening = true
                                -- Vị trí đích: Đứng thẳng tự nhiên ở chính giữa phía sau gốc cây/cánh cửa (trục Z âm), tàng hình tuyệt đối
                                local targetCFrame = targetPart.CFrame * CFrame.new(0, 0, -3.5)
                                local distance = (hrp.Position - targetPart.Position).Magnitude
                                local tweenSpeed = math.clamp(distance / 450, 0.08, 0.3)
                                
                                local tweenInfo = TweenInfo.new(tweenSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
                                tween:Play()
                                
                                tween.Completed:Wait()
                                
                                -- Kích hoạt mở cửa siêu tốc tức thì bất chấp mọi giới hạn khoảng cách hay góc nhìn
                                pcall(function()
                                    if prompt then
                                        prompt.MaxActivationDistance = 999999
                                        prompt.HoldDuration = 0
                                        fireproximityprompt(prompt)
                                        fireproximityprompt(prompt)
                                    end
                                end)
                                
                                task.wait(0.2)
                                if prompt and not prompt.Parent then
                                    openedDoors[obj] = true
                                end
                                
                                isTweening = false
                                foundDoor = true
                                break
                            end
                        end
                    end
                end
                if foundDoor then continue end
            end
        end
    end
end)

print("Halloween Tween Master Farm đã khởi chạy hoàn hảo!")
