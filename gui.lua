-- [[ 4King Mahanakhon - Optimized 23 Hitbox Menu ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- สร้างหน้าต่างเมนู (GUI) 
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBoss = Instance.new("TextButton")
local TogglePlayer = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "Hitbox23_Hub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Hitbox 23 Mode"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

local BossEnabled = false
local PlayerEnabled = false
local TargetHitboxSize = 23 -- ล็อกค่าไว้ที่ 23 ตามที่ขอครับ

-- ปุ่มเปิด-ปิด บอส
ToggleBoss.Parent = MainFrame
ToggleBoss.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleBoss.Size = UDim2.new(0.9, 0, 0, 40)
ToggleBoss.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleBoss.Text = "Hitbox บอส (23): ปิด"
ToggleBoss.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ปุ่มเปิด-ปิด ผู้เล่น
TogglePlayer.Parent = MainFrame
TogglePlayer.Position = UDim2.new(0.05, 0, 0.5, 0)
TogglePlayer.Size = UDim2.new(0.9, 0, 0, 40)
TogglePlayer.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
TogglePlayer.Text = "Hitbox ผู้เล่น (23): ปิด"
TogglePlayer.TextColor3 = Color3.fromRGB(255, 255, 255)

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 40)
StatusLabel.Text = "สถานะ: พร้อมใช้งาน"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)

-- ลูปอัปเดตระยะฟันแบบเว้นจังหวะกันแบน (Smart Loop)
task.spawn(function()
    while task.wait(0.6) do -- ขยับเวลาตรวจเช็กเล็กน้อยเพื่อหลบเลี่ยงสายตาเซิร์ฟเวอร์
        for _, v in ipairs(Workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                local p = Players:GetPlayerFromCharacter(v)
                if p then
                    -- โหมดตีผู้เล่นทั่วไป
                    if p ~= LocalPlayer and PlayerEnabled then
                        v.HumanoidRootPart.Size = Vector3.new(TargetHitboxSize, TargetHitboxSize, TargetHitboxSize)
                        v.HumanoidRootPart.CanCollide = false
                    elseif p ~= LocalPlayer and not PlayerEnabled then
                        v.HumanoidRootPart.Size = Vector3.new(2, 2, 2)
                    end
                else
                    -- โหมดตีบอส / NPC
                    if BossEnabled then
                        v.HumanoidRootPart.Size = Vector3.new(TargetHitboxSize, TargetHitboxSize, TargetHitboxSize)
                        v.HumanoidRootPart.CanCollide = false
                    elseif not BossEnabled then
                        v.HumanoidRootPart.Size = Vector3.new(2, 2, 2)
                    end
                end
            end
        end
    end
end)

ToggleBoss.MouseButton1Click:Connect(function()
    BossEnabled = not BossEnabled
    ToggleBoss.Text = BossEnabled and "Hitbox บอส (23): เปิด" or "Hitbox บอส (23): ปิด"
    ToggleBoss.BackgroundColor3 = BossEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

TogglePlayer.MouseButton1Click:Connect(function()
    PlayerEnabled = not PlayerEnabled
    TogglePlayer.Text = PlayerEnabled and "Hitbox ผู้เล่น (23): เปิด" or "Hitbox ผู้เล่น (23): ปิด"
    TogglePlayer.BackgroundColor3 = PlayerEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)
