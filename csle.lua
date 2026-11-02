print("VR TEST START")

local p = game:GetService("Players").LocalPlayer
local c = p.Character

if not c then
    warn("CHARACTER NOT FOUND")
else
    print("CHARACTER FOUND")

    local count = 0

    for _, v in ipairs(c:GetDescendants()) do
        if v:IsA("Motor6D") then
            count += 1
            print("JOINT:", v.Name)
        end
    end

    print("TOTAL JOINTS:", count)
end
