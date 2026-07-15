-- [[ Difference Finders - Auto Highlight Script ]] --
local Workspace = game:GetService("Workspace")

local function applyDifferenceESP(object)
    -- ตรวจสอบว่ามี ESP อยู่แล้วหรือยังเพื่อไม่ให้ซ้ำซ้อน
    if not object:FindFirstChild("DiffESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "DiffESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 100) -- สีชมพู/แดงสะท้อนแสง เห็นชัดๆ
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Adornee = object
        highlight.Parent = object
    end
end

local function scanDifferencePoints()
    -- วนลูปหา Part หรือ Object ที่ใช้เป็นปุ่มกดจุดต่างในแมพ
    for _, v in ipairs(Workspace:GetDescendants()) do
        -- เกมแนวนี้มักจะใช้ Part โปร่งใสครอบจุดต่างเอาไว้
        -- สคริปต์จะดักจับ Part ที่มีฟังก์ชันการคลิก หรือชื่อเฉพาะที่เกี่ยวข้อง
        if v:IsA("BasePart") and (v:FindFirstChildOfClass("ClickDetector") or v:FindFirstChildOfClass("TouchTransmitter")) then
            applyDifferenceESP(v)
        elseif v:IsA("BasePart") and (string.find(string.lower(v.Name), "button") or string.find(string.lower(v.Name), "diff") or string.find(string.lower(v.Name), "click")) then
            applyDifferenceESP(v)
        end
    end
end

-- รันสแกนจุดต่างทุกๆ 3 วินาที (รองรับเวลาเปลี่ยนด่านใหม่)
task.spawn(function()
    while true do
        scanDifferencePoints()
        task.wait(3)
    end
end)

print("Difference Finders ESP Loaded! ซูมดูที่ภาพได้เลยครับ")
