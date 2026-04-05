-- [[ FahriRoundopHUB - Bypass Generator V7.6 (Final Polish) ]] --
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RepairRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("RepairEvent")

local Survivor = {
    Active = false,
    CurrentTarget = nil,
    IsRepairing = false
}

-- [[ 1. METATABLE HOOK: ANTI-MAGNET ]] --
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if Survivor.Active and method == "FireServer" and self == RepairRemote then
        local char = Player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        -- KUNCI UTAMA: Jika analog bergerak, JANGAN BYPASS! 
        -- Biarkan sinyal 'false' (berhenti) lewat murni ke server.
        if hum and hum.MoveDirection.Magnitude > 0 then
            return oldNamecall(self, unpack(args))
        end

        -- Jika diam: Bypass sinyal gagal (false) menjadi berhasil (true)
        if args[2] == false then
            args[2] = true
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- [[ 2. AUTO-ATTACH LOGIC ]] --
task.spawn(function()
    while true do
        task.wait(0.3)
        if Survivor.Active then
            local char = Player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if root and hum then
                -- Mencari GeneratorPoint terdekat
                local target = nil
                local dist = 15 -- Jarak deteksi
                
                for _, obj in pairs(workspace:GetDescendants()) do
                    -- Gunakan keyword 'GeneratorPoint' sesuai prototipe kamu
                    if obj.Name:find("GeneratorPoint") and obj:IsA("BasePart") then
                        local magnitude = (root.Position - obj.Position).Magnitude
                        if magnitude < dist then
                            dist = magnitude
                            target = obj
                        end
                    end
                end

                -- Eksekusi Sinyal
                if hum.MoveDirection.Magnitude == 0 then
                    if target and not Survivor.IsRepairing then
                        -- Jika diam dan ada target: ATTACH
                        Survivor.IsRepairing = true
                        Survivor.CurrentTarget = target
                        RepairRemote:FireServer(target, true)
                    end
                else
                    if Survivor.IsRepairing then
                        -- Jika gerak: DETACH
                        Survivor.IsRepairing = false
                        if Survivor.CurrentTarget then
                            RepairRemote:FireServer(Survivor.CurrentTarget, false)
                        end
                        Survivor.CurrentTarget = nil
                        task.wait(0.5) -- Cooldown lari
                    end
                end
            end
        end
    end
end)

function Survivor:Toggle(state)
    self.Active = state
    Survivor.IsRepairing = false
    Survivor.CurrentTarget = nil
    print("[FahriRoundopHUB] Bypass Generator: " .. tostring(state))
end

_G.FahriSurvivor = Survivor
return Survivor
