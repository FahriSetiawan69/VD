-- [[ FahriRoundopHUB - Bypass Generator V7.6 (Initial Start Fix) ]] --
-- Perbaikan: Pengecekan Sit, Remote Wait, dan Debug Console

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Pastikan Remote sudah ada sebelum script lanjut (Mencegah error start-up)
local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes", 10)
local GenFolder = RemotesFolder and RemotesFolder:WaitForChild("Generator", 10)
local RepairRemote = GenFolder and GenFolder:WaitForChild("RepairEvent", 10)

local Survivor = {
    Active = false,
    IsStopping = false,
    LastTarget = nil,
    RepairRemote = RepairRemote
}

-- [[ FUNGSI AMBIL DATA KARAKTER ]] --
local function GetCurrentData()
    local char = Player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    return char, hum, root
end

-- [[ FUNGSI SAFETY CHECK (DIPERBAIKI) ]] --
local function IsPlayerSafe()
    local Char, Hum, Root = GetCurrentData()
    if not Char or not Hum or not Root then return false end
    
    -- 1. Cek folder Ragdoll (Tanda Knock/Gendong)
    if Char:FindFirstChild("RagdollConstraints") then return false end
    
    -- 2. Cek Animasi Knocked (Berdasarkan hasil scan kamu)
    local tracks = Hum:GetPlayingAnimationTracks()
    for _, track in pairs(tracks) do
        if string.find(string.lower(track.Name), "knocked") then return false end
    end
    
    -- CATATAN: Hum.Sit dihapus karena biasanya repair dianggap 'duduk' oleh sistem game
    if Hum.Health <= 0 or Hum.PlatformStand then return false end
    
    return true
end

-- [[ SCANNER TITIK TERDEKAT ]] --
local function getBestInteractionPoint()
    local Char, Hum, Root = GetCurrentData()
    if not Root then return nil end
    
    local closestPoint = nil
    local maxDistance = 15 
    
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

-- [[ METATABLE HOOK ]] --
if Survivor.RepairRemote then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if Survivor.Active and method == "FireServer" and self == Survivor.RepairRemote then
            if not Survivor.IsStopping and IsPlayerSafe() then
                if args[2] == false then
                    args[2] = true
                    return oldNamecall(self, unpack(args))
                end
            end
        end
        return oldNamecall(self, ...)
    end)
else
    warn("[FahriRoundopHUB] ERROR: RepairEvent tidak ditemukan di ReplicatedStorage!")
end

-- [[ LOOP UTAMA ]] --
task.spawn(function()
    print("[FahriRoundopHUB] Survivor Loop Started")
    while true do
        task.wait(0.5)
        if Survivor.Active then
            local Char, Hum, Root = GetCurrentData()
            
            if Hum and Root and IsPlayerSafe() then
                local currentTarget = getBestInteractionPoint()
                
                if Hum.MoveDirection.Magnitude == 0 then
                    if currentTarget then
                        if not Survivor.LastTarget then
                            -- DEBUG: Biar kamu tahu di console kalau dia mencoba menempel
                            print("[FahriRoundopHUB] Attempting Auto-Attach to: " .. currentTarget.Name)
                            Survivor.LastTarget = currentTarget
                            Survivor.RepairRemote:FireServer(currentTarget, true)
                        end
                    end
                elseif Hum.MoveDirection.Magnitude > 0 then
                    if Survivor.LastTarget then
                        Survivor.IsStopping = true 
                        Survivor.RepairRemote:FireServer(Survivor.LastTarget, false)
                        task.wait(0.1)
                        Survivor.IsStopping = false
                        Survivor.LastTarget = nil
                        task.wait(0.5)
                    end
                end
            else
                -- Reset jika terdeteksi tidak aman
                if Survivor.LastTarget then
                    Survivor.LastTarget = nil
                end
            end
        end
    end
end)

function Survivor:Toggle(state)
    self.Active = state
    print("[FahriRoundopHUB] Bypass Generator Active: " .. tostring(state))
end

_G.FahriSurvivor = Survivor
return Survivor
