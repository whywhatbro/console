-- The Strongest Battlegrounds - Advanced Object & Candy Inspector
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

if CoreGui:FindFirstChild("TSBAdvancedInspector") then
    CoreGui.TSBAdvancedInspector:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSBAdvancedInspector"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Nút mở Inspector nâng cao
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 320)
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
toggleBtn.Text = "🔬"
toggleBtn.TextSize = 24
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Parent = screenGui

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(1, 0)
cornerBtn.Parent = toggleBtn

local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(0, 340, 0, 220)
infoFrame.Position = UDim2.new(0.5, -170, 0.5, -110)
infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
infoFrame.Visible = false
infoFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = mainFrame or infoFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Advanced Candy & Object Inspector"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 12
title.Parent = infoFrame

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -20, 1, -85)
infoText.Position = UDim2.new(0, 10, 0, 35)
infoText.BackgroundTransparency = 1
infoText.Text = "Đứng gần viên kẹo rồi bấm nút 'Quét Vật Thể Gần Nhất' bên dưới."
infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
infoText.TextSize = 11
infoText.TextWrapped = true
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Parent = infoFrame

-- Nút thực hiện quét bán kính quanh người chơi
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, -20, 0, 35)
scanBtn.Position = UDim2.new(0, 10, 1, -75)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
scanBtn.Text = "Quét Vật Thể Xung Quanh (Bán kính 15 studs)"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextSize = 11
scanBtn.Parent = infoFrame

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(1, -20, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 1, -35)
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
copyBtn.Text = "Copy Tên Vật Thể Tìm Được"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.TextSize = 11
copyBtn.Parent = infoFrame

local isOpen = false
toggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    infoFrame.Visible = isOpen
end)

local foundTargetName = ""

scanBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    local closestObj = nil
    local shortestDist = 15 -- Bán kính quét 15 studs quanh bạn
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj ~= hrp then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist <= shortestDist then
                -- Lọc bỏ nhân vật người chơi để tập trung vào kẹo/vật phẩm rớt
                local isPlayerPart = false
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and obj:IsDescendantOf(p.Character) then
                        isPlayerPart = true
                        break
                    end
                end
                
                if not isPlayerPart and obj.Name ~= "Terrain" then
                    shortestDist = dist
                    closestObj = obj
                end
            end
        end
    end
    
    if closestObj then
        foundTargetName = closestObj.Name
        local parentName = closestObj.Parent and closestObj.Parent.Name or "None"
        local className = closestObj.ClassName
        
        infoText.Text = "Đã tìm thấy vật thể gần nhất:\n" ..
                        "- Tên (Name): " .. foundTargetName .. "\n" ..
                        "- Parent: " .. parentName .. "\n" ..
                        "- Loại (Class): " .. className .. "\n" ..
                        "- Khoảng cách: " .. math.floor(shortestDist) .. " studs"
    else
        infoText.Text = "Không tìm thấy vật thể nào trong bán kính 15 studs!"
    end
end)

copyBtn.MouseButton1Click:Connect(function()
    if foundTargetName ~= "" then
        pcall(function()
            setclipboard(foundTargetName)
        end)
        copyBtn.Text = "Đã Copy: " .. foundTargetName
        task.wait(1.5)
        copyBtn.Text = "Copy Tên Vật Thể Tìm Được"
    end
end)

print("Advanced Inspector đã sẵn sàng!")
