-- [[ FahriRoundopHUB - Bypass Generator V7.6 (Anti-Stuck Edition) ]] --
-- Fitur Unggulan: Instant Analog Cancel & Multi-Point Sync

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Survivor = {
    Active = false,
    RepairRemote = ReplicatedStorage.Remotes.Generator.RepairEvent,
    LastTarget = nil -- Menyimpan titik terakhir untuk memastikan sinyal 'false' terkirim tepat sasaran
}

-- [[ SCANNER TITIK REPAIR ]] --
local function getBestInteractionPoint()
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local Root = Character.HumanoidRootPart
    local closestPoint = nil
    local maxDistance = 12
    
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

-- [[ METATABLE HOOK: BYPASS & SAFETY CHECK ]] --
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if Survivor.Active and method == "FireServer" and self == Survivor.RepairRemote then
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        
        -- JIKA SEDANG GERAK: Jangan biarkan bypass merubah apapun (biarkan sinyal cancel lewat murni)
        if Humanoid and Humanoid.MoveDirection.Magnitude > 0 then
            return oldNamecall(self, unpack(args))
        end

        -- JIKA DIAM: Lakukan bypass skill check
        if args[2] == false then
            args[2] = true
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- [[ LOOP UTAMA: AUTO-ATTACH & INSTANT DETACH ]] --
task.spawn(function()
    while true do
        task.wait(0.2) -- Delay dipercepat (dari 0.4 ke 0.2) agar deteksi analog lebih responsif
        
        if Survivor.Active then
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            
            if Humanoid then
                local currentTarget = getBestInteractionPoint()
                
                -- LOGIKA 1: JIKA ANALOG DIAM (REPAIR JALAN)
                if Humanoid.MoveDirection.Magnitude == 0 then
                    if currentTarget then
                        Survivor.LastTarget = currentTarget
                        Survivor.RepairRemote:FireServer(currentTarget, true)
                    end
                
                -- LOGIKA 2: JIKA ANALOG BERGERAK (INSTANT CANCEL)
                elseif Humanoid.MoveDirection.Magnitude > 0 then
                    -- Kirim sinyal False ke target terakhir agar karakter langsung lepas/berdiri
                    if Survivor.LastTarget then
                        Survivor.RepairRemote:FireServer(Survivor.LastTarget, false)
                        Survivor.LastTarget = nil -- Reset target setelah lepas
                    end
                    -- Beri jeda sedikit agar tidak langsung nempel lagi saat sedang lari
                    task.wait(0.5) 
                end
            end
        end
    end
end)

function Survivor:Toggle(state)
    self.Active = state
    if not state then Survivor.LastTarget = nil end
    print("[FahriRoundopHUB] Bypass Generator: " .. (state and "ON" or "OFF"))
end

_G.FahriSurvivor = Survivor
return Survivor
