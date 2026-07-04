-- [[ 4King Mahanakhon - Helper Script ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 1. ฟังก์ชัน ESP (มองเห็นผู้เล่นทะลุกำแพง และเห็นชื่อ/ระยะทาง)
local function createESP(player)
    if player == LocalPlayer then return end
    
    local function applyESP(character)
        if not character:FindFirstChild("Highlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "Highlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0) -- สีแดง
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- ขอบสีขาว
            highlight.FillTransparency = 0.5
            highlight.Parent = character
        end
    end

    if player.Character then applyESP(player.Character) end
    player.CharacterAdded:Connect(applyESP)
end

-- เปิดใช้งาน ESP ให้ทุกคนในเซิร์ฟเวอร์
for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end
Players.PlayerAdded:Connect(createESP)

-- 2. ฟังก์ชัน Auto Kill / Auto Attack (เทเลพอร์ตไปฟันคนที่เลือดน้อยสุดหรือใกล้สุด)
-- *หมายเหตุ: สคริปต์นี้จะหาผู้เล่นที่อยู่ใกล้ที่สุดแล้วหันหน้าไปโจมตี*

_G.AutoAttack = true -- เปลี่ยนเป็น false เพื่อปิด

task.spawn(function()
    while _G.AutoAttack do
        task.wait(0.1)
        pcall(function()
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myTool = myChar and myChar:FindFirstChildOfClass("Tool") -- ต้องถืออาวุธไว้ในมือ
            
            if myRoot and myTool then
                local closestPlayer = nil
                local shortestDistance = math.huge
                
                -- หาคนที่อยู่ใกล้ที่สุด
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                        if player.Character.Humanoid.Health > 0 then
                            local distance = (myRoot.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                closestPlayer = player
                            end
                        end
                    end
                end
                
                -- ถ้าเจอเป้าหมายในระยะ (เช่น ต่ำกว่า 500 stud) ให้วาร์ปไปด้านหลังแล้วฟัน
                if closestPlayer and shortestDistance < 500 then
                    local targetRoot = closestPlayer.Character.HumanoidRootPart
                    -- วาร์ปไปข้างหลังเป้าหมายเล็กน้อยกันโดนสวน
                    myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3) 
                    
                    -- สั่งให้อาวุธทำงาน (แกว่งดาบ/ต่อย)
                    myTool:Activate() 
                end
            end
        end)
    end
end)

print("4King Script Loaded Successfully!")
