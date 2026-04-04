-- [[ FahriRoundopHUB - ESP Engine (Refined Fix) ]] --
-- Developer: FahriSetiawan69

local ESP = {
    Config = { Player = false, Generator = false, Pallet = false, Gate = false },
    Colors = {
        Killer = Color3.fromRGB(255, 0, 0),      -- Merah
        Survivor = Color3.fromRGB(0, 255, 0),    -- Hijau
        Generator = Color3.fromRGB(255, 165, 0), -- Oranye
        Pallet = Color3.fromRGB(255, 255, 0),    -- Kuning
        Gate = Color3.fromRGB(0, 0, 255)         -- Biru
    }
}

-- [[ FUNGSI HELPER HIGHLIGHT ]] --
local function ApplyHighlight(obj, color)
    if not obj then return end
    local hl = obj:FindFirstChild("FR_ESP") or Instance.new("Highlight")
    hl.Name = "FR_ESP"
    hl.Parent = obj
    
    hl.FillColor = color
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0.8 -- Outline sangat tipis agar tidak mengganggu
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Tetap tembus tembok
    hl.Enabled = true
    return hl
end

-- 1. PLAYER ESP (KILLER & SURVIVOR)
function ESP:SetPlayer(state)
    self.Config.Player = state
    local function UpdatePlayer(p)
        if p.Character then
            -- FIX: Default diatur ke Hijau (Survivor) agar tidak jadi Putih jika tim telat terdeteksi
            local playerColor = self.Colors.Survivor 
            
            if p.Team then
                local teamName = p.Team.Name
                -- Gunakan deteksi parsial agar lebih akurat
                if teamName:find("Killer") then
                    playerColor = self.Colors.Killer
                elseif teamName:find("Survivor") then
                    playerColor = self.Colors.Survivor
                end
            end
            
            local hl = ApplyHighlight(p.Character, playerColor)
            if hl then hl.Enabled = state end
        end
    end

    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= game:GetService("Players").LocalPlayer then
            UpdatePlayer(p)
        end
    end
end

-- 2. GENERATOR ESP (ORANYE)
function ESP:SetGenerator(state)
    self.Config.Generator = state
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:find("Generator") then
            local hl = ApplyHighlight(obj, self.Colors.Generator)
            if hl then hl.Enabled = state end
        end
    end
end

-- 3. PALLET ESP (KUNING - KEMBALI KE 1 KEYWORD)
function ESP:SetPallet(state)
    self.Config.Pallet = state
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Hanya scan objek dengan nama "Pallet" agar tidak berat/terlalu banyak
        if obj.Name == "Pallet" or obj.Name:find("Pallet") then
            local hl = ApplyHighlight(obj, self.Colors.Pallet)
            if hl then hl.Enabled = state end
        end
    end
end

-- 4. GATE ESP (BIRU - KEMBALI KE KEYWORD BERFUNGSI)
function ESP:SetGate(state)
    self.Config.Gate = state
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Gunakan keyword "ExitGate" yang sebelumnya kamu bilang berfungsi
        if obj.Name:find("ExitGate") or obj.Name:find("Gate") then
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
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("FR_ESP") then
            p.Character.FR_ESP:Destroy()
        end
    end
end

_G.FahriESP = ESP
return ESP
