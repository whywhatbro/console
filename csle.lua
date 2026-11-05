-- The Strongest Battlegrounds - CANDY BETA Farm (With Penyta Boss Teleport & Notification)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

if CoreGui:FindFirstChild("TSBCandyBetaGui") then
    CoreGui.TSBCandyBetaGui:Destroy()
end

-- Anti-AFK
player.Idled:Connect(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSBCandyBetaGui"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 150)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
toggleBtn.Text = "🍬"
toggleBtn.TextSize = 26
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Parent = screenGui

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(1, 0)
cornerBtn.Parent = toggleBtn

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 315)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -157)
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
title.Text = "CANDY BETA"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
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
    autoDoor = false,
    autoBoss = false
}

local function createFeatureToggle(name, posY, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name .. ": [OFF]"
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
            btn.Text = name .. ": [ON]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
            btn.Text = name .. ": [OFF]"
        end
    end)
end

createFeatureToggle("CANDY FARM", 50, "autoCandy")
createFeatureToggle("AUTOMATIC DOOR", 105, "autoDoor")
createFeatureToggle("PENGUIN BOSS TELEPORT", 160, "autoBoss")

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
local bossNotified = false

local function getBossTarget()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "penyta" and obj:IsA("Model") then
            local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
            if root then return obj, root end
        end
    end
    return nil, nil
end

RunService.Stepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end
    end
    
    -- Hệ thống thông báo khi Boss Penyta xuất hiện
    local bossModel, bossPart = getBossTarget()
    if bossModel and bossPart then
        if not bossNotified then
            bossNotified = true
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "CANDY BETA",
                    Text = "Boss Penyta (Bí Ngô) đã xuất hiện!",
                    Duration = 5
                })
            end)
        end
    else
        bossNotified = false
    end
end)

task.spawn(function()
    while true do
        task.wait(0.03)
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            
            -- PENGUIN BOSS TELEPORT (Ưu tiên số 1 khi bật)
            if settings.autoBoss then
                local bossModel, bossPart = getBossTarget()
                if bossModel and bossPart then
                    hrp.CFrame = bossPart.CFrame * CFrame.new(0, 0, 3)
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        task.wait(0.02)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    end)
                    continue
                end
            end
            
            -- CANDY FARM
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
                    hrp.CFrame = CFrame.new(bestCandyCenter.Position + Vector3.new(0, 2.5, 0), hrp.Position + hrp.CFrame.LookVector)
                    task.wait(0.02)
                    continue
                end
            end
            
            -- AUTOMATIC DOOR
            if settings.autoDoor then
                local foundDoor = false
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "DOOR 1 NEW" and not openedDoors[obj] then
                        local promptList = {}
                        for _, p in pairs(obj:GetDescendants()) do
                            if p:IsA("ProximityPrompt") then
                                table.insert(promptList, p)
                            end
                        end
                        
                        if #promptList == 0 or not obj.Parent then
                            openedDoors[obj] = true
                        else
                            local targetPart = obj:FindFirstChild("Right Door") or obj:FindFirstChild("RightDoor") or obj:FindFirstChild("Left Door") or obj:FindFirstChildOfClass("BasePart")
                            if targetPart then
                                hrp.CFrame = targetPart.CFrame * CFrame.new(0, 0, 3)
                                
                                for i = 1, 8 do
                                    pcall(function()
                                        for _, prompt in ipairs(promptList) do
                                            prompt.MaxActivationDistance = 999999
                                            prompt.HoldDuration = 0
                                            fireproximityprompt(prompt)
                                        end
                                    end)
                                    task.wait(0.01)
                                end
                                
                                local stillHasPrompt = false
                                for _, p in pairs(obj:GetDescendants()) do
                                    if p:IsA("ProximityPrompt") then
                                        stillHasPrompt = true
                                        break
                                    end
                                end
                                
                                if not stillHasPrompt then
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

print("CANDY BETA (With Boss Features) Loaded Successfully!")
