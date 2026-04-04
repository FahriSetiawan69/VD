-- [[ FahriRoundopHUB - ESP Engine (Final Config) ]] --
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

-- Fungsi Helper untuk membuat Highlight
local function ApplyHighlight(obj, color)
    if not obj then return end
    local hl = obj:FindFirstChild("FR_ESP") or Instance.new("Highlight")
    hl.Name = "FR_ESP"
    hl.Parent = obj
    hl.FillColor = color
    hl.OutlineColor = Color3.fromRGB(255, 255, 255) -- Outline Putih agar kontras
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Enabled = true
    return hl
end

-- 1. LOGIKA PLAYER ESP (KILLER & SURVIVOR)
function ESP:SetPlayer(state)
    self.Config.Player = state
    local function UpdatePlayer(p)
        if p.Character then
            local color = Color3.fromRGB(255, 255, 255) -- Default Putih jika tim tidak ketemu
            
            -- Deteksi Tim
            if p.Team and p.Team.Name == "Killer" then
                color = self.Colors.Killer
            elseif p.Team and p.Team.Name == "Survivor" then
                color = self.Colors.Survivor
            end
            
            local hl = ApplyHighlight(p.Character, color)
            if hl then hl.Enabled = state end
        end
    end

    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= game:GetService("Players").LocalPlayer then
            UpdatePlayer(p)
        end
    end
end

-- 2. LOGIKA GENERATOR ESP (ORANYE)
function ESP:SetGenerator(state)
    self.Config.Generator = state
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Generator" or obj:FindFirstChild("Generator") then
            local hl = ApplyHighlight(obj, self.Colors.Generator)
            if hl then hl.Enabled = state end
        end
    end
end

-- 3. LOGIKA PALLET ESP (KUNING)
function ESP:SetPallet(state)
    self.Config.Pallet = state
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:find("Pallet") then
            local hl = ApplyHighlight(obj, self.Colors.Pallet)
            if hl then hl.Enabled = state end
        end
    end
end

-- 4. LOGIKA GATE ESP (BIRU)
function ESP:SetGate(state)
    self.Config.Gate = state
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:find("ExitGate") or obj.Name:find("Gate") then
            local hl = ApplyHighlight(obj, self.Colors.Gate)
            if hl then hl.Enabled = state end
        end
    end
end

-- 5. CLEANUP SYSTEM
function ESP:DestroyAll()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("FR_ESP") then 
            obj.FR_ESP:Destroy() 
        end
    end
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("FR_ESP") then
            p.Character.FR_ESP:Destroy()
        end
    end
end

-- Simpan ke Global agar bisa dikontrol oleh HomeGui.lua
_G.FahriESP = ESP
print("[FahriRoundopHUB] ESP Engine Configured with Team Logic!")
return ESP
