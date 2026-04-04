-- [[ FahriRoundopHUB - ESP Engine (Pallet & Gate Fix) ]] --
-- Developer: FahriSetiawan69

local ESP = {
    Config = { Player = false, Generator = false, Pallet = false, Gate = false },
    Colors = {
        Killer = Color3.fromRGB(255, 0, 0),      
        Survivor = Color3.fromRGB(0, 255, 0),    
        Generator = Color3.fromRGB(255, 165, 0), 
        Pallet = Color3.fromRGB(255, 255, 0),    
        Gate = Color3.fromRGB(0, 0, 255)         
    }
}

local function ApplyHighlight(obj, color)
    if not obj then return end
    local hl = obj:FindFirstChild("FR_ESP") or Instance.new("Highlight")
    hl.Name = "FR_ESP"
    hl.Parent = obj
    hl.FillColor = color
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0.8 
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = true
    return hl
end

-- 1. PLAYER ESP
function ESP:SetPlayer(state)
    self.Config.Player = state
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= game:GetService("Players").LocalPlayer and p.Character then
            local color = self.Colors.Survivor
            if p.Team and p.Team.Name:find("Killer") then
                color = self.Colors.Killer
            end
            local hl = ApplyHighlight(p.Character, color)
            if hl then hl.Enabled = state end
        end
    end
end

-- 2. GENERATOR ESP
function ESP:SetGenerator(state)
    self.Config.Generator = state
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:find("Generator") then
            local hl = ApplyHighlight(obj, self.Colors.Generator)
            if hl then hl.Enabled = state end
        end
    end
end

-- 3. PALLET ESP (FIX: Kembali menggunakan :find agar akurat)
function ESP:SetPallet(state)
    self.Config.Pallet = state
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Kita gunakan :find agar "Pallet_01" atau "Pallets" tetap terdeteksi
        if obj.Name:find("Pallet") then
            local hl = ApplyHighlight(obj, self.Colors.Pallet)
            if hl then hl.Enabled = state end
        end
    end
end

-- 4. GATE ESP (FIX: Berdasarkan hasil Scanner Tool)
function ESP:SetGate(state)
    self.Config.Gate = state
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Berdasarkan scan kamu: Nama Parent-nya adalah "Gate"
        if obj.Name == "Gate" or obj.Name:find("ExitGate") then
            local hl = ApplyHighlight(obj, self.Colors.Gate)
            if hl then hl.Enabled = state end
        end
    end
end

-- 5. CLEANUP
function ESP:DestroyAll()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("FR_ESP") then obj.FR_ESP:Destroy() end
    end
end

_G.FahriESP = ESP
return ESP
