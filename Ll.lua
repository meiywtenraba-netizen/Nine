-- [[ Jaaj.lua - Ninja Executor Loader Standard ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ฟังก์ชันแจ้งเตือนบนหน้าจอว่าสคริปต์ทำงานผ่านตัวรันแล้ว
local function notifyUser(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 5;
    })
end

-- ตรวจสอบการโหลดสคริปต์เข้ากับตัวรัน
if LocalPlayer then
    notifyUser("🥷 NINJA EXECUTER", "สคริปต์ Jaaj.lua โหลดสำเร็จแล้ว!")
else
    warn("ไม่สามารถระบุตัวผู้เล่นได้")
end

-- โครงสร้างระบบเช็คเครื่องมือ (Tool) สำหรับตรวจสอบสัญญาณในเครื่องของเรา
local function onToolActivated(tool)
    -- มองหา Event ส่งข้อมูลของตัวเกมเพื่อเตรียมความพร้อมในการส่งสัญญาณ
    local targetEvent = ReplicatedStorage:FindFirstChildOfClass("RemoteEvent")
    if targetEvent then
        print("ระบบตรวจพบช่องทางส่งสัญญาณ: " .. targetEvent.Name)
    end
end

-- ตรวจจับการถืออาวุธ์ของผู้เล่น
LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            onToolActivated(child)
        end
    end)
end)

-- เช็ค Tool ณ เวลาปัจจุบัน
if LocalPlayer.Character then
    local heldTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if heldTool then
        onToolActivated(heldTool)
    end
end
