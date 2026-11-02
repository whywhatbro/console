local p = game:GetService("Players").LocalPlayer
local c = p.Character
local t = c and c:FindFirstChild("UpperTorso")

print("Character:", c and c.Name)
print("Humanoid:", c and c:FindFirstChildOfClass("Humanoid") and c:FindFirstChildOfClass("Humanoid").RigType)
print("UpperTorso:", t)

if t then
    for _, v in ipairs(t:GetChildren()) do
        if v:IsA("Motor6D") then
            print("Joint:", v.Name, "Part0:", v.Part0, "Part1:", v.Part1)
        end
    end
end
