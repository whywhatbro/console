local p = game:GetService("Players").LocalPlayer
local c = p.Character

for _, v in ipairs(c:GetDescendants()) do
    if v:IsA("Motor6D") then
        print(
            "JOINT:", v.Name,
            "| PART0:", v.Part0 and v.Part0.Name,
            "| PART1:", v.Part1 and v.Part1.Name
        )
    end
end
