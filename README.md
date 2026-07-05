-- ตัวอย่างสคริปต์แบบจำลองใน Roblox (Luau) สำหรับส่งกระสุนไปหาเป้าหมายอัตโนมัติ
local function getClosestEnemy(playerPosition, maxDistance)
    local closestEnemy = nil
    local shortestDistance = maxDistance

    -- ลูปหาศัตรูที่ใกล้ที่สุดในเกม
    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        local enemyPart = enemy:FindFirstChild("HumanoidRootPart")
        if enemyPart then
            local distance = (playerPosition - enemyPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestEnemy = enemyPart
            end
        end
    end
    return closestEnemy
end

-- ตอนที่กดยิง (Fire)
local target = getClosestEnemy(character.Head.Position, 500) -- ระยะ 500 หน่วย
local fireDirection

if target then
    -- เปลี่ยนทิศทางให้ล็อกไปที่เป้าหมายทันที
    fireDirection = (target.Position - gunMuzzle.Position).Unit
else
    -- ยิงไปตามหน้าจอปกติถ้าไม่มีเป้าหมาย
    fireDirection = mouse.Hit.LookVector
end
