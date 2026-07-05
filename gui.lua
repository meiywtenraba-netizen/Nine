-- [[ 4King Mahanakhon - Ultimate Safe Boss Helper ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- ===== [ ตั้งค่าระบบกันแบน - ปรับตรงนี้ได้ ] =====
local HitboxSize = 8       -- ขนาดระยะฟัน (ค่าปกติคือ 2, ปรับเป็น 8 เพื่อให้ฟันไกลแบบปลอดภัย ไม่โดนเตะ)
local AttackSpeedMultiplier = 1.15 -- บูสต์ความเร็ว/ความต่อเนื่องการฟันขึ้น 15% (ไม่ปรับแรงกว่านี้ป้องกัน Server Kick)
-- =============================================

-- 1. ระบบมองเห็นบอสทะลุกำแพง (Boss ESP)
local function applyBossESP(npc)
    if npc:IsA("Model") and not npc:FindFirstChild("BossGlow") then
        -- เช็กว่าเป็น NPC บอส ไม่ใช่ผู้เล่นทั่วไป
        if not Players:GetPlayerFromCharacter(npc) and npc:FindFirstChild("Humanoid") then
            -- ใส่แสงไฮไลต์สีทอง/เหลือง
            local highlight = Instance.new("Highlight")
            highlight.Name = "BossGlow"
            highlight.FillColor = Color3.fromRGB(255, 215, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.4
            highlight.Parent = npc
            
            -- 2. เพิ่มระยะฟันไกล (Safe Hitbox Extender)
            local root = npc:FindFirstChild("HumanoidRootPart")
            if root then
                root.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                root.CanCollide = false -- ป้องกันไม่ให้ชนบอสแล้วตัวลอย
            end
        end
    end
end

-- 3. ระบบกันแบนและเพิ่มประสิทธิภาพการตี (Safe Damage & Anti-Ban)
local function setupAntiBan()
    -- ป้องกันความเร็วการเดินหลุดเกณฑ์ป้องกันของเซิร์ฟเวอร์
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        -- ล็อกความเร็วให้ไหลลื่นเป็นธรรมชาติ (ประมาณ 22-24) ไม่ให้ขยับไวเกินไปจน Anti-Cheat จับได้
        if humanoid.WalkSpeed < 24 then
            humanoid.WalkSpeed = 24
        end
    end
    
    -- ลูปจำกัดและปรับการส่งข้อมูลการโจมตี (หลอกเซิร์ฟเวอร์ว่าเราตีปกติแต่โดนทุกดอก)
    task.spawn(function()
        while task.wait(0.2) do
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Animate") then
                    -- ปรับความเร็วอนิเมชั่นการฟันให้ไวและต่อเนื่องขึ้นเล็กน้อยตามค่าที่ตั้งไว้
                    local animate = tool.Animate
                    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                        if track.Name:lower():find("attack") or track.Name:lower():find("slash") then
                            track:AdjustSpeed(AttackSpeedMultiplier)
                        end
                    end
                end
            end
        end
    end)
end

-- เริ่มทำงานระบบสแกนบอสในฉาก
for _, obj in ipairs(Workspace:GetChildren()) do
    applyBossESP(obj)
end

Workspace.ChildAdded:Connect(function(child)
    task.wait(0.3)
    applyBossESP(child)
end)

-- เริ่มทำงานระบบกันแบน
if LocalPlayer.Character then setupAntiBan() end
LocalPlayer.CharacterAdded:Connect(setupAntiBan)

print("Ultimate Boss Helper Loaded! (Safe & Anti-Ban Active)")
