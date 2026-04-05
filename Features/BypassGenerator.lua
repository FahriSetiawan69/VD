-- [[ FahriRoundopHUB - Bypass Generator (Aggressive Version) ]] --
-- Deskripsi: Reverted to stable logic. No safety checks, pure performance.

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Mencari Remote secara langsung
local RepairRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("RepairEvent")

local Survivor = {
    Active = false,
    RepairRemote = RepairRemote
}

-- [[ 1. METATABLE HOOK: BYPASS SKILL CHECK ]] --
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if Survivor.Active and method == "FireServer" and self == Survivor.RepairRemote then
        -- Bypass: Paksa Gagal (false) jadi Berhasil (true)
        if args[2] == false then
            args[2] = true
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- [[ 2. AUTO-ATTACH LOOP ]] --
task.spawn(function()
    while true do
        task.wait(0.5) -- Delay santai agar tidak lag
        
        if Survivor.Active then
            local Char = Player.Character
            local Root = Char and Char:FindFirstChild("HumanoidRootPart")
            local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
            
            if Root and Hum then
                -- Cari GeneratorPoint terdekat
                local target = nil
                local dist = 12
                
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:find("GeneratorPoint") then
                        local magnitude = (Root.Position - obj.Position).Magnitude
                        if magnitude < dist then
                            dist = magnitude
                            target = obj
                        end
                    end
                end

                -- Logika Nempel & Lepas
                if Hum.MoveDirection.Magnitude == 0 then
                    if target then 
                        Survivor.RepairRemote:FireServer(target, true) 
                    end
                else
                    if target then 
                        Survivor.RepairRemote:FireServer(target, false) 
                    end
                end
            end
        end
    end
end)

function Survivor:Toggle(state)
    self.Active = state
    print("[FahriRoundopHUB] Bypass Generator: " .. tostring(state))
end

_G.FahriSurvivor = Survivor
return Survivor
