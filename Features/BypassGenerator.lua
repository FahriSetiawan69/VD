-- [[ FahriRoundopHUB - Bypass Generator V7.6 (Revive Fix) ]] --
-- Fix: Fitur otomatis aktif kembali setelah di-revive

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Survivor = {
    Active = false,
    IsStopping = false,
    LastTarget = nil,
    RepairRemote = ReplicatedStorage.Remotes.Generator.RepairEvent
}

-- [[ FUNGSI AMBIL KARAKTER TERBARU (SANGAT PENTING) ]] --
local function GetCurrentData()
    local char = Player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    return char, hum, root
end

-- [[ FUNGSI SAFETY CHECK ]] --
local function IsPlayerSafe()
    local Char, Hum, Root = GetCurrentData()
    if not Char or not Hum or not Root then return false end
    
    -- 1. Cek folder Ragdoll (Tanda Knock/Gendong)
    if Char:FindFirstChild("RagdollConstraints") then return false end
    
    -- 2. Cek Animasi Knocked
    local tracks = Hum:GetPlayingAnimationTracks()
    for _, track in pairs(tracks) do
        if string.find(string.lower(track.Name), "knocked") then return false end
    end
    
    -- 3. Cek Kondisi Fisik
    if Hum.Health <= 0 or Hum.PlatformStand or Hum.Sit then return false end
    
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

-- [[ LOOP UTAMA: DENGAN AUTO-REFRESH ]] --
task.spawn(function()
    while true do
        task.wait(0.3)
        if Survivor.Active then
            local Char, Hum, Root = GetCurrentData()
            
            -- Jika Player Bangkit & Aman
            if Hum and Root and IsPlayerSafe() then
                local currentTarget = getBestInteractionPoint()
                
                if Hum.MoveDirection.Magnitude == 0 then
                    if currentTarget and not Survivor.LastTarget then
                        Survivor.LastTarget = currentTarget
                        Survivor.RepairRemote:FireServer(currentTarget, true)
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
                -- JIKA LAGI KNOCK/GENDONG: Paksa Lepas & Reset Target
                -- Ini kunci agar setelah revive, LastTarget sudah bersih (nil)
                if Survivor.LastTarget then
                    pcall(function()
                        Survivor.IsStopping = true
                        Survivor.RepairRemote:FireServer(Survivor.LastTarget, false)
                        task.wait(0.1)
                        Survivor.IsStopping = false
                    end)
                    Survivor.LastTarget = nil
                end
            end
        end
    end
end)

-- Reset total saat karakter benar-benar respawn/refresh
Player.CharacterAdded:Connect(function()
    Survivor.LastTarget = nil
    Survivor.IsStopping = false
end)

function Survivor:Toggle(state)
    self.Active = state
    if not state then
        Survivor.IsStopping = false
        Survivor.LastTarget = nil
    end
end

_G.FahriSurvivor = Survivor
return Survivor
