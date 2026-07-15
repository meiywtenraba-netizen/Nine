-- สร้างหน้าจอ UI (ขยายขนาดเพื่อรองรับปุ่มใหม่)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local DodgeButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local StatusLabel = Instance.new("TextLabel")

local parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = parent
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MahanakhonUltra"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 180) -- เพิ่มความสูงหน้าจอ
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.BackgroundTransparency = 1
Title.Text = "4King Mahanakhon VIP"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 0, 0.2, 0)
StatusLabel.Size = UDim2.new(1, 0, 0.15, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Bypass System: ACTIVE"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.SourceSansItalic

-- ปุ่มที่ 1: ตีแรง
ToggleButton.Parent = MainFrame
ToggleButton.Position = UDim2.new(0.1, 0, 0.38, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.25, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Text = "เปิดระบบตีแรง (x50)"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.SourceSansBold

-- ปุ่มที่ 2: ตีโดนยาก (ใหม่)
DodgeButton.Parent = MainFrame
DodgeButton.Position = UDim2.new(0.1, 0, 0.68, 0)
DodgeButton.Size = UDim2.new(0.8, 0, 0.25, 0)
DodgeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DodgeButton.Text = "เปิดโหมดหลบหลีก (ตีโดนยาก)"
DodgeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DodgeButton.TextSize = 12
DodgeButton.Font = Enum.Font.SourceSansBold

-- ==========================================
-- ระบบ ANTI-BAN (Bypass)
-- ==========================================
local MT = getrawmetatable(game)
local OldNamecall = MT.__namecall
setreadonly(MT, false)

MT.__namecall = newcclosure(function(Self, ...)
    local Method = getnamecallmethod()
    if not checkcaller() and (Method == "FireServer" or Method == "InvokeServer") then
        local RemoteName = tostring(Self)
        if RemoteName:lower():find("cheat") or RemoteName:lower():find("ban") or RemoteName:lower():find("detect") or RemoteName:lower():find("check") then
            return nil
        end
    end
    return OldNamecall(Self, ...)
end)
setreadonly(MT, true)

-- ==========================================
-- ตัวแปรควบคุมระบบ
-- ==========================================
local _G = getgenv and getgenv() or _G
_G.SafeHit = false
_G.DodgeMode = false

-- ฟังก์ชันระบบตีแรง
local function startSafeHit()
    task.spawn(function()
        while _G.SafeHit do
            task.wait(0.01)
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                local char = player.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("RemoteClick") then 
                        tool.RemoteClick:FireServer() 
                    elseif tool then
                        local virtualUser = game:GetService("VirtualUser")
                        virtualUser:CaptureController()
                        virtualUser:ClickButton1(Vector2.new(0, 0))
                    end
                end
            end)
        end
    end)
end

-- ฟังก์ชันระบบหลบหลีก (Dodge Mode)
local function startDodge()
    task.spawn(function()
        while _G.DodgeMode do
            task.wait()
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if hum and hrp then
                    -- เพิ่มความเร็ววิ่งขึ้นเล็กน้อยให้หลบการโจมตีง่ายขึ้นแบบเนียนๆ
                    hum.WalkSpeed = 25 
                    
                    -- ทำการสั่นพิกัดเพื่อทำลายการเล็งเป้าหมาย (Desync) ทำให้อีกฝ่ายกดโจมตีโดนยากมาก
                    local originalCFrame = hrp.CFrame
                    hrp.CFrame = originalCFrame * CFrame.new(math.random(-1, 1) * 0.15, 0, math.random(-1, 1) * 0.15)
                    task.wait(0.01)
                    hrp.CFrame = originalCFrame
                end
            end)
        end
    end)
end

-- คืนค่าความเร็วปกติเมื่อปิดโหมดหลบหลีก
local function resetDodge()
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16 -- ค่าความเร็วมาตรฐานของ Roblox
        end
    end)
end

-- Event ปุ่มกดตีแรง
ToggleButton.MouseButton1Click:Connect(function()
    _G.SafeHit = not _G.SafeHit
    if _G.SafeHit then
        ToggleButton.Text = "ตีแรง: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        startSafeHit()
    else
        ToggleButton.Text = "เปิดระบบตีแรง (x50)"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- Event ปุ่มกดหลบหลีก
DodgeButton.MouseButton1Click:Connect(function()
    _G.DodgeMode = not _G.DodgeMode
    if _G.DodgeMode then
        DodgeButton.Text = "หลบหลีก: ON"
        DodgeButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        startDodge()
    else
        DodgeButton.Text = "เปิดโหมดหลบหลีก (ตีโดนยาก)"
        DodgeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        resetDodge()
    end
end)
