-- [[ FahriRoundopHUB - Bypass Generator V7.6 (Fixed Attachment & Detach) ]] --
-- Fix: Auto-attach jarak jauh & Instant Analog Detach

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. SETUP REMOTE & VARIABLES
local RepairRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("RepairEvent")

local Survivor = {
    Active = false,
    InternalStop = false, -- Flag rahasia agar sinyal 'Stop' tidak dicegat Hook
    LastTarget = nil
}

-- [[ 2. METATABLE HOOK: SMART BYPASS ]] --
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if Survivor.Active and method == "FireServer" and self == RepairRemote then
        -- Jika kita sedang sengaja mengirim sinyal STOP, jangan dirubah!
        if Survivor.InternalStop then
            return oldNamecall(self, unpack(args))
        end

        -- Bypass: Ubah Gagal (false) jadi Berhasil (true)
        if args[2] == false then
            args[2] = true
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- [[ 3. AUTO-ATTACH & DETACH LOOP ]] --
task.spawn(function()
    while true do
        task.wait(0.3) -- Lebih cepat agar respon analog makin tajam
        
        if Survivor.Active then
            local Char = Player.Character
            local Root = Char and Char:FindFirstChild("HumanoidRootPart")
            local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
            
            if Root and Hum then
                -- SCAN TARGET (Jarak dinaikkan ke 15 agar lebih sensitif)
                local currentTarget = nil
                local maxDist = 15
                
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:find("GeneratorPoint") then
                        local d = (Root.Position - obj.Position).Magnitude
                        if d < maxDist then
                            maxDist = d
                            currentTarget = obj
                        end
                    end
                end

                -- LOGIKA 1: JIKA DIAM (AUTO ATTACH)
                if Hum.MoveDirection.Magnitude == 0 then
                    if currentTarget and not Survivor.LastTarget then
                        Survivor.LastTarget = currentTarget
                        RepairRemote:FireServer(currentTarget, true)
                        print("[FR-HUB] Auto Attached!")
                    end
                
                -- LOGIKA 2: JIKA GERAK (INSTANT DETACH)
                elseif Hum.MoveDirection.Magnitude > 0 then
                    if Survivor.LastTarget then
                        -- Aktifkan rem darurat agar sinyal 'false' tidak diubah Hook
                        Survivor.InternalStop = true 
                        RepairRemote:FireServer(Survivor.LastTarget, false)
                        
                        task.wait(0.1) -- Jeda mikro agar sinyal terkirim
                        Survivor.InternalStop = false
                        Survivor.LastTarget = nil
                        print("[FR-HUB] Detached via Movement")
                        
                        -- Cooldown lari agar tidak langsung kesedot balik
                        task.wait(0.5)
                    end
                end
            end
        end
    end
end)

function Survivor:Toggle(state)
    self.Active = state
    Survivor.LastTarget = nil
    Survivor.InternalStop = false
end

_G.FahriSurvivor = Survivor
return Survivor
