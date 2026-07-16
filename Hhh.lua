-- [[ 🔴 SCRIPT: CLICK TO GET OVERPOWERED POWER ]] --
-- วางสคริปต์นี้ไว้ใน Part ที่มี ClickDetector

local button = script.Parent
local clickDetector = button:WaitForChild("ClickDetector")

-- ตั้งค่าพลังงาน (เปลี่ยนชื่อให้ตรงกับระบบ Leaderstats ของแมพคุณ)
local STAT_NAME = "Power" 
local BONUS_AMOUNT = 999999999 -- จำนวนพลังที่ได้ต่อการคลิก 1 ครั้ง

-- ฟังก์ชันทำงานเมื่อมีคนมากดปุ่ม
clickDetector.MouseClick:Connect(function(player)
	-- ตรวจสอบว่าผู้เล่นมีระบบ Leaderstats หรือไม่
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local powerStat = leaderstats:FindFirstChild(STAT_NAME)
		
		if powerStat then
			-- เพิ่มพลังแบบโอเวอร์โหลด!
			powerStat.Value = powerStat.Value + BONUS_AMOUNT
			print("⚡ " .. player.Name .. " ได้รับพลังโกงจำนวน " .. BONUS_AMOUNT .. " Power!")
		else
			warn("❌ ไม่พบค่าพลังที่ชื่อ: " .. STAT_NAME .. " ใน leaderstats")
		end
	else
		warn("❌ ไม่พบ leaderstats ในตัวผู้เล่น " .. player.Name)
	end
end)
