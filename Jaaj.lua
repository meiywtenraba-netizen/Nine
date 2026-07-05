-- [[ 4KING Mahanakhon - Hitbox 32 Script (For Executors) ]] --
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- ตั้งค่าระยะ Hitbox (32) และความโปร่งใสของกล่อง
local hitboxSize = Vector3.new(32, 32, 32)
local transparency = 0.7 -- 0 คือทึบมองไม่เห็นศัตรู, 1 คือล่องหนไปเลย

print("Hitbox 32 Enabled! รันสคริปต์สำเร็จ")

-- วนลูปทำงานตลอดเวลาเพื่ออัปเดตระยะ
runService.RenderStepped:Connect(function()
    -- เช็คตัวละครของผู้เล่นอื่นในเซิร์ฟเวอร์
    for _, enemy in ipairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = enemy.Character.HumanoidRootPart
            local humanoid = enemy.Character:FindFirstChildOfClass("Humanoid")
            
            -- เช็คว่าศัตรูยังมีชีวิตอยู่ไหม
            if humanoid and humanoid.Health > 0 then
                -- ขยายขนาด HumanoidRootPart ของศัตรูให้ใหญ่ขึ้นเป็น 32 เพื่อให้เราตีโดนง่ายขึ้น
                hrp.Size = hitboxSize
                hrp.Transparency = transparency
                hrp.Color = Color3.fromRGB(255, 0, 0) -- เปลี่ยนเป็นกล่องสีแดง
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false -- กันไม่ให้ตัวเราไปชนกล่องแล้วเด้ง
            end
        end
    end
end)
