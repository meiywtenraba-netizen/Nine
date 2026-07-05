-- [[ 4King Mahanakhon - Safe Menu Hub ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- สร้างหน้าต่างเมนูแบบเรียบง่าย (GUI) ป้องกันการตรวจจับจากสคริปต์สแกนหน้าจอ
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBoss = Instance.new("TextButton")
local TogglePlayer = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "SafeHub_4King"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true -- สามารถลากย้ายบนจอมือถือได้

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "4King Safe Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- สถานะการเปิดใช้งาน
local BossEnabled = false
local PlayerEnabled = false
local SafeHitboxSize = 7 -- ปรับไว้ที่ 7-8 เป็นเกณฑ์ปลอดภัยที่สุดสำหรับผู้เล่นทั่วไป

-- ปุ่มเปิด-ปิด ตีบอส
ToggleBoss.Parent = MainFrame
ToggleBoss.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleBoss.Size = UDim2.new(0.9, 0, 0, 40)
ToggleBoss.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleBoss.Text = "Hitbox บอส: ปิด"
ToggleBoss.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ปุ่มเปิด-ปิด ตีผู้เล่น
TogglePlayer.Parent = MainFrame
TogglePlayer.Position = UDim2.new(0.05, 0, 0.5, 0)
TogglePlayer.Size = UDim2.new(0.9, 0, 0, 40)
TogglePlayer.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
TogglePlayer.Text = "Hitbox ผู้เล่น: ปิด"
TogglePlayer.TextColor3 = Color3.fromRGB(255, 255, 255)

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 40)
StatusLabel.Text = "ระบบกันแบน: เปิดใช้งาน"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

-- ลูปทำงานเบื้องหลัง (กันแบน + ขยาย Hitbox)
task.spawn(function()
    while task.wait(0.5) do
        -- ระบบขยาย Hitbox บอส/ผู้เล่น
        for _, v in ipairs(Workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                local p = Players:GetPlayerFromCharacter(v)
                
                if p then
                    -- สำหรับผู้เล่นทั่วไป
                    if p ~= LocalPlayer and PlayerEnabled then
                        v.HumanoidRootPart.Size = Vector3.new(SafeHitboxSize, SafeHitboxSize, SafeHitboxSize)
                        v.HumanoidRootPart.CanCollide = false
                    elseif p ~= LocalPlayer and not PlayerEnabled then
                        v.HumanoidRootPart.Size = Vector3.new(2, 2, 2) -- คืนค่าเดิม
                    end
                else
                    -- สำหรับบอส / NPC
                    if BossEnabled then
                        v.HumanoidRootPart.Size = Vector3.new(SafeHitboxSize + 2, SafeHitboxSize + 2, SafeHitboxSize + 2)
                        v.HumanoidRootPart.CanCollide = false
                    elseif not BossEnabled then
                        v.HumanoidRootPart.Size = Vector3.new(2, 2, 2) -- คืนค่าเดิม
                    end
                end
            end
        end
        
        -- ระบบป้องกันฝั่ง Client ไม่ให้ WalkSpeed เกินที่เกมกำหนดป้องกันเซิร์ฟเวอร์ดีดออก
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            if char.Humanoid.WalkSpeed > 24 then
                char.Humanoid.WalkSpeed = 24
            end
        end
    end
end)

-- ควบคุมปุ่มกด
ToggleBoss.MouseButton1Click:Connect(function()
    BossEnabled = not BossEnabled
    if BossEnabled then
        ToggleBoss.Text = "Hitbox บอส: เปิด"
        ToggleBoss.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        ToggleBoss.Text = "Hitbox บอส: ปิด"
        ToggleBoss.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

TogglePlayer.MouseButton1Click:Connect(function()
    PlayerEnabled = not PlayerEnabled
    if PlayerEnabled then
        TogglePlayer.Text = "Hitbox ผู้เล่น: เปิด"
        TogglePlayer.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        TogglePlayer.Text = "Hitbox ผู้เล่น: ปิด"
        TogglePlayer.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)
