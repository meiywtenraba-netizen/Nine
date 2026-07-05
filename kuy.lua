-- [[ 4King Mahanakhon - Specific Boss Farm (เสือสมิง & หัวหน้าฟรอมช่าง) ]] --
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

ScreenGui.Name = "SpecificFarm_Hub"
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
UIStroke.Color = Color3.fromRGB(255, 60, 60) -- เปลี่ยนขอบเป็นสีแดงดุดัน
UIStroke.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(35, 25, 25)
Title.Text = "🐯 BOSS HUNTER v23"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local BossEnabled = false
local FarmEnabled = false
local TargetHitboxSize = 23

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

ToggleFarm.Parent = MainFrame
ToggleFarm.Position = UDim2.new(0.05, 0, 0.5, 0)
ToggleFarm.Size = UDim2.new(0.9, 0, 0, 42)
ToggleFarm.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
ToggleFarm.Text = "❌ ล็อกฟาร์ม เสือสมิง/ฟรอมช่าง"
ToggleFarm.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleFarm.TextSize = 13
ToggleFarm.Font = Enum.Font.GothamSemibold

local CornerFarm = Instance.new("UICorner")
CornerFarm.CornerRadius = UDim.new(0, 8)
CornerFarm.Parent = ToggleFarm

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 35)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "สถานะ: รอการเปิดใช้งาน"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Gotham

local function tweenButton(button, color, text)
    TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = color}):Play()
    button.Text = text
end

-- ฟังก์ชันกรองหาเฉพาะบอสเสือสมิง หรือหัวหน้าฟรอมช่าง
local function getTargetBoss()
    for _, v in ipairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
            if v.Humanoid.Health > 0 then
                -- ตรวจสอบชื่อของโมเดลบอส (รองรับทั้งภาษาไทยและอังกฤษที่ระบบมักใช้ตั้งชื่อบอส)
                local name = string.lower(v.Name)
                if string.find(name, "Saming") or string.find(name, "เสือสมิง") or string.find(name, "Sua") or
                   string.find(name, "Chang") or string.find(name, "ช่าง") or string.find(name, "หัวหน้า") then
                    return v
                end
            end
        end
    end
    return nil
end

-- ลูปเพิ่มขนาด Hitbox บอสเป้าหมาย
task.spawn(function()
    while task.wait(0.6) do
        if BossEnabled then
            local target = getTargetBoss()
            if target and target:FindFirstChild("HumanoidRootPart") then
                target.HumanoidRootPart.Size = Vector3.new(TargetHitboxSize, TargetHitboxSize, TargetHitboxSize)
                target.HumanoidRootPart.CanCollide = false
            end
        else
            -- คืนค่าขนาดปกติเมื่อปิด
            local target = getTargetBoss()
            if target and target:FindFirstChild("HumanoidRootPart") then
                target.HumanoidRootPart.Size = Vector3.new(2, 2, 2)
            end
        end
    end
end)

-- ลูประบบวาร์ปไปล็อกหัวบอสเป้าหมาย
task.spawn(function()
    while task.wait(0.1) do
        if FarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local target = getTargetBoss()
            if target and target:FindFirstChild("HumanoidRootPart") then
                -- วาร์ปไปจุดปลอดภัยเหนือหัวบอส 5.5 หน่วย
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5.5, 0)
                StatusLabel.Text = "🎯 กำลังฟาร์ม: " .. target.Name
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
            else
                StatusLabel.Text = "🔍 กำลังหาเสือสมิง/ฟรอมช่าง..."
                StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
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
        tweenButton(ToggleFarm, Color3.fromRGB(255, 50, 50), "🟢 กำลังล่าบอสเป้าหมาย")
        ToggleFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        tweenButton(ToggleFarm, Color3.fromRGB(45, 45, 50), "❌ ล็อกฟาร์ม เสือสมิง/ฟรอมช่าง")
        ToggleFarm.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatusLabel.Text = "สถานะ: หยุดทำงาน"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    end
end)
