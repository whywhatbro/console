-- The Strongest Battlegrounds - Halloween Ultimate Master Farm (Cleaned Candy List)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local camera = Workspace.CurrentCamera
local player = Players.LocalPlayer

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("TSBHalloweenUltimateMasterGui") then
    CoreGui.TSBHalloweenUltimateMasterGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSBHalloweenUltimateMasterGui"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Nút mở/đóng Menu
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

-- Khung Menu Chính
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
title.Text = "Halloween Ultimate Master Farm"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 11
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Khóa xoay màn hình khi chạm vào Menu
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

-- Trạng thái các tính năng
local settings = {
    espBoss = false,
    autoBoss = false,
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

createFeatureToggle("ESP Viền & Line Boss", 50, "espBoss")
createFeatureToggle("Auto Đánh Boss penyta", 105, "autoBoss")
createFeatureToggle("Auto Nhặt Kẹo Toàn Diện", 160, "autoCandy")
createFeatureToggle("Auto Gõ Cửa (DOOR 1 NEW)", 215, "autoDoor")

-- Tạo ESP Highlight cho Boss
local bossHighlight = Instance.new("Highlight")
bossHighlight.Name = "PenytaUltimateHighlight"
bossHighlight.FillColor = Color3.fromRGB(255, 140, 0)
bossHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
bossHighlight.FillTransparency = 0.4
bossHighlight.OutlineTransparency = 0
bossHighlight.Parent = CoreGui

-- Tạo đường Line chỉ đường
local tracerLine = Drawing.new("Line")
tracerLine.Visible = false
tracerLine.Color = Color3.fromRGB(255, 140, 0)
tracerLine.Thickness = 2
tracerLine.Transparency = 1

-- Danh sách chỉ chứa đúng các loại kẹo sự kiện (Đã loại bỏ Part và tạp chất)
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

-- Hàm tìm kiếm boss chuẩn xác
local function getBossTarget()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "penyta" then
            if obj:IsA("Model") then
                local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                if rootPart then return obj, rootPart end
            end
        elseif obj.Name == "HumanoidRootPart" and obj.Parent and obj.Parent.Name == "penyta" then
            return obj.Parent, obj
        end
    end
    return nil, nil
end

-- ================= ESP THREAD =================
RunService.RenderStepped:Connect(function()
    if not settings.espBoss then
        bossHighlight.Adornee = nil
        tracerLine.Visible = false
        return
    end
    
    local bossModel, bossPart = getBossTarget()
    if bossModel and bossPart then
        bossHighlight.Adornee = bossModel
        local vector, onScreen = camera:WorldToViewportPoint(bossPart.Position)
        if onScreen then
            tracerLine.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
            tracerLine.To = Vector2.new(vector.X, vector.Y)
            tracerLine.Visible = true
        else
            tracerLine.Visible = false
        end
    else
        bossHighlight.Adornee = nil
        tracerLine.Visible = false
    end
end)

-- ================= AUTO FARM THREAD =================
task.spawn(function()
    while true do
        task.wait(0.1)
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            
            -- 1. Auto Đánh Boss
            if settings.autoBoss then
                local bossModel, bossPart = getBossTarget()
                if bossModel and bossPart then
                    hrp.CFrame = bossPart.CFrame * CFrame.new(0, 0, 3)
                    pcall(function()
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        task.wait(0.02)
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    end)
                    continue
                end
            end
            
            -- 2. Auto Nhặt Kẹo Toàn Diện
            if settings.autoCandy then
                local foundItem = false
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and validCandies[obj.Name] and obj.Position.Y > -10 then
                        hrp.CFrame = obj.CFrame + Vector3.new(0, 2, 0)
                        foundItem = true
                        task.wait(0.1)
                        break
                    end
                end
                if foundItem then continue end
            end
            
            -- 3. Auto Gõ Cửa
            if settings.autoDoor then
                local foundDoor = false
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "DOOR 1 NEW" then
                        local targetPart = obj:FindFirstChild("Right Door") or obj:FindFirstChild("RightDoor") or obj:FindFirstChild("Left Door") or obj:FindFirstChildOfClass("BasePart")
                        if targetPart then
                            hrp.CFrame = targetPart.CFrame * CFrame.new(0, 0, 2)
                            for _, prompt in pairs(obj:GetDescendants()) do
                                if prompt:IsA("ProximityPrompt") then
                                    pcall(function()
                                        fireproximityprompt(prompt)
                                        prompt.HoldDuration = 0
                                    end)
                                end
                            end
                            foundDoor = true
                            task.wait(1.5)
                            break
                        end
                    end
                end
                if foundDoor then continue end
            end
        end
    end
end)

print("Halloween Ultimate Master Script (Cleaned) đã sẵn sàng!")
