-- The Strongest Battlegrounds - Object & NPC Name Inspector
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("TSBInspectorGui") then
    CoreGui.TSBInspectorGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSBInspectorGui"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Nút Bật/Tắt Inspector
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 260)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
toggleBtn.Text = "🔍"
toggleBtn.TextSize = 24
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Parent = screenGui

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(1, 0)
cornerBtn.Parent = toggleBtn

-- Bảng hiển thị thông tin chi tiết
local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(0, 320, 0, 180)
infoFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
infoFrame.Visible = false
infoFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = infoFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Object / NPC Inspector"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.Parent = infoFrame

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -20, 1, -80)
infoText.Position = UDim2.new(0, 10, 0, 35)
infoText.BackgroundTransparency = 1
infoText.Text = "Chưa chọn đối tượng nào.\nHãy bật tính năng và chạm vào NPC/Vật thể."
infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
infoText.TextSize = 12
infoText.TextWrapped = true
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Parent = infoFrame

-- Nút copy tên nhanh
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(1, -20, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 1, -40)
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
copyBtn.Text = "Copy Tên / Đường Dẫn"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.TextSize = 12
copyBtn.Parent = infoFrame

local isInspectorActive = false

toggleBtn.MouseButton1Click:Connect(function()
    isInspectorActive = not isInspectorActive
    infoFrame.Visible = isInspectorActive
    if isInspectorActive then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        toggleBtn.Text = "❌"
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
        toggleBtn.Text = "🔍"
    end
end)

local selectedTargetName = ""

-- Sự kiện bắt khi bấm vào màn hình / vật thể
UserInputService.InputBegan:Connect(function(input)
    if not isInspectorActive then return end
    
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local target = mouse.Target
        if target then
            selectedTargetName = target.Name
            local parentName = target.Parent and target.Parent.Name or "None"
            local className = target.ClassName
            local distance = math.floor((target.Position - player.Character.HumanoidRootPart.Position).Magnitude)
            
            infoText.Text = "Tên (Name): " .. selectedTargetName .. 
                            "\nParent: " .. parentName .. 
                            "\nLoại (Class): " .. className .. 
                            "\nKhoảng cách: " .. distance .. " studs"
        else
            infoText.Text = "Không tìm thấy vật thể nào ở vị trí này!"
        end
    end
end)

-- Nút copy vào bộ nhớ tạm (nếu executor hỗ trợ setclipboard)
copyBtn.MouseButton1Click:Connect(function()
    if selectedTargetName ~= "" then
        pcall(function()
            setclipboard(selectedTargetName)
        end)
        copyBtn.Text = "Đã Copy: " .. selectedTargetName
        task.wait(1.5)
        copyBtn.Text = "Copy Tên / Đường Dẫn"
    end
end)

print("TSB Inspector đã khởi động!")
