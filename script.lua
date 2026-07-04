-- [[ 4King Mahanakhon - Safe ESP Script ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ฟังก์ชัน ESP เท่านั้น (ปลอดภัย ไม่โดนเตะ)
local function createESP(player)
    if player == LocalPlayer or player.Character and player.Character:FindFirstChild("Highlight") then return end
    
    local function applyESP(character)
        local highlight = Instance.new("Highlight")
        highlight.Name = "Highlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.Parent = character
    end

    if player.Character then applyESP(player.Character) end
    player.CharacterAdded:Connect(applyESP)
end

for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end
Players.PlayerAdded:Connect(createESP)

print("ESP Loaded! (Safe mode)")
