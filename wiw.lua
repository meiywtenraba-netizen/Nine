-- [[ 4King Mahanakhon - Safe Farm Helper ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ปรับค่าความเร็วให้อยู่ในระดับปลอดภัย (แนะนำไม่เกิน 24-28 เพื่อไม่ให้ระบบเตะ)
local SafeSpeed = 26
local SafeJump = 55

local function applySafePhysics(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- ตั้งค่าเริ่มต้น
    humanoid.WalkSpeed = SafeSpeed
    humanoid.JumpPower = SafeJump
    
    -- ตรวจสอบและล็อกค่าไว้แบบนุ่มนวล ไม่ส่งข้อมูลถี่เกินไป
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if humanoid.WalkSpeed > SafeSpeed then
            humanoid.WalkSpeed = SafeSpeed
        end
    end)
    
    humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if humanoid.JumpPower > SafeJump then
            humanoid.JumpPower = SafeJump
        end
    end)
end

if LocalPlayer.Character then
    applySafePhysics(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(character)
    applySafePhysics(character)
end)

print("Safe Helper Loaded! Running on safe parameters.")
