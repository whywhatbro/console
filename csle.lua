-- The Strongest Battlegrounds - Halloween Master Farm (Optimized & Stealth)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local camera = Workspace.CurrentCamera
local player = Players.LocalPlayer

if CoreGui:FindFirstChild("TSBHalloweenOptimizedGui") then
    CoreGui.TSBHalloweenOptimizedGui:Destroy()
end

-- Chống AFK
player.Idled:Connect(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSBHalloweenOptimizedGui"
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
mainFrame.Size = UDim2.new(0, 280, 0, 310)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -155)
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
title.Text = "Halloween Optimized Farm"
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
            btn.Text = name .. ": [BẬT]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
            btn.Text = name .. ": [TẮT]"
        end
    end)
end

createFeatureToggle("Auto Nhặt Kẹo (Ưu Tiên)", 50, "autoCandy")
createFeatureToggle("Auto Gõ Cửa (Thông Minh)", 105, "autoDoor")

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

-- Lưu trữ danh sách cửa đã mở/hoàn thành để không lặp lại
local openedDoors = {}

task.spawn(function()
    while true do
        task.wait(0.05) -- Tốc độ quét cực nhanh
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            
            -- Ép nhân vật chìm xuống dưới đất (Stealth / Ẩn thân tránh bị phát hiện)
            pcall(function()
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
            
            -- 1. ƯU TIÊN SỐ 1: Auto Nhặt Kẹo (Tìm kẹo gần nhất, nằm trong map, loại bỏ khu vực cấm như rạp xiếc)
            local targetCandy = nil
            local shortestDist = math.huge
            
            if settings.autoCandy then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and validCandies[obj.Name] and obj.Position.Y > -10 then
                        -- Kiểm tra loại bỏ khu vực rạp xiếc hoặc vùng bị cấm bay vào
                        local pos = obj.Position
                        local isForbiddenArea = (pos.X > 500 and pos.X < 800 and pos.Z > -200 and pos.Z < 100) -- Vùng ví dụ của rạp xiếc
                        
                        if not isForbiddenArea then
                            local dist = (pos - hrp.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                targetCandy = obj
                            end
                        end
                    end
                end
                
                if targetCandy then
                    hrp.CFrame = targetCandy.CFrame + Vector3.new(0, -3, 0) -- Teleport chìm dưới đất sát kẹo
                    task.wait(0.02)
                    continue -- Bỏ qua các việc khác để tập trung hốt sạch kẹo gần nhất ngay lập tức
                end
            end
            
            -- 2. ƯU TIÊN SỐ 2: Auto Gõ Cửa (Chỉ gõ cửa chưa mở, tự động bỏ qua khi đã hoàn thành)
            if settings.autoDoor then
                local foundDoor = false
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "DOOR 1 NEW" and not openedDoors[obj] then
                        -- Kiểm tra xem cửa còn prompt hoặc chưa bị biến mất/chìm xuống đất
                        local prompt = nil
                        for _, p in pairs(obj:GetDescendants()) do
                            if p:IsA("ProximityPrompt") then
                                prompt = p
                                break
                            end
                        end
                        
                        -- Nếu không còn prompt hoặc cửa đã mở/biến mất thì đánh dấu bỏ qua luôn
                        if not prompt or not obj.Parent then
                            openedDoors[obj] = true
                        else
                            local targetPart = obj:FindFirstChild("Right Door") or obj:FindFirstChild("RightDoor") or obj:FindFirstChild("Left Door") or obj:FindFirstChildOfClass("BasePart")
                            if targetPart then
                                hrp.CFrame = targetPart.CFrame * CFrame.new(0, -3, 2) -- Đứng dưới đất sát cửa
                                pcall(function()
                                    prompt.MaxActivationDistance = 999999
                                    prompt.HoldDuration = 0
                                    fireproximityprompt(prompt)
                                end)
                                
                                -- Nếu sau một nhịp kiểm tra thấy prompt biến mất thì đánh dấu cửa này đã xong
                                task.wait(0.3)
                                if not prompt.Parent then
                                    openedDoors[obj] = true
                                end
                                
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

print("Halloween Optimized Master Script đã hoạt động hoàn hảo!")
