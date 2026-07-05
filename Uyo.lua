-- [[ 4King Mahanakhon - Premium Modern Hitbox Menu ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- สร้างหน้าต่างเมนูแบบโมเดิร์น (Premium GUI)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local ToggleBoss = Instance.new("TextButton")
local CornerBoss = Instance.new("UICorner")
local TogglePlayer = Instance.new("TextButton")
local CornerPlayer = Instance.new("UICorner")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "PremiumHitbox_Hub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ตกแต่งกรอบเมนูหลัก
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- สีดำโทนน้ำเงินเข้มแบบพรีเมียม
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 240)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12) -- เพิ่มความโค้งมนให้เมนู
UICorner.Parent = MainFrame

UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 120, 255) -- เส้นขอบเรืองแสงสีฟ้า
UIStroke.Parent = MainFrame

-- หัวข้อเมนู
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
Title.Text = "✨ PREMIUM HUB v23"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local BossEnabled = false
local PlayerEnabled = false
local TargetHitboxSize = 23 -- ล็อกค่าไว้ที่ 23

-- ปุ่มเปิด-ปิด บอส (สไตล์โมเดิร์น)
ToggleBoss.Parent = MainFrame
ToggleBoss.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleBoss.Size = UDim2.new(0.9, 0, 0, 42)
ToggleBoss.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
ToggleBoss.Text = "❌ Hitbox บอส (23)"
ToggleBoss.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleBoss.TextSize = 14
ToggleBoss.Font = Enum.Font.GothamSemibold

CornerBoss.CornerRadius = UDim.new(0, 8)
CornerBoss.Parent = ToggleBoss

-- ปุ่มเปิด-ปิด ผู้เล่น (สไตล์โมเดิร์น)
TogglePlayer.Parent = MainFrame
TogglePlayer.Position = UDim2.new(0.05, 0, 0.5, 0)
TogglePlayer.Size = UDim2.new(0.9, 0, 0, 42)
TogglePlayer.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
TogglePlayer.Text = "❌ Hitbox ผู้เล่น (23)"
TogglePlayer.TextColor3 = Color3.fromRGB(200, 200, 200)
TogglePlayer.TextSize = 14
TogglePlayer.Font = Enum.Font.GothamSemibold

CornerPlayer.CornerRadius = UDim.new(0, 8)
CornerPlayer.Parent = TogglePlayer

-- แถบสถานะด้านล่าง
StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 35)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🛡️ ระบบกันแบน: เปิดใช้งาน"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Gotham

-- ฟังก์ชันอนิเมชั่นเปลี่ยนสีปุ่มแบบนุ่มนวล (Tween)
local function tweenButton(button, color, text)
    TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = color}):Play()
    button.Text = text
end

-- ลูปอัปเดตระยะฟัน 23
task.spawn(function()
    while task.wait(0.6) do
        for _, v in ipairs(Workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                local p = Players:GetPlayerFromCharacter(v)
                if p then
                    if p ~= LocalPlayer and PlayerEnabled then
                        v.HumanoidRootPart.Size = Vector3.new(TargetHitboxSize, TargetHitboxSize, TargetHitboxSize)
                        v.HumanoidRootPart.CanCollide = false
                    elseif p ~= LocalPlayer and not PlayerEnabled then
                        v.HumanoidRootPart.Size = Vector3.new(2, 2, 2)
                    end
                else
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

-- ระบบปุ่มกดแบบมีเอฟเฟกต์สี
ToggleBoss.MouseButton1Click:Connect(function()
    BossEnabled = not BossEnabled
    if BossEnabled then
        tweenButton(ToggleBoss, Color3.fromRGB(0, 150, 100), "🟢 เปิดใช้งาน Hitbox บอส")
        ToggleBoss.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        tweenButton(ToggleBoss, Color3.fromRGB(45, 45, 50), "❌ Hitbox บอส (23)")
        ToggleBoss.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

TogglePlayer.MouseButton1Click:Connect(function()
    PlayerEnabled = not PlayerEnabled
    if PlayerEnabled then
        tweenButton(TogglePlayer, Color3.fromRGB(0, 150, 100), "🟢 เปิดใช้งาน Hitbox ผู้เล่น")
        TogglePlayer.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        tweenButton(TogglePlayer, Color3.fromRGB(45, 45, 50), "❌ Hitbox ผู้เล่น (23)")
        TogglePlayer.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)
