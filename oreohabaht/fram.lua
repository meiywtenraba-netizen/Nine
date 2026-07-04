-- [[ 4King Mahanakhon - Farm Helper Script ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ปรับแต่งความเร็วตรงนี้ได้ตามต้องการ (หากวิ่งเร็วเกินไปแล้วเด้ง ให้ปรับลดตัวเลือกลงมาครับ)
local TargetSpeed = 32   -- ความเร็วปกติของเกมจะอยู่ที่ 16
local TargetJump = 60    -- ระยะกระโดดปกติจะอยู่ที่ 50

local function applyPhysics(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- ตั้งค่าความเร็วและการกระโดด
    humanoid.WalkSpeed = TargetSpeed
    humanoid.JumpPower = TargetJump
    
    -- ลูปเช็กเพื่อป้องกันไม่ให้ระบบของเกมรีเซ็ตค่ากลับเป็นความเร็วปกติ
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if humanoid.WalkSpeed ~= TargetSpeed then
            humanoid.WalkSpeed = TargetSpeed
        end
    end)
    
    humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if humanoid.JumpPower ~= TargetJump then
            humanoid.JumpPower = TargetJump
        end
    end)
end

-- ทำงานทันทีเมื่อตัวละครเกิด
if LocalPlayer.Character then
    applyPhysics(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(character)
    applyPhysics(character)
end)

print("Farm Helper Loaded! Speed and Jump boosted.")
