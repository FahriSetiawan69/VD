-- [[ FahriRoundopHUB - ESP Engine ]] --
local ESP = {
    Config = { Player = false, Generator = false, Pallet = false, Gate = false },
    Storage = {} -- Folder untuk menyimpan Highlight agar bersih
}

local function CreateHighlight(obj, color, name_tag)
    if not obj then return end
    local hl = obj:FindFirstChild("FR_ESP") or Instance.new("Highlight")
    hl.Name = "FR_ESP"
    hl.Parent = obj
    hl.FillColor = color
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.Enabled = false
    return hl
end

-- AKTIVASI LOGIKA (API SESUAI PROTOTIPE)
function ESP:SetPlayer(state)
    self.Config.Player = state
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p.Character then
            local hl = CreateHighlight(p.Character, Color3.fromRGB(255, 0, 0))
            if hl then hl.Enabled = state end
        end
    end
end

function ESP:SetGenerator(state)
    self.Config.Generator = state
    -- Mencari objek Generator di Workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Generator" or obj:FindFirstChild("Generator") then
            local hl = CreateHighlight(obj, Color3.fromRGB(0, 255, 0))
            if hl then hl.Enabled = state end
        end
    end
end

function ESP:SetPallet(state)
    self.Config.Pallet = state
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:find("Pallet") then
            local hl = CreateHighlight(obj, Color3.fromRGB(255, 255, 0))
            if hl then hl.Enabled = state end
        end
    end
end

function ESP:SetGate(state)
    self.Config.Gate = state
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:find("ExitGate") or obj.Name:find("Gate") then
            local hl = CreateHighlight(obj, Color3.fromRGB(0, 0, 255))
            if hl then hl.Enabled = state end
        end
    end
end

function ESP:DestroyAll()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("FR_ESP") then obj.FR_ESP:Destroy() end
    end
end

-- Simpan ke Global
_G.FahriESP = ESP
return ESP
