-- [[ FahriRoundopHUB - Bypass Generator V7.6 (Fixed & Optimized) ]] --
-- Fix: Manual Repair, Auto-Attach, and Anti-Stuck Logic

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Survivor = {
    Active = false,
    IsStopping = false, -- Flag khusus agar tidak stuck saat lari
    LastTarget = nil,
    RepairRemote = ReplicatedStorage.Remotes.Generator.RepairEvent
}

-- [[ 1. SMART SCANNER: DETEKSI TITIK TERDEKAT ]] --
local function getBestInteractionPoint()
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local Root = Character.HumanoidRootPart
    local closestPoint = nil
    local maxDistance = 15 -- Jangkauan ditingkatkan agar auto-attach lebih peka
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.find(obj.Name, "GeneratorPoint") then
            local dist = (Root.Position - obj.Position).Magnitude
            if dist < maxDistance then
                maxDistance = dist
                closestPoint = obj
            end
        end
    end
    return closestPoint
end

-- [[ 2. METATABLE HOOK: BYPASS DENGAN FILTER SAFETY ]] --
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Cek apakah fitur ON dan Remote-nya benar
    if Survivor.Active and method == "FireServer" and self == Survivor.RepairRemote then
        -- JANGAN BYPASS jika kita sedang sengaja mengirim sinyal STOP (IsStopping)
        if not Survivor.IsStopping then
            -- Jika sinyal adalah 'false' (gagal skill check), ubah jadi 'true' (berhasil)
            if args[2] == false then
                args[2] = true
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end)

-- [[ 3. AUTO-ATTACH & CANCEL LOOP ]] --
task.spawn(function()
    while true do
        task.wait(0.3) -- Delay optimal agar tidak bentrok dengan manual repair
        
        if Survivor.Active then
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            
            if Humanoid then
                local currentTarget = getBestInteractionPoint()
                
                -- LOGIKA: JIKA DIAM (ANTARA AUTO ATAU MANUAL)
                if Humanoid.MoveDirection.Magnitude == 0 then
                    if currentTarget and not Survivor.LastTarget then
                        -- Hanya auto-attach jika kita belum menempel di mana pun
                        Survivor.LastTarget = currentTarget
                        Survivor.RepairRemote:FireServer(currentTarget, true)
                    end
                
                -- LOGIKA: JIKA BERGERAK (STOP TOTAL)
                elseif Humanoid.MoveDirection.Magnitude > 0 then
                    if Survivor.LastTarget then
                        -- AKTIFKAN MODE SAFETY: Beritahu Hook untuk tidak merubah sinyal ini
                        Survivor.IsStopping = true 
                        Survivor.RepairRemote:FireServer(Survivor.LastTarget, false)
                        
                        task.wait(0.1) -- Jeda singkat agar sinyal terkirim
                        Survivor.IsStopping = false
                        Survivor.LastTarget = nil
                        
                        -- Beri cooldown agar tidak langsung narik balik saat lari
                        task.wait(0.5)
                    end
                end
            end
        end
    end
end)

-- Fungsi Control untuk UI
function Survivor:Toggle(state)
    self.Active = state
    if not state then
        -- Jika dimatikan, pastikan semua flag reset
        Survivor.IsStopping = false
        Survivor.LastTarget = nil
    end
    print("[FahriRoundopHUB] Bypass Generator: " .. (state and "ON" or "OFF"))
end

_G.FahriSurvivor = Survivor
return Survivor
