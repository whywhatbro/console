-- TSB CANDY BETA - Guaranteed UI Render & Mobile Skill Fix
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Xóa bản cũ nếu tồn tại
if playerGui:FindFirstChild("TSBCandyBetaGui") then
    playerGui.TSBCandyBetaGui:Destroy()
end

-- 1. KHỞI TẠO GIAO DIỆN NGAY LẬP TỨC VÀO PLAYERGUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSBCandyBetaGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.Parent = playerGui

-- Thanh trạng thái PUMPKIN phía trên thanh nộ
local statusContainer = Instance.new("Frame")
statusContainer.Size = UDim2.new(0, 110, 0, 22)
statusContainer.Position = UDim2.new(0.5, -55, 1, -145)
statusContainer.BackgroundTransparency = 1
statusContainer.Parent = screenGui

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 0, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
statusDot.Parent = statusContainer
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -14, 1, 0)
statusText.Position = UDim2.new(0, 14, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "PUMPKIN"
statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
statusText.TextSize = 12
statusText.Font = Enum.Font.SourceSansBold
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusContainer

-- Nút bật/tắt menu hình viên kẹo
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 150)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
toggleBtn.Text = "🍬"
toggleBtn.TextSize = 26
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.ZIndex = 10
toggleBtn.Parent = screenGui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

-- Khung menu chính (Mở sẵn)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 275)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -137)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = true
mainFrame.ZIndex = 5
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "CANDY BETA"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.Font = Enum.Font.SourceSansBold
title.ZIndex = 6
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

-- Kéo thả khung menu trên Mobile
local dragging, dragInput, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- 2. CÁC NÚT CHỨC NĂNG
local settings = { autoCandy = false, autoDoor = false, autoBossCombat = false }

local function createFeatureToggle(name, posY, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name .. ": [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.ZIndex = 6
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        settings[key] = not settings[key]
        btn.BackgroundColor3 = settings[key] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
        btn.TextColor3 = settings[key] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 100, 100)
        btn.Text = name .. (settings[key] and ": [ON]" or ": [OFF]")
    end)
end

createFeatureToggle("CANDY FARM", 45, "autoCandy")
createFeatureToggle("AUTOMATIC DOOR", 90, "autoDoor")

local teleBossBtn = Instance.new("TextButton")
teleBossBtn.Size = UDim2.new(1, -20, 0, 40)
teleBossBtn.Position = UDim2.new(0, 10, 0, 135)
teleBossBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
teleBossBtn.Text = "TELEPORT TO PUMPKIN"
teleBossBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleBossBtn.TextSize = 12
teleBossBtn.Font = Enum.Font.SourceSansBold
teleBossBtn.ZIndex = 6
teleBossBtn.Parent = mainFrame
Instance.new("UICorner", teleBossBtn).CornerRadius = UDim.new(0, 8)

createFeatureToggle("AUTO PUMPKIN COMBAT", 180, "autoBossCombat")

local dropToggleBtn = Instance.new("TextButton")
dropToggleBtn.Size = UDim2.new(1, -20, 0, 35)
dropToggleBtn.Position = UDim2.new(0, 10, 0, 225)
dropToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropToggleBtn.Text = "▼ Select Combat Skills Order"
dropToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dropToggleBtn.TextSize = 11
dropToggleBtn.Font = Enum.Font.SourceSansBold
dropToggleBtn.ZIndex = 6
dropToggleBtn.Parent = mainFrame
Instance.new("UICorner", dropToggleBtn).CornerRadius = UDim.new(0, 8)

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, 100)
dropdownFrame.Position = UDim2.new(0, 10, 0, 265)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropdownFrame.Visible = false
dropdownFrame.ZIndex = 6
dropdownFrame.Parent = mainFrame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 8)

local skillListOpen = false
dropToggleBtn.MouseButton1Click:Connect(function()
    skillListOpen = not skillListOpen
    dropdownFrame.Visible = skillListOpen
    mainFrame.Size = skillListOpen and UDim2.new(0, 280, 0, 375) or UDim2.new(0, 280, 0, 275)
    dropToggleBtn.Text = (skillListOpen and "▲ " or "▼ ") .. "Select Combat Skills Order"
end)

local skillOrder = {"1", "2", "3", "4"}
local availableSkills = {"1", "2", "3", "4"}

for i = 1, 4 do
    local sBtn = Instance.new("TextButton")
    sBtn.Size = UDim2.new(1, -10, 0, 20)
    sBtn.Position = UDim2.new(0, 5, 0, 5 + (i - 1) * 23)
    sBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    sBtn.Text = "Skill Slot " .. i .. " : [" .. skillOrder[i] .. "]"
    sBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sBtn.TextSize = 10
    sBtn.Font = Enum.Font.SourceSansBold
    sBtn.ZIndex = 7
    sBtn.Parent = dropdownFrame
    Instance.new("UICorner", sBtn).CornerRadius = UDim.new(0, 4)
    
    sBtn.MouseButton1Click:Connect(function()
        for idx, val in ipairs(availableSkills) do
            if val == skillOrder[i] then
                skillOrder[i] = availableSkills[idx % #availableSkills + 1]
                break
            end
        end
        sBtn.Text = "Skill Slot " .. i .. " : [" .. skillOrder[i] .. "]"
    end)
end

mainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    if not mainFrame.Visible then
        skillListOpen = false
        dropdownFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 280, 0, 275)
        dropToggleBtn.Text = "▼ Select Combat Skills Order"
    end
end)

-- 3. LOGIC XỬ LÝ GAME & KÍCH HOẠT SKILL MOBILE
local validCandies = {
    ["DarkOrangeCandy1"] = true, ["DarkOrangeCandy2"] = true,
    ["DarkOrangeCandy3"] = true, ["DarkOrangeCandy4"] = true,
    ["OrangeCandy1"] = true, ["OrangeCandy2"] = true,
    ["OrangeCandy3"] = true, ["OrangeCandy4"] = true,
    ["MrBloxBar"] = true, ["BloxRoll"] = true,
    ["Chocoblox"] = true, ["BloxyDrops"] = true
}
local openedDoors = {}

local function getBossTarget()
    local live = Workspace:FindFirstChild("Live")
    local penyta = live and live:FindFirstChild("Penyta")
    local hrp = penyta and penyta:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:IsA("BasePart") then return penyta, hrp end
    return nil, nil
end

local function fireGuiButton(guiObj)
    if firesignal then
        pcall(function() firesignal(guiObj.TouchTap) end)
        pcall(function() firesignal(guiObj.MouseButton1Down) end)
        pcall(function() firesignal(guiObj.Activated) end)
        pcall(function() firesignal(guiObj.MouseButton1Click) end)
        pcall(function() firesignal(guiObj.MouseButton1Up) end)
    else
        local pos, size = guiObj.AbsolutePosition, guiObj.AbsoluteSize
        local cx, cy = pos.X + size.X / 2, pos.Y + size.Y / 2
        VirtualInputManager:SendTouchEvent(1, 0, cx, cy)
        task.wait(0.01)
        VirtualInputManager:SendTouchEvent(1, 2, cx, cy)
    end
end

local function triggerMobileM1()
    pcall(function()
        for _, guiObj in pairs(playerGui:GetDescendants()) do
            if guiObj:IsA("GuiButton") and guiObj.Visible and guiObj.Parent ~= screenGui then
                local gName = string.lower(guiObj.Name)
                local pName = guiObj.Parent and string.lower(guiObj.Parent.Name) or ""
                if gName == "punch" or gName == "m1" or gName == "attack" or pName == "punch" or gName:find("punch") then
                    fireGuiButton(guiObj)
                    return
                end
            end
        end
    end)
end

local function triggerMobileSkill(slotStr)
    pcall(function()
        local hotbar = playerGui:FindFirstChild("Hotbar")
        local backpack = hotbar and hotbar:FindFirstChild("Backpack")
        local innerHotbar = backpack and backpack:FindFirstChild("Hotbar")
        local slotFrame = innerHotbar and innerHotbar:FindFirstChild(slotStr)
        if slotFrame then
            local btn = slotFrame:FindFirstChild("Base") or slotFrame:FindFirstChildOfClass("ImageButton") or slotFrame:FindFirstChildOfClass("TextButton")
            if btn and btn:IsA("GuiButton") then
                fireGuiButton(btn)
                return
            end
        end
        
        local screenHeight = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize.Y or 800
        for _, guiObj in pairs(playerGui:GetDescendants()) do
            if guiObj:IsA("GuiButton") and guiObj.Visible and not guiObj:IsDescendantOf(screenGui) and guiObj.AbsolutePosition.Y > (screenHeight * 0.6) then
                local gName = guiObj.Name
                local pName = guiObj.Parent and guiObj.Parent.Name or ""
                if gName == slotStr or pName == slotStr or (gName == "Base" and pName == slotStr) then
                    fireGuiButton(guiObj)
                    return
                end
            end
        end
    end)
end

teleBossBtn.MouseButton1Click:Connect(function()
    local _, bossPart = getBossTarget()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and bossPart then
        char.HumanoidRootPart.CFrame = bossPart.CFrame
    end
end)

RunService.Stepped:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand = false
        hum.Sit = false
    end
    local bossModel, bossPart = getBossTarget()
    statusDot.BackgroundColor3 = (bossModel and bossPart) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(120, 120, 120)
end)

task.spawn(function()
    local currentSkillIndex = 1
    local actionDelay = 0
    while true do
        task.wait(0.03)
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if settings.autoBossCombat then
                local bossModel, bossPart = getBossTarget()
                if bossModel and bossPart then
                    hrp.CFrame = bossPart.CFrame
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    triggerMobileM1()
                    actionDelay = actionDelay + 1
                    if actionDelay >= 18 then
                        actionDelay = 0
                        triggerMobileSkill(skillOrder[currentSkillIndex])
                        currentSkillIndex = currentSkillIndex % #skillOrder + 1
                    end
                    continue
                end
            end
            
            if settings.autoCandy then
                local bestCandyCenter, maxCandiesInCluster, allCandies = nil, 0, {}
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and validCandies[obj.Name] and obj.Position.Y > -10 then
                        local pos = obj.Position
                        if not (pos.X > 500 and pos.X < 800 and pos.Z > -200 and pos.Z < 100) then
                            table.insert(allCandies, obj)
                        end
                    end
                end
                for _, candy in ipairs(allCandies) do
                    local count = 0
                    for _, other in ipairs(allCandies) do
                        if (candy.Position - other.Position).Magnitude <= 30 then count = count + 1 end
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
                        if dist < minDist then minDist = dist; bestCandyCenter = candy end
                    end
                end
                if bestCandyCenter then
                    hrp.CFrame = CFrame.new(bestCandyCenter.Position + Vector3.new(0, 2.5, 0), hrp.Position + hrp.CFrame.LookVector)
                    task.wait(0.02)
                    continue
                end
            end
            
            if settings.autoDoor then
                local foundDoor = false
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "DOOR 1 NEW" and not openedDoors[obj] then
                        local promptList = {}
                        for _, p in pairs(obj:GetDescendants()) do
                            if p:IsA("ProximityPrompt") then table.insert(promptList, p) end
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
                                    if p:IsA("ProximityPrompt") then stillHasPrompt = true; break end
                                end
                                if not stillHasPrompt then openedDoors[obj] = true end
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
