-- The Strongest Battlegrounds - Halloween Event Auto Farm (Candy, Trees & Pumpkin Boss)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("TSBHalloweenGui") then
    CoreGui.TSBHalloweenGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSBHalloweenGui"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Nút nổi mở menu Auto Farm
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 200)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
toggleBtn.Text = "🎃"
toggleBtn.TextSize = 24
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Parent = screenGui

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(1, 0)
cornerBtn.Parent = toggleBtn

-- Bảng menu chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 230)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -115)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local cornerFrame = Instance.new("UICorner")
cornerFrame.CornerRadius = UDim.new(0, 10)
cornerFrame.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Halloween Event Auto Farm"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.Parent = mainFrame

-- Biến trạng thái tính năng
local autoCandy = false
local autoTree = false
local autoBoss = false

-- Hàm tạo nút bật/tắt chức năng
local function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name .. ": [TẮT]"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.TextSize = 12
    btn.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = name .. ": [BẬT]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
            btn.Text = name .. ": [TẮT]"
        end
        callback(state)
    end)
end

createToggle("Auto Nhặt Kẹo", 45, function(val) autoCandy = val end)
createToggle("Auto Gõ Cửa Cây", 95, function(val) autoTree = val end)
createToggle("Auto Đánh Boss Bí Ngô", 145, function(val) autoBoss = val end)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Vòng lặp xử lý Auto Farm chính
RunService.Stepped:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    -- 1. Auto Nhặt Kẹo
    if autoCandy then
        for _, obj in pairs(Workspace:GetDescendants()) do
            -- Tìm các vật phẩm kẹo rơi trên map (thường có tên chứa từ khóa Candy hoặc nằm trong thư mục event)
            if obj:IsA("BasePart") and (string.find(string.lower(obj.Name), "candy") or string.find(string.lower(obj.Name), "sweet")) then
                hrp.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.2)
                break
            end
        end
    end
    
    -- 2. Auto Gõ Cửa Gốc Cây
    if autoTree then
        for _, obj in pairs(Workspace:GetDescendants()) do
            -- Tìm các phần cửa hoặc gốc cây tương tác được
            if obj:IsA("Model") or obj:IsA("BasePart") then
                if string.find(string.lower(obj.Name), "tree") or string.find(string.lower(obj.Name), "door") or string.find(string.lower(obj.Name), "trunk") then
                    local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        hrp.CFrame = obj:GetPivot() + Vector3.new(0, 3, 0)
                        fireproximityprompt(prompt)
                        task.wait(1)
                        break
                    end
                end
            end
        end
    end
    
    -- 3. Auto Đánh Boss Quái Bí Ngô
    if autoBoss then
        for _, model in pairs(Workspace:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChild("Humanoid") then
                local h = model.Humanoid
                -- Nhận diện quái boss đầu bí ngô (thường có tên hoặc phần đầu liên quan đến Pumpkin)
                if model.Name ~= player.Name and (string.find(string.lower(model.Name), "pumpkin") or string.find(string.lower(model.Name), "boss") or string.find(string.lower(model.Name), "headless")) then
                    if h.Health > 0 and model:FindFirstChild("HumanoidRootPart") then
                        hrp.CFrame = model.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        -- Giả lập hành động tấn công M1 liên tục vào boss
                        pcall(function()
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            task.wait(0.1)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        end)
                    end
                end
            end
        end
    end
end)

print("TSB Halloween Auto Farm đã được kích hoạt!")
