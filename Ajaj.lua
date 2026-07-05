-- [[ 4King Mahanakhon - Boss Farm Helper ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- สร้างหน้าต่างเมนู (Premium GUI)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local ToggleBoss = Instance.new("TextButton")
local ToggleFarm = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "PremiumFarm_Hub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 240)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 120, 255)
UIStroke.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
Title.Text = "✨ BOSS FARM v23"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local BossEnabled = false
local FarmEnabled = false
local TargetHitboxSize = 23

-- ปุ่มเปิด-ปิด Hitbox บอส
ToggleBoss.Parent = MainFrame
ToggleBoss.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleBoss.Size = UDim2.new(0.9, 0, 0, 42)
ToggleBoss.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
ToggleBoss.Text = "❌ Hitbox บอส (23)"
ToggleBoss.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleBoss.TextSize = 14
ToggleBoss.Font = Enum.Font.GothamSemibold

local CornerBoss = Instance.new("UICorner")
CornerBoss.CornerRadius = UDim.new(0, 8)
CornerBoss.Parent = ToggleBoss

-- ปุ่มเปิด-ปิด ล็อกตัวฟาร์มบอส
ToggleFarm.Parent = MainFrame
ToggleFarm.Position = UDim2.new(0.05, 0, 0.5, 0)
ToggleFarm.Size = UDim2.new(0.9, 0, 0, 42)
ToggleFarm.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
ToggleFarm.Text = "❌ ล็อกตัวฟาร์มบอส"
ToggleFarm.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleFarm.TextSize = 14
ToggleFarm.Font = Enum.Font.GothamSemibold

local CornerFarm = Instance.new("UICorner")
CornerFarm.CornerRadius = UDim.new(0, 8)
CornerFarm.Parent = ToggleFarm

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 35)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "สถานะ: พร้อมใช้งาน"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Gotham

local function tweenButton(button, color, text)
    TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = color}):Play()
    button.Text = text
end

-- ฟังก์ชันค้นหาบอสหรือ NPC ที่อยู่ใกล้ที่สุด
local function getClosestBoss()
    local closest = nil
    local shortestDistance = math.huge
    for _, v in ipairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
            -- ตรวจสอบว่าเป็น NPC (ไม่ใช่ผู้เล่น) และยังมีชีวิตอยู่
            if not Players:GetPlayerFromCharacter(v) and v.Humanoid.Health > 0 then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closest = v
                end
            end
        end
    end
    return closest
end

-- ลูปอัปเดตระยะฟัน 23
task.spawn(function()
    while task.wait(0.6) do
        for _, v in ipairs(Workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                if not Players:GetPlayerFromCharacter(v) then
                    if BossEnabled then
                        v.HumanoidRootPart.Size = Vector3.new(TargetHitboxSize, TargetHitboxSize, TargetHitboxSize)
                        v.HumanoidRootPart.CanCollide = false
                    else
                        v.HumanoidRootPart.Size = Vector3.new(2, 2, 2)
                    end
                end
            end
        end
    end
end)

-- ลูประบบวาร์ปฟาร์มบอส (จะวาร์ปไปเหนือหัวบอสเพื่อความปลอดภัย)
task.spawn(function()
    while task.wait(0.1) do
        if FarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetBoss = getClosestBoss()
            if targetBoss and targetBoss:FindFirstChild("HumanoidRootPart") then
                -- วาร์ปไปตำแหน่งเหนือหัวบอส 5 หน่วย เพื่อหลบการโจมตีสวนกลับ
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetBoss.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
            end
        end
    end
end)

ToggleBoss.MouseButton1Click:Connect(function()
    BossEnabled = not BossEnabled
    if BossEnabled then
        tweenButton(ToggleBoss, Color3.fromRGB(0, 150, 100), "🟢 เปิด Hitbox บอส")
        ToggleBoss.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        tweenButton(ToggleBoss, Color3.fromRGB(45, 45, 50), "❌ Hitbox บอส (23)")
        ToggleBoss.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

ToggleFarm.MouseButton1Click:Connect(function()
    FarmEnabled = not FarmEnabled
    if FarmEnabled then
        tweenButton(ToggleFarm, Color3.fromRGB(0, 120, 255), "🟢 กำลังฟาร์มบอสอัตโนมัติ")
        ToggleFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
        StatusLabel.Text = "🎯 กำลังล็อกเป้าหมายบอส..."
    else
        tweenButton(ToggleFarm, Color3.fromRGB(45, 45, 50), "❌ ล็อกตัวฟาร์มบอส")
        ToggleFarm.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatusLabel.Text = "🛡️ ระบบกันแบน: เปิดใช้งาน"
    end
end)
